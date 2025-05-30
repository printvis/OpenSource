codeunit 80266 "PTE CIM 1 Upg. TT Codeunit"//Get new object id
{
    Subtype = Upgrade;
    trigger OnCheckPreconditionsPerCompany()
    begin
        // Code to make sure company is OK to upgrade.
    end;

    trigger OnUpgradePerCompany()
    begin
        // Code to perform company related table upgrade tasks
        UpgradeMoveDeviceToTempTable();
        UpgradeMoveControllerToTempTable();
        UpgradeMoveCostCenterFieldToTempTable();
    end;

    trigger OnValidateUpgradePerCompany()
    begin
        // Code to make sure that upgrade was successful for each company
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
        UpgradeLogic: Codeunit "PTE CIM 1 Upg. PrintVis L.";
        UpgradeTag: Codeunit "Upgrade Tag";
        UpgradeTags: Codeunit "PTE CIM 1 Upg. PrintVis Tags";

}