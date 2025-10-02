pageextension 80154 "SINS Shipping Setup" extends "PVS Shipping Setup"
{
    layout
    {
        addlast(DefaultAddress)
        {
            field("SINS Quick Id"; Rec."SINS Quick Id")
            {
                ApplicationArea = All;
                Caption = 'Quick Id';
            }
        }
    }
}