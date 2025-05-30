codeunit 80268 "PTE Upg. Into PrintVis L. W."//Get new object id
{
    trigger OnRun()
    var
        UpgradeLogic: Codeunit "PTE CIM 1 Upg. PrintVis L.";
    begin
        UpgradeLogic.MoveControllerToTempTable();
        UpgradeLogic.MoveDeviceToTempTable();
        UpgradeLogic.MoveCostCenterFieldToTempTable();
    end;
}