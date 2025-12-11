#if not CLEAN27
PageExtension 80101 "PTE SOI SOint Bookkeeper RC" extends "PVS Bookkeeper Role Center"
{
    actions
    {
        addlast("PVS PVSPrintVis")
        {
            action("PTE SOIPurchaseReceiptList")
            {
                ApplicationArea = All;
                Caption = 'Purchase Receipt List';
                RunObject = Page "PTE SOI Wareh. P. Rcpt L";
            }
        }
    }
}
#endif