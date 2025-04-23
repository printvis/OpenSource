Table 80218 "PVS UPG Cust JDF Intent Files"
//Table 6010911 "PVS Customer JDF Intent Files"
{
    Caption = 'Customer JDF Intent Files';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
        }
        field(10; Status; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
            OptionCaption = 'New,Processed,Error';
            OptionMembers = New,Processed,Error;
        }
        field(11; "Error Message"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Error Message';
        }
        field(12; "Processing Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Time of Process';
        }
        field(19; "File Size"; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'File Size';
        }
        field(20; ID; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'ID';
        }
        field(21; "File BLOB"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'File BLOB';
        }
        field(22; "File Name"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Filename';
        }
        field(23; "File Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'File date';
        }
        field(24; "File Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'File time';
        }
        field(25; "Creation Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date of creation';
        }
        field(26; "Creation Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Time of creation';
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