namespace PrintVis.OpenSource.EasyPost;

using Microsoft.Inventory.Location;
using System.Utilities;

interface "SIEP Integration" extends "PVS Shipping Integration"
{
    procedure VerifyAddress(in_Action: Enum "PVS Shipping Action"; var out_Shipment: Record "PVS Job Shipment"; var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean

    procedure VerifyAddress(in_Action: Enum "PVS Shipping Action"; var out_CombinedShipmentHeader: Record "PVS Combined Shipment Header"; var out_CombinedShipmentLine: Record "PVS Combined Shipment Line"; var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean

    procedure VerifyAddress(in_Action: enum "PVS Shipping Action"; var out_ShippingSetup: Record "PVS Shipping Setup"; var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean

    procedure VerifyAddress(in_Action: enum "PVS Shipping Action"; var out_SenderAddress: Record "PVS Sender Address"; var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean

    procedure VerifyAddress(in_Action: enum "PVS Shipping Action"; var out_Location: Record "Location"; var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean

    procedure BuyShipment(in_Action: Enum "PVS Shipping Action"; var out_Shipment: Record "PVS Job Shipment"; var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean

    procedure BuyShipment(in_Action: Enum "PVS Shipping Action"; var out_CombinedShipment: Record "PVS Combined Shipment Header"; var out_CombinedShipmentLine: Record "PVS Combined Shipment Line"; var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
}