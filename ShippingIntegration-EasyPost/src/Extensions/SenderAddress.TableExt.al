tableextension 80136 "SIEP Sender Address" extends "PVS Sender Address"
{
    fields
    {
        field(80135; "SIEP Address Verified"; Boolean)
        {
            Caption = 'Address Verified';
        }
        field(80136; "SIEP Address Id"; Text[100])
        {
            Caption = 'EasyPost Address Id';
            DataClassification = CustomerContent;
        }
    }
}