Codeunit 80421 "PTE Avoid Same Sorting"
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Planning Units Generate ", OnAfterFindCreateTempPlanUnit, '', false, false)]
    local procedure OnAfterFind_Create_TempPlanUnit(in_CapacityCode: Code[20];
                                                    in_SheetID: Integer;
                                                    in_ProcessID: Integer;
                                                    in_IsPlanningEntryInserted: Boolean;
                                                    in_SetupRec: Record "PVS Calculation Unit Setup";
                                                    var out_JobItemRec_Tmp: Record "PVS Job Item" temporary;
                                                    var out_CalcUnitTMP: Record "PVS Job Calculation Unit" temporary;
                                                    var out_PlanUnitTmp: Record "PVS Job Planning Unit" temporary)
    var
        Temp_PlanUnit: Record "PVS Job Planning Unit" temporary;
    begin
        if not in_IsPlanningEntryInserted then
            exit;

        if in_SheetID <> 0 then
            exit;

        Temp_PlanUnit.Copy(out_PlanUnitTmp, true);
        Temp_PlanUnit.Reset();
        Temp_PlanUnit.SetCurrentKey("Simulation Version", ID, Job, "Sorting Order");
        Temp_PlanUnit.SetRange("Simulation Version", out_PlanUnitTmp."Simulation Version");
        Temp_PlanUnit.SetRange(ID, out_PlanUnitTmp.ID);
        Temp_PlanUnit.SetRange(Job, out_PlanUnitTmp.Job);
        Temp_PlanUnit.SetRange(Unit, out_PlanUnitTmp.Unit);
        Temp_PlanUnit.SetRange("Capacity Unit", out_PlanUnitTmp."Capacity Unit");
        Temp_PlanUnit.SetRange("Sorting Order", out_PlanUnitTmp."Sorting Order");
        Temp_PlanUnit.SetRange("Sheet ID", 0);
        Temp_PlanUnit.SetFilter("Plan ID", '<>%1', Temp_PlanUnit."Plan ID");
        if Temp_PlanUnit.Findlast() then begin
            out_PlanUnitTmp."Sorting Order" := Temp_PlanUnit."Sorting Order" + 1;
            out_PlanUnitTmp.modify();
        end;
    end;
}