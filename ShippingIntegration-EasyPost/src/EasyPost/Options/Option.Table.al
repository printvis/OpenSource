namespace PrintVis.OpenSource.EasyPost;

using Microsoft.Foundation.Shipping;

table 80135 "SIEP Option"
{
    Caption = 'EasyPost Options';
    DataClassification = CustomerContent;
    DrillDownPageId = "SIEP Options";
    LookupPageId = "SIEP Options";

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Custom Code,Predefined Package';
            OptionMembers = " ","Custom Code","Predefined Package";
        }
        field(2; "Code"; Code[50])
        {
            Caption = 'Code';
        }
        field(3; "Shipping Agent Code"; Text[50])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent".Code;
        }
        field(4; Description; Text[250])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Code", "Shipping Agent Code")
        {
            Clustered = true;
        }
    }
}