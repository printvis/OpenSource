codeunit 80174 "PTE Status Code Sub. Filter"
{
    [EventSubscriber(ObjectType::Table, Database::"PVS Case", 'OnLookUp_StatusCode_OnBeforeSettingStatusCodeFilter', '', false, false)]
    local procedure OnLookUp_StatusCode_OnBeforeSettingStatusCodeFilter(var PVSStatusCode: Record "PVS Status Code"; PVSCase: Record "PVS Case")
    begin
        PVSStatusCode.SetFilter(Status, '%1..', PVSCase.Type);
    end;
}
