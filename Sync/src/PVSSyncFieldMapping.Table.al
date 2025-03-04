Table 80203 "PVS Sync Field Mapping"
{
    Caption = 'Sync Field Mapping';

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
            TableRelation = Field."No." where(TableNo = field("Table No."));
        }
        field(3; "Business Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Business Group';
            TableRelation = "PVS Business Group";
        }
        field(4; "From Code"; Code[250])
        {
            DataClassification = CustomerContent;
            Caption = 'From Code';
        }
        field(10; "To Code"; Code[250])
        {
            DataClassification = CustomerContent;
            Caption = 'To Code';
        }
        field(100; "Field Name"; Text[250])
        {
            CalcFormula = lookup(Field.FieldName where(TableNo = field("Table No."),
                                                        "No." = field("Field No.")));
            Caption = 'Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Table No.", "Field No.", "Business Group", "From Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

