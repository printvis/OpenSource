codeunit 80139 "SIEP Resp. Handler"
{
    var
        ErrorHelper: Codeunit "PVS Error Logging Management";

    #region Verify Address
    procedure ProcessVerifyAddress(var out_ShippingSetup: Record "PVS Shipping Setup"; in_ResponseJson: Text; var out_ErrorMessageMgt: Codeunit "Error Message Management")
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(out_ShippingSetup);
        this.ProcessVerifyAddress(RecRef, in_ResponseJson, out_ErrorMessageMgt);
        RecRef.SetTable(out_ShippingSetup);
    end;

    procedure ProcessVerifyAddress(var out_SenderAddress: Record "PVS Sender Address"; in_ResponseJson: Text; var out_ErrorMessageMgt: Codeunit "Error Message Management")
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(out_SenderAddress);
        this.ProcessVerifyAddress(RecRef, in_ResponseJson, out_ErrorMessageMgt);
        RecRef.SetTable(out_SenderAddress);
    end;

    procedure ProcessVerifyAddress(var out_Location: Record "Location"; in_ResponseJson: Text; var out_ErrorMessageMgt: Codeunit "Error Message Management")
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(out_Location);
        this.ProcessVerifyAddress(RecRef, in_ResponseJson, out_ErrorMessageMgt);
        RecRef.SetTable(out_Location);
    end;

    procedure ProcessVerifyAddress(var out_Shipment: Record "PVS Job Shipment"; in_ResponseJson: Text; var out_ErrorMessageMgt: Codeunit "Error Message Management")
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(out_Shipment);
        this.ProcessVerifyAddress(RecRef, in_ResponseJson, out_ErrorMessageMgt);
        RecRef.SetTable(out_Shipment);
    end;

    local procedure ProcessVerifyAddress(var out_RecRef: RecordRef; in_ResponseJson: Text; var out_ErrorMessageMgt: Codeunit "Error Message Management")
    var
        Location: Record Location;
        Shipment: Record "PVS Job Shipment";
        SenderAddress: Record "PVS Sender Address";
        ShippingSetup: Record "PVS Shipping Setup";
        JsonMgt: Codeunit "JSON Management";
        AddressIdFld: FieldRef;
        AddressVerifiedFld: FieldRef;
        IsSuccess: Boolean;
        Errors, IsSuccessText : Text;
    begin
        if not JsonMgt.InitializeFromString(in_ResponseJson) then
            exit;

        IsSuccessText := JsonMgt.GetValue('$.verifications.delivery.success');
        Evaluate(IsSuccess, IsSuccessText);
        if not IsSuccess then begin
            Errors := JsonMgt.GetValue('$.verifications.delivery.errors');
            out_ErrorMessageMgt.LogSimpleErrorMessage(Errors);
            exit;
        end;

        case out_RecRef.Number() of
            Database::"PVS Shipping Setup":
                begin
                    AddressIdFld := out_RecRef.Field(ShippingSetup.FieldNo("SIEP Address Id"));
                    AddressVerifiedFld := out_RecRef.Field(ShippingSetup.FieldNo("SIEP Address Verified"));
                end;
            Database::"PVS Sender Address":
                begin
                    AddressIdFld := out_RecRef.Field(SenderAddress.FieldNo("SIEP Address Id"));
                    AddressVerifiedFld := out_RecRef.Field(SenderAddress.FieldNo("SIEP Address Verified"));
                end;
            Database::Location:
                begin
                    AddressIdFld := out_RecRef.Field(Location.FieldNo("SIEP Address Id"));
                    AddressVerifiedFld := out_RecRef.Field(Location.FieldNo("SIEP Address Verified"));
                end;
            Database::"PVS Job Shipment":
                begin
                    AddressIdFld := out_RecRef.Field(Shipment.FieldNo("SIEP Ship-to Address Id"));
                    AddressVerifiedFld := out_RecRef.Field(Shipment.FieldNo("SIEP Ship-to Address Verified"));
                end;
        end;

        AddressIdFld.Value := JsonMgt.GetValue('id');
        AddressVerifiedFld.Value := true;
        out_RecRef.Modify();
    end;

    #endregion

    procedure ProcessCreateOrderResponse(var out_Shipment: Record "PVS Job Shipment";
        in_LabelType: Enum "PVS Label Type";
        in_ResponseJson: Text;
        var out_ErrorMessageMgt: Codeunit "Error Message Management")
    var
        ResponseObject: Codeunit "JSON Management";
        MessageJson, RatesJson, ShipmentsJson : Text;
    begin
        if not ResponseObject.InitializeFromString(in_ResponseJson) then
            exit;

        MessageJson := ResponseObject.GetValue('$.messages');
        if MessageJson <> '' then
            this.ProcessMessage(MessageJson, out_ErrorMessageMgt);

        ShipmentsJson := ResponseObject.GetValue('$.shipments');
        this.ProcessShipments(out_Shipment, in_LabelType, ShipmentsJson, out_ErrorMessageMgt);

        RatesJson := ResponseObject.GetValue('$.rates');
        this.ProcessRates(out_Shipment, RatesJson, out_ErrorMessageMgt);

        if this.ErrorHelper.HasErrors(out_ErrorMessageMgt) then
            exit;

        out_Shipment."Shipment Status" := out_Shipment."Shipment Status"::"Shipment Created";
        out_Shipment."Shipment Reference No." := ResponseObject.GetValue('id');
        out_Shipment.Modify();
    end;

    local procedure ProcessMessage(in_ResponseJson: Text; var out_ErrorMessageMgt: Codeunit "Error Message Management")
    var
        JsonMgt: Codeunit "JSON Management";
        i: Integer;
        JsonArray: JsonArray;
        JsonToken: JsonToken;
        TempText: Text;
    begin
        if not JsonToken.ReadFrom(in_ResponseJson) then
            exit;

        JsonArray := JsonToken.AsArray();

        for i := 0 to JsonArray.Count() - 1 do begin
            JsonArray.Get(i, JsonToken);
            JsonToken.AsObject().WriteTo(TempText);

            JsonMgt.InitializeFromString(TempText);

            out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo('%1, %2: %3',
                JsonMgt.GetValue('$.carrier'),
                JsonMgt.GetValue('$.type'),
                JsonMgt.GetValue('$.message')));
        end;
    end;

    local procedure ProcessShipments(var out_Shipment: Record "PVS Job Shipment";
        in_LabelType: Enum "PVS Label Type";
        in_ShipmentsJson: Text;
        var out_ErrorMessageMgt: Codeunit "Error Message Management")
    var
        JobShipmentLabel: Record "PVS Job Shipment Label";
        ParcelObject, ShipmentObject : Codeunit "JSON Management";
        i: Integer;
        JsonArray: JsonArray;
        JsonToken: JsonToken;
        MessagesJson, TempText : Text;
    begin
        if not JsonToken.ReadFrom(in_ShipmentsJson) then
            exit;

        JsonArray := JsonToken.AsArray();

        for i := 0 to JsonArray.Count() - 1 do begin
            JsonArray.Get(i, JsonToken);
            JsonToken.AsObject().WriteTo(TempText);

            ShipmentObject.InitializeFromString(TempText);

            MessagesJson := ShipmentObject.GetValue('$.messages');
            if (MessagesJson <> '[]') then
                exit;

            ParcelObject.InitializeFromString(ShipmentObject.GetValue('$.parcel'));

            Clear(JobShipmentLabel);
            JobShipmentLabel."Source Record ID" := out_Shipment.RecordId;

            JobShipmentLabel."SIEP Shipment ID" := ShipmentObject.GetValue('id');
            JobShipmentLabel."SIEP Shipment Reference" := ShipmentObject.GetValue('reference');
            JobShipmentLabel."Package No." := ParcelObject.GetValue('id');
            JobShipmentLabel."Label Type" := in_LabelType;
            JobShipmentLabel.Insert();
        end;
    end;

    local procedure ProcessRates(var out_Shipment: Record "PVS Job Shipment"; in_RatesJson: Text; var out_ErrorMessageMgt: Codeunit "Error Message Management")
    var
        Rate: Record "PVS Job Shipment Rate";
        ShippingAgent: Record "Shipping Agent";
        ShippingAgentService: Record "Shipping Agent Services";
        JsonMgt2: Codeunit "JSON Management";
        i: Integer;
        JsonArray: JsonArray;
        JsonToken: JsonToken;
        CarrierAccountNotFoundErr: Label 'Shipping agent not found for id %1 (%2).', Comment = '%1 = Carrier Account ID, %2 = Carrier Code';
        ShippingAgentServiceNotFoundErr: Label 'Shipping agent service not found for %1.', Comment = '%1 = Carrier Account ID, %2 = Carrier Code';
        RateText, TempText : Text;
    begin
        if not JsonToken.ReadFrom(in_RatesJson) then
            exit;

        JsonArray := JsonToken.AsArray();

        for i := 0 to JsonArray.Count() - 1 do begin
            JsonArray.Get(i, JsonToken);
            JsonToken.AsObject().WriteTo(TempText);

            JsonMgt2.InitializeFromString(TempText);
            RateText := JsonMgt2.GetValue('rate');

            ShippingAgent.Reset();
            ShippingAgent.SetRange("PVS Carrier Account ID", JsonMgt2.GetValue('carrier_account_id'));
            if not ShippingAgent.FindFirst() then
                out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(CarrierAccountNotFoundErr, JsonMgt2.GetValue('carrier_account_id'), JsonMgt2.GetValue('carrier')));

            ShippingAgentService.Reset();
            ShippingAgentService.SetRange("Shipping Agent Code", ShippingAgent.Code);
            ShippingAgentService.SetRange("PVS External Service Id", JsonMgt2.GetValue('service'));
            if not ShippingAgentService.FindFirst() then
                out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(ShippingAgentServiceNotFoundErr, JsonMgt2.GetValue('service')));

            if (ShippingAgentService.Code <> '') then begin
                Clear(Rate);
                Rate.Insert();
                Rate."Source Record ID" := out_Shipment.RecordId;
                Rate."Shipping Agent Code" := ShippingAgentService."Shipping Agent Code";
                Rate."Shipping Agent Service Code" := ShippingAgentService.Code;
                Rate."Currency Code" := JsonMgt2.GetValue('currency');
                Evaluate(Rate.Rate, RateText);
                Evaluate(Rate."SIEP Rate Id", JsonMgt2.GetValue('id'));
                Evaluate(Rate."SIEP List Rate", JsonMgt2.GetValue('list_rate'));
                Rate."SIEP List Currency" := JsonMgt2.GetValue('list_currency');
                Rate."SIEP Billing Type" := JsonMgt2.GetValue('billing_type');
                Evaluate(Rate."SIEP Delivery Days", JsonMgt2.GetValue('delivery_days'));
                Evaluate(Rate."SIEP Delivery Date", JsonMgt2.GetValue('delivery_date'));
                Evaluate(Rate."SIEP Delivery Date Guaranteed", JsonMgt2.GetValue('delivery_date_guaranteed'));
                Evaluate(Rate."SIEP Est. Delivery Days", JsonMgt2.GetValue('est_delivery_days'));
                Evaluate(Rate."SIEP Carrier Account Id", JsonMgt2.GetValue('carrier_account_id'));
                Rate.Modify();
            end;
        end;
    end;

    procedure ProcessCancelShipmentResponse(var out_Shipment: Record "PVS Job Shipment"; in_ResponseJson: Text; var out_ErrorMessageMgt: Codeunit "Error Message Management")
    var
    begin
        out_Shipment.Validate("Shipment Status", out_Shipment."Shipment Status"::Cancelled);
        out_Shipment."Shipment Reference No." := '';
        out_Shipment.Modify();
    end;

    procedure ProcessBuyOrderResponse(var out_Shipment: Record "PVS Job Shipment"; in_ResponseJson: Text; var out_ErrorMessageMgt: Codeunit "Error Message Management")
    var
        JsonMgt: Codeunit "JSON Management";
        JsonArray: JsonArray;
        JsonToken: JsonToken;
        ShipmentJson: Text;
    begin
        if not JsonMgt.InitializeFromString(in_ResponseJson) then
            exit;

        if not JsonToken.ReadFrom(JsonMgt.GetValue('$.shipments')) then
            exit;

        JsonArray := JsonToken.AsArray();
        if JsonArray.Count() = 0 then
            exit;

        JsonArray.Get(0, JsonToken);
        JsonToken.WriteTo(ShipmentJson);
        JsonMgt.InitializeFromString(ShipmentJson);

        out_Shipment."Track and Trace No." := CopyStr(JsonMgt.GetValue('$.tracking_code'), 1, MaxStrLen(out_Shipment."Track and Trace No."));
        out_Shipment."Tracking URL" := CopyStr(JsonMgt.GetValue('$.tracker.public_url'), 1, MaxStrLen(out_Shipment."Tracking URL"));
        out_Shipment.Validate("Shipment Status", out_Shipment."Shipment Status"::"SIEP Courier Booked");
        out_Shipment.Modify();
    end;

    procedure ProcessBuyOrderFailedResponse(var out_Shipment: Record "PVS Job Shipment"; in_ResponseJson: Text; var out_ErrorMessageMgt: Codeunit "Error Message Management")
    var
        ErrorObject, ResponseObject : Codeunit "JSON Management";
        ErrorsJson: Text;
    begin
        if not ResponseObject.InitializeFromString(in_ResponseJson) then
            exit;

        ErrorObject.InitializeFromString(ResponseObject.GetValue('$.error'));

        out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo('%1: %2',
            ErrorObject.GetValue('$.code'),
            ErrorObject.GetValue('$.message')));

        ErrorsJson := ErrorObject.GetValue('$.errors');
        if ErrorsJson <> '[]' then
            out_ErrorMessageMgt.LogSimpleErrorMessage(ErrorsJson);
    end;
}