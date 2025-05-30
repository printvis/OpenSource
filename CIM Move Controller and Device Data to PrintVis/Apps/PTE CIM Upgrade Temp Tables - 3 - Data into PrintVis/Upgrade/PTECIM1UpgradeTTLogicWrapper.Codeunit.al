codeunit 80272 "PTE Upg. Into PrintVis L. W."//Get new object id
{
    trigger OnRun()
    var
        UpgradeLogic: Codeunit "PTE CIM 1 Upg. PrintVis L.";
    begin
        UpgradeLogic.MoveControllerToPrintVisTable();
        UpgradeLogic.MoveDeviceToPrintVisTable();
        UpgradeLogic.MoveCostCenterFieldToPrintVisTable();
        UpgradeLogic.UpdatePVSCIMSystemJDFEnumValueInControllerTable();
    end;
}