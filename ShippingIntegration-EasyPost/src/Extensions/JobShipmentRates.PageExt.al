pageextension 80138 "SIEP Job Shipment Rates" extends "PVS Job Shipment Rates"
{
    layout
    {
        addlast(Rates)
        {
            field("SIEP Delivery Date"; Rec."SIEP Delivery Date")
            {
                ApplicationArea = All;
            }
            field("SIEP Delivery Date Guaranteed"; Rec."SIEP Delivery Date Guaranteed")
            {
                ApplicationArea = All;
            }
            field("SIEP Est. Delivery Days"; Rec."SIEP Est. Delivery Days")
            {
                ApplicationArea = All;
            }
            field("SIEP List Rate"; Rec."SIEP List Rate")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("SIEP Rate Id"; Rec."SIEP Rate Id")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }
}