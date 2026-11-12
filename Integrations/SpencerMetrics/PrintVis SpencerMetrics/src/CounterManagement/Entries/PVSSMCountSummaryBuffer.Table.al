namespace PrintVis.SpencerMetrics.CounterManagement;

table 80295 "PVS SM Count Summary Buffer"
{
    Caption = 'SpencerMetrics Count Summary Buffer';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; UOM; Code[20])
        {
            Caption = 'UOM';
            ToolTip = 'The Unit of Measure for the Count entry.';
        }
        field(2; "Total Difference Count"; Integer)
        {
            Caption = 'Counts';
            ToolTip = 'The total difference count for the Count entry.';
        }
        field(3; "Cost Center Code"; Code[20])
        {
            Caption = 'Cost Center Code';
            ToolTip = 'The Cost Center Code for the Count entry.';
        }
        field(4; "Case ID"; Integer)
        {
            Caption = 'Case ID';
            ToolTip = 'The Case ID for the Count entry.';
        }
        field(5; "Plan ID"; Integer)
        {
            Caption = 'Plan ID';
            ToolTip = 'The Plan ID for the Count entry.';
        }
    }
    keys
    {
        key(PK; "UOM", "Case ID", "Plan ID") { Clustered = true; }
    }
}