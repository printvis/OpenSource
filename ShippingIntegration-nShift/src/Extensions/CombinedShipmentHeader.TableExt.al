tableextension 80158 "SINS Combined Shipment Header" extends "PVS Combined Shipment Header"
{
    fields
    {
        field(80155; "SINS Sender Quick ID"; Text[30])
        {
            Caption = 'Quick ID';
            DataClassification = CustomerContent;
        }
        field(80156; "SINS Add. Surcharges Percent"; Decimal)
        {
            BlankZero = true;
            Caption = 'Additional Surcharges Percent';
            DataClassification = CustomerContent;
            DecimalPlaces = 1 : 1;
        }
        field(80157; "SINS Add. Surcharges Amount"; Decimal)
        {
            BlankZero = true;
            Caption = 'Additional Surcharges Amount';
            DataClassification = CustomerContent;
            DecimalPlaces = 1 : 1;
        }
        field(80160; "SINS Shipment Tag"; Text[100])
        {
            Caption = 'Shipment Tag';
            DataClassification = CustomerContent;
        }
    }
}