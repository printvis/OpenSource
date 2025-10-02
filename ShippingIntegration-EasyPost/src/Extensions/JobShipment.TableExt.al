tableextension 80135 "SIEP Job Shipment" extends "PVS Job Shipment"
{
    fields
    {
        field(80135; "SIEP Sender Address Id"; Text[100])
        {
            Caption = 'EasyPost Sender Address Id';
            DataClassification = CustomerContent;
        }
        field(80136; "SIEP Ship-to Address Id"; Text[100])
        {
            Caption = 'EasyPost Address Id';
            DataClassification = CustomerContent;
        }
        field(80137; "SIEP Ship-to Address Verified"; Boolean)
        {
            Caption = 'EasyPost Address Verified';
            DataClassification = CustomerContent;
        }
        field(80138; "SIEP Predefined Package"; Text[50])
        {
            Caption = 'Predefined Package';
            DataClassification = CustomerContent;
        }
        field(80139; "SIEP Rate Id"; Text[100])
        {
            Caption = 'Rate Id';
            DataClassification = SystemMetadata;
        }
        field(80140; "SIEP Customs Certify"; Boolean)
        {
            Caption = 'Customs Certify';
            DataClassification = CustomerContent;
        }
        field(80141; "SIEP Customs Signer"; Text[100])
        {
            Caption = 'Customs Signer';
            DataClassification = CustomerContent;
        }
        field(80142; "SIEP Non Delivery Option"; Option)
        {
            Caption = 'Non Delivery Option';
            DataClassification = CustomerContent;
            OptionCaption = 'Return,Abandon';
            OptionMembers = return,abandon;
        }
        field(80143; "SIEP Contents Explanation"; Text[255])
        {
            Caption = 'Contents Explanation';
            DataClassification = CustomerContent;
        }
        field(80144; "SIEP Restriction Type"; Enum "SIEP Restriction Type")
        {
            Caption = 'Restriction Type';
            DataClassification = CustomerContent;
        }
        field(80145; "SIEP Restriction Comments"; Text[100])
        {
            Caption = 'Restriction Comments';
            DataClassification = CustomerContent;
        }
    }
}