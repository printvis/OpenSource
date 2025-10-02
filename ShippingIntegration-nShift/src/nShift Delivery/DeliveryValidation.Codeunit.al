namespace PrintVis.OpenSource.NShift.Delivery;

using PrintVis.OpenSource.NShift.Common;
using PrintVis.OpenSource.NShift.Delivery.Setup;
using System.Utilities;

codeunit 80165 "SINS Delivery Validation"
{
    var
        ErrorMessageMgt: Codeunit "Error Message Management";
        GeneralValidation: Codeunit "SINS General Validation";

    procedure ValidateShipmentCreation(in_Shipment: Record "PVS Job Shipment")
    begin
        this.ValidateSetup();

        this.GeneralValidation.Set(this.ErrorMessageMgt);
        this.GeneralValidation.CheckShippingAgentSetup(in_Shipment);
        this.GeneralValidation.CheckShipmentPallet(in_Shipment);
        this.GeneralValidation.CheckShipmentRecipientAddress(in_Shipment);
        this.CheckShipmentSenderAddress(in_Shipment);
    end;

    procedure ValidateShipmentCreation(in_CombinedShipment: Record "PVS Combined Shipment Header")
    begin
        this.ValidateSetup();

        this.GeneralValidation.Set(this.ErrorMessageMgt);
        this.GeneralValidation.CheckShippingAgentSetup(in_CombinedShipment);
        this.GeneralValidation.CheckShipmentPallet(in_CombinedShipment);
        this.GeneralValidation.CheckShipmentRecipientAddress(in_CombinedShipment);
        this.CheckShipmentSenderAddress(in_CombinedShipment);
    end;

    procedure ValidateSetup()
    var
        DeliverySetup: Record "SINS Delivery Setup";
    begin
        if not DeliverySetup.Get() then
            this.ErrorMessageMgt.LogSimpleErrorMessage('nShift Setup not found');

        if DeliverySetup."Server Url" = '' then
            this.LogEmptyField(DeliverySetup.RecordId(), DeliverySetup.FieldNo("Server Url"));

        if not DeliverySetup.ApiKeyIsSet() then
            this.LogEmptyField(DeliverySetup.RecordId(), DeliverySetup.FieldNo("Api Key ID"));
    end;

    local procedure CheckShipmentSenderAddress(in_Shipment: Record "PVS Job Shipment")
    begin
        if in_Shipment."SINS Sender Quick ID" = '' then
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo(Name));
    end;

    local procedure CheckShipmentSenderAddress(in_CombinedShipment: Record "PVS Combined Shipment Header")
    begin
        if in_CombinedShipment."SINS Sender Quick ID" = '' then
            this.LogEmptyField(in_CombinedShipment.RecordId(), in_CombinedShipment.FieldNo(Name));
    end;

    local procedure LogEmptyField(in_SourceVariant: Variant; in_SourceFieldNo: Integer)
    var
        EmptyFieldErr: Label 'Field is empty';
    begin
        this.ErrorMessageMgt.LogContextFieldError(0, EmptyFieldErr, in_SourceVariant, in_SourceFieldNo, '');
    end;

    procedure Set(var out_ErrorMessageMgt2: Codeunit "Error Message Management")
    begin
        this.ErrorMessageMgt := out_ErrorMessageMgt2;
    end;
}