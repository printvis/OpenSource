namespace PrintVis.OpenSource.Shipmondo.API;

using System.Utilities;
using System.Text;

codeunit 80189 "SISM Resp. Handler"
{
    var
        Utilities: Codeunit "PVS Shipping Integration Util";

    procedure ProcessCreateShipmentQuoteResponse(
        in_Shipment: Record "PVS Job Shipment";
        in_Responses: List of [Text];
        var out_ErrorMessageMgt: codeunit "Error Message Management")
    var
        Rate: Record "PVS Job Shipment Rate";
        PalletType: Record "PVS Pallet Types";
        CurrencyCode: Code[10];
        LastParcelPrice, ParcelPrice : Decimal;
        Counter: Integer;
        NoOfPackages: Integer;
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        ResponseJson: Text;
    begin
        Counter := 0;
        foreach ResponseJson in in_Responses do
            if JsonObject.ReadFrom(ResponseJson) then begin
                JsonObject.Get('price', JsonToken);

                Counter += 1;
                if Counter = 1 then begin
                    ParcelPrice := JsonToken.AsValue().AsDecimal();
                    if JsonObject.Get('currency_code', JsonToken) then
                        CurrencyCode := JsonToken.AsValue().AsText();
                end else
                    LastParcelPrice := JsonToken.AsValue().AsDecimal();
            end;

        NoOfPackages := 1;
        if PalletType.Get(in_Shipment."Shipping Agent Code", in_Shipment."Pallet Type") then
            if PalletType.Package then
                NoOfPackages := in_Shipment."No. Of Packages"
            else
                NoOfPackages := in_Shipment."No. Of Pallets";

        Rate.Init();
        Rate."Source Record ID" := in_Shipment.RecordId();
        Rate."Shipping Agent Code" := in_Shipment."Shipping Agent Code";
        Rate."Shipping Agent Service Code" := in_Shipment."Shipping Agent Service Code";
        if (LastParcelPrice > 0) then
            Rate.Rate := ((NoOfPackages - 1) * ParcelPrice) + (1 * LastParcelPrice)
        else
            Rate.Rate := (NoOfPackages * ParcelPrice);
        Rate."Currency Code" := CurrencyCode;
        Rate.Insert();
    end;

    procedure ProcessCreateShipmentResponse(
        var out_Shipment: Record "PVS Job Shipment";
        in_ResponseJson: Text;
        var out_ErrorMessageMgt: codeunit "Error Message Management")
    var
        JsonMgt: Codeunit "JSON Management";
        ShipmentCreatedMsg: Label 'Shipment created with id %1', Comment = '%1 = Shipment Id';
    begin
        if not JsonMgt.InitializeFromString(in_ResponseJson) then
            exit;

        out_Shipment."Shipment Status" := Enum::"PVS Shipment Status"::"Shipment Created";
        out_Shipment."Shipment Reference No." := JsonMgt.GetValue('id');
        out_Shipment."Track and Trace No." := JsonMgt.GetValue('pkg_no');
        out_Shipment."Tracking Url" := '';
        out_Shipment.Modify();

        if out_Shipment."Shipment Reference No." <> '' then
            Message(ShipmentCreatedMsg, out_Shipment."Shipment Reference No.");
    end;

    procedure ProcessCancelShipmentResponse(
        in_Shipment: Record "PVS Job Shipment";
        in_ResponseJson: Text;
        var out_ErrorMessageMgt: codeunit "Error Message Management")
    var
        IsCancelled: Boolean;
        JsonObject: JsonObject;
        JsonToken: JsonToken;
    begin
        if not JsonObject.ReadFrom(in_ResponseJson) then
            exit;

        if JsonObject.Get('cancelled', JsonToken) then
            IsCancelled := JsonToken.AsValue().AsBoolean();

        if IsCancelled then begin
            in_Shipment."Shipment Status" := Enum::"PVS Shipment Status"::Cancelled;
            in_Shipment."Shipment Reference No." := '';
            in_Shipment."Track and Trace No." := '';
            in_Shipment."Tracking Url" := '';
            in_Shipment.Modify();
        end else
            out_ErrorMessageMgt.LogSimpleErrorMessage(in_ResponseJson);
    end;

    procedure ProcessRetrieveLabelsResponse(
        in_Shipment: Record "PVS Job Shipment";
        in_ResponseJson: Text;
        var out_ErrorMessageMgt: codeunit "Error Message Management")
    var
        ShipmentLabel: Record "PVS Job Shipment Label";
        Convert: Codeunit "Base64 Convert";
        LabelObject: Codeunit "JSON Management";
        i: Integer;
        JsonArray: JsonArray;
        JsonToken: JsonToken;
        LabelOutStream: OutStream;
        LabelContent: Text;
        LabelJson: Text;
    begin
        if not JsonToken.ReadFrom(in_ResponseJson) then
            exit;

        JsonArray := JsonToken.AsArray();

        for i := 0 to JsonArray.Count() - 1 do begin
            JsonArray.Get(i, JsonToken);
            JsonToken.AsObject().WriteTo(LabelJson);

            LabelObject.InitializeFromString(LabelJson);
            LabelContent := LabelObject.GetValue('$.base64');

            Clear(ShipmentLabel);
            ShipmentLabel."Source Record ID" := in_Shipment.RecordId;
            ShipmentLabel."Package No." := Format(i + 1);
            ShipmentLabel."Label Base64".CreateOutStream(LabelOutStream);
            Convert.FromBase64(LabelContent, LabelOutStream);
            case LabelObject.GetValue('$.file_format').ToLower() of
                'pdf':
                    ShipmentLabel."Label Type" := Enum::"PVS Label Type"::PDF;
                'png':
                    ShipmentLabel."Label Type" := Enum::"PVS Label Type"::PNG;
                'zpl':
                    ShipmentLabel."Label Type" := Enum::"PVS Label Type"::ZPL
            end;
            ShipmentLabel.Insert();
        end;
    end;

    procedure ProcessGetPrintersResponse(
        in_ResponseJson: Text;
        var out_ErrorMessageMgt: codeunit "Error Message Management")
    var
        PrintClient: Record "SISM Print Client";
        ConfirmMgt: Codeunit "Confirm Management";
        PrinterObject: Codeunit "JSON Management";
        i: Integer;
        JsonArray: JsonArray;
        JsonToken: JsonToken;
        ConfirmQst: Label 'Do you want to remove all existing printers and import new ones?';
    begin
        if not JsonToken.ReadFrom(in_ResponseJson) then
            exit;

        if not JsonToken.IsArray then
            exit;

        if not ConfirmMgt.GetResponseOrDefault(ConfirmQst, true) then
            exit;

        JsonArray := JsonToken.AsArray();

        PrintClient.DeleteAll();

        for i := 0 to JsonArray.Count() - 1 do begin
            JsonArray.Get(i, JsonToken);
            PrinterObject.InitializeFromString(JsonToken.AsValue().AsText());

            Clear(PrintClient);
            PrintClient.Name := CopyStr(PrinterObject.GetValue('name'), 1, MaxStrLen(PrintClient.Name));
            PrintClient.Hostname := CopyStr(PrinterObject.GetValue('hostname'), 1, MaxStrLen(PrintClient.Hostname));
            PrintClient.Printer := CopyStr(PrinterObject.GetValue('printer'), 1, MaxStrLen(PrintClient.Printer));
            PrintClient."Label Format" := CopyStr(PrinterObject.GetValue('label_format'), 1, MaxStrLen(PrintClient."Label Format"));
            Evaluate(PrintClient."Default Printer", PrinterObject.GetValue('default_printer'));
            Evaluate(PrintClient."Default Document Printer", PrinterObject.GetValue('default_document_printer'));
            Evaluate(PrintClient."Default Pick Document Printer", PrinterObject.GetValue('default_pick_document_printer'));
            Evaluate(PrintClient."Staff Account ID", PrinterObject.GetValue('staff_account_id'));
            PrintClient.Insert();
        end;
    end;

    procedure ProcessPrintJobResponse(
        in_Shipment: Record "PVS Job Shipment";
        in_ResponseJson: Text;
        var out_ErrorMessageMgt: codeunit "Error Message Management")
    var
        ResponseObject: Codeunit "JSON Management";
        ErrorText, SuccessText : Text;
    begin
        if not ResponseObject.InitializeFromString(in_ResponseJson) then
            exit;

        SuccessText := ResponseObject.GetValue('$.success');

        if SuccessText <> '' then
            this.Utilities.RemoveLabelsBySourceRecordID(in_Shipment.RecordId())
        else begin
            ErrorText := ResponseObject.GetValue('$.error');
            out_ErrorMessageMgt.LogSimpleErrorMessage(ErrorText);
        end;
    end;

    procedure ProcessGetPickupPointsResponse(
        in_ResponseJson: Text;
        var out_ServicePoints: Record "SISM Pickup Point";
        var out_ErrorMessageMgt: codeunit "Error Message Management")
    var
        PickupPointObject: Codeunit "JSON Management";
        i: Integer;
        JsonArray: JsonArray;
        JsonToken, JsonToken2 : JsonToken;
        PickupPointJson: Text;
    begin
        if not JsonToken.ReadFrom(in_ResponseJson) then
            exit;

        if not JsonToken.IsArray then
            exit;

        JsonArray := JsonToken.AsArray();

        for i := 0 to JsonArray.Count() - 1 do begin
            JsonArray.Get(i, JsonToken2);
            JsonToken2.AsObject().WriteTo(PickupPointJson);
            PickupPointObject.InitializeFromString(PickupPointJson);

            Clear(out_ServicePoints);
            out_ServicePoints.Number := CopyStr(PickupPointObject.GetValue('$.number'), 1, MaxStrLen(out_ServicePoints.Number));
            out_ServicePoints.ID := CopyStr(PickupPointObject.GetValue('$.id'), 1, MaxStrLen(out_ServicePoints.ID));
            out_ServicePoints."Company Name" := CopyStr(PickupPointObject.GetValue('$.company_name'), 1, MaxStrLen(out_ServicePoints."Company Name"));
            out_ServicePoints.Address := CopyStr(PickupPointObject.GetValue('$.address'), 1, MaxStrLen(out_ServicePoints.Address));
            out_ServicePoints."Address 2" := CopyStr(PickupPointObject.GetValue('$.address2'), 1, MaxStrLen(out_ServicePoints."Address 2"));
            out_ServicePoints."Post Code" := CopyStr(PickupPointObject.GetValue('$.zipcode'), 1, MaxStrLen(out_ServicePoints."Post Code"));
            out_ServicePoints.City := CopyStr(PickupPointObject.GetValue('$.city'), 1, MaxStrLen(out_ServicePoints.City));
            out_ServicePoints."Country Code" := CopyStr(PickupPointObject.GetValue('$.country'), 1, MaxStrLen(out_ServicePoints."Country Code"));
            Evaluate(out_ServicePoints.Longitude, PickupPointObject.GetValue('$.longitude'));
            Evaluate(out_ServicePoints.Latitude, PickupPointObject.GetValue('$.latitude'));
            out_ServicePoints."Carrier Code" := CopyStr(PickupPointObject.GetValue('$.carrier_code'), 1, MaxStrLen(out_ServicePoints."Carrier Code"));
            out_ServicePoints.Insert();
        end;
    end;
}
