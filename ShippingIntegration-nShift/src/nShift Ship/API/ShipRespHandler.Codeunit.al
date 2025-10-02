namespace PrintVis.OpenSource.NShift.Ship.API;

using PrintVis.OpenSource.NShift.Ship.Setup;
using System.Text;
using System.Utilities;

codeunit 80162 "SINS Ship Resp. Handler"
{
    var
        Utilities: codeunit "PVS Shipping Integration Util";

    procedure ProcessCreateShipmentResponse(var out_Shipment: Record "PVS Job Shipment";
        in_ResponseJson: Text;
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    var
        ShipSetup: Record "SINS Ship Setup";
        JsonMgt: Codeunit "JSON Management";
        CostAmount: Decimal;
        AmountJson, LabelsJson, ShpNo, ShpTag : Text;
    begin
        if this.ReadErrorResponse(in_ResponseJson, out_ErrorMessageMgt) then
            exit(false);

        ShipSetup.Get();

        JsonMgt.InitializeFromString(in_ResponseJson);
        ShpTag := JsonMgt.GetValue('ShpTag');
        ShpNo := JsonMgt.GetValue('ShpNo');
        AmountJson := JsonMgt.GetValue('Amounts');
        LabelsJson := JsonMgt.GetValue('Labels');

        CostAmount := this.ProcessShipmentCost(out_Shipment.RecordId, out_Shipment."Shipping Agent Code", out_Shipment."Shipping Agent Service Code", AmountJson);

        this.ProcessLabels(out_Shipment.RecordId, ShipSetup."Package Tracking Url", ShipSetup."Label Type", LabelsJson);

        this.UpdateShipment(out_Shipment, ShipSetup, ShpTag, ShpNo, out_Shipment."Order No.", CostAmount);

        exit(true);
    end;

    procedure ProcessCreateShipmentResponse(var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
        in_ResponseJson: Text;
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    var
        Shipment: Record "PVS Job Shipment";
        ShipSetup: Record "SINS Ship Setup";
        JsonMgt: Codeunit "JSON Management";
        CostAmount: Decimal;
        AmountJson, LabelsJson, ShpNo, ShpTag : Text;
    begin
        if this.ReadErrorResponse(in_ResponseJson, out_ErrorMessageMgt) then
            exit(false);

        ShipSetup.Get();

        JsonMgt.InitializeFromString(in_ResponseJson);
        ShpTag := JsonMgt.GetValue('ShpTag');
        ShpNo := JsonMgt.GetValue('ShpNo');
        AmountJson := JsonMgt.GetValue('Amounts');
        LabelsJson := JsonMgt.GetValue('Labels');

        CostAmount := this.ProcessShipmentCost(out_CombinedShipment.RecordId,
            out_CombinedShipment."Shipping Agent Code",
            out_CombinedShipment."Shipping Agent Service Code", AmountJson);

        this.ProcessLabels(out_CombinedShipment.RecordId, ShipSetup."Package Tracking Url", ShipSetup."Label Type", LabelsJson);

        if out_CombinedShipmentLine.FindSet() then
            repeat
                Shipment.Get(out_CombinedShipmentLine.ID, out_CombinedShipmentLine.Job, out_CombinedShipmentLine.Shipment);
                this.UpdateShipment(Shipment, ShipSetup, ShpTag, ShpNo, Shipment."Order No.", CostAmount);
            until out_CombinedShipmentLine.Next() = 0;

        out_CombinedShipment."Shipment Status" := Enum::"PVS Shipment Status"::"Shipment Created";
        out_CombinedShipment."Shipment Id" := '';
        out_CombinedShipment."Shipment Reference No." := ShpNo;
        out_CombinedShipment."SINS Shipment Tag" := ShpTag;
        out_CombinedShipment."Track and Trace No." := Shipment."Shipment Reference No.";
        if (out_CombinedShipment."Track and Trace No." = '') then
            out_CombinedShipment."Track and Trace No." := out_CombinedShipment."No.";

        out_CombinedShipment."Tracking Url" := '';
        if (ShipSetup."Shipment Tracking Url" <> '') then
            out_CombinedShipment."Tracking Url" := CopyStr(ShipSetup."Shipment Tracking Url" + Shipment."Track and Trace No.", 1, MaxStrLen(Shipment."Tracking Url"));
        out_CombinedShipment.Modify();

        exit(true);
    end;

    procedure ProcessCancelShipmentResponse(var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line"): Boolean
    var
        Shipment: Record "PVS Job Shipment";
    begin
        if out_CombinedShipmentLine.FindSet() then
            repeat
                Shipment.Get(out_CombinedShipmentLine.ID, out_CombinedShipmentLine.Job, out_CombinedShipmentLine.Shipment);
                this.ProcessCancelShipmentResponse(Shipment);
            until out_CombinedShipmentLine.Next() = 0;

        out_CombinedShipment."Shipment Status" := Enum::"PVS Shipment Status"::Cancelled;
        out_CombinedShipment."Shipment Id" := '';
        out_CombinedShipment."Shipment Reference No." := '';
        out_CombinedShipment."SINS Shipment Tag" := '';
        out_CombinedShipment."Track and Trace No." := '';
        out_CombinedShipment."Tracking Url" := '';
        out_CombinedShipment.Modify();

        exit(true);
    end;

    procedure ProcessCancelShipmentResponse(var out_Shipment: Record "PVS Job Shipment"): Boolean
    begin
        out_Shipment."Shipment Status" := Enum::"PVS Shipment Status"::Cancelled;
        out_Shipment."Shipment Id" := '';
        out_Shipment."Shipment Reference No." := '';
        out_Shipment."SINS Shipment Tag" := '';
        out_Shipment."Track and Trace No." := '';
        out_Shipment."Tracking Url" := '';
        out_Shipment.Modify();

        exit(true);
    end;

    procedure ProcessFetchShippingRatesResponse(var out_Shipment: Record "PVS Job Shipment"; in_ResponseJson: Text): Boolean
    var
        CostAmount: Decimal;
    begin
        if (in_ResponseJson = '') then
            exit(false);

        CostAmount := this.ProcessShipmentCost(out_Shipment.RecordId, out_Shipment."Shipping Agent Code", out_Shipment."Shipping Agent Service Code", in_ResponseJson);

        if (CostAmount > 0) then begin
            out_Shipment."Cost Amount" := CostAmount;
            out_Shipment.Modify();
        end;

        exit(true);
    end;

    procedure ProcessFetchShippingRatesResponse(var out_CombinedShipment: Record "PVS Combined Shipment Header"; in_ResponseJson: Text): Boolean
    var
        CostAmount: Decimal;
    begin
        if (in_ResponseJson = '') then
            exit(false);

        CostAmount := this.ProcessShipmentCost(out_CombinedShipment.RecordId,
            out_CombinedShipment."Shipping Agent Code",
            out_CombinedShipment."Shipping Agent Service Code", in_ResponseJson);

        // if (CostAmount > 0) then begin
        //     out_CombinedShipment."Cost Amount" := CostAmount;
        //     out_CombinedShipment.Modify();
        // end;

        exit(true);
    end;

    procedure ProcessRetrieveShipmentStatusResponse(var out_Shipment: Record "PVS Job Shipment";
        in_ResponseJson: Text;
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    var
        ShipmentLabel: Record "PVS Job Shipment Label";
        JsonMgt, PackagesJsonMgt, PkgJsonMgt : Codeunit "JSON Management";
        Index: Integer;
        MissingPackagesLbl: Label 'Missing packages: %1';
        MissingPackages: Text;
        PkgJson, PkgNo, TrackingURL : Text;
    begin
        if in_ResponseJson = '' then
            exit(false);

        JsonMgt.InitializeFromString(in_ResponseJson);
        PackagesJsonMgt.InitializeCollection(JsonMgt.GetValue('Pkgs'));
        for Index := 0 to PackagesJsonMgt.GetCollectionCount() - 1 do begin
            PackagesJsonMgt.GetObjectFromCollectionByIndex(PkgJson, Index);
            PkgJsonMgt.InitializeFromString(PkgJson);

            PkgNo := PkgJsonMgt.GetValue('PkgNo');
            TrackingURL := PkgJsonMgt.GetValue('TrackingURL');

            ShipmentLabel.SetRange("Source Record ID", out_Shipment.RecordId);
            ShipmentLabel.SetRange("Package No.", PkgNo);
            if ShipmentLabel.FindFirst() then begin
                ShipmentLabel."Tracking URL" := TrackingURL;
                ShipmentLabel.Modify();
            end else
                MissingPackages += PkgNo + ', ';
        end;

        if MissingPackages <> '' then
            out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(MissingPackagesLbl, MissingPackages));

        exit(true);
    end;

    local procedure UpdateShipment(var out_Shipment: Record "PVS Job Shipment";
        in_ShipSetup: Record "SINS Ship Setup";
        in_ShpTag: Text;
        in_ShpNo: Text;
        in_OrderNo: Text;
        in_CostAmount: Decimal)
    begin
        out_Shipment."Shipment Status" := Enum::"PVS Shipment Status"::"Shipment Created";
        out_Shipment."Shipment Id" := '';
        out_Shipment."Shipment Reference No." := in_ShpNo;
        out_Shipment."SINS Shipment Tag" := in_ShpTag;
        out_Shipment."Track and Trace No." := out_Shipment."Shipment Reference No.";
        if (out_Shipment."Track and Trace No." = '') then
            out_Shipment."Track and Trace No." := in_OrderNo;

        out_Shipment."Tracking Url" := '';
        if (in_ShipSetup."Shipment Tracking Url" <> '') then
            out_Shipment."Tracking Url" := CopyStr(in_ShipSetup."Shipment Tracking Url" + out_Shipment."Track and Trace No.", 1, MaxStrLen(out_Shipment."Tracking Url"));

        out_Shipment."Cost Amount" := in_CostAmount;
        out_Shipment.Modify();
    end;

    local procedure ReadErrorResponse(in_ResponseJson: Text; var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    var
        JsonMgt: Codeunit "JSON Management";
        ErrorMessages, ErrorsJson : Text;
    begin
        JsonMgt.InitializeFromString(in_ResponseJson);

        ErrorMessages := JsonMgt.GetValue('Message');
        ErrorsJson := JsonMgt.GetValue('Errors');

        if (ErrorsJson = '') and (ErrorMessages <> '') then
            out_ErrorMessageMgt.LogSimpleErrorMessage(ErrorMessages)
        else
            this.ProcessErrorMessages(ErrorsJson, out_ErrorMessageMgt);

        exit((ErrorMessages <> '') or (ErrorsJson <> ''));
    end;

    local procedure ProcessShipmentCost(
        in_SourceRecordID: RecordId;
        in_ShippingAgentCode: Code[10];
        in_ShippingAgentServiceCode: Code[10];
        in_AmountJson: Text): Decimal
    var
        CostAmount: Decimal;
    begin
        CostAmount := this.GetRateFromCalculation(in_AmountJson);

        if CostAmount > 0 then
            this.CreateShippingRate(in_SourceRecordID, in_ShippingAgentCode, in_ShippingAgentServiceCode, CostAmount);

        exit(CostAmount);
    end;

    local procedure CreateShippingRate(
        in_SourceRecordID: RecordId;
        in_ShippingAgentCode: Code[10];
        in_ShippingAgentServiceCode: Code[10];
        in_CostAmount: Decimal)
    var
        ShipmentRate: Record "PVS Job Shipment Rate";
    begin
        Clear(ShipmentRate);
        ShipmentRate.Insert();
        ShipmentRate."Source Record ID" := in_SourceRecordID;
        ShipmentRate."Shipping Agent Code" := in_ShippingAgentCode;
        ShipmentRate."Shipping Agent Service Code" := in_ShippingAgentServiceCode;
        ShipmentRate.Validate(Rate, in_CostAmount);
        ShipmentRate.Modify();
    end;

    local procedure ProcessErrorMessages(in_ErrorsJson: Text; var out_ErrorMessageMgt: Codeunit "Error Message Management")
    var
        JsonMgt, JsonMgt2 : Codeunit "JSON Management";
        Index: Integer;
        ErrorObjectJson, Message : Text;
    begin
        JsonMgt.InitializeCollection(in_ErrorsJson);
        for Index := 0 to JsonMgt.GetCollectionCount() - 1 do begin
            JsonMgt.GetObjectFromCollectionByIndex(ErrorObjectJson, Index);

            JsonMgt2.InitializeFromString(ErrorObjectJson);
            Message := JsonMgt2.GetValue('message');

            out_ErrorMessageMgt.LogSimpleErrorMessage(Message);
        end;
    end;

    local procedure GetRateFromCalculation(in_AmountJson: Text): Decimal
    var
        Convert: Codeunit "Base64 Convert";
        JsonMgt: Codeunit "JSON Management";
        CostAmount: Decimal;
        PriceCalculationResponseLbl: Label 'Price calculation response';
        Response: Text;
    begin
        CostAmount := 0;

        JsonMgt.InitializeFromString(in_AmountJson);
        if Evaluate(CostAmount, JsonMgt.GetValue('Price2')) then;

        if (CostAmount = 0) then begin
            Response := JsonMgt.GetValue('Response');
            if (Response <> '') then
                this.Utilities.ShowHtmlContent(Convert.FromBase64(Response), PriceCalculationResponseLbl);
        end;

        exit(CostAmount);
    end;

    local procedure ProcessLabels(
        in_SourceRecordID: RecordId;
        in_PackageTrackingUrl: Text;
        in_LabelType: Enum "PVS Label Type";
        in_LabelsJson: Text)
    begin
        if (in_LabelsJson = '') then
            exit;

        this.SaveLabels(in_SourceRecordID, in_PackageTrackingUrl, in_LabelType, in_LabelsJson);
    end;

    local procedure SaveLabels(
        in_SourceRecordID: RecordId;
        in_PackageTrackingUrl: Text;
        in_LabelType: Enum "PVS Label Type";
        in_LabelsJson: Text)
    var
        JsonMgt, JsonMgt2 : Codeunit "JSON Management";
        Index: Integer;
        Content, CopiesText, DocumentIdText, DocumentName, LabelJson, PackageNo, PackageTag, PkgCSIDText, Tag, TypeText : Text;
    begin
        JsonMgt.InitializeCollection(in_LabelsJson);
        for Index := 0 to JsonMgt.GetCollectionCount() - 1 do begin
            JsonMgt.GetObjectFromCollectionByIndex(LabelJson, Index);
            JsonMgt2.InitializeFromString(LabelJson);

            Content := JsonMgt2.GetValue('Content');
            TypeText := JsonMgt2.GetValue('Type');
            DocumentIdText := JsonMgt2.GetValue('DocumentId');
            DocumentName := JsonMgt2.GetValue('DocumentName');
            CopiesText := JsonMgt2.GetValue('Copies');
            PkgCSIDText := JsonMgt2.GetValue('PkgCSID');
            PackageTag := JsonMgt2.GetValue('PkgTag');
            PackageNo := JsonMgt2.GetValue('PkgNo');
            Tag := JsonMgt2.GetValue('Tag');

            this.InsertShipmentLabel(in_SourceRecordID, in_PackageTrackingUrl, PackageNo, PackageTag, in_LabelType, Content);
        end;
    end;

    local procedure InsertShipmentLabel(
        in_SourceRecordID: RecordId;
        in_PackageTrackingUrl: Text;
        in_PackageNo: Text;
        in_PackageTag: Text;
        in_LabelType: Enum "PVS Label Type";
        in_Content: Text)
    var
        ShipmentLabel: Record "PVS Job Shipment Label";
        Convert: Codeunit "Base64 Convert";
        LabelOutStream: OutStream;
    begin
        Clear(ShipmentLabel);
        ShipmentLabel.Insert();
        ShipmentLabel."Source Record ID" := in_SourceRecordID;
        ShipmentLabel."Package No." := in_PackageNo;
        ShipmentLabel."SINS Package Tag" := in_PackageTag;
        ShipmentLabel."Label Type" := in_LabelType;
        ShipmentLabel."Label Base64".CreateOutStream(LabelOutStream);
        Convert.FromBase64(in_Content, LabelOutStream);

        if (in_PackageTrackingUrl <> '') then
            ShipmentLabel."Tracking URL" := in_PackageTrackingUrl + ShipmentLabel."Package No.";
        ShipmentLabel.Modify();
    end;
}