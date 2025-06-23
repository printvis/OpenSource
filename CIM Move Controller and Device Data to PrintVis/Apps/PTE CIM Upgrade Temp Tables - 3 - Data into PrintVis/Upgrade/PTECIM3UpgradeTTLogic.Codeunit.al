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
    begin
        upgfunctions.MoveCostCenterFieldToTable(true, false, true);
    end;

    internal procedure UpdatePVSCIMSystemJDFEnumValueInControllerTable()
    begin
        upgfunctions.UpdatePVSCIMSystemJDFEnumValueInControllerTable();
    end;
}