pageextension 80156 "SINS Location Card" extends "Location Card"
{
    layout
    {
        addfirst(AddressDetails)
        {
            field("SINS Quick ID"; Rec."SINS Quick ID")
            {
                ApplicationArea = All;
                Caption = 'Quick ID';
            }
        }
    }
}