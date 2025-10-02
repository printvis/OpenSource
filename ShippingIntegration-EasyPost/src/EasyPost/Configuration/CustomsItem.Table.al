table 80136 "SIEP Customs Item"
{
    Caption = 'Customs Item';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Source Record ID"; RecordId)
        {
            Caption = 'Source Record ID';
        }
        // field(2; "Line No."; Integer)
        // {
        //     Caption = 'Line No.';
        //     AutoIncrement = true;
        // }
        // field(3; id; Text[100])
        // {
        //     Caption = 'Customs Item Id';
        // }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            NotBlank = true;
        }
        field(5; "Tariff Number"; Text[100])
        {
            Caption = 'Tariff Number';
        }
        field(6; "Origin Country"; Code[10])
        {
            Caption = 'Origin Country';
            TableRelation = "Country/Region";
        }
        field(7; Quantity; Decimal)
        {
            BlankZero = true;
            Caption = 'Quantity';
            DecimalPlaces = 1 : 1;
        }
        field(8; Value; Decimal)
        {
            BlankZero = true;
            Caption = 'Value';
            DecimalPlaces = 1 : 1;
        }
        field(9; Weight; Decimal)
        {
            BlankZero = true;
            Caption = 'Weight';
            DecimalPlaces = 1 : 1;
        }
    }

    keys
    {
        key(Key1; "Source Record ID", Description)
        {
            Clustered = true;
        }
    }
}