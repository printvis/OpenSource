tableextension 80137 "SIEP Location" extends Location
{
    fields
    {
        field(80135; "SIEP Address Verified"; Boolean)
        {
            Caption = 'Address Verified';
        }
        field(80137; "SIEP Address Id"; Text[100])
        {
            Caption = 'EasyPost Address Id';
            DataClassification = CustomerContent;
        }
    }
}