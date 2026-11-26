namespace PrintVis.BoldSign.Extensions;

pageextension 80301 "PVS BS Report Selection Setup" extends "PVS Report Selection Setup"
{
    layout
    {
        addafter("Use for Email Body")
        {
            field("PVS BS Use for BoldSign Sign."; Rec."PVS BS Use for BoldSign Sign.")
            {
                ApplicationArea = All;
            }
            field("PVS BS Sent Doc. Workflow"; Rec."PVS BS Sent Doc. Workflow")
            {
                ApplicationArea = All;
            }
            field("PVS BS Signed Workflow"; Rec."PVS BS Signed Doc. Workflow")
            {
                ApplicationArea = All;
            }
            field("PVS BS Declined Doc. Workflow"; Rec."PVS BS Declined Doc. Workflow")
            {
                ApplicationArea = All;
            }
            field("PVS BS Expired Document Workflow"; Rec."PVS BS Expired Doc. Workflow")
            {
                ApplicationArea = All;
            }
            field("PVS BS Add Decline Button"; Rec."PVS BS Add Decline Button")
            {
                ApplicationArea = All;
            }
            field("PVS BS Allow Delegate"; Rec."PVS BS Allow Delegate")
            {
                ApplicationArea = All;
            }
            field("PVS BS Sign. On Last Page"; Rec."PVS BS Sign. On Last Page")
            {
                ApplicationArea = All;
            }
            field("PVS BS Sign. Page No."; Rec."PVS BS Sign. Page No.")
            {
                ApplicationArea = All;
            }
            field("PVS BS Sign. X"; Rec."PVS BS Sign. X")
            {
                ApplicationArea = All;
            }
            field("PVS BS Sign. Y"; Rec."PVS BS Sign. Y")
            {
                ApplicationArea = All;
            }
            field("PVS BS Sign. Width"; Rec."PVS BS Sign. Width")
            {
                ApplicationArea = All;
            }
            field("PVS BS Sign. Height"; Rec."PVS BS Sign. Height")
            {
                ApplicationArea = All;
            }
        }
    }
}