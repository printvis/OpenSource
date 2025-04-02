Table 80211 "PVS UPG CIM Controller"
//Table 6010915 "PVS CIM Controller"
{
    Caption = 'Controller';
    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
            NotBlank = true;
        }
        field(9; "Workflow Partner Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Workflow Partner Name';
        }
        field(10; Description; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(11; "Hot Folder Incoming"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Hotfolder incoming';
        }
        field(12; "Target URL"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Target URL';
        }
        field(13; Port; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Port';
        }
        field(15; "Receiving Method"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Receiving Method';
            InitValue = JMF;
            OptionCaption = 'Hotfolder,JMF';
            OptionMembers = Hotfolder,JMF;
        }
        field(16; "Submission Method"; enum "PVS UPG CIM Submission Method")
        {
            DataClassification = CustomerContent;
            Caption = 'Submission Method';
            InitValue = JMF;
        }
        field(19; "MIME Packaging"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'MIME Packaging';
            InitValue = true;
        }
        field(40; Closed; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Closed';
        }
        field(50; "CIM System"; Enum "PVS UPG CIM System")
        {
            DataClassification = CustomerContent;
            Caption = 'System';
        }
        field(51; "Receive Detail Level"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Recieve Detail Level';
            InitValue = "JMF Signal";
            OptionCaption = 'JDF Audit,JMF Signal';
            OptionMembers = "JDF Audit","JMF Signal";
        }
        field(52; "JDF Structure"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'JDF Structure';
            InitValue = Standard;
            OptionCaption = 'Standard,Process Level,,,Single Process,Intent';
            OptionMembers = Standard,"Process Level",,,"Single Process",Intent;
        }
        field(80; "Workflow Submission"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Workflow Submission';
            InitValue = OnePerController;
            OptionCaption = 'First Only,Always,One Per Controller';
            OptionMembers = "First only",Always,OnePerController;
        }
        field(100; "Private Namespace"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Private Namespace';
            OptionCaption = '', Comment = ' ,Kodak,manroland,Komori,Agfa,Esko Graphics,Xerox,Heidelberg';
            OptionMembers = " ",Kodak,manroland,Komori,Agfa,"Esko Graphics",Xerox,Heidelberg;
        }
        field(101; "Resubmission Allowed"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Resubmission allowed';
            InitValue = true;
        }
        field(102; "Subscription Method"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Subscription Method';
            InitValue = "None";
            OptionCaption = 'SubmitQueueEntry Device Globally,Query Device (Globally),Job Level JDF Node,Query Job Level JDF Node,None,Job Level JDF Node (Device)';
            OptionMembers = "SubmitQueueEntry Device Globally","Query Device Globally","Job Level JDF Node","Query Job Level JDF Node","None","Job Level JDF Node (Device)";
        }
        field(103; "No. Of Submission Retries"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'No. of Submission Retries';
            InitValue = 5;
            MaxValue = 99;
        }
        field(110; "SM Hot Folder"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Hotfolder';
            Description = 'Submission Methods';
            Editable = false;
        }
        field(111; "SM File Schema Support"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'File Schema Support';
            Description = 'Submission Methods';
            Editable = false;
        }
        field(112; "SM FTP Schema Support"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'FTP Schema Support';
            Description = 'Submission Methods';
            Editable = false;
        }
        field(113; "SM HTTP Schema Support"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'HTTP Schema Support';
            Description = 'Submission Methods';
            Editable = false;
        }
        field(114; "SM HTTPS Schema Support"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'HTTPS Schema Support';
            Description = 'Submission Methods';
            Editable = false;
        }
        field(115; "SM MIME Packaging Support"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'MIME Packaging Support';
            Description = 'Submission Methods';
            Editable = false;
        }
        field(120; "Sender ID"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Sender ID';
        }
        field(130; "Subscribed To Status"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Subscribed to Status';
            Description = 'Subscription';
            Editable = false;
        }
        field(131; "Subscribed To Resource"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Subscribed to Resource';
            Description = 'Subscription';
            Editable = false;
        }
        field(132; "Subscribed To Events"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Subscribed to Events';
            Description = 'Subscription';
            Editable = false;
        }
        field(133; "Subscribed To Notifications"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Subscribed to Notifications';
            Description = 'Subscription';
            Editable = false;
        }
        field(150; "Clean Org. Name"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Clean OrganisationName';
        }
        field(200; "Paper Media Partioned"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Paper Media Partioned';
            InitValue = true;
        }
        field(201; "Plate Media Partioned"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Plate Media Partioned';
            InitValue = true;
        }
        field(202; "Position Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Position Type';
            InitValue = RelativeBox;
            OptionCaption = 'RelativeBox,AbsoluteBox';
            OptionMembers = RelativeBox,AbsoluteBox;
        }
        field(210; "Preview Separation Node"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Preview Separation Node';
            InitValue = true;
        }
        field(211; "Preview Thumbnail Node"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Preview Thumbnail Node';
            InitValue = true;
        }
        field(212; "Preview Sep. Thumbnail Node"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Preview Separation Thumbnail Node';
            InitValue = true;
        }
        field(213; "Media Intent Dim. Node"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'MediaIntent Dimension Node';
            InitValue = true;
        }
        field(220; "JDF ProductTypeDetails Value"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'JDF ProductTypeDetails Value';
            OptionCaption = ' ,Product Group JDFProductTypeDetails,Custom';
            OptionMembers = " ",ProductGroupJDFProductTypeDetails,Custom;
        }
        field(221; "JDF ProductTypeDetails Buildup"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'JDF ProductTypeDetails BuildUp';
        }
        field(222; "JDF GeneralID ProductClass"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'JDF ProductClass GeneralID';
        }
        field(223; "JDF GeneralID ProductionType"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'JDF ProductionType GeneralID';
        }
        field(240; "Format Contact Names"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Format Contact names';
            InitValue = "None";
            OptionCaption = 'None,Case Folder rules';
            OptionMembers = "None","Case Folder rules";
        }
        field(300; "HTTP Use"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'HTTP Use';
            Description = 'Use HTTP Server for Resources and Runlists';
        }
        field(400; "JMF AcknowledgeURL Attribute"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'JMF AcknowledgeURL Attribute';
            InitValue = true;
        }
        field(401; "JMF WatchURL Attribute"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'JMF WatchURL Attribute';
            InitValue = true;
        }
        field(402; "JMF ResubmitQueue Supported"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'JMF ResubmitQueue Supported';
            InitValue = true;
        }
        field(502; "Job Ticket ID"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Jobticket ID';
        }
        field(504; "File Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Filetype';
            InitValue = PDF;
            OptionCaption = ' ,,,,PDF,WORD';
            OptionMembers = " ",,,,PDF,WORD;
        }
        field(600; "Special Target URL"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Special Target URL';
        }
        field(700; "JMF Port"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'JMF Port';
        }
        field(701; "Status Port"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Status Port';
        }
        field(800; "Auto Count Plant ID"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'AutoCount Plant ID';
        }
        field(900; "Use Agfa TicketTemplate"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Use Agfa Ticket Template';
        }
        field(901; "Use Agfa JobDescriptiveName"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Use Agfa JobDescriptiveName';
        }
        field(920; "Esko Label PrePress Workflow"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Esko Label PrePress Workflow';
        }
        field(921; "Esko Label Production Workflow"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Esko Label Production Workflow';
        }
        field(1000; "Status Subscription ID"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Status Subscription ID';
        }
        field(1001; "Resource Subscription ID"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Resource Subscription ID';
        }
        field(1002; "Event Subscription ID"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Event Subscription ID';
        }
        field(1003; "Notification Subscription ID"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Notification Subscription ID';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }
}

