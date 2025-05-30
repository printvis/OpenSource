codeunit 80273 "PTE CIM 1 Upg. PrintVis Tags"//Get new object id
{
    Access = Internal;


    procedure GetMoveControllerToPrintVisTableTag(): Code[250]
    begin
        exit('5e18f680-4e78-46bc-ad0b-e28a6fffa881');
    end;

    procedure GetMoveDeviceToPrintVisTableTag(): Code[250]
    begin
        exit('b7edb4d0-2db4-4f47-847b-4b35c837bc96');
    end;

    procedure GetMoveCostCenterFieldToPrintVisTableTag(): Code[250]
    begin
        exit('bba7197e-7864-4dd4-a065-8d7a923200e7');
    end;

    procedure GetPVSCIMSystemJDFEnumValueInControllerTableTag(): Code[250]
    begin
        exit('88bba459-aad0-4beb-b3e5-f50bcfdbee07');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Upgrade Tag", 'OnGetPerCompanyUpgradeTags', '', false, false)]
    local procedure OnGetPerCompanyUpgradeTags(var PerCompanyUpgradeTags: List of [Code[250]]);
    begin
        PerCompanyUpgradeTags.Add(GetMoveControllerToPrintVisTableTag());
        PerCompanyUpgradeTags.Add(GetMoveDeviceToPrintVisTableTag());
        PerCompanyUpgradeTags.Add(GetMoveCostCenterFieldToPrintVisTableTag());
        PerCompanyUpgradeTags.Add(GetPVSCIMSystemJDFEnumValueInControllerTableTag());
    end;
}