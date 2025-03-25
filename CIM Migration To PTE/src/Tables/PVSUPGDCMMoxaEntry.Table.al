table 80223 "PVS UPG DCM Moxa Entry"//6010920 "PVS DCM Moxa Entry"
{
    Caption = 'DCM Moxa Entry', Locked = true;
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }
        field(2; "Data String"; Text[250])
        {
            Caption = 'Data String', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(3; "CIM Controller Code"; code[20])
        {
            Caption = 'CIM Controll Code';
            DataClassification = SystemMetadata;
        }
        field(4; "Time Milliseconds"; Integer)
        {
            Caption = 'Time Milliseconds', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(5; "DateTime (Added)"; DateTime)
        {
            Caption = 'DateTime', Locked = true;
            DataClassification = SystemMetadata;
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
