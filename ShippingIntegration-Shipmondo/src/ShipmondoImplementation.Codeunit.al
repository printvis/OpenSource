namespace PrintVis.OpenSource.Shipmondo;

using System.Utilities;

codeunit 80185 "SISM Implementation" implements "PVS Shipping Integration", "SISM Integration"
{
    var
        Shipmondo: Codeunit "SISM Mgt";
        NotImplementedErr: Label 'This action %1 is not implemented for Shipmondo', Comment = '%1 = Shipping Action';

    procedure VerifyAddress(
        in_Action: enum "PVS Shipping Action";
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: codeunit System.Utilities."Error Message Management";
        in_IsCombinedShipment: Boolean): Boolean
    begin
        out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(this.NotImplementedErr, in_Action));
        exit(false);
    end;

    procedure VerifyAddress(
        in_Action: enum "PVS Shipping Action";
        var out_CombinedShipmentHeader: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: codeunit System.Utilities."Error Message Management";
        in_IsCombinedShipment: Boolean): Boolean
    begin
        out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(this.NotImplementedErr, in_Action));
        exit(false);
    end;

    procedure CreateShipment(
        in_Action: Enum "PVS Shipping Action";
        in_IsBatch: Boolean;
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    begin
        exit(this.Shipmondo.CreateShipment(in_Action, out_Shipment, out_ErrorMessageMgt));
    end;

    procedure CreateShipment(
        in_Action: enum "PVS Shipping Action";
        var out_CombinedShipmentHeader: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: codeunit System.Utilities."Error Message Management"): Boolean
    begin
        out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(this.NotImplementedErr, in_Action));
        exit(false);
    end;

    procedure CancelShipment(
        in_Action: Enum "PVS Shipping Action";
        in_IsBatch: Boolean;
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    begin
        exit(this.Shipmondo.CancelShipment(in_Action, out_Shipment, out_ErrorMessageMgt));
    end;

    procedure CancelShipment(
        in_Action: Enum "PVS Shipping Action";
        var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    begin
        out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(this.NotImplementedErr, in_Action));
        exit(false);
    end;

    procedure BookCourier(
        in_Action: enum "PVS Shipping Action";
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: codeunit System.Utilities."Error Message Management";
        in_IsCombinedShipment: Boolean;
        var out_CombinedShipmentHeader: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line"): Boolean
    begin
        out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(this.NotImplementedErr, in_Action));
        exit(false);
    end;

    procedure BookCourier(
        in_Action: enum "PVS Shipping Action";
        var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: codeunit System.Utilities."Error Message Management";
        in_IsCombinedShipment: Boolean): Boolean
    begin
        out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(this.NotImplementedErr, in_Action));
        exit(false);
    end;

    procedure RetrieveShipmentStatus(
        in_Action: Enum "PVS Shipping Action";
        in_IsBatch: Boolean;
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    begin
        out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(this.NotImplementedErr, in_Action));
        exit(false);
    end;

    procedure RetrieveShipmentStatus(
        in_Action: Enum "PVS Shipping Action";
        var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    begin
        out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(this.NotImplementedErr, in_Action));
        exit(false);
    end;

    procedure FetchShippingRates(
        in_Action: Enum "PVS Shipping Action";
        in_IsBatch: Boolean;
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    begin
        out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(this.NotImplementedErr, in_Action));
        exit(false);
    end;

    procedure FetchShippingRates(
        in_Action: Enum "PVS Shipping Action";
        var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    begin
        out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(this.NotImplementedErr, in_Action));
        exit(false);
    end;

    procedure RetrieveLabels(
        in_Action: Enum "PVS Shipping Action";
        in_IsBatch: Boolean;
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    begin
        exit(this.Shipmondo.RetrieveLabels(in_Action, out_Shipment, out_ErrorMessageMgt));
    end;

    procedure RetrieveLabels(
     in_Action: Enum "PVS Shipping Action";
     var out_CombinedShipment: Record "PVS Combined Shipment Header";
     var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
     var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    begin
        out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(this.NotImplementedErr, in_Action));
        exit(false);
    end;

    procedure GetPrinters(): Boolean
    begin
        exit(this.Shipmondo.GetPrinters());
    end;

    procedure PrintJob(
        in_Action: enum "PVS Shipping Action";
        in_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    var
        DocumentType: Text;
    begin
        DocumentType := this.GetDocumentType();
        exit(this.Shipmondo.PrintJob(in_Action, in_Shipment, DocumentType, out_ErrorMessageMgt));
    end;

    procedure GetDocumentType(): Text
    var
        DocumentTypes: List of [Text];
        Options, Value : Text;
    begin
        DocumentTypes.Add('shipment');
        DocumentTypes.Add('sales_order');
        DocumentTypes.Add('fulfillment');
        DocumentTypes.Add('proforma');
        DocumentTypes.Add('waybill');

        foreach Value in DocumentTypes do
            if Options = '' then
                Options := Value
            else
                Options += ',' + Value;

        exit(DocumentTypes.Get(StrMenu(Options, 1)));
    end;

    procedure GetPickupPoints(
        in_CarrierCode: Code[20];
        in_CountryCode: Code[10];
        in_PostCode: Code[20];
        in_Address: Text;
        var out_ServicePoints: Record "SISM Pickup Point";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        exit(this.Shipmondo.GetPickupPoints(in_CarrierCode, in_CountryCode, in_PostCode, in_Address, out_ServicePoints, out_ErrorMessageMgt));
    end;

    procedure IsEnabled(): Boolean
    begin
        exit(this.Shipmondo.IsEnabled());
    end;
}