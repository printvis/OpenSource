namespace PrintVis.OpenSource.NShift.Common;

using Microsoft.Foundation.Shipping;
using System.Utilities;

codeunit 80155 "SINS General Validation"
{
    var
        ErrorMessageMgt: Codeunit "Error Message Management";
        InvalidPalletTypeErr: Label 'Invalid pallet type: %1', Comment = '%1 = Pallet Type';

    #region Shipping
    procedure CheckShippingAgentSetup(in_Shipment: Record "PVS Job Shipment")
    var
        ShippingAgentServices: Record "Shipping Agent Services";
    begin
        if in_Shipment."Shipping Agent Code" = '' then
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Shipping Agent Code"));

        if in_Shipment."Shipping Agent Service Code" = '' then
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Shipping Agent Service Code"));

        if ShippingAgentServices.Get(in_Shipment."Shipping Agent Code", in_Shipment."Shipping Agent Service Code") then
            if ShippingAgentServices."PVS External Service Id" = '' then
                this.LogEmptyField(ShippingAgentServices.RecordId(), ShippingAgentServices.FieldNo("PVS External Service Id"));
    end;

    procedure CheckShipmentPallet(in_Shipment: Record "PVS Job Shipment")
    var
        PalletType: Record "PVS Pallet Types";
    begin
        if in_Shipment."Qty. To Ship" = 0 then
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Qty. To Ship"));

        if in_Shipment."Pallet Type" = '' then
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Pallet Type"));

        if PalletType.Get(in_Shipment."Shipping Agent Code", in_Shipment."Pallet Type") then begin
            if PalletType."External Pallet Code" = '' then
                this.LogEmptyField(PalletType.RecordId(), PalletType.FieldNo("External Pallet Code"));

            if PalletType.Package then begin
                if in_Shipment."No. Of Packages" = 0 then
                    this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("No. Of Packages"));
                if in_Shipment."Weight Per Package" = 0 then
                    this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Weight Per Package"));
                if (in_Shipment.Last_Packet_Quantity() > 0) and (in_Shipment."Weight of Last Package" = 0) then
                    this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Weight of Last Package"));

                if in_Shipment."Package Height" = 0 then
                    this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Package Height"));
                if in_Shipment."Package Width" = 0 then
                    this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Package Width"));
                if in_Shipment."Package Length" = 0 then
                    this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Package Length"));
            end else begin
                if in_Shipment."No. Of Pallets" = 0 then
                    this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("No. Of Pallets"));
                if in_Shipment."Weight Per Pallet" = 0 then
                    this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Weight Per Pallet"));
            end;
        end else
            this.ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(this.InvalidPalletTypeErr, in_Shipment."Pallet Type"));
    end;

    procedure CheckShipmentSenderAddress(in_Shipment: Record "PVS Job Shipment")
    begin
        if in_Shipment."Sender Name" = '' then
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Sender Name"));
        if in_Shipment."Sender Address" = '' then
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Sender Address"));
        if in_Shipment."Sender City" = '' then
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Sender City"));
        if in_Shipment."Sender Post Code" = '' then
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Sender Post Code"));
        if in_Shipment."Sender Contact" = '' then
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Sender Contact"));
        if in_Shipment."Sender E-Mail" = '' then
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Sender E-Mail"));
    end;

    procedure CheckShipmentRecipientAddress(in_Shipment: Record "PVS Job Shipment")
    begin
        if in_Shipment.Name = '' then
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo(Name));
        if in_Shipment.Address = '' then
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo(Address));
        if in_Shipment.City = '' then
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo(City));
        if in_Shipment."Post Code" = '' then
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Post Code"));
        if in_Shipment."Ship-to EMail" = '' then
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Ship-to EMail"));
    end;

    #endregion

    #region Combined Shipment
    procedure CheckShippingAgentSetup(in_CombinedShipment: Record "PVS Combined Shipment Header")
    var
        ShippingAgentServices: Record "Shipping Agent Services";
    begin
        if in_CombinedShipment."Shipping Agent Code" = '' then
            this.LogEmptyField(in_CombinedShipment.RecordId(), in_CombinedShipment.FieldNo("Shipping Agent Code"));

        if in_CombinedShipment."Shipping Agent Service Code" = '' then
            this.LogEmptyField(in_CombinedShipment.RecordId(), in_CombinedShipment.FieldNo("Shipping Agent Service Code"));

        if ShippingAgentServices.Get(in_CombinedShipment."Shipping Agent Code", in_CombinedShipment."Shipping Agent Service Code") then
            if ShippingAgentServices."PVS External Service Id" = '' then
                this.LogEmptyField(in_CombinedShipment.RecordId(), ShippingAgentServices.FieldNo("PVS External Service Id"));
    end;

    procedure CheckShipmentPallet(in_CombinedShipment: Record "PVS Combined Shipment Header")
    var
        PalletType: Record "PVS Pallet Types";
    begin
        if in_CombinedShipment."Pallet Type" = '' then
            this.LogEmptyField(in_CombinedShipment.RecordId(), in_CombinedShipment.FieldNo("Pallet Type"));

        if PalletType.Get(in_CombinedShipment."Shipping Agent Code", in_CombinedShipment."Pallet Type") then begin
            if PalletType."External Pallet Code" = '' then
                this.LogEmptyField(in_CombinedShipment.RecordId(), PalletType.FieldNo("External Pallet Code"));
        end else
            this.ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(this.InvalidPalletTypeErr, in_CombinedShipment."Pallet Type"));

        if in_CombinedShipment."No. Of Pallets" = 0 then
            this.LogEmptyField(in_CombinedShipment.RecordId(), in_CombinedShipment.FieldNo("No. Of Pallets"));
        if in_CombinedShipment."Weight Per Pallet" = 0 then
            this.LogEmptyField(in_CombinedShipment.RecordId(), in_CombinedShipment.FieldNo("Weight Per Pallet"));
    end;

    procedure CheckShipmentSenderAddress(in_CombinedShipment: Record "PVS Combined Shipment Header")
    begin
        if in_CombinedShipment."Sender Name" = '' then
            this.LogEmptyField(in_CombinedShipment.RecordId(), in_CombinedShipment.FieldNo("Sender Name"));
        if in_CombinedShipment."Sender Address" = '' then
            this.LogEmptyField(in_CombinedShipment.RecordId(), in_CombinedShipment.FieldNo("Sender Address"));
        if in_CombinedShipment."Sender City" = '' then
            this.LogEmptyField(in_CombinedShipment.RecordId(), in_CombinedShipment.FieldNo("Sender City"));
        if in_CombinedShipment."Sender Post Code" = '' then
            this.LogEmptyField(in_CombinedShipment.RecordId(), in_CombinedShipment.FieldNo("Sender Post Code"));
        if in_CombinedShipment."Sender Contact" = '' then
            this.LogEmptyField(in_CombinedShipment.RecordId(), in_CombinedShipment.FieldNo("Sender Contact"));
        if in_CombinedShipment."Sender E-Mail" = '' then
            this.LogEmptyField(in_CombinedShipment.RecordId(), in_CombinedShipment.FieldNo("Sender E-Mail"));
    end;

    procedure CheckShipmentRecipientAddress(in_CombinedShipment: Record "PVS Combined Shipment Header")
    begin
        if in_CombinedShipment.Name = '' then
            this.LogEmptyField(in_CombinedShipment.RecordId(), in_CombinedShipment.FieldNo(Name));
        if in_CombinedShipment.Address = '' then
            this.LogEmptyField(in_CombinedShipment.RecordId(), in_CombinedShipment.FieldNo(Address));
        if in_CombinedShipment.City = '' then
            this.LogEmptyField(in_CombinedShipment.RecordId(), in_CombinedShipment.FieldNo(City));
        if in_CombinedShipment."Post Code" = '' then
            this.LogEmptyField(in_CombinedShipment.RecordId(), in_CombinedShipment.FieldNo("Post Code"));
        if in_CombinedShipment."Ship-to EMail" = '' then
            this.LogEmptyField(in_CombinedShipment.RecordId(), in_CombinedShipment.FieldNo("Ship-to EMail"));
    end;
    #endregion

    procedure LogEmptyField(in_SourceVariant: Variant; in_SourceFieldNo: Integer)
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