Table 80220 "PVS UPG Esko Setup"
//Table 6010102 "PVS Esko Setup"
{
    Caption = 'Esko Setup';

    fields
    {
        field(1; "KEY"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'KEY';
        }
        field(2; "AE Connect Server"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Server Name';
        }
        field(3; "AE Connect Port"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Server Port';
        }
        field(4; "Integration Activated"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Integration Activated';
        }
        field(5; "AE Container Share Name"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Container Share Name';
        }
        field(10; "Sync Endpoint"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Synchronization Endpoint';
        }
        field(11; "Processing Endpoint"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Processing Endpoint';
        }
        field(20; "AE Server User Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Server Username';
        }
        field(21; "AE Server Password"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Server Password';
            ExtendedDatatype = Masked;
        }
        field(22; "AE Server Domain"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Server Domain';
        }
        field(25; "Default Substrate Queue"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Default Substrate Queue';
        }
        field(30; "CAD Spec. Base Folder Name"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'CAD Specification Base Folder Name';
        }
        field(31; "CAD Spec. Output Folder Name"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'CAD Specification Output Folder Name';
        }
        field(32; "CAD Spec. ARD Folder Name"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'CAD Specification ARD Folder Name';
        }
        field(33; "CAD Spec. JPG Folder Name"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'CAD Specification JPG Folder Name';
        }
        field(34; "CAD Spec. PDF Folder Name"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'CAD Specification PDF Folder Name';
        }
        field(35; "CAD Spec. Interm. Folder Name"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'CAD Specification Intermediate Folder Name';
        }
        field(36; "CAD Spec. Notific. Folder Name"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'CAD Specification Notification Folder Name';
        }
        field(37; "CAD Spec. Error Folder Name"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'CAD Specification Error Folder Name';
        }
        field(38; "Run List Folder Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'RunList Folder Path (UNC)';
        }
        field(40; "Request 3D Previews"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Request 3D Previews';
        }
        field(41; "Request 3D PDF"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Request 3D PDF';
        }
        field(50; "Incoming Imposition File Mask"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Imposition File Mask';
        }
        field(51; "Incoming Strct. Dsg. File Mask"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Structural Design File Mask';
        }
        field(55; "Allow Mfg Sheets without Job"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Manufacturings without Job Info';
            InitValue = true;
        }
        field(60; "Debug Mode Enabled"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Debug Mode Enabled';
        }
        field(61; "Service Tier Debug Path"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Service-tier Debug Path';
        }
        field(70; "No. Series CAD Specs."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No. Series CAD Specification';
        }
        field(71; "No. Series Mfg. Sheet"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No. Series Manufacturing';
        }
    }

    keys
    {
        key(Key1; "KEY")
        {
            Clustered = true;
        }
    }
}

