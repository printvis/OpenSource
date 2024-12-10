codeunit 80500 "PTE Job Ticket Rich Text"
{
    SingleInstance = true;

    var
        GlobalBufferRecTmp: Record "PVS Sorting Buffer" temporary;
        GlobalLastEntryBufferRecTmp: Record "PVS Sorting Buffer" temporary;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS JobTicket Management", 'OnAfterGetReportBuffer', '', false, false)]
    local procedure OnAfterGetReportBuffer(var in_JobRec: Record "PVS Job"; var Out_BufferRecTmp: Record "PVS Sorting Buffer" temporary)
    begin
        TransferJobRichTextCommentsIntoJobTicketBuffer(in_JobRec, Out_BufferRecTmp);
        AddBufferToGlobalInstance(Out_BufferRecTmp);
    end;

    local procedure AddBufferToGlobalInstance(var In_BufferRecTmp: Record "PVS Sorting Buffer" temporary)
    begin
        clear(GlobalBufferRecTmp);
        clear(GlobalLastEntryBufferRecTmp);
        GlobalBufferRecTmp.DeleteAll();
        In_BufferRecTmp.Reset();
        if In_BufferRecTmp.FindSet(false) then
            repeat
                GlobalBufferRecTmp := In_BufferRecTmp;
                GlobalBufferRecTmp.Insert(true);
            until In_BufferRecTmp.Next() = 0;

        In_BufferRecTmp.Reset();
        GlobalBufferRecTmp.Reset();
    end;

    internal procedure GetNextEntry(var Out_BufferRecTmp: Record "PVS Sorting Buffer" temporary)
    begin
        if GlobalLastEntryBufferRecTmp.PK1_Integer1 = 0 then begin
            if GlobalBufferRecTmp.FindSet(false) then;
        end
        else
            if GlobalLastEntryBufferRecTmp.PK1_Integer1 = GlobalBufferRecTmp.PK1_Integer1 then
                if GlobalBufferRecTmp.Next() = 0 then
                    if GlobalBufferRecTmp.FindSet(false) then;

        Out_BufferRecTmp := GlobalBufferRecTmp;
        GlobalLastEntryBufferRecTmp := GlobalBufferRecTmp;
    end;

    local procedure TransferJobRichTextCommentsIntoJobTicketBuffer(var in_JobRec: Record "PVS Job"; var Out_BufferRecTmp: Record "PVS Sorting Buffer" temporary)
    var
        JobTextDescriptionRec: Record "PVS Job Text Description";
        DepartmentRec: Record "PVS Department";
        LastEntryNo: Integer;
        DepartmentEntry: Dictionary of [Code[20], Integer];
    begin
        Out_BufferRecTmp.Reset();
        if not Out_BufferRecTmp.FindLast() then
            exit;

        if not DoesCaseCommentsWithRichTextExist(in_JobRec.ID) then
            exit;

        SetCaseRichTextFilters(in_JobRec.ID, JobTextDescriptionRec);
        DepartmentRec.SetCurrentKey("Sorting Order");
        DepartmentRec.SetRange("Job Ticket Comments", true);
        if DepartmentRec.FindSet(false) then
            repeat
                JobTextDescriptionRec.SetRange(Department, DepartmentRec.Code);
                if JobTextDescriptionRec.FindSet(false) then begin
                    Out_BufferRecTmp.SetRange("Report Department Code", DepartmentRec.Code);
                    Out_BufferRecTmp.SetRange("Report Section", 3);
                    if not Out_BufferRecTmp.FindLast() then
                        Out_BufferRecTmp.SetRange("Report Section", 2);
                    if Out_BufferRecTmp.FindFirst() then begin
                        LastEntryNo := Out_BufferRecTmp.PK1_Integer1;
                        Out_BufferRecTmp.Reset();
                        Out_BufferRecTmp.Init();
                        Out_BufferRecTmp."Report Section" := 50100;
                        Out_BufferRecTmp.PK1_Integer1 := LastEntryNo;
                        Out_BufferRecTmp."PTE Department Name" := DepartmentRec.Name;
                        Out_BufferRecTmp."PTE Comment Found" := true;
                        Out_BufferRecTmp."Report Department Code" := DepartmentRec.Code;
                        repeat
                            Out_BufferRecTmp.PK1_Integer2 += LastEntryNo;
                            Out_BufferRecTmp."PTE Comment Rich Text SystemID" := JobTextDescriptionRec.SystemId;
                            Out_BufferRecTmp.Insert(true);
                        until JobTextDescriptionRec.Next() = 0;
                    end
                end;

            until DepartmentRec.Next() = 0;
        Out_BufferRecTmp.Reset();
    end;

    internal procedure DoesCaseCommentsWithRichTextExist(in_CaseID: Integer): Boolean
    var
        JobTextDescriptionRec: Record "PVS Job Text Description";
    begin
        SetCaseRichTextFilters(in_CaseID, JobTextDescriptionRec);
        exit(not JobTextDescriptionRec.IsEmpty())
    end;

    internal procedure SetCaseRichTextFilters(in_CaseID: Integer; var out_JobTextDescriptionRec: Record "PVS Job Text Description")
    begin
        out_JobTextDescriptionRec.SetRange(ID, in_CaseID);
        out_JobTextDescriptionRec.SetRange("Table ID", Database::"PVS Case");
        out_JobTextDescriptionRec.SetRange(Type, out_JobTextDescriptionRec.Type::"Rich Text");
    end;
}