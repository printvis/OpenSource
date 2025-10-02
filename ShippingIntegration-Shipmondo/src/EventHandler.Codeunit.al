namespace PrintVis.OpenSource.Shipmondo;

using PrintVis.OpenSource.Shipmondo.Configuration;
using System.Utilities;

codeunit 80184 "SISM Event Handler"
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Shipping Integration Evts.", 'OnRegisterShippingApps', '', true, false)]
    local procedure RegisterShipmondoShipApp(var out_ShippingApps: Record "PVS Shipping Apps")
    var
        ShipmondoSetup: Record "SISM Setup";
        ShippingIntegrationLbl: Label 'PrintVis Open Source - Shipmondo';
    begin
        ShipmondoSetup.Initialize();

        if ShipmondoSetup.Enabled then
            out_ShippingApps.Status := out_ShippingApps.Status::Enabled
        else
            out_ShippingApps.Status := out_ShippingApps.Status::Disabled;

        out_ShippingApps.InsertShippingApp(out_ShippingApps, ShippingIntegrationLbl, ShipmondoSetup.RecordId(), Page::"SISM Setup");
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Shipment", 'OnAfterValidateEvent', 'Shipping Agent Code', false, false)]
    local procedure OnAfterValidateJobShipmentShippingAgentCode(var Rec: Record "PVS Job Shipment"; var xRec: Record "PVS Job Shipment")
    var
        ShipmondoIntegration: Codeunit "SISM Mgt";
    begin
        if not ShipmondoIntegration.IsEnabled() then
            exit;

        if Rec."Shipping Agent Code" <> xRec."Shipping Agent Code" then
            Rec.Validate("SISM Service Point ID", '');
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Shipment", 'OnAfterValidateEvent', 'Shipping Agent Service Code', false, false)]
    local procedure OnAfterValidateJobShipmentShippingAgentServiceCode(var Rec: Record "PVS Job Shipment"; var xRec: Record "PVS Job Shipment")
    var
        ShipmondoIntegration: Codeunit "SISM Mgt";
    begin
        if not ShipmondoIntegration.IsEnabled() then
            exit;

        if Rec."Shipping Agent Service Code" <> xRec."Shipping Agent Service Code" then
            Rec.Validate("SISM Service Point ID", '');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Shipping Integration Evts.", 'OnAfterExecuteShippingAction', '', false, false)]
    local procedure OnAfterExecuteShippingAction(
        in_ShippingAction: Enum "PVS Shipping Action";
        in_Integration: Interface "PVS Shipping Integration";
        var out_ErrorMessageMgt: Codeunit "Error Message Management";
        in_IsCombinedShipment: Boolean;
        var out_Shipment: Record "PVS Job Shipment";
        var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
        var out_Result: Boolean)
    var
        ErrorHelper: Codeunit "PVS Error Logging Management";
        ShippingIntegration: codeunit "PVS Shipping Integration";
        ShipmondoIntegration: Codeunit "SISM Mgt";
    begin
        if not ShipmondoIntegration.IsEnabled() then
            exit;

        if ErrorHelper.HasErrors(out_ErrorMessageMgt) then
            exit;

        if not out_Result then
            exit;

        case in_ShippingAction of
            Enum::"PVS Shipping Action"::"Retrieve Labels":
                if in_IsCombinedShipment then
                    ShippingIntegration.ExecuteShippingAction(Enum::"PVS Shipping Action"::"View Labels", out_CombinedShipment, out_CombinedShipmentLine)
                else
                    ShippingIntegration.ExecuteShippingAction(Enum::"PVS Shipping Action"::"View Labels", out_Shipment);
            Enum::"PVS Shipping Action"::"Fetch Shipping Rates":
                begin
                    Commit();
                    if in_IsCombinedShipment then
                        ShippingIntegration.ExecuteShippingAction(Enum::"PVS Shipping Action"::"View Shipping Rates", out_CombinedShipment, out_CombinedShipmentLine)
                    else
                        ShippingIntegration.ExecuteShippingAction(Enum::"PVS Shipping Action"::"View Shipping Rates", out_Shipment);
                end;
        end;
    end;
}
