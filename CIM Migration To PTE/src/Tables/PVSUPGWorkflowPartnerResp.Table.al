Table 80229 "PVS UPG Workflow Partner Resp"
//Table 6010921 "PVS Workflow Partner Resp. At."
{
    Caption = 'Workflow Partner Response Attachments';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "JMF Response Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'JMF Response Entry No.';
        }
        field(3; "DateTime Received"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'DateTime Recieved';
        }
        field(4; "File BLOB"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'File BLOB';
        }
        field(5; "File Name"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Filename';
        }
        field(6; ContentID; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'ContentID';
        }
        field(7; ContentType; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'ContentType';
        }
        field(8; "File Size"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'File Size';
            Editable = false;
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

