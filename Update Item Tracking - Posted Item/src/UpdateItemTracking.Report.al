report 80110 "Update Item Tracking"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Update Item Tracking - Posted Item';
    Permissions = tabledata Item = RM,
                  tabledata "Item Ledger Entry" = RM,
                  tabledata "Warehouse Entry" = RM;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.";
            trigger OnAfterGetRecord()
            begin
                if ItemNumber = 1 then
                    Error(ErrorItemQuantityLbl)
                else begin
                    // Checking
                    Item.TestField("Item Tracking Code", '');
                    ItemLedgerEntry.SetRange("Item No.", Item."No.");
                    ItemLedgerEntry.SetFilter("Lot No.", '<>%1', '');
                    if not ItemLedgerEntry.IsEmpty then begin
                        ItemLedgerEntry.FindFirst();
                        ItemLedgerEntry.TestField("Lot No.", '');
                    end;
                    ItemLedgerEntry.SetRange("Lot No.");
                    if ItemLedgerEntry.FindSet() then
                        repeat
                            if ItemLedgerEntry."Invoiced Quantity" <> ItemLedgerEntry.Quantity then
                                ItemLedgerEntry.TestField(ItemLedgerEntry."Invoiced Quantity", ItemLedgerEntry.Quantity);
                        until ItemLedgerEntry.Next() = 0;

                    ItemJournalLine.SetRange("Item No.", Item."No.");
                    if not ItemJournalLine.IsEmpty then
                        ItemJournalLine.TestField("Item No.", '');

                    PVSJobCostingJournalLine.SetRange("Item No.", Item."No.");
                    if not PVSJobCostingJournalLine.IsEmpty then
                        PVSJobCostingJournalLine.TestField("Item No.", '');

                    TransferLines.SetRange("Item No.", Item."No.");
                    if not TransferLines.IsEmpty then
                        TransferLines.TestField("Item No.", '');

                    // Update data
                    if ItemLedgerEntry.FindSet() then
                        repeat
                            ItemLedgerEntry."Lot No." := OldEntriesLotNo;
                            ItemLedgerEntry.Modify(false);
                        until ItemLedgerEntry.Next() = 0;

                    WarehouseEntry.SetRange("Item No.", Item."No.");
                    if not WarehouseEntry.IsEmpty then
                        WarehouseEntry.ModifyAll("Lot No.", OldEntriesLotNo);

                    Item."Item Tracking Code" := NewItemTrackingCode;
                    Item.Modify(false);
                    Commit();
                end;
                ItemNumber := ItemNumber + 1;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(NewItemTrackingCode; NewItemTrackingCode)
                    {
                        Caption = 'New Item Tracking Code';
                        ApplicationArea = All;
                        TableRelation = "Item Tracking Code".Code;
                        ToolTip = 'New Item Tracking Code';
                        ShowMandatory = true;
                    }
                    field(OldEntriesLotNo; OldEntriesLotNo)
                    {
                        Caption = 'Old Entries Lot No.';
                        ApplicationArea = All;
                        ToolTip = 'Lot No. for all old Item entries';
                        ShowMandatory = true;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        ItemLedgerEntry.SetCurrentKey("Item No.", "Posting Date");
        WarehouseEntry.SetCurrentKey("Item No.", "Bin Code", "Location Code", "Variant Code", "Unit of Measure Code", "Lot No.", "Serial No.", "Entry Type", Dedicated, "Package No.", "Bin Type Code", "SIFT Bucket No.");
        ItemNumber := 0;
        if NewItemTrackingCode = '' then
            Error(ErrorNewItemTrackingEmptyLbl);
        if OldEntriesLotNo = '' then
            Error(ErrorLotNoEmptyLbl);
    end;

    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        WarehouseEntry: Record "Warehouse Entry";
        TransferLines: Record "Transfer Line";
        ItemJournalLine: Record "Item Journal Line";
        PVSJobCostingJournalLine: Record "PVS Job Costing Journal Line";
        NewItemTrackingCode: Code[10];
        OldEntriesLotNo: Code[50];
        ItemNumber: Integer;
        ErrorItemQuantityLbl: Label 'You can update only one Item.';
        ErrorNewItemTrackingEmptyLbl: Label 'New Item Tracking Code can not be empty.';
        ErrorLotNoEmptyLbl: Label 'Old Entries Lot No. can not be empty.';
}