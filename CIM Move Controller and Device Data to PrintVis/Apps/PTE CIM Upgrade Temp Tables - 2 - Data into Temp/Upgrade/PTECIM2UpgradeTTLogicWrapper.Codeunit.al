codeunit 80268 "PTE CIM 2 Upg. L. W."//Get new object id
{
    trigger OnRun()
    var
        UpgradeLogic: Codeunit "PTE CIM 2 Upg. PrintVis L.";
    begin
        UpgradeLogic.MoveControllerToTempTable();
        UpgradeLogic.MoveDeviceToTempTable();
        UpgradeLogic.MoveCostCenterFieldToTempTable();
    end;
}