namespace PrintVis.OpenSource.NShift.Ship.API;

using Microsoft.Foundation.Shipping;
using PrintVis.OpenSource.NShift.Ship.Setup;

codeunit 80161 "SINS Ship Req. Builder"
{
    var
        Utilities: codeunit "PVS Shipping Integration Util";

    procedure CreateRequestBody(in_DataObject: JsonObject; in_OptionsObject: JsonObject): Text
    var
        BodyObject: JsonObject;
        RequestJson: Text;
    begin
        Clear(BodyObject);
        BodyObject.Add('data', in_DataObject);
        BodyObject.Add('options', in_OptionsObject);
        BodyObject.WriteTo(RequestJson);

        exit(RequestJson);
    end;

    procedure CreateOptionsObject(in_Setup: Record "SINS Ship Setup"): JsonObject
    var
        OptionsObject: JsonObject;
    begin
        OptionsObject.Add('Labels', Format(in_Setup."Label Type"));
        if in_Setup."Enable Price Calculation" then
            OptionsObject.Add('PriceCalculation', 1)
        else
            OptionsObject.Add('PriceCalculation', 0);

        exit(OptionsObject);
    end;

    procedure CreateShipmentObject(in_JobShipment: Record "PVS Job Shipment"): JsonObject
    var
        ShippingAgent: Record "Shipping Agent";
        ShippingAgentService: Record "Shipping Agent Services";
        PickupDate: Date;
        References: JsonArray;
        ReferenceObject, ShipmentObject : JsonObject;
        PickupEndTime, PickupStartTime : Time;
    begin
        ShippingAgent.Get(in_JobShipment."Shipping Agent Code");

        ShippingAgentService.Get(in_JobShipment."Shipping Agent Code", in_JobShipment."Shipping Agent Service Code");
        ShippingAgentService.TestField("PVS External Service Id");

        ShipmentObject.Add('OrderNo', in_JobShipment."Order No.");

        PickupDate := in_JobShipment."Pickup Date";
        PickupStartTime := in_JobShipment."Pickup Start Time";
        PickupEndTime := in_JobShipment."Pickup End Time";
        if (PickupDate <> 0D) then
            ShipmentObject.Add('PickupDt', this.Utilities.GetISO8601DateTime(PickupDate, PickupStartTime));

        ShipmentObject.Add('ProdConceptID', ShippingAgentService."PVS External Service Id");

        if (ShippingAgent."Account No." <> '') then begin
            ShipmentObject.Add('PayerAccountAtCarrier', ShippingAgent."Account No.");
            ShipmentObject.Add('SenderAccountAtCarrier', ShippingAgent."Account No.");
        end;

        this.AddAddressesPart(ShipmentObject, in_JobShipment, ShippingAgentService."PVS Normalize Post Code");

        if (PickupDate <> 0D) and
            (PickupStartTime <> 0T) and
            (PickupEndTime <> 0T) then begin

            Clear(ReferenceObject);
            ReferenceObject.Add('Kind', 108);
            ReferenceObject.Add('Value', this.Utilities.GetISO8601DateTime(PickupDate, PickupStartTime));
            References.Add(ReferenceObject);

            Clear(ReferenceObject);
            ReferenceObject.Add('Kind', 109);
            ReferenceObject.Add('Value', this.Utilities.GetISO8601DateTime(PickupDate, PickupEndTime));
            References.Add(ReferenceObject);
        end;

        if References.Count() > 0 then
            ShipmentObject.Add('References', References);

        this.AddLinesPart(ShipmentObject, in_JobShipment);

        exit(ShipmentObject);
    end;

    procedure CreateShipmentObject(in_CombinedShipment: Record "PVS Combined Shipment Header"): JsonObject
    var
        ShippingAgent: Record "Shipping Agent";
        ShippingAgentService: Record "Shipping Agent Services";
        PickupDate: Date;
        References: JsonArray;
        ReferenceObject, ShipmentObject : JsonObject;
        PickupEndTime, PickupStartTime : Time;
    begin
        ShippingAgent.Get(in_CombinedShipment."Shipping Agent Code");

        ShippingAgentService.Get(in_CombinedShipment."Shipping Agent Code", in_CombinedShipment."Shipping Agent Service Code");
        ShippingAgentService.TestField("PVS External Service Id");

        ShipmentObject.Add('OrderNo', in_CombinedShipment."No.");

        PickupDate := in_CombinedShipment."Pickup Date";
        PickupStartTime := in_CombinedShipment."Pickup Start Time";
        PickupEndTime := in_CombinedShipment."Pickup End Time";
        if (PickupDate <> 0D) then
            ShipmentObject.Add('PickupDt', this.Utilities.GetISO8601DateTime(PickupDate, PickupStartTime));

        ShipmentObject.Add('ProdConceptID', ShippingAgentService."PVS External Service Id");

        if (ShippingAgent."Account No." <> '') then begin
            ShipmentObject.Add('PayerAccountAtCarrier', ShippingAgent."Account No.");
            ShipmentObject.Add('SenderAccountAtCarrier', ShippingAgent."Account No.");
        end;

        this.AddAddressesPart(ShipmentObject, in_CombinedShipment, ShippingAgentService."PVS Normalize Post Code");

        if (PickupDate <> 0D) and
            (PickupStartTime <> 0T) and
            (PickupEndTime <> 0T) then begin

            Clear(ReferenceObject);
            ReferenceObject.Add('Kind', 108);
            ReferenceObject.Add('Value', this.Utilities.GetISO8601DateTime(PickupDate, PickupStartTime));
            References.Add(ReferenceObject);

            Clear(ReferenceObject);
            ReferenceObject.Add('Kind', 109);
            ReferenceObject.Add('Value', this.Utilities.GetISO8601DateTime(PickupDate, PickupEndTime));
            References.Add(ReferenceObject);
        end;

        if References.Count() > 0 then
            ShipmentObject.Add('References', References);

        this.AddLinesPart(ShipmentObject, in_CombinedShipment);

        exit(ShipmentObject);
    end;

    local procedure AddAddressesPart(var out_ParentObject: JsonObject; in_JobShipment: Record "PVS Job Shipment"; in_NormalizePostCode: Boolean)
    var
        Addresses: JsonArray;
    begin
        // 1 - Receiver
        // 2 - Sender
        // 4 - Payer
        // 9 - ReturnTo
        // 10 - DropPoint

        Clear(Addresses);

        Addresses.Add(this.CreateAddressObject(1,
            in_JobShipment.Name,
            in_JobShipment."Name 2",
            in_JobShipment.Address,
             in_JobShipment."Address 2",
            in_JobShipment."Post Code",
            in_NormalizePostCode,
            in_JobShipment.City,
            in_JobShipment."Country/Region Code",
            in_JobShipment."Ship-to PhoneNo.",
            in_JobShipment."Ship-to EMail",
            in_JobShipment.Contact));

        Addresses.Add(this.CreateAddressObject(2,
            in_JobShipment."Sender Name",
            in_JobShipment."Sender Name 2",
            in_JobShipment."Sender Address",
            in_JobShipment."Sender Address 2",
            in_JobShipment."Sender Post Code",
            in_NormalizePostCode,
            in_JobShipment."Sender City",
            in_JobShipment."Sender Country/Region Code",
            in_JobShipment."Sender Phone No.",
            in_JobShipment."Sender E-Mail",
            in_JobShipment."Sender Contact"));

        out_ParentObject.Add('Addresses', Addresses);
    end;

    local procedure AddAddressesPart(var out_ParentObject: JsonObject; in_CombinedShipment: Record "PVS Combined Shipment Header"; in_NormalizePostCode: Boolean)
    var
        Addresses: JsonArray;
    begin
        // 1 - Receiver
        // 2 - Sender
        // 4 - Payer
        // 9 - ReturnTo
        // 10 - DropPoint

        Clear(Addresses);

        Addresses.Add(this.CreateAddressObject(1,
            in_CombinedShipment.Name,
            in_CombinedShipment."Name 2",
            in_CombinedShipment.Address,
            in_CombinedShipment."Address 2",
            in_CombinedShipment."Post Code",
            in_NormalizePostCode,
            in_CombinedShipment.City,
            in_CombinedShipment."Country/Region Code",
            in_CombinedShipment."Ship-to PhoneNo.",
            in_CombinedShipment."Ship-to EMail",
            in_CombinedShipment.Contact));

        Addresses.Add(this.CreateAddressObject(2,
            in_CombinedShipment."Sender Name",
            in_CombinedShipment."Sender Name 2",
            in_CombinedShipment."Sender Address",
            in_CombinedShipment."Sender Address 2",
            in_CombinedShipment."Sender Post Code",
            in_NormalizePostCode,
            in_CombinedShipment."Sender City",
            in_CombinedShipment."Sender Country/Region Code",
            in_CombinedShipment."Sender Phone No.",
            in_CombinedShipment."Sender E-Mail",
            in_CombinedShipment."Sender Contact"));

        out_ParentObject.Add('Addresses', Addresses);
    end;

    local procedure CreateAddressObject(in_KindType: Integer;
        in_Name: Text;
        in_Name2: Text;
        in_Address: Text;
        in_Address2: Text;
        in_PostCode: Text;
        in_NormalizePostCode: Boolean;
        in_City: Text;
        in_CountryCode: Text;
        in_Phone: Text;
        in_Email: Text;
        in_Attention: Text): JsonObject
    var
        JObject: JsonObject;
    begin
        if in_NormalizePostCode then
            in_PostCode := this.Utilities.SanitizeText(in_PostCode);

        JObject.Add('Kind', in_KindType);
        JObject.Add('Name1', in_Name);
        if (in_Name2 <> '') then
            JObject.Add('Name2', in_Name2);
        JObject.Add('Street1', in_Address);
        if (in_Address2 <> '') then
            JObject.Add('Street2', in_Address2);
        JObject.Add('PostCode', in_PostCode);
        JObject.Add('City', in_City);
        JObject.Add('CountryCode', in_CountryCode);
        JObject.Add('Phone', in_Phone);
        JObject.Add('Email', in_Email);
        JObject.Add('Attention', in_Attention);

        exit(JObject);
    end;

    local procedure AddLinesPart(var out_ParentObject: JsonObject; in_Shipment: Record "PVS Job Shipment")
    var
        PalletType: Record "PVS Pallet Types";
        ExternalPalletCode: Code[50];
        LastPackageQuantity, LastPackageWeight, Weight : Decimal;
        Quantity: Integer;
        Lines: JsonArray;
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
            Lines.Add(this.CreateLineObject(ExternalPalletCode,
                Quantity - 1,
                Weight,
                in_Shipment."Package Height",
                in_Shipment."Package Length",
                in_Shipment."Package Width",
                in_Shipment."Content Type Code"));
            Lines.Add(this.CreateLineObject(ExternalPalletCode,
                1,
                LastPackageWeight,
                in_Shipment."Package Height",
                in_Shipment."Package Length",
                in_Shipment."Package Width",
                in_Shipment."Content Type Code"));
        end else
            Lines.Add(this.CreateLineObject(ExternalPalletCode,
                Quantity,
                Weight,
                in_Shipment."Package Height",
                in_Shipment."Package Length",
                in_Shipment."Package Width",
                in_Shipment."Content Type Code"));

        out_ParentObject.Add('Lines', Lines);
    end;

    local procedure AddLinesPart(var out_ParentObject: JsonObject; in_CombinedShipment: Record "PVS Combined Shipment Header")
    var
        PalletType: Record "PVS Pallet Types";
        ExternalPalletCode: Code[50];
        Weight: Decimal;
        Quantity: Integer;
        Lines: JsonArray;
    begin
        PalletType.Get(in_CombinedShipment."Shipping Agent Code", in_CombinedShipment."Pallet Type");
        Quantity := in_CombinedShipment."No. Of Pallets";
        Weight := in_CombinedShipment."Weight Per Pallet";
        ExternalPalletCode := PalletType."External Pallet Code";

        Lines.Add(this.CreateLineObject(ExternalPalletCode,
            Quantity,
            Weight,
            0,
            0,
            0,
            in_CombinedShipment."Content Type Code"));

        out_ParentObject.Add('Lines', Lines);
    end;

    local procedure CreateLineObject(in_ExternalPalletCode: Code[50];
        in_Numbers: Integer;
        in_Weight: Decimal;
        in_PackageHeight: Decimal;
        in_PackageLength: Decimal;
        in_PackageWidth: Decimal;
        in_ContentTypeCode: Code[50]): JsonObject
    var
        ContentType: Record "PVS Content Type";
        References: JsonArray;
        JObject, ReferenceObject : JsonObject;
    begin
        JObject.Add('Number', in_Numbers);
        JObject.Add('PkgWeight', in_Weight * 1000);
        JObject.Add('GoodsTypeID', in_ExternalPalletCode);
        JObject.Add('Height', in_PackageHeight);
        JObject.Add('Length', in_PackageLength);
        JObject.Add('Width', in_PackageWidth);

        if in_ContentTypeCode <> '' then begin
            ContentType.Get(in_ContentTypeCode);
            Clear(ReferenceObject);
            ReferenceObject.Add('Kind', 23);
            ReferenceObject.Add('Value', ContentType.Description);
            References.Add(ReferenceObject);
        end;

        if References.Count() > 0 then
            JObject.Add('References', References);

        exit(JObject);
    end;
}