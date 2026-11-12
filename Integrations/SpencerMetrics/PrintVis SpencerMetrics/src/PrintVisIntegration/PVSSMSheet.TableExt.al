namespace PrintVis.SpencerMetrics.Integration;

tableextension 80290 "PVS SM Sheet" extends "PVS Job Sheet"
{
    fields
    {
        field(80290; "PVS SM Key"; Text[30])
        {
            Caption = 'SpencerMetrics Key';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key("PVS SM Key"; "PVS SM Key") { }
    }

    trigger OnBeforeInsert()
    begin
        this.GenerateSpencerMetricsKey(Rec);
    end;

    trigger OnBeforeModify()
    begin
        this.GenerateSpencerMetricsKey(Rec);
    end;

    local procedure GenerateSpencerMetricsKey(var in_JobSheet: Record "PVS Job Sheet")
    begin
        in_JobSheet.CalcFields("Order No.");
        in_JobSheet."PVS SM Key" := Format(in_JobSheet."Order No.") + '_Se.' + Format(in_JobSheet."Sheet No.");
    end;
}
