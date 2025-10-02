namespace PrintVis.OpenSource.NShift.Ship;

using PrintVis.OpenSource.NShift.Common;
using PrintVis.OpenSource.NShift.Ship.Setup;
using System.Utilities;

codeunit 80159 "SINS Ship Validation"
{
    var
        ErrorMessageMgt: Codeunit "Error Message Management";

    procedure ValidateShipmentCreation(in_Shipment: Record "PVS Job Shipment")
    var
        GeneralValidation: Codeunit "SINS General Validation";
    begin
        this.ValidateSetup();

        GeneralValidation.Set(this.ErrorMessageMgt);
        GeneralValidation.CheckShippingAgentSetup(in_Shipment);
        GeneralValidation.CheckShipmentPallet(in_Shipment);
        GeneralValidation.CheckShipmentSenderAddress(in_Shipment);
        GeneralValidation.CheckShipmentRecipientAddress(in_Shipment);
    end;

    procedure ValidateShipmentCreation(in_CombinedShipment: Record "PVS Combined Shipment Header")
    var
        GeneralValidation: Codeunit "SINS General Validation";
    begin
        this.ValidateSetup();

        GeneralValidation.Set(this.ErrorMessageMgt);
        GeneralValidation.CheckShippingAgentSetup(in_CombinedShipment);
        GeneralValidation.CheckShipmentPallet(in_CombinedShipment);
        GeneralValidation.CheckShipmentSenderAddress(in_CombinedShipment);
        GeneralValidation.CheckShipmentRecipientAddress(in_CombinedShipment);
    end;

    procedure ValidateSetup()
    var
        ShipSetup: Record "SINS Ship Setup";
    begin
        if not ShipSetup.Get() then
            this.ErrorMessageMgt.LogSimpleErrorMessage('nShift Setup not found');

        if ShipSetup."Authentication Server Url" = '' then
            this.LogEmptyField(ShipSetup.RecordId(), ShipSetup.FieldNo("Authentication Server Url"));
        if ShipSetup."Server Url" = '' then
            this.LogEmptyField(ShipSetup.RecordId(), ShipSetup.FieldNo("Server Url"));
        if ShipSetup."Actor ID" = 0 then
            this.LogEmptyField(ShipSetup.RecordId(), ShipSetup.FieldNo("Actor ID"));

        if ShipSetup."Client ID" = '' then
            this.LogEmptyField(ShipSetup.RecordId(), ShipSetup.FieldNo("Client ID"));
        if not ShipSetup.ClientSecretIsSet() then
            this.ErrorMessageMgt.LogSimpleErrorMessage('Client Secret is not set');
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