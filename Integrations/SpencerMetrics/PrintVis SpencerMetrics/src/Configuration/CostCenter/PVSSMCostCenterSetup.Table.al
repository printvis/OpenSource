namespace PrintVis.SpencerMetrics.Configuration;

table 80290 "PVS SM Cost Center Setup"
{
    Caption = 'SpencerMetrics Cost Center Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Cost Center"; Code[20])
        {
            Caption = 'Cost Center';
            NotBlank = true;
            TableRelation = "PVS Cost Center".Code;
            ToolTip = 'The Cost Center code for SpencerMetrics connection';
        }
        field(2; "API Key"; Text[50])
        {
            Caption = 'API Key';
            ExtendedDatatype = Masked;
            ToolTip = 'The SpencerMetrics API Key for this cost center';
        }
        field(3; Enabled; Boolean)
        {
            Caption = 'Enabled';
            Editable = false;
            InitValue = false;
            ToolTip = 'Set SpencerMetrics Timer On';
        }
        field(4; "Interval (ms)"; Integer)
        {
            Caption = 'Interval (ms)';
            InitValue = 15000;
            MinValue = 5000;
            ToolTip = 'The interval for the timer to check SpencerMetrics for new counts. It is not recommended to set this less than 15000 (15 seconds)';
        }
        field(5; "Session Id"; Integer)
        {
            Caption = 'Session Id';
            ToolTip = 'The session ID that is running the SpencerMetrics timer';
        }
        field(6; "Login Key"; Text[100])
        {
            Caption = 'Login Key';
            ExtendedDatatype = Masked;
        }
        field(7; "Last Heartbeat"; DateTime)
        {
            Caption = 'Last Heartbeat';
            ToolTip = 'The last heartbeat for the session running the SpencerMetrics timer';
        }
        field(8; "Last Error"; Text[2048])
        {
            Caption = 'Last Error';
            ToolTip = 'The last error for the session running the SpencerMetrics timer';
        }
        field(9; "Job Queue Entry ID"; Guid)
        {
            Caption = 'Job Queue Entry ID';
            ToolTip = 'The Job Queue Entry ID for the session running the SpencerMetrics timer';
        }
    }

    keys { key(Key1; "Cost Center") { Clustered = true; } }

    internal procedure SetLastHeartbeat()
    begin
        "Last Heartbeat" := CurrentDateTime();
    end;
}