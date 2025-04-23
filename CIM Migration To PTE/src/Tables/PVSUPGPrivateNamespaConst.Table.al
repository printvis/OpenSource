Table 80222 "PVS UPG Private Namespa Const"
//Table 6010919 "PVS Private Namespace Const."
{
    Caption = 'Private Namespace Constants';

    fields
    {
        field(1; "Controller Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Controller Code';
        }
        field(2; Namespace; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Namespace';
            Editable = false;
        }
        field(3; "Private Namespace"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Private Namespace';
            OptionCaption = ' ,Kodak,manroland,Komori,Agfa,Esko Graphics,Xerox,Heidelberg', Locked = true;
            OptionMembers = " ",Kodak,manroland,Komori,Agfa,"Esko Graphics",Xerox,Heidelberg;
        }
        field(10; "Tag Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Tag Name';
            Editable = false;
        }
        field(11; Value; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Value';
        }
        field(12; Description; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Controller Code", Namespace, "Tag Name")
        {
            Clustered = true;
        }
    }
}