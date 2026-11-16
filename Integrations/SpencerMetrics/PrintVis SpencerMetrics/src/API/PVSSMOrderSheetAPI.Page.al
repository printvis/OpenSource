namespace PrintVis.SpencerMetrics.API;

page 80290 "PVS SM Order Sheet API"
{
    APIGroup = 'spencerMetrics';
    APIPublisher = 'printvis';
    APIVersion = 'v1.0';
    Editable = false;
    EntityName = 'orderSheet';
    EntitySetName = 'orderSheets';
    ODataKeyFields = "PVS SM Key";
    PageType = API;
    SourceTable = "PVS Job Sheet";

    layout
    {
        area(content)
        {
            field(smKey; Rec."PVS SM Key") { Caption = 'smKey', Locked = true; }
            field(active; Rec.Active) { Caption = 'active', Locked = true; }
            field(jobStatus; Rec."Job Status") { Caption = 'jobStatus', Locked = true; }
            field(orderNo; Rec."Order No.") { Caption = 'orderNo', Locked = true; }
            field(sheetNo; Rec."Sheet No.") { Caption = 'sheetNo', Locked = true; }
            field(paperItemNo; Rec."Paper Item No.") { Caption = 'paperItemNo', Locked = true; }
            field(paperWeight; Rec.Weight) { Caption = 'paperWeight', Locked = true; }
            field(paperWeightUnit; Rec."Weight Unit") { Caption = 'paperWeightUnit', Locked = true; }
            field(paperQuality; Rec."Paper Quality") { Caption = 'paperQuality', Locked = true; }
            field(sizeWidth; Rec."Full Sheet Format 1") { Caption = 'sizeWidth', Locked = true; }
            field(sizeLength; Rec."Full Sheet Format 2") { Caption = 'sizeLength', Locked = true; }
            field(grossQty; Rec."Gross Printed Sheets") { Caption = 'grossPrintedSheets', Locked = true; }
            field(netQty; Rec."End Qty.") { Caption = 'netPrintedSheets', Locked = true; }
        }
    }
}