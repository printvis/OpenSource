codeunit 80266 "PTE CIM 2 Upg. TT Codeunit"//Get new object id
{
    Subtype = Install;
    trigger OnInstallAppPerCompany()
    begin
        // Code to perform company related table upgrade tasks
        UpgradeMoveDeviceToTempTable();
        UpgradeMoveControllerToTempTable();
        UpgradeMoveCostCenterFieldToTempTable();
    end;

    local procedure UpgradeMoveControllerToTempTable();
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.GetMoveControllerToTempTableTag()) then
            exit;
        UpgradeLogic.MoveControllerToTempTable();
        UpgradeTag.SetUpgradeTag(UpgradeTags.GetMoveControllerToTempTableTag());
    end;

    local procedure UpgradeMoveDeviceToTempTable()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.GetMoveDeviceToTempTableTag()) then
            exit;
        UpgradeLogic.MoveDeviceToTempTable();
        UpgradeTag.SetUpgradeTag(UpgradeTags.GetMoveDeviceToTempTableTag());
    end;

    local procedure UpgradeMoveCostCenterFieldToTempTable()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.GetMoveCostCenterFieldToTempTableTag()) then
            exit;
        UpgradeLogic.MoveCostCenterFieldToTempTable();
        UpgradeTag.SetUpgradeTag(UpgradeTags.GetMoveCostCenterFieldToTempTableTag());
    end;

    var
        UpgradeLogic: Codeunit "PTE CIM 2 Upg. PrintVis L.";
        UpgradeTag: Codeunit "Upgrade Tag";
        UpgradeTags: Codeunit "PTE CIM 2 Upg. PrintVis Tags";

}