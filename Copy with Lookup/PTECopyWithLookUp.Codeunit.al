Codeunit 80420 "PTE Copy With Lookup"
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Copy Management", OnAfterMainCopyJobToOrder, '', true, false)]
    local procedure OnAfterMainCopyJobToOrder(var in_OrderRec: Record "PVS Case"; var in_From_JobRec: Record "PVS Job"; in_Include_Shipments: Boolean; in_Is_New_Version: Boolean; var To_JobRec: Record "PVS Job")
    var
        Singleinstance: Codeunit "PVS SingleInstance";
        MainMgt: Codeunit "PVS Main";
        FilterMgt: Codeunit "PVS Table Filters";
        FormulaUnit: Codeunit "PVS Calculation Management";
        CalcUnitTMP: Record "PVS Job Calculation Unit" temporary;
        CalcUnitRec: Record "PVS Job Calculation Unit";
        xCalcUnitRec: Record "PVS Job Calculation Unit";
        CalcUnit_SetupRec: Record "PVS Calculation Unit Setup";
        CalcUnitDetailRec: Record "PVS Job Calculation Detail";
        Is_Skip_Calc: Boolean;
    begin

        CalcUnitTMP.DeleteAll();
        FilterMgt.SELECT_CalcUnits2Job(CalcUnitRec, To_JobRec.ID, To_JobRec.Job, To_JobRec.Version);
        if CalcUnitRec.findset(true) then
            repeat
                if CalcUnit_SetupRec.get(CalcUnit_SetupRec.Type::"Price Unit", CalcUnitRec.Unit) then
                    if CalcUnit_SetupRec."Lookup on Copy" then begin
                        CalcUnitTMP := CalcUnitRec;
                        CalcUnitTMP.insert;
                    end;
            until CalcUnitRec.next = 0;

        if CalcUnitTMP.IsEmpty then
            exit;

        Singleinstance.Set_GUINOTALLOWED(true);

        Is_Skip_Calc := To_JobRec."Skip Calc.";
        if not Is_Skip_Calc then begin
            To_JobRec."Skip Calc." := true;
            To_JobRec.Modify();
        end;

        if CalcUnitTmp.findset() then
            repeat
                if CalcUnitRec.get(CalcUnitTMP.ID, CalcUnitTMP.Job, CalcUnitTMP.Version, CalcUnitTMP."Entry No.") then begin
                    // Validate Unit
                    xCalcUnitRec := CalcUnitRec;
                    xCalcUnitRec.Unit := 'DELETE';
                    MainMgt.Main_On_Validate_CalcUnit(CalcUnitRec, xCalcUnitRec, CalcUnitRec."Sheet ID", CalcUnitRec."Process ID");
                end;
            until CalcUnitTMP.next = 0;

        if not Is_Skip_Calc then begin
            To_JobRec.get(To_JobRec.ID, To_JobRec.Job, To_JobRec.Version);
            To_JobRec."Skip Calc." := false;
            To_JobRec.Modify();
            FormulaUnit.Main_Calculate_Job(To_JobRec.ID, To_JobRec.Job, To_JobRec.Version);
            To_JobRec.get(To_JobRec.ID, To_JobRec.Job, To_JobRec.Version);
        end;
        Singleinstance.Set_GUINOTALLOWED(false);
    end;

}