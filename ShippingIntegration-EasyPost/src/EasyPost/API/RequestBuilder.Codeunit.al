namespace PrintVis.OpenSource.EasyPost.API;

using Microsoft.Inventory.Location;
using PrintVis.OpenSource.EasyPost;
using PrintVis.OpenSource.EasyPost.Setup;
using Microsoft.Foundation.Shipping;

codeunit 80138 "SIEP Request Builder"
{
    procedure CreateVerifyAddressObject(in_ShippingSetup: Record "PVS Shipping Setup"): JsonObject
    var
        RecRef: RecordRef;
        AddressObject: JsonObject;
    begin
        RecRef.GetTable(in_ShippingSetup);
        AddressObject := this.CreateVerifyAddressObject(RecRef);
        exit(AddressObject);
    end;

    procedure CreateVerifyAddressObject(in_SenderAddress: Record "PVS Sender Address"): JsonObject
    var
        RecRef: RecordRef;
        AddressObject: JsonObject;
    begin
        RecRef.GetTable(in_SenderAddress);
        AddressObject := this.CreateVerifyAddressObject(RecRef);
        exit(AddressObject);
    end;

    procedure CreateVerifyAddressObject(in_Location: Record "Location"): JsonObject
    var
        RecRef: RecordRef;
        AddressObject: JsonObject;
    begin
        RecRef.GetTable(in_Location);
        AddressObject := this.CreateVerifyAddressObject(RecRef);
        exit(AddressObject);
    end;

    procedure CreateVerifyAddressObject(in_Shipment: Record "PVS Job Shipment"): JsonObject
    var
        RecRef: RecordRef;
        AddressObject: JsonObject;
    begin
        RecRef.GetTable(in_Shipment);
        AddressObject := this.CreateVerifyAddressObject(RecRef);
        exit(AddressObject);
    end;

    procedure CreateVerifyAddressObject(in_RecRef: RecordRef): JsonObject
    var
        Location: Record Location;
        Shipment: Record "PVS Job Shipment";
        SenderAddress: Record "PVS Sender Address";
        ShippingSetup: Record "PVS Shipping Setup";
        FldRef: FieldRef;
        AddressObject: JsonObject;
        Address: Text;
        Address2: Text;
        AddressId: Text;
        City: Text;
        CountryCode: Text;
        County: Text;
        Email: Text;
        Name: Text;
        Name2: Text;
        Phone: Text;
        PostCode: Text;

    begin
        case in_RecRef.Number of
            Database::"PVS Shipping Setup":
                begin
                    FldRef := in_RecRef.Field(ShippingSetup.FieldNo("SIEP Address Id"));
                    AddressId := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(ShippingSetup.FieldNo(Name));
                    Name := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(ShippingSetup.FieldNo("Name 2"));
                    Name2 := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(ShippingSetup.FieldNo(Address));
                    Address := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(ShippingSetup.FieldNo("Address 2"));
                    Address2 := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(ShippingSetup.FieldNo("Post Code"));
                    PostCode := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(ShippingSetup.FieldNo(City));
                    City := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(ShippingSetup.FieldNo(County));
                    County := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(ShippingSetup.FieldNo("Country/Region Code"));
                    CountryCode := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(ShippingSetup.FieldNo("Phone No."));
                    Phone := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(ShippingSetup.FieldNo("E-Mail"));
                    Email := Format(FldRef.Value);
                end;
            Database::"PVS Sender Address":
                begin
                    FldRef := in_RecRef.Field(SenderAddress.FieldNo("SIEP Address Id"));
                    AddressId := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(SenderAddress.FieldNo(Name));
                    Name := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(SenderAddress.FieldNo("Name 2"));
                    Name2 := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(SenderAddress.FieldNo(Address));
                    Address := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(SenderAddress.FieldNo("Address 2"));
                    Address2 := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(SenderAddress.FieldNo("Post Code"));
                    PostCode := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(SenderAddress.FieldNo(City));
                    City := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(SenderAddress.FieldNo(County));
                    County := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(SenderAddress.FieldNo("Country/Region Code"));
                    CountryCode := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(SenderAddress.FieldNo("Phone No."));
                    Phone := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(SenderAddress.FieldNo("E-Mail"));
                    Email := Format(FldRef.Value);
                end;
            Database::Location:
                begin
                    FldRef := in_RecRef.Field(Location.FieldNo("SIEP Address Id"));
                    AddressId := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(Location.FieldNo(Name));
                    Name := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(Location.FieldNo("Name 2"));
                    Name2 := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(Location.FieldNo(Address));
                    Address := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(Location.FieldNo("Address 2"));
                    Address2 := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(Location.FieldNo("Post Code"));
                    PostCode := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(Location.FieldNo(City));
                    City := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(Location.FieldNo(County));
                    County := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(Location.FieldNo("Country/Region Code"));
                    CountryCode := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(Location.FieldNo("Phone No."));
                    Phone := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(Location.FieldNo("E-Mail"));
                    Email := Format(FldRef.Value);
                end;
            Database::"PVS Job Shipment":
                begin
                    FldRef := in_RecRef.Field(Shipment.FieldNo("SIEP Ship-to Address Id"));
                    AddressId := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(Shipment.FieldNo(Name));
                    Name := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(Shipment.FieldNo("Name 2"));
                    Name2 := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(Shipment.FieldNo(Address));
                    Address := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(Shipment.FieldNo("Address 2"));
                    Address2 := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(Shipment.FieldNo("Post Code"));
                    PostCode := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(Shipment.FieldNo(City));
                    City := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(Shipment.FieldNo(County));
                    County := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(Shipment.FieldNo("Country/Region Code"));
                    CountryCode := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(Shipment.FieldNo("Ship-to PhoneNo."));
                    Phone := Format(FldRef.Value);
                    FldRef := in_RecRef.Field(Shipment.FieldNo("Ship-to EMail"));
                    Email := Format(FldRef.Value);
                end;
        end;

        AddressObject := this.CreateAddressObject(
            AddressId,
            Name,
            Name2,
            Address,
            Address2,
            PostCode,
            City,
            County,
            CountryCode,
            Phone,
            Email,
            true);

        exit(AddressObject);
    end;

    procedure CreateCreateOrderObject(in_Shipment: Record "PVS Job Shipment";
        in_LabelSize: Enum "SIEP Label Size";
        in_LabelType: Enum "PVS Label Type"): JsonObject
    var
        PalletType: Record "PVS Pallet Types";
        LastPackageWeight, Weight : Decimal;
        LastPackageQuantity, Quantity : Integer;
        CarrierAccountsArray, ShipmentsArray : JsonArray;
        FromAddressObject, OrderObject, RootObject, ToAddressObject : JsonObject;
    begin
        FromAddressObject := this.CreateAddressObject(in_Shipment."SIEP Sender Address Id",
            in_Shipment."Sender Name",
            in_Shipment."Name 2",
            in_Shipment."Sender Address",
            in_Shipment."Sender Address 2",
            in_Shipment."Sender Post Code",
            in_Shipment."Sender City",
            '',//in_Shipment.sender coun
            in_Shipment."Sender Country/Region Code",
            in_Shipment."Sender Phone No.",
            in_Shipment."Sender E-Mail",
            false);
        OrderObject.Add('from_address', FromAddressObject);

        ToAddressObject := this.CreateAddressObject(in_Shipment."SIEP Ship-to Address Id",
                    in_Shipment.Name,
                    in_Shipment."Name 2",
                    in_Shipment.Address,
                    in_Shipment."Address 2",
                    in_Shipment."Post Code",
                    in_Shipment.City,
                    in_Shipment.County,
                    in_Shipment."Country/Region Code",
                    in_Shipment."Ship-to PhoneNo.",
                    in_Shipment."Ship-to EMail",
                    false);

        OrderObject.Add('to_address', ToAddressObject);

        OrderObject.Add('reference', Format(StrSubstNo('%1-%2', in_Shipment."Order No.", in_Shipment.ID)));

        CarrierAccountsArray := this.CreateCarrierAccountsArray(in_Shipment."Shipping Agent Code");
        OrderObject.Add('carrier_accounts', CarrierAccountsArray);

        PalletType.Get(in_Shipment."Shipping Agent Code", in_Shipment."Pallet Type");
        if PalletType.Package then begin
            Quantity := in_Shipment."No. Of Packages";
            Weight := in_Shipment."Weight Per Package";
            LastPackageQuantity := in_Shipment.Last_Packet_Quantity();
            LastPackageWeight := in_Shipment."Weight of Last Package";
        end else begin
            Quantity := in_Shipment."No. Of Pallets";
            Weight := in_Shipment."Weight Per Pallet";
            LastPackageQuantity := in_Shipment.Last_Pallet_Quantity();
            LastPackageWeight := in_Shipment."Weight of Last Pallet";
        end;

        if (LastPackageQuantity > 0) and (LastPackageWeight > 0) then begin
            this.CreateOrderShipmentBody(in_Shipment,
                ShipmentsArray,
                Quantity - 1,
                Weight,
                in_LabelSize,
                in_LabelType);
            this.CreateOrderShipmentBody(in_Shipment,
                ShipmentsArray,
                1,
                LastPackageWeight,
                in_LabelSize,
                in_LabelType);
        end else
            this.CreateOrderShipmentBody(in_Shipment,
                ShipmentsArray,
                Quantity,
                Weight,
                in_LabelSize,
                in_LabelType);

        OrderObject.add('shipments', ShipmentsArray);

        RootObject.Add('order', OrderObject);

        exit(RootObject);
    end;

    procedure CreateBuyOrderBody(in_Shipment: Record "PVS Job Shipment"): JsonObject
    var
        ShippingAgentService: Record "Shipping Agent Services";
        JObject: JsonObject;
    begin
        JObject.Add('carrier', in_Shipment."Shipping Agent Code");
        ShippingAgentService.Get(in_Shipment."Shipping Agent Code", in_Shipment."Shipping Agent Service Code");
        JObject.Add('service', ShippingAgentService."PVS External Service Id");

        exit(JObject);
    end;

    local procedure CreateOrderShipmentBody(in_Shipment: Record "PVS Job Shipment";
        var out_Parcels: JsonArray;
        in_NoOfPackage: Integer;
        in_weight: Decimal;
        in_LabelSize: Enum "SIEP Label Size";
        in_LabelType: Enum "PVS Label Type")
    var
        EasyPostSetup: Record "SIEP Setup";
        Counter: Integer;
        Options, Parcel, ParcelObject : JsonObject;
    begin
        EasyPostSetup.Get();

        for Counter := 1 to in_NoOfPackage do begin

            Clear(Parcel);
            ParcelObject := this.CreateParcelBody(in_Shipment."Package Length",
                in_Shipment."Package Width",
                in_Shipment."Package Height",
                in_weight,
                in_Shipment."SIEP Predefined Package");

            Parcel.Add('parcel', ParcelObject);

            Clear(Options);
            Options.Add('label_type', format(in_LabelType));
            Options.Add('label_size', format(in_LabelSize));
            Options.Add('payment', this.CreatePaymentObject(in_Shipment));
            Options.Add('print_custom_1', in_Shipment."Label Reference 1");
            Options.Add('print_custom_2', in_Shipment."Label Reference 2");
            Options.Add('print_custom_3', in_Shipment."Label Reference 3");
            if in_Shipment."Reference Code 1" <> '' then
                Options.Add('print_custom_1_code', in_Shipment."Reference Code 1");
            if in_Shipment."Reference Code 2" <> '' then
                Options.Add('print_custom_2_code', in_Shipment."Reference Code 2");
            if in_Shipment."Reference Code 3" <> '' then
                Options.Add('print_custom_3_code', in_Shipment."Reference Code 3");
            Parcel.Add('options', Options);

            if in_Shipment."Content Type Code" <> '' then
                Parcel.Add('customs_info', this.CreateCustomsInfoBody(in_Shipment));

            Parcel.Add('reference', Format(StrSubstNo('%1-%2-%3', in_Shipment."Order No.", in_Shipment.ID, Counter)));

            out_Parcels.Add(Parcel);
        end;
    end;

    procedure CreateCustomsInfoBody(in_Shipment: Record "PVS Job Shipment"): JsonObject
    var
        JObject: JsonObject;
    begin
        JObject.Add('contents_type', this.GetContentTypeName(in_Shipment."Content Type Code"));
        JObject.Add('customs_certify', in_Shipment."SIEP Customs Certify");
        JObject.Add('customs_signer', in_Shipment."SIEP Customs Signer");
        JObject.Add('non_delivery_option', LowerCase(Format(in_Shipment."SIEP Non Delivery Option")));
        JObject.Add('contents_explanation', in_Shipment."SIEP Contents Explanation");
        if in_Shipment."SIEP Restriction Type" <> in_Shipment."SIEP Restriction Type"::none then begin
            JObject.Add('restriction_type', Format(in_Shipment."SIEP Restriction Type"));
            JObject.Add('restriction_comments', in_Shipment."SIEP Restriction Comments");
        end;
        JObject.Add('customs_items', this.GetCustomsItems(in_Shipment));
        exit(JObject);
    end;

    local procedure GetCustomsItems(in_Shipment: Record "PVS Job Shipment"): JsonArray
    var
        CustomsItem: Record "SIEP Customs Item";
        JArray: JsonArray;
        JObject: JsonObject;
    begin
        CustomsItem.SetRange("Source Record ID", in_Shipment.RecordId);
        if CustomsItem.FindSet() then
            repeat
                Clear(JObject);
                JObject.Add('description', CustomsItem.Description);
                JObject.Add('quantity', CustomsItem.Quantity);
                JObject.Add('value', CustomsItem.Value);
                JObject.Add('weight', CustomsItem.Weight);
                JObject.Add('hs_tariff_number', CustomsItem."Tariff Number");
                JObject.Add('origin_country', CustomsItem."Origin Country");
                JArray.Add(JObject);
            until CustomsItem.Next() = 0;
        exit(JArray);
    end;

    local procedure GetContentTypeName(in_ContentTypeCode: Code[50]): Text
    var
        ContentType: Record "PVS Content Type";
    begin
        if ContentType.Get(in_ContentTypeCode) then
            exit(ContentType.Name);
        exit('');
    end;

    local procedure CreateParcelBody(in_PackageLength: Decimal;
        in_PackageWidth: Decimal;
        in_PackageHeight: Decimal;
        in_PackageWeight: Decimal;
        in_PredefinedPackage: Text): JsonObject
    var
        JObject: JsonObject;
    begin
        if in_PackageLength <> 0 then
            JObject.Add('length', in_PackageLength);
        if in_PackageWidth <> 0 then
            JObject.Add('width', in_PackageWidth);
        if in_PackageHeight <> 0 then
            JObject.Add('height', in_PackageHeight);
        JObject.Add('weight', in_PackageWeight * 16); // Harcoded pounds in ounces

        if in_PredefinedPackage <> '' then
            JObject.Add('predefined_package', in_PredefinedPackage);

        exit(JObject);
    end;

    procedure CreatePaymentObject(in_JobShipment: Record "PVS Job Shipment"): JsonObject
    var
        PaymentObject: JsonObject;
    begin
        PaymentObject.Add('type', format(in_JobShipment."Payment Type"));

        if in_JobShipment."Payment Type" in [in_JobShipment."Payment Type"::RECEIVER, in_JobShipment."Payment Type"::THIRD_PARTY] then begin
            PaymentObject.Add('account', in_JobShipment."Payment Account No.");
            PaymentObject.Add('country', in_JobShipment."Payment Country/Region");
            PaymentObject.Add('postal_code', in_JobShipment."Payment Postal Code");
        end;

        exit(PaymentObject);
    end;

    local procedure CreateAddressObject(in_AddressId: Text;
        in_Name: Text;
        in_Name2: Text;
        in_Address: Text;
        in_Address2: Text;
        in_PostCode: Text;
        in_City: Text;
        in_County: Text;
        in_CountryCode: Text;
        in_Phone: Text;
        in_Email: Text;
        in_verify: Boolean): JsonObject
    var
        JObject: JsonObject;
    begin
        if (in_AddressId <> '') and (not in_verify) then
            JObject.Add('id', in_AddressId)
        else begin
            JObject.Add('street1', in_Address);
            if (in_Address2 <> '') then
                JObject.Add('street2', in_Address2);
            JObject.Add('city', in_City);
            JObject.Add('state', in_County);
            JObject.Add('zip', in_PostCode);
            JObject.Add('country', in_CountryCode);
            JObject.Add('name', in_Name);
            // JObject.Add('company', contact/);
            JObject.Add('phone', in_Phone);
            JObject.Add('email', in_Email);
            if in_verify then
                JObject.Add('verify', 'delivery');
        end;

        exit(JObject);
    end;

    local procedure CreateCarrierAccountsArray(in_ShippingAgentCode: Code[10]): JsonArray
    var
        ShippingAgent: Record "Shipping Agent";
        AccountsJArray: JsonArray;
    begin
        if in_ShippingAgentCode <> '' then
            if ShippingAgent.Get(in_ShippingAgentCode) then
                if ShippingAgent."PVS Carrier Account ID" <> '' then
                    AccountsJArray.Add(ShippingAgent."PVS Carrier Account ID");

        exit(AccountsJArray);
    end;
}