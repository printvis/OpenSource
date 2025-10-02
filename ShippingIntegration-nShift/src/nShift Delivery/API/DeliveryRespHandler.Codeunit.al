namespace PrintVis.OpenSource.NShift.Delivery.API;

using System.Text;

codeunit 80168 "SINS Delivery Resp. Handler"
{
    procedure ProcessCreateShipmentResponse(var out_Shipment: Record "PVS Job Shipment"; in_ResponseJson: Text): Boolean
    var
        JsonMgt: Codeunit "JSON Management";
        JsonArray: JsonArray;
        JObject: JsonObject;
        JsonToken: JsonToken;
        LabelData: Text;
        ShpId: Text;
        ShpNo: Text;
    begin
        JsonToken.ReadFrom(in_ResponseJson);
        JsonArray := JsonToken.AsArray();

        if not JsonArray.Get(0, JsonToken) then
            exit(false);

        JObject.ReadFrom(Format(JsonToken));
        JsonMgt.InitializeFromString(Format(JsonToken));

        ShpId := JsonMgt.GetValue('id');
        ShpNo := JsonMgt.GetValue('shipmentNo');

        LabelData := JsonMgt.GetValue('$.prints[?(@.description == ''Label'' && @.type == ''pdf'')].data');
        if (LabelData <> '') then
            this.SaveShipmentLabel(out_Shipment.RecordId, LabelData, 1);

        this.UpdateShipment(out_Shipment, ShpId, ShpNo, out_Shipment."Order No.");

        exit(true);
    end;

    local procedure SaveShipmentLabel(in_SourceRecordID: RecordID; in_LabelContent: Text; in_i: Integer)
    var
        ShipmentLabel: Record "PVS Job Shipment Label";
        Convert: Codeunit "Base64 Convert";
        LabelOutStream: OutStream;
    begin
        Clear(ShipmentLabel);
        ShipmentLabel."Source Record ID" := in_SourceRecordID;
        ShipmentLabel."Package No." := Format(in_i + 1);
        ShipmentLabel."Label Base64".CreateOutStream(LabelOutStream);
        Convert.FromBase64(in_LabelContent, LabelOutStream);
        ShipmentLabel."Label Type" := Enum::"PVS Label Type"::PDF;
        ShipmentLabel.Insert();
    end;

    procedure ProcessCreateShipmentResponse(var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
        in_ResponseJson: Text): Boolean
    var
        Shipment: Record "PVS Job Shipment";
        JsonMgt: Codeunit "JSON Management";
        JsonArray: JsonArray;
        JsonToken: JsonToken;
        LabelData: Text;
        ShpId: Text;
        ShpNo: Text;
    begin
        JsonToken.ReadFrom(in_ResponseJson);
        JsonArray := JsonToken.AsArray();

        if not JsonArray.Get(0, JsonToken) then
            exit(false);

        JsonMgt.InitializeFromString(Format(JsonToken));

        ShpId := JsonMgt.GetValue('id');
        ShpNo := JsonMgt.GetValue('shipmentNo');

        LabelData := JsonMgt.GetValue('$.prints[?(@.description == ''Label'' && @.type == ''pdf'')].data');
        if (LabelData <> '') then
            this.SaveShipmentLabel(out_CombinedShipment.RecordId, LabelData, 1);

        if out_CombinedShipmentLine.FindSet() then
            repeat
                Shipment.Get(out_CombinedShipmentLine.ID, out_CombinedShipmentLine.Job, out_CombinedShipmentLine.Shipment);
                this.UpdateShipment(Shipment, ShpId, ShpNo, out_CombinedShipment."No.");
            until out_CombinedShipmentLine.Next() = 0;

        exit(true);
    end;

    procedure ProcessCancelShipmentResponse(var out_Shipment: Record "PVS Job Shipment"): Boolean
    begin
        out_Shipment."Shipment Status" := out_Shipment."Shipment Status"::Cancelled;
        out_Shipment."Shipment Id" := '';
        out_Shipment."Shipment Reference No." := '';
        out_Shipment."SINS Shipment Tag" := '';
        out_Shipment."Track and Trace No." := '';
        out_Shipment."Tracking Url" := '';
        out_Shipment.Modify();

        exit(true);
    end;

    procedure ProcessCancelShipmentResponse(var out_CombinedShipmentLine: Record "PVS Combined Shipment Line"): Boolean
    var
        Shipment: Record "PVS Job Shipment";
    begin
        if out_CombinedShipmentLine.FindSet() then
            repeat
                Shipment.Get(out_CombinedShipmentLine.ID, out_CombinedShipmentLine.Job, out_CombinedShipmentLine.Shipment);
                this.ProcessCancelShipmentResponse(Shipment);
            until out_CombinedShipmentLine.Next() = 0;

        exit(true);
    end;

    procedure ProcessFetchShippingRatesResponse(var out_Shipment: Record "PVS Job Shipment"; in_ResponseJson: Text): Boolean
    var
        ShipmentRate: Record "PVS Job Shipment Rate";
        JsonMgt: Codeunit "JSON Management";
        JsonObject: JsonObject;
        PriceDataToken: JsonToken;
    begin
        JsonObject.ReadFrom(in_ResponseJson);

        if not JsonObject.Get('priceData', PriceDataToken) then
            exit(false);

        JsonMgt.InitializeFromString(Format(PriceDataToken));

        ShipmentRate.Init();
        ShipmentRate."Source Record ID" := out_Shipment.RecordId;
        ShipmentRate."Shipping Agent Code" := out_Shipment."Shipping Agent Code";
        ShipmentRate."Shipping Agent Service Code" := out_Shipment."Shipping Agent Service Code";
        Evaluate(ShipmentRate.Rate, JsonMgt.GetValue('priceWithAdditionalSurcharges'));
        ShipmentRate.Insert();

        exit(true);
    end;

    procedure ProcessFetchShippingRatesResponse(var out_CombinedShipment: Record "PVS Combined Shipment Header"; in_ResponseJson: Text): Boolean
    var
        ShipmentRate: Record "PVS Job Shipment Rate";
        JsonMgt: Codeunit "JSON Management";
        JsonObject: JsonObject;
        PriceDataToken: JsonToken;
    begin
        JsonObject.ReadFrom(in_ResponseJson);

        if not JsonObject.Get('priceData', PriceDataToken) then
            exit(false);

        JsonMgt.InitializeFromString(Format(PriceDataToken));

        ShipmentRate.Init();
        ShipmentRate."Source Record ID" := out_CombinedShipment.RecordId;
        ShipmentRate."Shipping Agent Code" := out_CombinedShipment."Shipping Agent Code";
        ShipmentRate."Shipping Agent Service Code" := out_CombinedShipment."Shipping Agent Service Code";
        Evaluate(ShipmentRate.Rate, JsonMgt.GetValue('priceWithAdditionalSurcharges'));
        ShipmentRate.Insert();

        exit(true);
    end;

    local procedure UpdateShipment(
        var out_Shipment: Record "PVS Job Shipment";
        in_ShpId: Text;
        in_ShpNo: Text;
        in_OrderNo: Text)
    begin
        out_Shipment."Shipment Status" := Enum::"PVS Shipment Status"::"Shipment Created";
        out_Shipment."Shipment Id" := in_ShpId;
        out_Shipment."Shipment Reference No." := in_ShpNo;
        out_Shipment."SINS Shipment Tag" := '';

        out_Shipment."Track and Trace No." := out_Shipment."Shipment Reference No.";
        if (out_Shipment."Track and Trace No." = '') then
            out_Shipment."Track and Trace No." := in_OrderNo;

        out_Shipment."Tracking Url" := '';
        out_Shipment.Modify();
    end;
}