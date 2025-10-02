pageextension 80155 "SINS Sender Address List" extends "PVS Sender Address List"
{
    layout
    {
        addlast(Control1)
        {
            field("SINS Quick ID"; Rec."SINS Quick ID")
            {
                ApplicationArea = All;
                Caption = 'Quick ID';
            }
        }
    }
}