Table 80212 "PVS UPG CIM Controller URL"
//Table 6010912 "PVS CIM Controller URL"
{
    Caption = 'CIM Controller URL';
    fields
    {
        field(1; "Controller Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Controller Code';
        }
        field(2; "Code"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
            NotBlank = true;
        }
        field(3; Name; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
        }
        field(113; ControllerURL; Text[200])
        {
            DataClassification = CustomerContent;
            Caption = 'ControllerURL';
            Editable = false;
        }
        field(114; ControllerShortURL; Text[200])
        {
            DataClassification = CustomerContent;
            Caption = 'ControllerShortURL';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Controller Code", "Code")
        {
            Clustered = true;
        }
    }
}

