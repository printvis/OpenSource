tableextension 80138 "SIEP Job Shipment Label" extends "PVS Job Shipment Label"
{
    fields
    {
        field(80134; "SIEP Shipment ID"; Text[100])
        {
            Caption = 'EasyPost Shipment ID';
        }
        field(80135; "SIEP Shipment Reference"; Text[100])
        {
            Caption = 'EasyPost Shipment Reference';
        }
    }
}