tableextension 80140 "SIEP Job Shipment Rate" extends "PVS Job Shipment Rate"
{
    fields
    {
        field(80140; "SIEP Rate Id"; Text[100])
        {
            Caption = 'Rate Id';
            DataClassification = CustomerContent;
        }
        field(80141; "SIEP List Rate"; Decimal)
        {
            Caption = 'List Rate';
            DataClassification = CustomerContent;
        }
        field(80142; "SIEP List Currency"; Code[10])
        {
            Caption = 'List Currency';
            DataClassification = CustomerContent;
        }
        field(80143; "SIEP Billing Type"; Text[50])
        {
            Caption = 'Billing Type';
            DataClassification = CustomerContent;
        }
        field(80144; "SIEP Delivery Days"; Integer)
        {
            Caption = 'Delivery Days';
            DataClassification = CustomerContent;
        }
        field(80145; "SIEP Delivery Date"; DateTime)
        {
            Caption = 'Delivery Date';
            DataClassification = CustomerContent;
        }
        field(80146; "SIEP Delivery Date Guaranteed"; Boolean)
        {
            Caption = 'Delivery Date Guaranteed';
            DataClassification = CustomerContent;
        }
        field(80147; "SIEP Est. Delivery Days"; Integer)
        {
            Caption = 'Estimated Delivery Days';
            DataClassification = CustomerContent;
        }
        field(80148; "SIEP Carrier Account Id"; Text[100])
        {
            Caption = 'Carrier Account Id';
            DataClassification = CustomerContent;
        }
    }
}