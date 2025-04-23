Table 80227 "PVS UPG Workflow Part MIME Buf"
//Table 6010923 "PVS Workflow Partner MIME Buf."
{
    Caption = 'PV Workflow Partner MIME Buffer';

    fields
    {
        field(1; Type; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Type';
            OptionCaption = 'Header,Body';
            OptionMembers = Header,Body;
        }
        field(2; "Part Acid"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Part Acid';
        }
        field(3; "Part No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Part No';
        }
        field(4; "Closing Part"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Closing Part';
        }
        field(5; "Response Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Response Entry No';
        }
        field(6; "Part Body"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Part Contents';
        }
        field(7; "Base64 Encoded"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Base64 Encoded';
        }
        field(8; "Body Size"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Body Size';
        }
        field(9; "Content Type"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'ContentType';
        }
        field(10; "File Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Filename';
        }
    }

    keys
    {
        key(Key1; Type, "Part Acid", "Part No.", "Response Entry No.")
        {
            Clustered = true;
        }

    }
}