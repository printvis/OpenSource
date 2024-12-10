codeunit 80501 "PTE Job Ticket 2 Rich Text"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS JobTicket Management", 'OnAfterGetJobTicket', '', false, false)]
    local procedure MyProcedure(var in_JobRec: Record "PVS Job"; var Out_JobTicketTmp: Record "PVS Job Ticket Temp" temporary)
    begin
        TransferJobRichTextCommentsIntoJobTicketBuffer(in_JobRec, Out_JobTicketTmp);
    end;

    local procedure TransferJobRichTextCommentsIntoJobTicketBuffer(var in_JobRec: Record "PVS Job"; var Out_JobTicketTmp: Record "PVS Job Ticket Temp" temporary)
    var
        JobTextDescriptionRec: Record "PVS Job Text Description";
        DepartmentRec: Record "PVS Department";
        LastEntryNo: Integer;
    begin
        if not DoesCaseCommentsWithRichTextExist(in_JobRec.ID) then
            exit;

        Out_JobTicketTmp.Reset();
        if not Out_JobTicketTmp.FindLast() then
            exit;

        SetCaseRichTextFilters(in_JobRec.ID, JobTextDescriptionRec);
        DepartmentRec.SetCurrentKey("Sorting Order");
        DepartmentRec.SetRange("Job Ticket Comments", true);
        if DepartmentRec.FindSet(false) then
            repeat
                JobTextDescriptionRec.SetRange(Department, DepartmentRec.Code);
                if JobTextDescriptionRec.FindSet(false) then begin
                    Out_JobTicketTmp.SetRange("Report Department Code", DepartmentRec.Code);
                    Out_JobTicketTmp.SetRange("Report Section", 3);
                    if not Out_JobTicketTmp.FindLast() then
                        Out_JobTicketTmp.SetRange("Report Section", 2);
                    if Out_JobTicketTmp.FindFirst() then begin
                        LastEntryNo := Out_JobTicketTmp.PK1_Integer1;
                        Out_JobTicketTmp.Reset();
                        Out_JobTicketTmp.Init();
                        Out_JobTicketTmp."Report Section" := Out_JobTicketTmp."Report Section"::"PTE Rich Text";
                        Out_JobTicketTmp.PK1_Integer1 := LastEntryNo;
                        Out_JobTicketTmp."Department Name" := DepartmentRec.Name;
                        Out_JobTicketTmp."PTE Comment Found" := true;
                        Out_JobTicketTmp."Report Department Code" := DepartmentRec.Code;
                        repeat
                            Out_JobTicketTmp.PK1_Integer2 += LastEntryNo;
                            Out_JobTicketTmp."PTE Comment Rich Text SystemID" := JobTextDescriptionRec.SystemId;
                            Out_JobTicketTmp.Insert(true);
                        until JobTextDescriptionRec.Next() = 0;
                    end;
                end;
            until DepartmentRec.Next() = 0;
        Out_JobTicketTmp.Reset();
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