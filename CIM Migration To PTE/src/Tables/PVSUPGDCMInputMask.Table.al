Table 80219 "PVS UPG DCM Input Mask"
//Table 6010753 "PVS DCM Input Mask"
{
    Caption = 'DCM Input Mask';

    fields
    {
        field(10; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
        }
        field(20; "Device Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Device Code';
        }
        field(30; "Cost Centre Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Cost Center Code';
        }
        field(40; "Input Mask"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Input Mask';
            CharAllowed = '01**??';
            ;
        }
        field(50; "Work Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Work Code';
        }
        field(60; "Input Mask (User)"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Input Mask (Human Readable)';
            CharAllowed = '01??**,,..  ';

        }
        field(70; "Include Counter"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Include Counter';
        }
        field(80; "Device Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Device Status';
            OptionCaption = 'Idle,Running';
            OptionMembers = Idle,Running;
        }
        field(90; Priority; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Priority';
        }
        field(1000; "Created By"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Created By';
        }
        field(1001; "Created Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Created Date';
        }
        field(1002; "Created Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Created Time';
        }
        field(1005; "Modified By"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Modified By';
        }
        field(1006; "Modified Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Modified Date';
        }
        field(1007; "Modified Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Modified Time';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }

    }

}

