interface "SISM Integration" extends "PVS Shipping Integration"
{
    procedure GetPickupPoints(
        in_CarrierCode: Code[20];
        in_CountryCode: Code[10];
        in_PostCode: Code[20];
        in_Address: Text;
        var out_ServicePoints: Record "SISM Pickup Point";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean

    procedure GetPrinters(): Boolean

    procedure PrintJob(
        in_Action: enum "PVS Shipping Action";
        in_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
}
