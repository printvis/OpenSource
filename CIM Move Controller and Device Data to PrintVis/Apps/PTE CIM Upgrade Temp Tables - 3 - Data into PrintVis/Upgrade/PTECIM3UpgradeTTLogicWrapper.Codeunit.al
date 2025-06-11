codeunit 80272 "PTE CIM 3 Upg. L. W."//Get new object id
{
    trigger OnRun()
    var
        UpgradeLogic: Codeunit "PTE CIM 3 Upg. PrintVis L.";
    begin
        UpgradeLogic.MoveControllerToPrintVisTable();
        UpgradeLogic.MoveDeviceToPrintVisTable();
        UpgradeLogic.MoveCostCenterFieldToPrintVisTable();
        UpgradeLogic.UpdatePVSCIMSystemJDFEnumValueInControllerTable();
    end;
}