Table 80213 "PVS UPG CIM Controller URL Map"
//Table 6010914 "PVS CIM Controller URL Mapping"
{
    Caption = 'CIM Controller URL Mapping';

    fields
    {
        field(1; "Device Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Device Code';
        }
        field(2; "Order Type"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Order Type';
        }
        field(3; "Product Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Product Group';
        }
        field(4; "Customer Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Group';
        }
        field(5; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer No.';
        }
        field(6; "Finished Goods Item Group Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Finished Good Item Group Code';
        }
        field(7; "Finished Goods Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Finished Good Item No.';
        }
        field(30; "CIM Controller URL Code"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'CIM Controller URL Code';
        }
    }

    keys
    {
        key(Key1; "Device Code", "Order Type", "Product Group", "Customer Group", "Customer No.", "Finished Goods Item Group Code", "Finished Goods Item No.")
        {
            Clustered = true;
        }
    }
}

