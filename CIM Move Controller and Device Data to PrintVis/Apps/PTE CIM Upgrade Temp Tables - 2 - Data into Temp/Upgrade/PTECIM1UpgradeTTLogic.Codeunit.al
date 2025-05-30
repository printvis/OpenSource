codeunit 80267 "PTE CIM 1 Upg. PrintVis L."//Get new object id
{
    Access = Internal;

    var
        upgfunctions: Codeunit "PTE CIM 1 - UPG Functions";

    internal procedure MoveControllerToTempTable()
    begin
        upgfunctions.MoveControllerToTable(false, true, false);
    end;

    internal procedure MoveDeviceToTempTable()
    begin
        upgfunctions.MoveDeviceToTable(false, true, false);
    end;

    internal procedure MoveCostCenterFieldToTempTable()
    begin
        upgfunctions.MoveCostCenterFieldToTable(false, true, false);
    end;

}