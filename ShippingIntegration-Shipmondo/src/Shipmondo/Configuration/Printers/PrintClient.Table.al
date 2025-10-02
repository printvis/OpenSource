table 80185 "SISM Print Client"
{
    Caption = 'Print Client';
    DataClassification = CustomerContent;
    DrillDownPageId = "SISM Print Clients";
    LookupPageId = "SISM Print Clients";

    fields
    {
        field(1; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(2; Hostname; Text[100])
        {
            Caption = 'Hostname';
        }
        field(3; Printer; Text[100])
        {
            Caption = 'Printer';
        }
        field(4; "Label Format"; Text[30])
        {
            Caption = 'Label Format';
        }
        field(5; "Default Printer"; Boolean)
        {
            Caption = 'Default Printer';
        }
        field(6; "Default Document Printer"; Boolean)
        {
            Caption = 'Default Document Printer';
        }
        field(7; "Default Pick Document Printer"; Boolean)
        {
            Caption = 'Default Pick Document Printer';
        }
        field(8; "Staff Account ID"; Integer)
        {
            Caption = 'Staff Account ID';
        }
    }

    keys
    {
        key(PK; Name)
        {
            Clustered = true;
        }
    }
}