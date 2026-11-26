namespace PrintVis.BoldSign.Extensions;

pageextension 80302 "PVS BS Folder Setup" extends "PVS Folder Setup"
{
    layout
    {
        addlast(Control1160230000)
        {
            field("PVS BS Sent Documents"; Rec."PVS BS Sent Documents")
            {
                ApplicationArea = All;
            }
            field("PVS BS Signed Documents"; Rec."PVS BS Signed Documents")
            {
                ApplicationArea = All;
            }
            field("PVS BS Declined Documents"; Rec."PVS BS Declined Documents")
            {
                ApplicationArea = All;
            }
        }
    }
}