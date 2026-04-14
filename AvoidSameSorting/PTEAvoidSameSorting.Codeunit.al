Codeunit 80421 "PTE Avoid Same Sorting"
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Planning Units Generate ", 'OnAfterFind_Create_TempPlanUnit', '', false, false)]
    local procedure OnAfterFind_Create_TempPlanUnit(in_CapacityCode: Code[20];
                                                    in_SheetID: Integer;
                                                    in_ProcessID: Integer;
                                                    in_Is_Created: Boolean;
                                                    in_SetupRec: Record "PVS Calculation Unit Setup";
                                                    var out_JobItemRec_Tmp: Record "PVS Job Item" temporary;
                                                    var out_CalcUnitTMP: Record "PVS Job Calculation Unit" temporary;
                                                    var out_PlanUnitTmp: Record "PVS Job Planning Unit" temporary)
    var
        PlanUnitTmp: Record "PVS Job Planning Unit" temporary;
    begin
        if not in_Is_Created then
            exit;

        if in_SheetID <> 0 then
            exit;

        PlanUnitTmp.Copy(out_PlanUnitTmp, true);
        PlanUnitTmp.Reset();
        PlanUnitTmp.SetCurrentKey("Simulation Version", ID, Job, "Sorting Order");
        PlanUnitTmp.SetRange("Simulation Version", out_PlanUnitTmp."Simulation Version");
        PlanUnitTmp.SetRange(ID, out_PlanUnitTmp.ID);
        PlanUnitTmp.SetRange(Job, out_PlanUnitTmp.Job);
        PlanUnitTmp.SetRange(Unit, out_PlanUnitTmp.Unit);
        PlanUnitTmp.SetRange("Capacity Unit", out_PlanUnitTmp."Capacity Unit");
        PlanUnitTmp.SetRange("Sorting Order", out_PlanUnitTmp."Sorting Order");
        PlanUnitTmp.SetRange("Sheet ID", 0);
        PlanUnitTmp.SetFilter("Plan ID", '<>%1', PlanUnitTmp."Plan ID");
        if PlanUnitTmp.Findlast then begin
            out_PlanUnitTmp."Sorting Order" := PlanUnitTmp."Sorting Order" + 1;
            out_PlanUnitTmp.modify();
        end;
    end;
}