Table 80202 "PVS Sync Field Setup"
{
    Caption = 'Sync Field Setup';

    fields
    {
        field(1; "Table No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Table No.';
        }
        field(2; "Field No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Field No.';
        }
        field(10; "Sync Mode"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Sync Mode';
            OptionCaption = 'Force Sync,Always Skip,Skip if not Empty';
            OptionMembers = ForceSync,AlwaysSkip,SkipIfNotEmpty;
        }
        field(11; "Validate Field"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Validate Field';
            OptionCaption = 'No,Yes';
            OptionMembers = No,Yes;
        }
        field(12; "Convert to Local Currency"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Convert to Local Currency';
        }
    }

    keys
    {
        key(Key1; "Table No.", "Field No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

