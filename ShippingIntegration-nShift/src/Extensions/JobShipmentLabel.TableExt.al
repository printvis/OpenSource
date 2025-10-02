tableextension 80159 "SINS Job Shipment Label" extends "PVS Job Shipment Label"
{
    fields
    {
        field(80154; "SINS Package Tag"; Text[100])
        {
            Caption = 'Package Tag';
            DataClassification = CustomerContent;
        }
    }
}