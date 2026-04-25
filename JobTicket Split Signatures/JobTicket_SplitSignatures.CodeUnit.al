codeunit 80422 "Jobticket Split Signatures"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS JobTicket Management", 'OnAfterGetReportBuffer', '', true, true)]
    local procedure OnAfterGetReportBuffer(var in_JobRec: Record "PVS Job"; var in_VERSION_COUNTER: Integer; var Out_BufferRecTmp: Record "PVS Sorting Buffer" temporary; var Result: Boolean)
    var
        i, Set : Integer;
        New_BufferRecTmp: Record "PVS Sorting Buffer" temporary;
    begin
        Out_BufferRecTmp.setrange("Report Section", 52);
        if Out_BufferRecTmp.findset then
            repeat
                if Out_BufferRecTmp.Decimal1 > 1 then begin
                    New_BufferRecTmp := Out_BufferRecTmp;
                    New_BufferRecTmp.insert;
                end;
            until Out_BufferRecTmp.next = 0;
        Out_BufferRecTmp.reset;

        if new_BufferRecTmp.findset then
            repeat
                if Out_BufferRecTmp.Get(New_BufferRecTmp.PK1_Integer1, New_BufferRecTmp.PK1_Integer2, New_BufferRecTmp.PK1_Integer3, New_BufferRecTmp.PK1_Integer4,
                New_BufferRecTmp.PK2_Code1, New_BufferRecTmp.PK2_Code2, New_BufferRecTmp.PK2_Code3, New_BufferRecTmp.PK2_Code4,
                New_BufferRecTmp.PK3_Integer1, New_BufferRecTmp.PK3_Integer2, New_BufferRecTmp.PK3_Integer3, New_BufferRecTmp.PK3_Integer4) then begin
                    Set := round(Out_BufferRecTmp.Decimal1, 1);
                    Out_BufferRecTmp.Decimal1 := 1;
                    Out_BufferRecTmp.Decimal4 := Out_BufferRecTmp.Decimal4 DIV Set;
                    Out_BufferRecTmp.Decimal5 := Out_BufferRecTmp.Decimal4 DIV Set;
                    Out_BufferRecTmp.Decimal6 := Out_BufferRecTmp.Decimal4 DIV Set;
                    Out_BufferRecTmp.modify;
                    for i := 2 to Set do begin
                        Out_BufferRecTmp.PK1_Integer2 := i;
                        Out_BufferRecTmp.insert;
                    end;
                end;
            until New_BufferRecTmp.next = 0;
    end;
}