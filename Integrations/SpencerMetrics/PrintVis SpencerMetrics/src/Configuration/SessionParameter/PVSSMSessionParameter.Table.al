namespace PrintVis.SpencerMetrics.Configuration;

table 80292 "PVS SM Session Parameter"
{
    Caption = 'SpencerMetrics Session Parameter';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Session Id"; Integer)
        {
            Caption = 'Session Id';
        }
        field(2; "Setup Code"; Code[20])
        {
            Caption = 'Setup Code';
        }
        field(3; "Session Type"; Text[50])
        {
            Caption = 'Session Type';
        }
        field(4; "Case ID"; Integer)
        {
            Caption = 'Case ID';
        }
        field(5; "Plan ID"; Integer)
        {
            Caption = 'Plan ID';
        }
    }

    keys { key(PK; "Session Id") { Clustered = true; } }
}