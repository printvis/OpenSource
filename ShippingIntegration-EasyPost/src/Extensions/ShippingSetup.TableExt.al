tableextension 80134 "SIEP Shipping Setup" extends "PVS Shipping Setup"
{
    fields
    {
        field(80134; "SIEP Address Id"; Text[100])
        {
            Caption = 'Address Id';
        }
        field(80135; "SIEP Address Verified"; Boolean)
        {
            Caption = 'Address Verified';
        }
    }
}