Table 80217 "PVS UPG CIM Setup"
//Table 6010910 "PVS CIM Setup"
{
    Caption = 'CIM Setup';

    fields
    {
        field(1; "KEY"; Code[10])
        {
            Caption = 'KEY';
            DataClassification = CustomerContent;
            Description = 'Primary Key';
        }
        field(3; "Test Mode"; Boolean)
        {
            Caption = 'Test Mode';
            DataClassification = CustomerContent;
        }
        field(4; "Hotfolder Customer Intents"; Text[250])
        {
            Caption = 'Hotfolder Customer Intents';
            DataClassification = CustomerContent;
        }
        field(12; "JMF Channel IP"; Text[100])
        {
            Caption = 'JMF Channel IP';
            DataClassification = CustomerContent;
            Description = 'The IP address (use ''*'' to listen on any IP address).';
        }
        field(13; "JMF Channel Port"; Integer)
        {
            Caption = 'JMF Channel Port';
            DataClassification = CustomerContent;
            Description = 'The used port.';
            InitValue = 4060;
        }
        field(14; "JMF Channel Domain"; Text[100])
        {
            Caption = 'JMF Channel Domain Suffix';
            DataClassification = CustomerContent;
            Description = 'The Domain Suffix when installing JMF Service on Azure';
        }
        field(20; "WCF OnPremise Port"; Integer)
        {
            Caption = 'Regular TCP Binding Port';
            DataClassification = CustomerContent;
            InitValue = 9998;
        }
        field(21; "HTTP Listener Port"; Integer)
        {
            Caption = 'HTTP Listener Port';
            DataClassification = CustomerContent;
            InitValue = 4061;
        }
        field(22; "HTTP Status Port"; Integer)
        {
            Caption = 'HTTP Status Port';
            DataClassification = CustomerContent;
            InitValue = 4062;
        }
        field(24; "JDF Sender ID Suffix"; Text[30])
        {
            Caption = 'JDF Sender ID Suffix';
            DataClassification = CustomerContent;
        }
        field(25; "Disable Scheduler in External"; Boolean)
        {
            Caption = 'Disable Scheduler in PrintVis Link';
            DataClassification = CustomerContent;
        }
        field(30; "Delete Response History"; Boolean)
        {
            Caption = 'Delete Response History';
            DataClassification = CustomerContent;
        }
        field(31; "Retain History Date Formula"; DateFormula)
        {
            Caption = 'Retain History Date Formula';
            DataClassification = CustomerContent;
        }
        field(40; "JDF Version"; Option)
        {
            Caption = 'JDF Version';
            DataClassification = CustomerContent;
            OptionCaption = '', Comment = '1.3,1.4,1.5,1.6';
            OptionMembers = "1.3","1.4","1.5","1.6";
        }
        field(50; "Max Msg Size For Service Tier"; Integer)
        {
            Caption = 'Max Msg Size for Service Tier (KB)';
            DataClassification = CustomerContent;
            InitValue = 768;
        }
        field(51; "Max Msg Size To Initiate Async"; Integer)
        {
            Caption = 'Max Msg Size to Initiate Async Sending (KB)';
            DataClassification = CustomerContent;
            InitValue = 512;
        }
        field(52; "Transform URL To MIME"; Boolean)
        {
            Caption = 'Transform local URL(s) into MIME message';
            DataClassification = CustomerContent;
        }
        field(201; "Test Controller Code"; Code[20])
        {
            Caption = 'Test Controller Code';
            DataClassification = CustomerContent;
        }

        field(203; "Test Disable Auto Processing"; Boolean)
        {
            Caption = 'Test Disable Auto Processing';
            DataClassification = CustomerContent;
        }
        field(204; "Test Enable Multi-ID Encoding"; Boolean)
        {
            Caption = 'Test Enable Multi ID Encoding';
            DataClassification = CustomerContent;
        }
        field(210; "Test JDF File Blob"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Test JDF file';
        }
        field(211; "Test JDF File Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Test JDF file Name';
        }
        field(300; "JDF Descriptive Naming"; Option)
        {
            Caption = 'JDF Descriptive Naming';
            DataClassification = CustomerContent;
            OptionCaption = 'From Case,From Job';
            OptionMembers = "From Case","From Job";
        }
        field(400; "CIM Queue Blocked"; Boolean)
        {
            Caption = 'CIM Queue Blocked';
            DataClassification = CustomerContent;
        }
        field(401; "CIM Session ID"; Integer)
        {
            Caption = 'CIM SessionID';
            DataClassification = CustomerContent;
        }
        field(402; "CIM Server Instance ID"; Integer)
        {
            Caption = 'CIM Server Instance ID';
            DataClassification = CustomerContent;
        }
        field(406; "CIM Task ID"; Guid)
        {
            Caption = 'CIM Task Id';
            DataClassification = CustomerContent;
        }
        field(410; "DCM Queue Blocked"; Boolean)
        {
            Caption = 'DCM Queue Blocked';
            DataClassification = CustomerContent;
        }
        field(411; "DCM Session ID"; Integer)
        {
            Caption = 'DCM SessionID';
            DataClassification = CustomerContent;
        }
        field(412; "DCM Server Instance ID"; Integer)
        {
            Caption = 'DCM Server Instance ID';
            DataClassification = CustomerContent;
        }
        field(413; "DCM Task ID"; Guid)
        {
            Caption = 'DCM Task Id';
            DataClassification = CustomerContent;
        }

        field(420; "Timer Interval"; Integer)
        {
            Caption = 'Timer Interval (ms)';
            DataClassification = CustomerContent;
        }
        field(500; "Messages Received"; Integer)
        {
            Caption = 'Messages received since Service Start';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(501; "WCF Service Started"; DateTime)
        {
            Caption = 'WCF Service Started';
            DataClassification = CustomerContent;
        }
        field(502; "WCF Service Running"; Boolean)
        {
            Caption = 'Service Running';
            DataClassification = CustomerContent;
        }
        field(503; "WCF Service Stopped"; DateTime)
        {
            Caption = 'WCF Service Stopped';
            DataClassification = CustomerContent;
        }
        field(504; "WCF Service Version"; Text[50])
        {
            Caption = 'WCF Service Version';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(505; "WCF Service Started As User ID"; Text[50])
        {
            Caption = 'WCF Service Started as User ID';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(508; "WCF Service IP Address"; Text[50])
        {
            Caption = 'WCF Service Network IP Address (Only special cases)';
            DataClassification = CustomerContent;
        }
        field(600; "Timer Interval (DCM)"; Integer)
        {
            Caption = 'Timer Interval (DCM)';
            DataClassification = CustomerContent;
            Description = 'DCM';
        }
        field(700; "Job Ticket ID"; Integer)
        {
            Caption = 'Jobticket ID';
            DataClassification = CustomerContent;
        }
        field(701; "Job Ticket File Type"; Option)
        {
            Caption = 'Jobticket Filetype';
            DataClassification = CustomerContent;
            InitValue = PDF;
            OptionCaption = ' ,,,,PDF,WORD';
            OptionMembers = " ",,,,PDF,WORD;
        }
        field(900; Responsible; Code[50])
        {
            Caption = 'Responsible';
            DataClassification = CustomerContent;
        }
        field(1000; "Esko JDF Integration Active"; Boolean)
        {
            Caption = 'Esko JDF Integration Active';
            DataClassification = CustomerContent;
        }

        field(1100; "PVS User Login"; Code[50])
        {
            Caption = 'User Login';
            DataClassification = CustomerContent;
        }
        field(1101; "PVS User Password"; Text[1024])
        {
            Caption = 'User Password';
            ExtendedDatatype = Masked;
            DataClassification = CustomerContent;
        }
        field(2100; "XMPIE Front End Port"; Integer)
        {
            Caption = 'XMPIE Front End Port';
            DataClassification = CustomerContent;
            InitValue = 4063;
        }
        field(2101; "XMPIE Web Service URL"; Text[250])
        {
            Caption = 'XMPIE Web Service URL';
            DataClassification = CustomerContent;
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