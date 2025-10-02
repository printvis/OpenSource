tableextension 80184 "SISM Shipping Agent Services" extends "Shipping Agent Services"
{
    fields
    {
        field(80184; "SISM Required Services"; Text[500])
        {
            Caption = 'Required Services';
            DataClassification = CustomerContent;
        }
        field(80185; "SISM Req. Service Point"; Boolean)
        {
            Caption = 'Required Service Point';
            DataClassification = CustomerContent;
        }
    }
}