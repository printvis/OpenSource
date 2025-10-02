enumextension 80154 "SINS Integration" extends "PVS Shipping Integration"
{
    value(80154; "SINS nShift Ship")
    {
        Caption = 'nShift Ship';
        Implementation = "PVS Shipping Integration" = "SINS Ship Implementation";
    }

    value(80155; "SINS nShift Delivery")
    {
        Caption = 'nShift Delivery';
        Implementation = "PVS Shipping Integration" = "SINS Delivery Implementation";
    }
}