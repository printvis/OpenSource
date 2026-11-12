namespace PrintVis.SpencerMetrics.Configuration;

table 80291 "PVS SM Session Log"
{
    Caption = 'SpencerMetrics Session Log';
    DataClassification = CustomerContent;
    DrillDownPageId = "PVS SM Session Log";
    LookupPageId = "PVS SM Session Log";
    Access = Internal;

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            ToolTip = 'Entry No. for SpencerMetrics Session Log';
            Editable = false;
        }
        field(2; "Cost Center"; Code[20])
        {
            Caption = 'Cost Center';
            ToolTip = 'Cost Center for SpencerMetrics Session Log';
            NotBlank = true;
            TableRelation = "PVS Cost Center".Code;
        }
        field(4; "Event Type"; Enum "PVS SM Session Event Type")
        {
            Caption = 'Event Type';
            ToolTip = 'Event Type for SpencerMetrics Session Log';
        }
        field(5; "Event DateTime"; DateTime)
        {
            Caption = 'Event DateTime';
            ToolTip = 'Event DateTime for SpencerMetrics Session Log';
        }
        field(6; "User ID"; Code[50])
        {
            Caption = 'User ID';
            ToolTip = 'User ID for SpencerMetrics Session Log';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(7; "Error Message"; Text[2048])
        {
            Caption = 'Error Message';
            ToolTip = 'Error Message for SpencerMetrics Session Log';
        }
        field(8; Success; Boolean)
        {
            Caption = 'Success';
            ToolTip = 'Success for SpencerMetrics Session Log';
            InitValue = true;
        }
        field(9; "Expected End DateTime"; DateTime)
        {
            Caption = 'Expected End DateTime';
            ToolTip = 'Expected End DateTime for SpencerMetrics Session Log';
        }
        field(10; "Job Queue Entry ID"; Guid)
        {
            Caption = 'Job Queue Entry ID';
            ToolTip = 'Job Queue Entry ID for SpencerMetrics Session Log';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
