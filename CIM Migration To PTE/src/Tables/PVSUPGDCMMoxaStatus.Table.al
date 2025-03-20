table 80224 "PVS UPG DCM Moxa Status"//6010925 "PVS DCM Moxa Status"
{
    Caption = 'DCM Moxa Status', Locked = true;
    ;
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Cost Center Code"; Code[20])
        {
            Caption = 'Cost Center Code';
            DataClassification = SystemMetadata;
        }
        field(10; "Now Time"; Integer)
        {
            Caption = 'Now Time', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(11; Counter; Integer)
        {
            Caption = 'Counter', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(12; Running; Boolean)
        {
            Caption = 'Running', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(13; "Running Speed"; Decimal)
        {
            Caption = 'Running Speed', Locked = true;
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; "Cost Center Code")
        {
            Clustered = true;
        }
    }

}
