pageextension 80107 "PTE SOI Estimator RC" extends "PVS Estimator Role Center"
{
    actions
    {
        addlast(PrintVis)
        {
            action("PTE SOI_PurchaseReceiptList")
            {
                ApplicationArea = All;
                Caption = 'Purchase Receipt List';
                RunObject = Page "PTE SOI Wareh. P. Rcpt L";
                ToolTip = 'Purchase Receipt List';
            }
        }
    }
}