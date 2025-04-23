Table 80215 "PVS UPG CIM Device"
//Table 6010916 "PVS CIM Device"
{
    Caption = 'Device';
    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Name; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
        }
        field(10; "Controller Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Controller Code';
        }
        field(12; "JMF Level"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'JMF Level';
            OptionCaption = 'Level 0 - No messaging,Level 1 - Notification,Level 2 - Query support,Level 3 - Command support,Level 4 - Submission support';
            OptionMembers = "Level 0","Level 1","Level 2","Level 3","Level 4";
        }
        field(13; "Device ID"; Text[200])
        {
            DataClassification = CustomerContent;
            Caption = 'Device ID';
        }
        field(14; "Device Type"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Device Type';
        }
        field(15; "Descriptive Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Descriptive Name';
        }
        field(16; "Report Total No. of Plates"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Report Total No. of Plates';
        }
        field(40; Closed; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Closed';
        }
        field(41; "Device Sequence"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Device Sequence';
        }
        field(42; "Max Speed"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Max Speed';
        }
        field(50; "External Reference Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'External Reference Code';
        }
        field(60; "PrePress Job Creation"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'PrePress Job Creation';
        }
        field(95; "Bitmap Code Big"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Bitmap Code Big';
        }
        field(96; "Bitmap Code Small"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Bitmap Code Small';
        }
        field(98; Picture; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Picture';
        }
        field(100; UPC; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'UPC';
            Editable = false;
        }
        field(101; DeviceFamily; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'DeviceFamily';
            Editable = false;
        }
        field(102; FriendlyName; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'FriendlyName';
            Editable = false;
        }
        field(103; Manufacturer; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Manufacturer';
            Editable = false;
        }
        field(104; ModelDescription; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'ModelDescription';
            Editable = false;
        }
        field(105; ModelName; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'ModelName';
            Editable = false;
        }
        field(106; ModelNumber; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'ModelNumber';
            Editable = false;
        }
        field(107; ICSVersions; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'ICS Versions';
            Editable = false;
        }
        field(108; JDFErrorURL; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'JDF ErrorURL';
            Editable = false;
        }
        field(109; JDFInputURL; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'JDF InputURL';
            Editable = false;
        }
        field(110; JDFOutputURL; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'JDF OutputURL';
            Editable = false;
        }
        field(111; JDFVersions; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'JDF Versions';
            Editable = false;
        }
        field(112; JMFSenderID; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'JMF SenderID';
        }
        field(113; JMFURL; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'JMF URL';
            Editable = false;
        }
        field(114; "Serial No."; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Serial Number';
            Editable = false;
        }
        field(115; PresentationURL; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Presentation URL';
            Editable = false;
        }
        field(116; SecureJMFURL; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Secure JMF URL';
            Editable = false;
        }
        field(117; Directory; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Directory';
            Editable = false;
        }
        field(118; Type; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Type';
            Editable = false;
        }
        field(120; "Counter Channel"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Counter Channel';
        }
        field(121; "Switches From Channel"; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Switches - From Channel';
            MaxValue = 15;
            MinValue = 0;
        }
        field(122; "Switches To Channel"; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Switches - To Channel';
            MaxValue = 15;
            MinValue = 0;
        }
        field(123; "Switches No. Of Channels"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Switches - No. of Channels';
            Editable = false;
        }
        field(124; "Switches Channels"; Code[40])
        {
            DataClassification = CustomerContent;
            Caption = 'Switches - Channels';
            CharAllowed = '09,,';
            Editable = true;
        }

        field(130; "Enable Switches"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Enable Switches';
        }
        field(140; "AutoCount ID"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'AutoCount ID';
        }
        field(141; "AutoCount Plant ID"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'AutoCount Plant ID';
        }
        field(142; "Use AutoCount As Machine Cntr"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Use AutoCount as Machine Counter';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

