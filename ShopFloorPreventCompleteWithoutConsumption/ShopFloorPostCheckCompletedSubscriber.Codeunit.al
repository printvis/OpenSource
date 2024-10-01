codeunit 80176 "PTE SF post check compl. sub"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Shop Floor Management", 'OnBeforeShopFloorJournalEntryCompleteJob', '', false, false)]
    local procedure OnBeforeShopFloorJournalEntryCompleteJob(PlanRec: Record "PVS Job Planning Unit"; var in_JournalRec: Record "PVS Shop Floor Journal Entry"; var isHandled: Boolean)
    var
        PVSJobCostingEntry: Record "PVS Job Costing Entry";
        PVSJobCostingJournalLines: Record "PVS Job Costing Journal Line";
        NotAllowedToCompleteLbl: Label 'Your not allowed to complete it without having registered some consumption';
    begin
        PVSJobCostingEntry.SetRange(ID, PlanRec.ID);
        PVSJobCostingEntry.SetRange("Plan ID", PlanRec."Plan ID");
        PVSJobCostingEntry.SetFilter("Item No.", '<>%1', '');
        if not PVSJobCostingEntry.IsEmpty() then
            exit;

        PVSJobCostingJournalLines.SetRange(ID, PlanRec.ID);
        PVSJobCostingJournalLines.SetRange("Plan ID", PlanRec."Plan ID");
        PVSJobCostingJournalLines.SetFilter("Item No.", '<>%1', '');
        if not PVSJobCostingJournalLines.IsEmpty() then
            exit;

        Error(NotAllowedToCompleteLbl);
    end;

}