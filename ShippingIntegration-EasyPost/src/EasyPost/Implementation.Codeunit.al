namespace PrintVis.OpenSource.EasyPost;

using System.Utilities;
using Microsoft.Inventory.Location;

codeunit 80134 "SIEP Implementation" implements "PVS Shipping Integration", "SIEP Integration"
{
    var
        EasyPost: codeunit "SIEP Mgt.";
        NotImplementedErr: Label 'This action %1 is not implemented for EasyPost', Comment = '%1 = Shipping Action';

    procedure VerifyAddress(
        in_Action: enum "PVS Shipping Action";
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        exit(this.EasyPost.VerifyAddress(in_Action, out_Shipment, out_ErrorMessageMgt));
    end;

    procedure VerifyAddress(
        in_Action: enum "PVS Shipping Action";
        var out_CombinedShipmentHeader: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLines: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(this.NotImplementedErr, in_Action));
        exit(false);
    end;

    procedure VerifyAddress(
        in_Action: enum "PVS Shipping Action";
        var out_ShippingSetup: Record "PVS Shipping Setup";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        exit(this.EasyPost.VerifyAddress(in_Action, out_ShippingSetup, out_ErrorMessageMgt));
    end;

    procedure VerifyAddress(
        in_Action: enum "PVS Shipping Action";
        var out_SenderAddress: Record "PVS Sender Address";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        exit(this.EasyPost.VerifyAddress(in_Action, out_SenderAddress, out_ErrorMessageMgt));
    end;

    procedure VerifyAddress(
        in_Action: enum "PVS Shipping Action";
        var out_Location: Record "Location";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        exit(this.EasyPost.VerifyAddress(in_Action, out_Location, out_ErrorMessageMgt));
    end;

    procedure CreateShipment(
        in_Action: enum "PVS Shipping Action";
        in_IsBatch: Boolean;
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        exit(this.EasyPost.CreateOrder(in_Action, out_Shipment, out_ErrorMessageMgt));
    end;

    procedure CreateShipment(
        in_Action: enum "PVS Shipping Action";
        var out_CombinedShipmentHeader: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLines: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(this.NotImplementedErr, in_Action));
        exit(false);
    end;

    procedure CancelShipment(
        in_Action: enum "PVS Shipping Action";
        in_IsBatch: Boolean;
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        exit(this.EasyPost.RefundShipment(in_Action, out_Shipment, out_ErrorMessageMgt));
    end;

    procedure CancelShipment(
        in_Action: enum "PVS Shipping Action";
        var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLines: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(this.NotImplementedErr, in_Action));
        exit(false);
    end;

    procedure BuyShipment(
        in_Action: enum "PVS Shipping Action";
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        exit(this.EasyPost.BuyOrder(in_Action, out_Shipment, out_ErrorMessageMgt));
    end;

    procedure BuyShipment(
        in_Action: enum "PVS Shipping Action";
        var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLines: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(this.NotImplementedErr, in_Action));
        exit(false);
    end;

    procedure RetrieveShipmentStatus(
        in_Action: enum "PVS Shipping Action";
        in_IsBatch: Boolean;
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        exit(this.EasyPost.RetrieveShipmentStatus(in_Action, out_Shipment, out_ErrorMessageMgt));
    end;

    procedure RetrieveShipmentStatus(
        in_Action: enum "PVS Shipping Action";
        var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLines: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(this.NotImplementedErr, in_Action));
        exit(false);
    end;

    procedure FetchShippingRates(
        in_Action: enum "PVS Shipping Action";
        in_IsBatch: Boolean;
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(this.NotImplementedErr, in_Action));
        exit(false);
    end;

    procedure FetchShippingRates(
        in_Action: enum "PVS Shipping Action";
        var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLines: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(this.NotImplementedErr, in_Action));
        exit(false);
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
        var out_CombinedShipmentLines: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    begin
        out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(this.NotImplementedErr, in_Action));
        exit(false);
    end;

    procedure IsEnabled(): Boolean
    begin
        exit(this.EasyPost.IsEnabled());
    end;
}