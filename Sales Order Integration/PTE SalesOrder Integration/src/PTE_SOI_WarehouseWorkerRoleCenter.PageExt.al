pageextension 80131 "PTE SOI WarehouseWorker RC" extends "PVS WarehouseWorker RC"
{
    actions
    {
        addlast(embedding)
        {
            action("PTE SOI_PurchaseList")
            {
                ApplicationArea = All;
                Caption = 'Purchase Receipt List';
                RunObject = Page "PTE SOI Wareh. P. Rcpt L";
                ToolTip = 'Purchase Receipt List';
            }
            action("PTE SOI_ReceiptsList")
            {
                ApplicationArea = All;
                Caption = 'Receipt Overview';
                RunObject = Page "PVS Whse. Receipts List";
                ToolTip = 'Receipt Overview';
            }
        }
        addfirst(PrintVis)
        {
            action("PTE PurchaseReceiptList")
            {
                ApplicationArea = All;
                Caption = 'Purchase Receipt List';
                RunObject = Page "PTE SOI Wareh. P. Rcpt L";
                ToolTip = 'Purchase Receipt List';
            }
            action("PTE ReceiptOverview")
            {
                ApplicationArea = All;
                Caption = 'Receipt Overview';
                RunObject = Page "PVS Whse. Receipts List";
                ToolTip = 'Receipt Overview';
            }

        }
    }
}
