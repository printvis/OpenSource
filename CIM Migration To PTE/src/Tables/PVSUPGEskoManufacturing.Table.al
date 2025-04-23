Table 80225 "PVS UPG Esko Manufacturing"
//6010109 "PVS Esko Manufacturing"
{
    Caption = 'Esko Manufacturing';

    fields
    {
        field(1; "Mfg. Sheet No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Manufacturing No.';
        }
        field(2; "Mfg. File Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Mfg File Path';
        }
        field(3; "Mfg. File Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Mfg File Name';
        }
        field(10; Description; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(20; "Imposition Picture"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Imposition Picture';
        }
        field(21; "Sheet Width"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Sheet Width';
            DecimalPlaces = 6 : 6;
        }
        field(22; "Sheet Length"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Sheet Length';
            DecimalPlaces = 6 : 6;
        }
        field(23; "Artios Board Code"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Artios Board Code';
        }
        field(24; "Artios Printing Press"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Artios Printing Press';
        }
        field(25; "Artios Die Press"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Artios Die Press';
        }
        field(26; "Grain Direction"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Grain Direction';
            OptionCaption = 'Vertical,Horizontal';
            OptionMembers = Vertical,Horizontal;
        }

        field(40; "Paper Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Paper Item No.';
        }
        field(41; "Plate Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Plate Item No.';
        }
        field(50; "Plate Width"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Plate Width';
        }
        field(51; "Plate Length"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Plate Length';
        }
    }

    keys
    {
        key(Key1; "Mfg. Sheet No.")
        {
            Clustered = true;
        }
    }

}

