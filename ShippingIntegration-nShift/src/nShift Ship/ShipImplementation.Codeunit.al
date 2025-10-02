namespace PrintVis.OpenSource.NShift.Ship;

using System.Utilities;
using PrintVis.OpenSource.NShift.Ship.Setup;

codeunit 80158 "SINS Ship Implementation" implements "PVS Shipping Integration"
{
    var
        Ship: Codeunit "SINS Ship Shpt. Mgt.";
        NotImplementedErr: Label 'This action %1 is not implemented for nShift Ship.';

    procedure CreateShipment(
        in_Action: Enum "PVS Shipping Action";
        in_IsBatch: Boolean;
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    begin
        exit(this.Ship.CreateShipment(in_Action, in_IsBatch, out_Shipment, out_ErrorMessageMgt));
    end;

    procedure CreateShipment(
        in_Action: enum "PVS Shipping Action";
        var out_CombinedShipmentHeader: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        exit(this.Ship.CreateShipment(in_Action, false, out_CombinedShipmentHeader, out_CombinedShipmentLine, out_ErrorMessageMgt));
    end;

    procedure CancelShipment(
        in_Action: Enum "PVS Shipping Action";
        in_IsBatch: Boolean;
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    begin
        exit(this.Ship.CancelShipment(in_Action, in_IsBatch, out_Shipment, out_ErrorMessageMgt));
    end;

    procedure CancelShipment(
        in_Action: enum "PVS Shipping Action";
        var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        exit(this.Ship.CancelShipment(in_Action, false, out_CombinedShipment, out_CombinedShipmentLine, out_ErrorMessageMgt));
    end;

    procedure RetrieveShipmentStatus(
        in_Action: Enum "PVS Shipping Action";
        in_IsBatch: Boolean;
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    begin
        exit(this.Ship.RetrieveShipmentStatus(out_Shipment));
    end;

    procedure RetrieveShipmentStatus(
        in_Action: enum "PVS Shipping Action";
        var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        exit(this.Ship.RetrieveShipmentStatus(out_CombinedShipment));
    end;

    procedure FetchShippingRates(
        in_Action: enum "PVS Shipping Action";
        in_IsBatch: Boolean;
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        exit(this.Ship.FetchShippingRates(in_Action, in_IsBatch, out_Shipment, out_ErrorMessageMgt));
    end;

    procedure FetchShippingRates(
        in_Action: enum "PVS Shipping Action";
        var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        exit(this.Ship.FetchShippingRates(in_Action, false, out_CombinedShipment, out_ErrorMessageMgt));
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
    var
        Setup: Record "SINS Ship Setup";
    begin
        exit(Setup.IsEnabled());
    end;
}