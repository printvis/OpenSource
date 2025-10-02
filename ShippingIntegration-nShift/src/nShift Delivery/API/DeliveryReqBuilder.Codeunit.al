namespace PrintVis.OpenSource.NShift.Delivery.API;
using Microsoft.Foundation.Shipping;

codeunit 80167 "SINS Delivery Req. Builder"
{
    procedure CreateShipmentObject(var out_Shipment: Record "PVS Job Shipment"; in_Rates: Boolean): JsonObject
    var
        PalletType: Record "PVS Pallet Types";
        ShippingAgentServices: Record "Shipping Agent Services";
        RootObject, ShipmentObject : JsonObject;
    begin
        ShippingAgentServices.Get(out_Shipment."Shipping Agent Code", out_Shipment."Shipping Agent Service Code");
        PalletType.Get(out_Shipment."Shipping Agent Code", out_Shipment."Pallet Type");

        ShipmentObject.Add('orderNo', out_Shipment."Order No.");
        ShipmentObject.Add('senderReference', out_Shipment."Order No.");

        this.AddSenderAddressPart(ShipmentObject,
            out_Shipment."Sender Name" + out_Shipment."Name 2",
            out_Shipment."Sender Address",
            out_Shipment."Sender Address 2",
            out_Shipment."Sender City",
            out_Shipment."Sender Post Code",
            out_Shipment."Sender Country/Region Code",
            out_Shipment."Sender Contact",
            out_Shipment."Sender Phone No.",
            out_Shipment."Sender E-Mail",
            out_Shipment."SINS Sender Quick ID");

        this.AddReceiverAddressPart(ShipmentObject,
            out_Shipment.Name + out_Shipment."Name 2",
            out_Shipment.Address,
            out_Shipment."Address 2",
            out_Shipment.City,
            out_Shipment."Post Code",
            out_Shipment."Country/Region Code",
            out_Shipment.Contact,
            out_Shipment."Ship-to PhoneNo.",
            out_Shipment."Ship-to EMail");

        this.AddServicePart(ShipmentObject, ShippingAgentServices."PVS External Service Id");

        this.AddParcelsPart(ShipmentObject, out_Shipment);

        RootObject.Add('shipment', ShipmentObject);

        if in_Rates then
            this.AddAdditionalSurcharges(RootObject, out_Shipment."SINS Add. Surcharges Percent", out_Shipment."SINS Add. Surcharges Amount")
        else
            this.AddConfigPart(RootObject);

        exit(RootObject);
    end;

    procedure CreateShipmentObject(var out_CombinedShipment: Record "PVS Combined Shipment Header"; in_Rates: Boolean): JsonObject
    var
        PalletType: Record "PVS Pallet Types";
        ShippingAgentServices: Record "Shipping Agent Services";
        RootObject, ShipmentObject : JsonObject;
    begin
        ShippingAgentServices.Get(out_CombinedShipment."Shipping Agent Code", out_CombinedShipment."Shipping Agent Service Code");
        PalletType.Get(out_CombinedShipment."Shipping Agent Code", out_CombinedShipment."Pallet Type");

        ShipmentObject.Add('orderNo', out_CombinedShipment."No.");
        ShipmentObject.Add('senderReference', out_CombinedShipment."No.");

        this.AddSenderAddressPart(ShipmentObject,
            out_CombinedShipment."Sender Name" + out_CombinedShipment."Name 2",
            out_CombinedShipment."Sender Address",
            out_CombinedShipment."Sender Address 2",
            out_CombinedShipment."Sender City",
            out_CombinedShipment."Sender Post Code",
            out_CombinedShipment."Sender Country/Region Code",
            out_CombinedShipment."Sender Contact",
            out_CombinedShipment."Sender Phone No.",
            out_CombinedShipment."Sender E-Mail",
            out_CombinedShipment."SINS Sender Quick ID");

        this.AddReceiverAddressPart(ShipmentObject,
            out_CombinedShipment.Name + out_CombinedShipment."Name 2",
            out_CombinedShipment.Address,
            out_CombinedShipment."Address 2",
            out_CombinedShipment.City,
            out_CombinedShipment."Post Code",
            out_CombinedShipment."Country/Region Code",
            out_CombinedShipment.Contact,
            out_CombinedShipment."Ship-to PhoneNo.",
            out_CombinedShipment."Ship-to EMail");

        this.AddServicePart(ShipmentObject, ShippingAgentServices."PVS External Service Id");

        this.AddParcelsPart(ShipmentObject, out_CombinedShipment);

        RootObject.Add('shipment', ShipmentObject);

        if in_Rates then
            this.AddAdditionalSurcharges(RootObject, out_CombinedShipment."SINS Add. Surcharges Percent", out_CombinedShipment."SINS Add. Surcharges Amount")
        else
            this.AddConfigPart(RootObject);

        exit(RootObject);
    end;

    local procedure AddParcelsPart(var out_ParentObject: JsonObject; in_Shipment: Record "PVS Job Shipment")
    var
        PalletType: Record "PVS Pallet Types";
        ExternalPalletCode: Code[50];
        LastPackageQuantity, LastPackageWeight, Weight : Decimal;
        Quantity: Integer;
        Parcels: JsonArray;
    begin
        PalletType.Get(in_Shipment."Shipping Agent Code", in_Shipment."Pallet Type");
        if PalletType.Package then begin
            Quantity := in_Shipment."No. Of Packages";
            Weight := in_Shipment."Weight Per Package";
            LastPackageQuantity := in_Shipment.Last_Packet_Quantity();
            LastPackageWeight := in_Shipment."Weight of Last Package";
            ExternalPalletCode := PalletType."External Pallet Code";
        end else begin
            Quantity := in_Shipment."No. Of Pallets";
            Weight := in_Shipment."Weight Per Pallet";
            LastPackageQuantity := in_Shipment.Last_Pallet_Quantity();
            LastPackageWeight := in_Shipment."Weight of Last Pallet";
            ExternalPalletCode := PalletType."External Pallet Code";
        end;

        if (LastPackageQuantity > 0) and (LastPackageWeight > 0) then begin
            Parcels.Add(this.CreateParcelObject(ExternalPalletCode,
                Quantity - 1,
                Weight,
                in_Shipment."Package Height",
                in_Shipment."Package Length",
                in_Shipment."Package Width",
                in_Shipment."Content Type Code"));
            Parcels.Add(this.CreateParcelObject(ExternalPalletCode,
                1,
                LastPackageWeight,
                in_Shipment."Package Height",
                in_Shipment."Package Length",
                in_Shipment."Package Width",
                in_Shipment."Content Type Code"));
        end else
            Parcels.Add(this.CreateParcelObject(ExternalPalletCode,
                Quantity,
                Weight,
                in_Shipment."Package Height",
                in_Shipment."Package Length",
                in_Shipment."Package Width",
                in_Shipment."Content Type Code"));

        out_ParentObject.Add('parcels', Parcels);
    end;

    local procedure AddParcelsPart(var out_ParentObject: JsonObject; in_CombinedShipment: Record "PVS Combined Shipment Header")
    var
        PalletType: Record "PVS Pallet Types";
        ExternalPalletCode: Code[50];
        Parcels: JsonArray;
    begin
        PalletType.Get(in_CombinedShipment."Shipping Agent Code", in_CombinedShipment."Pallet Type");
        ExternalPalletCode := PalletType."External Pallet Code";

        Parcels.Add(this.CreateParcelObject(ExternalPalletCode,
            in_CombinedShipment."No. Of Pallets",
            in_CombinedShipment."Weight Per Pallet",
            0,
            0,
            0,
            in_CombinedShipment."Content Type Code"));

        out_ParentObject.Add('parcels', Parcels);
    end;

    local procedure CreateParcelObject(in_PackageCode: Text;
        in_Copies: Integer;
        in_Weight: Decimal;
        in_Height: Decimal;
        in_Length: Decimal;
        in_Width: Decimal;
        in_ContentTypeCode: Code[50]): JsonObject
    var
        ParcelObject: JsonObject;
        Contents: Text;
    begin
        ParcelObject.Add('copies', in_Copies);
        ParcelObject.Add('weight', in_Weight);
        ParcelObject.Add('valuePerParcel', true);
        ParcelObject.Add('packageCode', in_PackageCode);

        Contents := this.GetPackageContents(in_ContentTypeCode);
        if (Contents <> '') then
            ParcelObject.Add('contents', Contents);

        exit(ParcelObject);
    end;

    local procedure GetPackageContents(in_ContentTypeCode: Code[50]): Text
    var
        ContentType: Record "PVS Content Type";
        Contents: Text;
    begin
        if not ContentType.Get(in_ContentTypeCode) then
            Clear(ContentType);

        Contents := ContentType.Description;
        if (Contents = '') then
            Contents := ContentType.Code;

        exit(Contents);
    end;

    local procedure AddSenderAddressPart(var out_ParentObject: JsonObject;
        in_Name: Text;
        in_Address: Text;
        in_Address2: Text;
        in_City: Text;
        in_PostCode: Text;
        in_CountryCode: Text;
        in_Contact: Text;
        in_Phone: Text;
        in_Email: Text;
        in_QuickId: Text)
    var
        SenderAddress: JsonObject;
    begin
        SenderAddress.Add('quickId', in_QuickId);
        SenderAddress.Add('name', in_Name);
        SenderAddress.Add('address1', in_Address);
        if (in_Address2 <> '') then
            SenderAddress.Add('address2', in_Address2);
        SenderAddress.Add('city', in_City);
        SenderAddress.Add('zipcode', in_PostCode);
        SenderAddress.Add('country', in_CountryCode);
        SenderAddress.Add('contact', in_Contact);
        SenderAddress.Add('phone', in_Phone);
        SenderAddress.Add('email', in_Email);

        out_ParentObject.Add('sender', SenderAddress);
    end;

    local procedure AddReceiverAddressPart(var out_ParentObject: JsonObject;
        in_Name: Text;
        in_Address: Text;
        in_Address2: Text;
        in_City: Text;
        in_PostCode: Text;
        in_CountryCode: Text;
        in_Contact: Text;
        in_Phone: Text;
        in_Email: Text)
    var
        ReceiverAddress: JsonObject;
    begin
        ReceiverAddress.Add('name', in_Name);
        ReceiverAddress.Add('address1', in_Address);
        if (in_Address2 <> '') then
            ReceiverAddress.Add('address2', in_Address2);
        ReceiverAddress.Add('city', in_City);
        ReceiverAddress.Add('zipcode', in_PostCode);
        ReceiverAddress.Add('country', in_CountryCode);
        ReceiverAddress.Add('contact', in_Contact);
        ReceiverAddress.Add('phone', in_Phone);
        ReceiverAddress.Add('email', in_Email);

        out_ParentObject.Add('receiver', ReceiverAddress);
    end;

    local procedure AddServicePart(var out_ParentObject: JsonObject; in_ExternalServiceId: Text)
    var
        Service: JsonObject;
    begin
        Service.Add('id', in_ExternalServiceId);
        Service.Add('normalShipment', true);

        out_ParentObject.Add('service', Service);
    end;

    local procedure AddAdditionalSurcharges(var out_ParentObject: JsonObject; in_AdditionalSurchargesPercent: Decimal; in_AdditionalSurchargesAmount: Decimal)
    var
        Surcharges: JsonObject;
    begin
        if (in_AdditionalSurchargesPercent <> 0) then
            Surcharges.Add('percent', in_AdditionalSurchargesPercent);
        if (in_AdditionalSurchargesAmount <> 0) then
            Surcharges.Add('amount', in_AdditionalSurchargesAmount);

        out_ParentObject.Add('additionalSurcharges', Surcharges);
    end;

    local procedure AddConfigPart(var out_ParentObject: JsonObject)
    var
        Config: JsonObject;
    begin
        Config.Add('target1Media', 'thermo-190');
        Config.Add('target1Type', 'pdf');

        out_ParentObject.Add('printConfig', Config);
    end;
}