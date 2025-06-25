codeunit 80270 "PTE CIM 3 Upg. TT Codeunit"//Get new object id
{
    Subtype = Install;
    trigger OnInstallAppPerCompany()
    begin
        // Code to perform company related table upgrade tasks
        UpgradeMoveDeviceToPrintVisTable();
        UpgradeMoveControllerToPrintVisTable();
        UpgradeMoveCostCenterFieldToPrintVisTable();
        UpgradePVSCIMSystemJDFEnumValueInControllerTable();
    end;

    local procedure UpgradeMoveControllerToPrintVisTable();
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.GetMoveControllerToPrintVisTableTag()) then
            exit;
        UpgradeLogic.MoveControllerToPrintVisTable();
        UpgradeTag.SetUpgradeTag(UpgradeTags.GetMoveControllerToPrintVisTableTag());
    end;

    local procedure UpgradeMoveDeviceToPrintVisTable()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.GetMoveDeviceToPrintVisTableTag()) then
            exit;
        UpgradeLogic.MoveDeviceToPrintVisTable();
        UpgradeTag.SetUpgradeTag(UpgradeTags.GetMoveDeviceToPrintVisTableTag());
    end;

    local procedure UpgradeMoveCostCenterFieldToPrintVisTable()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.GetMoveCostCenterFieldToPrintVisTableTag()) then
            exit;
        UpgradeLogic.MoveCostCenterFieldToPrintVisTable();
        UpgradeTag.SetUpgradeTag(UpgradeTags.GetMoveCostCenterFieldToPrintVisTableTag());
    end;

    local procedure UpgradePVSCIMSystemJDFEnumValueInControllerTable()
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.GetPVSCIMSystemJDFEnumValueInControllerTableTag()) then
            exit;
        UpgradeLogic.UpdatePVSCIMSystemJDFEnumValueInControllerTable();
        UpgradeTag.SetUpgradeTag(UpgradeTags.GetPVSCIMSystemJDFEnumValueInControllerTableTag());
    end;

    var
        UpgradeLogic: Codeunit "PTE CIM 3 Upg. PrintVis L.";
        UpgradeTag: Codeunit "Upgrade Tag";
        UpgradeTags: Codeunit "PTE CIM 3 Upg. PrintVis Tags";

}