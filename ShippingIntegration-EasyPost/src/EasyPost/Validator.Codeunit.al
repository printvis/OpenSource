codeunit 80141 "SIEP Validator"
{
    var
        ErrorMessageMgt: Codeunit "Error Message Management";

    procedure CreateOrderValidate(var out_Shipment: Record "PVS Job Shipment"): Boolean
    var
        PalletType: Record "PVS Pallet Types";
    begin
        this.CheckShippingAgent(out_Shipment);
        this.CheckShipmentSenderAddress(out_Shipment);
        this.CheckShipmentRecipientAddress(out_Shipment);

        if PalletType.Get(out_Shipment."Shipping Agent Code", out_Shipment."Pallet Type") then begin
            this.CheckPackageInfo(out_Shipment, PalletType);
            this.CheckPackageDimensions(out_Shipment, PalletType);
            this.CheckPackageWeight(out_Shipment, PalletType);
        end else
            this.ErrorMessageMgt.LogSimpleErrorMessage('Pallet type not found');
    end;

    procedure CheckShipmentSenderAddress(in_Shipment: Record "PVS Job Shipment")
    begin
        if in_Shipment."SIEP Sender Address Id" = '' then
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("SIEP Sender Address Id"));
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
    var
        ShipToAddressVerifiedErr: Label 'Ship-to address not verified';
    begin
        if in_Shipment."SIEP Ship-to Address Id" = '' then
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("SIEP Ship-to Address Id"));
        if in_Shipment."SIEP Ship-to Address Verified" = false then
            this.ErrorMessageMgt.LogSimpleErrorMessage(ShipToAddressVerifiedErr);
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

    local procedure CheckPackageDimensions(in_Shipment: Record "PVS Job Shipment"; in_PalletType: Record "PVS Pallet Types")
    var
        DimensionsRequiredErr: Label 'Package dimensions are required when no predefined package is specified';
    begin
        if not in_PalletType.Package then
            exit;

        if (in_Shipment."SIEP Predefined Package" = '') then begin
            if in_Shipment."Package Length" <= 0 then
                this.ErrorMessageMgt.LogContextFieldError(0, DimensionsRequiredErr, in_Shipment.RecordId(), in_Shipment.FieldNo("Package Length"), '');
            if in_Shipment."Package Width" <= 0 then
                this.ErrorMessageMgt.LogContextFieldError(0, DimensionsRequiredErr, in_Shipment.RecordId(), in_Shipment.FieldNo("Package Width"), '');
            if in_Shipment."Package Height" <= 0 then
                this.ErrorMessageMgt.LogContextFieldError(0, DimensionsRequiredErr, in_Shipment.RecordId(), in_Shipment.FieldNo("Package Height"), '');
        end;
    end;

    local procedure CheckPackageWeight(in_Shipment: Record "PVS Job Shipment"; in_PalletType: Record "PVS Pallet Types")
    var
        DimensionsRequiredErr: Label 'Package weight is required';
    begin
        if in_PalletType.Package then begin
            if in_Shipment."Weight Per Package" <= 0 then
                this.ErrorMessageMgt.LogContextFieldError(0, DimensionsRequiredErr, in_Shipment.RecordId(), in_Shipment.FieldNo("Weight Per Package"), '');
        end else
            if in_Shipment."Weight Per Pallet" <= 0 then
                this.ErrorMessageMgt.LogContextFieldError(0, DimensionsRequiredErr, in_Shipment.RecordId(), in_Shipment.FieldNo("Weight Per Pallet"), '');
    end;

    local procedure CheckShippingAgent(in_Shipment: Record "PVS Job Shipment")
    var
        ShippingAgent: Record "Shipping Agent";
        ShippingAgentService: Record "Shipping Agent Services";
        ShippingAgentErr: Label 'Invalid shipping agent';
        ShippingServiceErr: Label 'Invalid shipping service';
    begin
        if not ShippingAgent.Get(in_Shipment."Shipping Agent Code") then
            this.ErrorMessageMgt.LogSimpleErrorMessage(ShippingAgentErr);

        if not ShippingAgentService.Get(in_Shipment."Shipping Agent Code", in_Shipment."Shipping Agent Service Code") then
            this.ErrorMessageMgt.LogSimpleErrorMessage(ShippingServiceErr);
    end;

    local procedure CheckPackageInfo(in_Shipment: Record "PVS Job Shipment"; in_PalletType: Record "PVS Pallet Types")
    var
        PackageInfoErr: Label 'Package quantity must be greater than 0';
    begin
        if in_PalletType.Package then begin
            if in_Shipment."No. Of Packages" <= 0 then
                this.ErrorMessageMgt.LogSimpleErrorMessage(PackageInfoErr)
        end else
            if in_Shipment."No. Of Pallets" <= 0 then
                this.ErrorMessageMgt.LogSimpleErrorMessage(PackageInfoErr);
    end;
}