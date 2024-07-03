PageExtension 80105 "PTE SOI SOint Coordinator RC" extends "PVS Coordinator Role Center"
{
    actions
    {
        addlast(PrintVis)
        {
            action("PTE_PVS_PurchaseReceiptList")
            {
                ApplicationArea = All;
                Caption = 'Purchase Receipt List';
                RunObject = Page "PTE SOI Wareh. P. Rcpt L";
                ToolTip = 'Purchase Receipt List';
            }
        }
    }
}