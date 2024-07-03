pageextension 80103 "PTE SOI SOint Accounting Act" extends "PVS Accounting Activities"
{

    layout
    {
        addlast(Cases)
        {
            field("PTE PurchaseApproval"; Rec."PTE User ID Purchase Approval")
            {
                ApplicationArea = All;
                Caption = 'Purchase Approval';
                DrillDownPageID = "Purchase List";
                Image = Checklist;
                ToolTip = 'Specifies the number of pending purchase approvals that are assigned to you.';
            }
        }
    }
}