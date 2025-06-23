codeunit 80269 "PTE CIM 2 Upg. PrintVis Tags"//Get new object id
{
    Access = Internal;
    procedure GetMoveControllerToTempTableTag(): Code[250]
    begin
        exit('806be5f9-9dc7-4493-8e45-9fcd7253fbe7');
    end;

    procedure GetMoveDeviceToTempTableTag(): Code[250]
    begin
        exit('71c6e312-1c0e-4cfb-b8b0-91b584b3c18c');
    end;

    procedure GetMoveCostCenterFieldToTempTableTag(): Code[250]
    begin
        exit('4622581a-466b-4a35-afa2-3d78fc19efb3');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Upgrade Tag", 'OnGetPerCompanyUpgradeTags', '', false, false)]
    local procedure OnGetPerCompanyUpgradeTags(var PerCompanyUpgradeTags: List of [Code[250]]);
    begin
        PerCompanyUpgradeTags.Add(GetMoveControllerToTempTableTag());
        PerCompanyUpgradeTags.Add(GetMoveDeviceToTempTableTag());
        PerCompanyUpgradeTags.Add(GetMoveCostCenterFieldToTempTableTag());
    end;
}