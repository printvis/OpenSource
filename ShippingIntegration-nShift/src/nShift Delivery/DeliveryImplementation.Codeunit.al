namespace PrintVis.OpenSource.NShift.Delivery;

using System.Utilities;

codeunit 80164 "SINS Delivery Implementation" implements "PVS Shipping Integration"
{
    var
        Delivery: Codeunit "SINS Delivery Shpt. Mgt.";
        NotImplementedErr: Label 'This action %1 is not implemented for nShift Delivery.';

    procedure CreateShipment(
        in_Action: Enum "PVS Shipping Action";
        in_IsBatch: Boolean;
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    begin
        exit(this.Delivery.CreateShipment(in_Action, out_Shipment, out_ErrorMessageMgt));
    end;

    procedure CreateShipment(
        in_Action: enum "PVS Shipping Action";
        var out_CombinedShipmentHeader: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        exit(this.Delivery.CreateShipment(in_Action, out_CombinedShipmentHeader, out_CombinedShipmentLine, out_ErrorMessageMgt));
    end;

    procedure CancelShipment(
        in_Action: Enum "PVS Shipping Action";
        in_IsBatch: Boolean;
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    begin
        exit(this.Delivery.CancelShipment(in_Action, out_Shipment, out_ErrorMessageMgt));
    end;

    procedure CancelShipment(
        in_Action: enum "PVS Shipping Action";
        var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        exit(this.Delivery.CancelShipment(in_Action, out_CombinedShipment, out_CombinedShipmentLine, out_ErrorMessageMgt));
    end;

    procedure RetrieveShipmentStatus(
        in_Action: Enum "PVS Shipping Action";
        in_IsBatch: Boolean;
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    begin
        exit(this.Delivery.RetrieveShipmentStatus(out_Shipment."Order No.", out_ErrorMessageMgt));
    end;

    procedure RetrieveShipmentStatus(
        in_Action: enum "PVS Shipping Action";
        var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        exit(this.Delivery.RetrieveShipmentStatus(out_CombinedShipment."No.", out_ErrorMessageMgt));
    end;

    procedure FetchShippingRates(
        in_Action: enum "PVS Shipping Action";
        in_IsBatch: Boolean;
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        exit(this.Delivery.FetchShippingRates(in_Action, out_Shipment, out_ErrorMessageMgt));
    end;

    procedure FetchShippingRates(
        in_Action: enum "PVS Shipping Action";
        var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        exit(this.Delivery.FetchShippingRates(in_Action, out_CombinedShipment, out_ErrorMessageMgt));
    end;

    procedure RetrieveLabels(
        in_Action: enum "PVS Shipping Action";
        in_IsBatch: Boolean;
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(this.NotImplementedErr, in_Action));
        exit(false);
    end;

    procedure RetrieveLabels(
        in_Action: enum "PVS Shipping Action";
        var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(this.NotImplementedErr, in_Action));
        exit(false);
    end;

    procedure IsEnabled(): Boolean
    begin
        exit(this.Delivery.IsEnabled());
    end;
}