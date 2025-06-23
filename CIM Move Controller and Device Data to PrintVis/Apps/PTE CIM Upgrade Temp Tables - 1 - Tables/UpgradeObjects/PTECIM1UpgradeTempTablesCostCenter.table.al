Table 80265 "PTE CIM 1 Upg. TT. Cost Center"
{
    Caption = 'Cost Center';
    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
            NotBlank = true;
        }
        field(6010050; "PVS CIM Device Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'CIM Device Code';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }
}

