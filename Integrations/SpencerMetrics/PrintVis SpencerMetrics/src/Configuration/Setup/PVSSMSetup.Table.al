table 80293 "PVS SM Setup"
{
    Caption = 'SpencerMetrics Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            Caption = 'Primary Key';
        }
        field(9; "Base URL"; Text[200])
        {
            Caption = 'Base URL';
            InitValue = 'https://clientlogin.spencermetrics.com/api/';
            NotBlank = true;
            ToolTip = 'The base URL for SpencerMetrics API endpoints';
        }
        field(10; "Max Session Duration (min)"; Integer)
        {
            Caption = 'Max Session Duration (min)';
            InitValue = 480;
            MinValue = 0;
            ToolTip = 'Maximum session duration in minutes. 0 means no limit. Default is 8 hours (480 min).';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    internal procedure Initialize()
    begin
        if not Rec.Get() then begin
            Clear(Rec);
            Rec.Insert(true);
        end;
    end;
}