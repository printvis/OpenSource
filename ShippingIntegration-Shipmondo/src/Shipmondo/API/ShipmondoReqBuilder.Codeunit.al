namespace PrintVis.OpenSource.Shipmondo.API;
using Microsoft.Foundation.Shipping;
using PrintVis.OpenSource.Shipmondo.Configuration;

codeunit 80188 "SISM Req. Builder"
{
    procedure CreateShipmentQuoteObject(in_Shipment: Record "PVS Job Shipment"; in_InclParcel: Boolean; in_InclLastParcelOnly: Boolean): JsonObject
    var
        ShippingAgentService: Record "Shipping Agent Services";
        ParcelsArray: JsonArray;
        ReceiverObject, RequestObject, SenderObject, ServicePointObject : JsonObject;
    begin
        ShippingAgentService.Get(in_Shipment."Shipping Agent Code", in_Shipment."Shipping Agent Service Code");

        RequestObject.Add('product_code', ShippingAgentService."PVS External Service Id");
        if (ShippingAgentService."SISM Required Services" <> '') then
            RequestObject.Add('service_codes', ShippingAgentService."SISM Required Services");

        SenderObject := this.CreateAddressObject(in_Shipment."Sender Name",
            in_Shipment."Sender Name 2",
            in_Shipment."Sender Address",
            in_Shipment."Sender Address 2",
            in_Shipment."Sender Post Code",
            in_Shipment."Sender City",
            in_Shipment."Sender Country/Region Code",
            in_Shipment."Sender E-Mail",
            in_Shipment."Sender Phone No.",
            in_Shipment."Sender Mobile Phone No.",
            in_Shipment."Sender Name" + in_Shipment."Sender Name 2");
        RequestObject.Add('sender', SenderObject);

        if ShippingAgentService."SISM Req. Service Point" then begin
            ServicePointObject := this.CreateServicePointObject(in_Shipment."SISM Service Point ID");
            RequestObject.Add('service_point', ServicePointObject);
        end;

        ReceiverObject := this.CreateAddressObject(in_Shipment.Name,
            in_Shipment."Name 2",
            in_Shipment."Address",
            in_Shipment."Address 2",
            in_Shipment."Post Code",
            in_Shipment.City,
            in_Shipment."Country/Region Code",
            in_Shipment."Ship-to EMail",
            in_Shipment."Ship-to PhoneNo.",
            '',
            in_Shipment."Contact Name");
        RequestObject.Add('receiver', ReceiverObject);

        ParcelsArray := this.CreateParcelArray(in_Shipment, in_InclParcel, in_InclLastParcelOnly);

        RequestObject.Add('parcels', ParcelsArray);

        exit(RequestObject);
    end;

    procedure CreateShipmentObject(in_Shipment: Record "PVS Job Shipment"): JsonObject
    var
        ShippingAgent: Record "Shipping Agent";
        ShippingAgentService: Record "Shipping Agent Services";
        ShipmondoSetup: Record "SISM Setup";
        ParcelsArray: JsonArray;
        PrintAtObject, ReceiverObject, RequestObject, SenderObject, ServicePointObject : JsonObject;
    begin
        ShippingAgent.Get(in_Shipment."Shipping Agent Code");
        ShippingAgentService.Get(in_Shipment."Shipping Agent Code", in_Shipment."Shipping Agent Service Code");

        if ShipmondoSetup."Test Mode" then
            RequestObject.Add('test_mode', true);

        if (ShippingAgent."PVS Carrier Account ID" <> '') then begin
            RequestObject.Add('own_agreement', 'true');
            ReceiverObject.Add('customer_number', ShippingAgent."PVS Carrier Account ID");
        end else
            RequestObject.Add('own_agreement', false);

        RequestObject.Add('product_code', ShippingAgentService."PVS External Service Id");
        if (ShippingAgentService."SISM Required Services" <> '') then
            RequestObject.Add('service_codes', ShippingAgentService."SISM Required Services");

        RequestObject.Add('reference', in_Shipment."Order No.");

        SenderObject := this.CreateAddressObject(in_Shipment."Sender Name",
            in_Shipment."Sender Name 2",
            in_Shipment."Sender Address",
            in_Shipment."Sender Address 2",
            in_Shipment."Sender Post Code",
            in_Shipment."Sender City",
            in_Shipment."Sender Country/Region Code",
            in_Shipment."Sender E-Mail",
            in_Shipment."Sender Phone No.",
            in_Shipment."Sender Mobile Phone No.",
            in_Shipment."Sender Name" + in_Shipment."Sender Name 2");
        RequestObject.Add('sender', SenderObject);

        if ShippingAgentService."SISM Req. Service Point" then begin
            ServicePointObject := this.CreateServicePointObject(in_Shipment."SISM Service Point ID");
            RequestObject.Add('service_point', ServicePointObject);
        end;

        ReceiverObject := this.CreateAddressObject(in_Shipment.Name,
            in_Shipment."Name 2",
            in_Shipment."Address",
            in_Shipment."Address 2",
            in_Shipment."Post Code",
            in_Shipment.City,
            in_Shipment."Country/Region Code",
            in_Shipment."Ship-to EMail",
            in_Shipment."Ship-to PhoneNo.",
            '',
            in_Shipment.Contact);
        RequestObject.Add('receiver', ReceiverObject);

        if in_Shipment."SISM Print Label" then begin
            PrintAtObject := this.CreatePrintAtObject(in_Shipment."SISM Printer Name");
            RequestObject.Add('print', in_Shipment."SISM Print Label");
            RequestObject.Add('print_at', PrintAtObject)
        end;

        ParcelsArray := this.CreateParcelArray(in_Shipment, true, true);

        RequestObject.Add('parcels', ParcelsArray);

        exit(RequestObject);
    end;

    local procedure CreatePrintAtObject(in_PrinterName: Text): JsonObject
    var
        PrintClient: Record "SISM Print Client";
        PrintAtObject: JsonObject;
    begin
        PrintClient.Get(in_PrinterName);

        PrintAtObject.Add('printer_name', PrintClient.Name);
        PrintAtObject.Add('host_name', PrintClient.Hostname);
        PrintAtObject.Add('label_format', PrintClient."Label Format");

        exit(PrintAtObject);
    end;

    // local procedure CreatePickupObject(Shipment: Record "PVS Job Shipment"): JsonObject
    // var
    //     PickupObject: JsonObject;
    // begin
    //     // PickupObject.Add('name', in_Shipment."Sender Name");
    //     // PickupObject.Add('address1', in_Shipment."Sender Address");
    //     // if (in_Shipment."Sender Address 2" <> '') then
    //     //     PickupObject.Add('address2', in_Shipment."Sender Address 2");
    //     // PickupObject.Add('country_code', in_Shipment."Sender Country/Region Code");
    //     // PickupObject.Add('zipcode', in_Shipment."Sender Post Code");
    //     // PickupObject.Add('city', in_Shipment."Sender City");
    //     // if (in_Shipment."Sender Phone No." <> '') then
    //     //     PickupObject.Add('telephone', in_Shipment."Sender Phone No.");
    //     // if (in_Shipment."Pickup Instructions" <> '') then
    //     //     PickupObject.Add('instruction', in_Shipment."Pickup Instructions");
    //     if (in_Shipment."Pickup Date" <> 0D) then
    //         PickupObject.Add('date', Format(in_Shipment."Pickup Date", 0, '<Year4>-<Month,2>-<Day,2>'));
    //     if (in_Shipment."Pickup Start Time" <> 0T) then
    //         PickupObject.Add('from_time', Format(in_Shipment."Pickup Start Time", 0, '<Hours24,2>:<Minutes,2>'));
    //     if (in_Shipment."Pickup End Time" <> 0T) then
    //         PickupObject.Add('to_time', Format(in_Shipment."Pickup End Time", 0, '<Hours24,2>:<Minutes,2>'));
    //     PickupObject.Add('pickup_custom', false);

    //     exit(PickupObject);
    // end;

    local procedure CreateAddressObject(
        in_Name: Text;
        in_Name2: Text;
        in_Address: Text;
        in_Address2: Text;
        in_Zipcode: Text;
        in_City: Text;
        in_CountryCode: Text;
        in_Email: Text;
        in_Phone: Text;
        in_MobilePhone: Text;
        in_Attention: Text): JsonObject
    var
        AddressObject: JsonObject;
    begin
        AddressObject.Add('name', in_Name + in_Name2);
        AddressObject.Add('address1', in_Address);
        if (in_Address2 <> '') then
            AddressObject.Add('address2', in_Address2);
        AddressObject.Add('zipcode', in_Zipcode);
        AddressObject.Add('city', in_City);
        AddressObject.Add('country_code', in_CountryCode);
        if (in_Email <> '') then
            AddressObject.Add('email', in_Email);

        if (in_Phone <> '') then
            AddressObject.Add('phone', in_Phone);

        if (in_MobilePhone <> '') then
            AddressObject.Add('mobile_phone', in_MobilePhone);

        AddressObject.Add('attention', in_Attention);

        exit(AddressObject);
    end;

    local procedure CreateServicePointObject(in_ID: Text): JsonObject
    var
        ServicePointObject: JsonObject;
    begin
        ServicePointObject.Add('id', in_ID);
        exit(ServicePointObject);
    end;

    local procedure CreateParcelArray(
        in_Shipment: Record "PVS Job Shipment";
        in_InclParcel: Boolean;
        in_InclLastParcelOnly: Boolean): JsonArray
    var
        PalletType: Record "PVS Pallet Types";
        HasLastPackage: Boolean;
        ExternalPalletCode: Code[50];
        LastPackageWeight: Decimal;
        Weight: Decimal;
        Copies: Integer;
        ParcelsArray: JsonArray;
    begin
        PalletType.Get(in_Shipment."Shipping Agent Code", in_Shipment."Pallet Type");
        if PalletType.Package then begin
            HasLastPackage := (in_Shipment.Last_Packet_Quantity() > 0) and (in_Shipment."Weight of Last Package" > 0);
            Copies := in_Shipment."No. Of Packages";
            Weight := in_Shipment."Weight Per Package";
            LastPackageWeight := in_Shipment."Weight of Last Package";
            ExternalPalletCode := PalletType."External Pallet Code";
        end else begin
            HasLastPackage := (in_Shipment.Last_Pallet_Quantity() > 0) and (in_Shipment."Weight of Last Pallet" > 0);
            Copies := in_Shipment."No. Of Pallets";
            Weight := in_Shipment."Weight Per Pallet";
            LastPackageWeight := in_Shipment."Weight of Last Pallet";
            ExternalPalletCode := PalletType."External Pallet Code";
        end;

        // Validation
        if Copies <= 0 then
            Error('Number of packages/pallets must be greater than 0');

        if HasLastPackage then begin
            // Ensure we don't create parcels with 0 quantity
            if in_InclParcel and (Copies > 1) then
                ParcelsArray.Add(this.CreatePackageParcel(ExternalPalletCode,
                    Copies - 1,
                    Weight,
                    in_Shipment."Package Height",
                    in_Shipment."Package Length",
                    in_Shipment."Package Width",
                    in_Shipment."Content Type Code"));

            if in_InclLastParcelOnly then
                ParcelsArray.Add(this.CreatePackageParcel(ExternalPalletCode,
                    1,
                    LastPackageWeight,
                    in_Shipment."Package Height",
                    in_Shipment."Package Length",
                    in_Shipment."Package Width",
                    in_Shipment."Content Type Code"));

            // Handle edge case where no flags are set
            if not in_InclParcel and not in_InclLastParcelOnly then
                Error('At least one parcel type must be included');

        end else
            // When no last package, include all regardless of flags
            ParcelsArray.Add(this.CreatePackageParcel(ExternalPalletCode,
                Copies,
                Weight,
                in_Shipment."Package Height",
                in_Shipment."Package Length",
                in_Shipment."Package Width",
                in_Shipment."Content Type Code"));

        exit(ParcelsArray);
    end;

    local procedure CreatePackageParcel(
        in_ExternalPalletCode: Code[50];
        in_Quantity: Integer;
        in_Weight: Decimal;
        in_Length: Decimal;
        in_Width: Decimal;
        in_Height: Decimal;
        in_ContentTypeCode: Code[50]): JsonObject
    var
        ParcelObject: JsonObject;
    begin
        Clear(ParcelObject);
        ParcelObject.Add('quantity', in_Quantity);
        ParcelObject.Add('weight', in_Weight * GetWeightFactor());
        ParcelObject.Add('length', in_Length);
        ParcelObject.Add('width', in_Width);
        ParcelObject.Add('height', in_Height);

        this.AddContentTypeDescription(ParcelObject, in_ContentTypeCode);

        if in_ExternalPalletCode <> '' then
            ParcelObject.Add('packaging', in_ExternalPalletCode);

        exit(ParcelObject);
    end;

    local procedure AddContentTypeDescription(var out_ParcelObject: JsonObject; in_ContentTypeCode: Code[50])
    var
        ContentType: Record "PVS Content Type";
    begin
        if in_ContentTypeCode <> '' then begin
            ContentType.Get(in_ContentTypeCode);
            if ContentType.Description <> '' then
                out_ParcelObject.Add('description', ContentType.Description);
        end;
    end;

    procedure RequestPrintJob(in_Shipment: Record "PVS Job Shipment"; in_DocumentType: Text): JsonObject
    var
        PrintClient: Record "SISM Print Client";
        PrintJobObject: JsonObject;
    begin
        PrintClient.Get(in_Shipment."SISM Printer Name");

        PrintJobObject.Add('document_id', in_Shipment."Shipment Reference No.");
        PrintJobObject.Add('document_type', in_DocumentType);
        PrintJobObject.Add('host_name', PrintClient.Hostname);
        PrintJobObject.Add('printer_name', PrintClient.Name);
        PrintJobObject.Add('label_format', PrintClient."Label Format");

        exit(PrintJobObject);
    end;

    local procedure GetWeightFactor(): Decimal
    begin
        exit(1000); // kg to grams
    end;
}