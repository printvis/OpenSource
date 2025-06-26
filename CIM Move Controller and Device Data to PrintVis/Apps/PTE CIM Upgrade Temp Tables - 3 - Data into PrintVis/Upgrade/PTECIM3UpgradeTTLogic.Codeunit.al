codeunit 80271 "PTE CIM 3 Upg. PrintVis L."//Get new object id
{
    Access = Internal;

    var
        upgfunctions: Codeunit "PTE CIM 1 - UPG Functions";

    internal procedure MoveControllerToPrintVisTable()
    begin
        upgfunctions.MoveControllerToTable(true, true, false);
    end;

    internal procedure MoveDeviceToPrintVisTable()
    begin
        upgfunctions.MoveDeviceToTable(true, true, false);
    end;

    internal procedure MoveCostCenterFieldToPrintVisTable()
    var
        CostCenters: Record "PVS Cost Center";
        CostCenterUpg: Record "PTE CIM 1 Upg. TT. Cost Center";
    begin
        if CostCenterUpg.FindSet(false) then
            repeat
                if CostCenters.get(CostCenterUpg.Code) then begin
                    CostCenters."PVS CIM Device Code" := CostCenterUpg."PVS CIM Device Code";
                    if CostCenters.Modify(false) then;
                end;
            until CostCenterUpg.Next() = 0;
    end;

    internal procedure UpdatePVSCIMSystemJDFEnumValueInControllerTable()
    var
        Controller: Record "PVS CIM Controller";
        FieldRef: FieldRef;
        RecordRef: RecordRef;
    begin
        RecordRef.Open(Database::"PVS CIM Controller");
        Controller.SetRange("CIM System", Controller."CIM System"::" ");
        if Controller.FindSet() then
            repeat
                RecordRef.GetTable(Controller);
                FieldRef := RecordRef.Field(Controller.FieldNo("CIM System"));
                FieldRef.Value := 1;
                RecordRef.Modify(false);
            until Controller.Next() = 0;
    end;
}