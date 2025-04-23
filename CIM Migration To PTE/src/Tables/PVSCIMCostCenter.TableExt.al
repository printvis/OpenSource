/* TableExtension 6010910 "PVS CIM Cost Center" extends "PVS Cost Center"
{
    fields
    {
        field(6010050; "PVS CIM Device Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'CIM Device Code'; 
        }
        field(6010060; "PVS Running Ratio Qty."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Running Ratio Quantity';
        }
        field(6010061; "PVS Running Ratio Seconds"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Running Ratio Seconds';
            Description = '600 and 601 comprises a ratio';
        }
        field(6010070; "PVS Esko Press Brand"; Enum "PVS CIM Esko Press Brand")
        {
            DataClassification = CustomerContent;
            Caption = 'Esko Press Brand';
        }
        field(6010071; "PVS Esko Print Process"; Enum "PVS CIM Esko Print Process")
        {
            DataClassification = CustomerContent;
            Caption = 'Esko Print Process';
        }
        field(6010072; "PVS Machine ID"; Text[50])
        {
            DataClassification = SystemMetadata;
            Caption = 'Machine ID';
        }
    }
} */

table 80214 "PVS UPG CIM Cost Center Ext"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(6010050; "PVS CIM Device Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'CIM Device Code';
        }
        field(6010060; "PVS Running Ratio Qty."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Running Ratio Quantity';
        }
        field(6010061; "PVS Running Ratio Seconds"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Running Ratio Seconds';
            Description = '600 and 601 comprises a ratio';
        }
        field(6010070; "PVS Esko Press Brand"; Enum "PVS UPG CIM Esko Press Brand")
        {
            DataClassification = CustomerContent;
            Caption = 'Esko Press Brand';
        }
        field(6010071; "PVS Esko Print Process"; Enum "PVS UPG CIM Esko Print Process")
        {
            DataClassification = CustomerContent;
            Caption = 'Esko Print Process';
        }
        field(6010072; "PVS Machine ID"; Text[50])
        {
            DataClassification = SystemMetadata;
            Caption = 'Machine ID';
        }
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }
}