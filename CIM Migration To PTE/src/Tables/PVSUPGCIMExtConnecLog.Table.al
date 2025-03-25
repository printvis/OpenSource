table 80231 "PVS UPG CIM Ext Connec Log"
//table 6010924 "PVS CIM External Connector Log"
{
    DataClassification = SystemMetadata;
    Caption = 'PVS CIM External Connector Log';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
            Caption = 'Entry No.';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }
}