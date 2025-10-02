namespace PrintVis.OpenSource.Shipmondo;

using Microsoft.Foundation.Shipping;
using PrintVis.OpenSource.Shipmondo.Configuration;
using System.Utilities;

codeunit 80191 "SISM Validation"
{
    var
        ErrorMessageMgt: Codeunit "Error Message Management";
        PasswordMissingErr: Label 'Password is not configured in Shipmondo setup.';
        PrinterNotFoundErr: Label 'Print Client "%1" does not exist. Please configure the printer in Print Client setup.', Comment = '%1 = Printer Name';
        PVSExternalServiceIdMissingErr: Label 'PVS External Service Id is not configured for Shipping Agent Service "%1" "%2". Please configure it in the Shipping Agent Services setup.', Comment = '%1 = Shipping Agent Code, %2 = Service Code';
        ServerUrlMissingErr: Label 'Server URL is not configured in Shipmondo setup.';

        ShipmondoSetupMissingErr: Label 'Shipmondo setup is not configured. Please complete the setup before creating shipments.';
        ShipmondoSetupNotEnabledErr: Label 'Shipmondo integration is not enabled. Please enable it in the setup.';
        ShippingAgentNotShipmondoErr: Label 'Shipping Agent "%1" is not configured for Shipmondo integration.', Comment = '%1 = Shipping Agent Code';
        UsernameMissingErr: Label 'Username is not configured in Shipmondo setup.';

    procedure Set(var out_NewErrorMessageMgt: Codeunit "Error Message Management")
    begin
        ErrorMessageMgt := out_NewErrorMessageMgt;
    end;

    procedure ValidateShipmentCreation(in_Shipment: Record "PVS Job Shipment"): Boolean
    begin
        exit(ValidateSetup() and ValidateShipmentData(in_Shipment));
    end;

    procedure ValidateSetup(): Boolean
    var
        ShipmondoSetup: Record "SISM Setup";
        IsValid: Boolean;
    begin
        IsValid := true;

        if not ShipmondoSetup.Get() then begin
            ErrorMessageMgt.LogSimpleErrorMessage(ShipmondoSetupMissingErr);
            exit(false);
        end;

        if not ShipmondoSetup.Enabled then begin
            ErrorMessageMgt.LogSimpleErrorMessage(ShipmondoSetupNotEnabledErr);
            IsValid := false;
        end;

        if ShipmondoSetup."Server Url" = '' then begin
            ErrorMessageMgt.LogSimpleErrorMessage(ServerUrlMissingErr);
            IsValid := false;
        end;

        if ShipmondoSetup.Username = '' then begin
            ErrorMessageMgt.LogSimpleErrorMessage(UsernameMissingErr);
            IsValid := false;
        end;

        if not ShipmondoSetup.PasswordIsSet() then begin
            ErrorMessageMgt.LogSimpleErrorMessage(PasswordMissingErr);
            IsValid := false;
        end;

        exit(IsValid);
    end;

    local procedure ValidateShipmentData(in_Shipment: Record "PVS Job Shipment"): Boolean
    begin
        exit(ValidateShippingAgent(in_Shipment) and
             ValidateShippingAgentService(in_Shipment) and
             ValidateSenderAddress(in_Shipment) and
             ValidateReceiverAddress(in_Shipment) and
             ValidateParcelData(in_Shipment) and
             ValidateServicePointRequirement(in_Shipment) and
             ValidatePrintRequirement(in_Shipment));
    end;

    local procedure ValidateShippingAgent(in_Shipment: Record "PVS Job Shipment"): Boolean
    var
        ShippingAgent: Record "Shipping Agent";
        IsValid: Boolean;
    begin
        IsValid := true;

        if in_Shipment."Shipping Agent Code" = '' then begin
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Shipping Agent Code"));
            exit(false);
        end;

        if not ShippingAgent.Get(in_Shipment."Shipping Agent Code") then begin
            ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(ShippingAgentNotShipmondoErr, in_Shipment."Shipping Agent Code"));
            exit(false);
        end;

        if ShippingAgent."PVS Shipping Integration" <> Enum::"PVS Shipping Integration"::"SISM" then begin
            ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(ShippingAgentNotShipmondoErr, in_Shipment."Shipping Agent Code"));
            IsValid := false;
        end;

        if ShippingAgent."SISM External Service Id" = '' then begin
            this.LogEmptyField(ShippingAgent.RecordId(), ShippingAgent.FieldNo("SISM External Service Id"));
            IsValid := false;
        end;

        exit(IsValid);
    end;

    local procedure ValidateShippingAgentService(in_Shipment: Record "PVS Job Shipment"): Boolean
    var
        ShippingAgentService: Record "Shipping Agent Services";
        IsValid: Boolean;
    begin
        IsValid := true;

        if in_Shipment."Shipping Agent Service Code" = '' then begin
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Shipping Agent Service Code"));
            exit(false);
        end;

        if not ShippingAgentService.Get(in_Shipment."Shipping Agent Code", in_Shipment."Shipping Agent Service Code") then begin
            ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(PVSExternalServiceIdMissingErr, in_Shipment."Shipping Agent Code", in_Shipment."Shipping Agent Service Code"));
            exit(false);
        end;

        if ShippingAgentService."PVS External Service Id" = '' then begin
            this.LogEmptyField(ShippingAgentService.RecordId(), ShippingAgentService.FieldNo("PVS External Service Id"));
            IsValid := false;
        end;

        exit(IsValid);
    end;

    local procedure ValidateSenderAddress(in_Shipment: Record "PVS Job Shipment"): Boolean
    var
        IsValid: Boolean;
    begin
        IsValid := true;

        if in_Shipment."Sender Name" = '' then begin
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Sender Name"));
            IsValid := false;
        end;

        if in_Shipment."Sender Address" = '' then begin
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Sender Address"));
            IsValid := false;
        end;

        if in_Shipment."Sender Post Code" = '' then begin
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Sender Post Code"));
            IsValid := false;
        end;

        if in_Shipment."Sender City" = '' then begin
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Sender City"));
            IsValid := false;
        end;

        if in_Shipment."Sender Country/Region Code" = '' then begin
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Sender Country/Region Code"));
            IsValid := false;
        end;

        exit(IsValid);
    end;

    local procedure ValidateReceiverAddress(in_Shipment: Record "PVS Job Shipment"): Boolean
    var
        IsValid: Boolean;
    begin
        IsValid := true;

        if in_Shipment.Name = '' then begin
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo(Name));
            IsValid := false;
        end;

        if in_Shipment.Address = '' then begin
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo(Address));
            IsValid := false;
        end;

        if in_Shipment."Post Code" = '' then begin
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Post Code"));
            IsValid := false;
        end;

        if in_Shipment.City = '' then begin
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo(City));
            IsValid := false;
        end;

        if in_Shipment."Country/Region Code" = '' then begin
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Country/Region Code"));
            IsValid := false;
        end;

        exit(IsValid);
    end;

    local procedure ValidateParcelData(in_Shipment: Record "PVS Job Shipment"): Boolean
    var
        PalletType: Record "PVS Pallet Types";
        IsValid: Boolean;
        Weight: Decimal;
        Copies: Integer;
        InvalidPalletTypeErr: Label 'Invalid Pallet Type "%1" for this shipping agent.', Comment = '%1 = Pallet Type';
    begin
        IsValid := true;

        if in_Shipment."Qty. To Ship" = 0 then begin
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Qty. To Ship"));
            IsValid := false;
        end;

        if in_Shipment."Pallet Type" = '' then begin
            this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Pallet Type"));
            exit(false);
        end;

        if not PalletType.Get(in_Shipment."Shipping Agent Code", in_Shipment."Pallet Type") then begin
            ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(InvalidPalletTypeErr, in_Shipment."Pallet Type"));
            exit(false);
        end;

        if PalletType."External Pallet Code" = '' then begin
            this.LogEmptyField(PalletType.RecordId(), PalletType.FieldNo("External Pallet Code"));
            IsValid := false;
        end;

        if PalletType.Package then begin
            Copies := in_Shipment."No. Of Packages";
            Weight := in_Shipment."Weight Per Package";

            if Copies <= 0 then begin
                this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("No. Of Packages"));
                IsValid := false;
            end;

            if Weight <= 0 then begin
                this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Weight Per Package"));
                IsValid := false;
            end;

            if (in_Shipment.Last_Packet_Quantity() > 0) and (in_Shipment."Weight of Last Package" = 0) then begin
                this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Weight of Last Package"));
                IsValid := false;
            end;

            if in_Shipment."Package Height" = 0 then begin
                this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Package Height"));
                IsValid := false;
            end;

            if in_Shipment."Package Width" = 0 then begin
                this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Package Width"));
                IsValid := false;
            end;

            if in_Shipment."Package Length" = 0 then begin
                this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Package Length"));
                IsValid := false;
            end;
        end else begin
            Copies := in_Shipment."No. Of Pallets";
            Weight := in_Shipment."Weight Per Pallet";

            if Copies <= 0 then begin
                this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("No. Of Pallets"));
                IsValid := false;
            end;

            if Weight <= 0 then begin
                this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("Weight Per Pallet"));
                IsValid := false;
            end;
        end;

        exit(IsValid);
    end;

    local procedure ValidateServicePointRequirement(in_Shipment: Record "PVS Job Shipment"): Boolean
    var
        ShippingAgentService: Record "Shipping Agent Services";
    begin
        if ShippingAgentService.Get(in_Shipment."Shipping Agent Code", in_Shipment."Shipping Agent Service Code") then
            if ShippingAgentService."SISM Req. Service Point" and (in_Shipment."SISM Service Point ID" = '') then begin
                this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("SISM Service Point ID"));
                exit(false);
            end;

        exit(true);
    end;

    local procedure ValidatePrintRequirement(in_Shipment: Record "PVS Job Shipment"): Boolean
    var
        PrintClient: Record "SISM Print Client";
    begin
        if in_Shipment."SISM Print Label" then begin
            if in_Shipment."SISM Printer Name" = '' then begin
                this.LogEmptyField(in_Shipment.RecordId(), in_Shipment.FieldNo("SISM Printer Name"));
                exit(false);
            end;

            if not PrintClient.Get(in_Shipment."SISM Printer Name") then begin
                ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(PrinterNotFoundErr, in_Shipment."SISM Printer Name"));
                exit(false);
            end;
        end;

        exit(true);
    end;

    local procedure LogEmptyField(in_SourceRecordId: RecordId; in_SourceFieldNo: Integer)
    var
        EmptyFieldErr: Label 'Field is empty';
    begin
        this.ErrorMessageMgt.LogContextFieldError(0, EmptyFieldErr, in_SourceRecordId, in_SourceFieldNo, '');
    end;
}