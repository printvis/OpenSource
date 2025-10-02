namespace PrintVis.OpenSource.NShift.Common;

using PrintVis.OpenSource.NShift.Delivery.Setup;
using PrintVis.OpenSource.NShift.Ship.Setup;
using Microsoft.Inventory.Location;

codeunit 80156 "SINS Event Handler"
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Shipping Integration Evts.", 'OnRegisterShippingApps', '', false, false)]
    local procedure RegisterNShiftShipApp(var out_ShippingApps: Record "PVS Shipping Apps")
    var
        ShipSetup: Record "SINS Ship Setup";
        ShippingIntegrationLbl: Label 'PrintVis Open Source - nShift Ship';
    begin
        ShipSetup.Initialize();

        if ShipSetup.Enabled then
            out_ShippingApps.Status := out_ShippingApps.Status::Enabled
        else
            out_ShippingApps.Status := out_ShippingApps.Status::Disabled;

        out_ShippingApps.InsertShippingApp(out_ShippingApps, ShippingIntegrationLbl, ShipSetup.RecordId(), Page::"SINS Ship Setup");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Shipping Integration Evts.", 'OnRegisterShippingApps', '', false, false)]
    local procedure RegisterNShiftDeliveryApp(var out_ShippingApps: Record "PVS Shipping Apps")
    var
        DeliverySetup: Record "SINS Delivery Setup";
        DeliveryIntegrationLbl: Label 'PrintVis Open Source - nShift Delivery';
    begin
        DeliverySetup.Initialize();

        if DeliverySetup.Enabled then
            out_ShippingApps.Status := out_ShippingApps.Status::Enabled
        else
            out_ShippingApps.Status := out_ShippingApps.Status::Disabled;

        out_ShippingApps.InsertShippingApp(out_ShippingApps, DeliveryIntegrationLbl, DeliverySetup.RecordId(), Page::"SINS Delivery Setup");
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Shipment", 'OnAfterValidateEvent', 'Sender Code', false, false)]
    local procedure OnAfterValidateJobShipmentSenderCode(var Rec: Record "PVS Job Shipment"; var xRec: Record "PVS Job Shipment")
    var
        SenderAddress: Record "PVS Sender Address";
    begin
        if not SenderAddress.Get(Rec."Sender Code") then
            Clear(SenderAddress);

        Rec."SINS Sender Quick ID" := SenderAddress."SINS Quick ID";
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Shipment", 'OnAfterSetSenderAddressFromDefaultAddress', '', false, false)]
    local procedure OnAfterSetSenderAddressFromDefaultAddress(var JobShipment: Record "PVS Job Shipment"; ShippingSetup: Record "PVS Shipping Setup")
    var
    begin
        JobShipment."SINS Sender Quick ID" := ShippingSetup."SINS Quick Id";
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Shipment", 'OnAfterSetSenderAddressFromSenderAddress', '', false, false)]
    local procedure OnAfterSetSenderAddressFromSenderAddress(var JobShipment: Record "PVS Job Shipment"; SenderAddress: Record "PVS Sender Address")
    var
    begin
        JobShipment."SINS Sender Quick ID" := SenderAddress."SINS Quick ID";
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Shipment", 'OnAfterSetSenderAddressFromLocation', '', false, false)]
    local procedure OnAfterSetSenderAddressFromLocation(var JobShipment: Record "PVS Job Shipment"; Location: Record Location)
    var
    begin
        JobShipment."SINS Sender Quick ID" := Location."SINS Quick ID";
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Combined Shipment Header", 'OnBeforeInsertCreateFromShipment', '', false, false)]
    local procedure OnBeforeInsertCreateFromShipment(PVSJobShipment: Record "PVS Job Shipment"; var PVSCombinedShipmentHeader: Record "PVS Combined Shipment Header")
    begin
        PVSCombinedShipmentHeader."SINS Sender Quick ID" := PVSJobShipment."SINS Sender Quick ID";
        PVSCombinedShipmentHeader."SINS Shipment Tag" := PVSJobShipment."SINS Shipment Tag";
    end;
}