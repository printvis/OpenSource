codeunit 80201 "PTE AutoLock Milestone"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Planning Management", 'On_Before_Check_Planning_Method', '', true, true)]
    local procedure On_Before_Check_Planning_Method(var in_PlanUnitRec: Record "PVS Job Planning Unit"; var IsHandled: Boolean)
    begin
        if not (in_PlanUnitRec.Milestone) then
            exit;

        if (in_PlanUnitRec.Start = 0DT) then
            exit;

        if (in_PlanUnitRec."Planning Status" <> in_PlanUnitRec."planning status"::"Variable Planned") then
            exit;

        in_PlanUnitRec."Planning Status" := in_PlanUnitRec."planning status"::Locked;
        IsHandled := true;
    end;
}
