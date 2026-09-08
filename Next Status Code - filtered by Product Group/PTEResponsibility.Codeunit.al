codeunit 80278 "PTE Responsibility"
{
    [EventSubscriber(ObjectType::Table, DataBase::"PVS Status Code", 'OnBeforeGetNewStatusFromResponsibilities', '', false, false)]
    local procedure OnBeforeGetNewStatusFromResponsibilities(in_ID: Integer; in_CurrStatusCode: Code[20]; in_OrderType: Code[20]; in_CustomerGroup: Code[20]; in_CustomerNo: Code[20]; var out_NewStatusCode: Code[20]; var out_IsHandled: Boolean)
    var
        CaseRec: Record "PVS Case";
        ResponsibilityRec: Record "PVS Status Responsiblity Area";
    begin
        if not CaseRec.get(in_ID) then
            exit;

        ResponsibilityRec.Reset();
        ResponsibilityRec.SetFilter(Status, '%1|%2', in_CurrStatusCode, '');
        ResponsibilityRec.SetFilter("Order Type", '%1|%2', in_OrderType, '');
        ResponsibilityRec.SetFilter("Customer Group", '%1|%2', CaseRec."Product Group", '');
        ResponsibilityRec.SetFilter("Sell-To No.", '%1|%2', in_CustomerNo, '');
        ResponsibilityRec.SetFilter("From Date", '..%1', Today());
        ResponsibilityRec.SetFilter("To Date", '%1..|%2', Today(), 0D);
        if ResponsibilityRec.FindLast() then
            if ResponsibilityRec."Next Status" <> '' then
                out_NewStatusCode := ResponsibilityRec."Next Status";
        out_IsHandled := true;

    end;
}
