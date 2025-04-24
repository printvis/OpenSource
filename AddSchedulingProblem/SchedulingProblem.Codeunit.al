codeunit 80195 SchedulingProblem
{
    [EventSubscriber(ObjectType::Table, database::"PVS Job Planning Unit", OnBeforeInfoText, '', true, true)]
    local procedure OnBeforeInfoText(var in_rec: Record "PVS Job Planning Unit"; InfoText: text)
    begin
        in_rec.CalcFields("Requested Delivery DateTime");
        if in_rec."Requested Delivery DateTime" <> 0DT then
            if (in_rec."Requested Delivery DateTime" < in_Rec.Ending) then
                InfoText := 'Planned after delivery date';
    end;
}
