Table 80226 "PVS UPG Workflow Partner Comma"
//Table 6010913 "PVS Workflow Partner Commands"
{
    Caption = 'Workflow Partner Commands';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
        }
        field(2; "Entry Type"; enum "PVS UPG Part Comman Entry Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Entry Type';
        }
        field(3; "Device Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Device Code';
        }
        field(6; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
        }
        field(7; ID; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'ID';
        }
        field(8; Job; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Job';
        }
        field(9; Version; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Version';
        }
        field(10; "Sheet ID"; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Sheet ID';
            Editable = false;
        }
        field(11; Command; Enum "PVS UPG CIM Partner Command")
        {
            DataClassification = CustomerContent;
            Caption = 'Command';
        }
        field(12; Status; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
            OptionCaption = 'New,Processed,Error';
            OptionMembers = New,Processed,Error;
        }
        field(13; "Error Message"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Error Message';
        }
        field(14; Submitted; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Submitted';
        }
        field(15; "Submission Pending"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Submission Pending';
        }
        field(16; "File Name"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Filename';
        }
        field(17; "File BLOB"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'File BLOB';
        }
        field(20; Information; Text[1024])
        {
            DataClassification = CustomerContent;
            Caption = 'Information';
        }
        field(21; Text1; Text[1024])
        {
            DataClassification = CustomerContent;
            Caption = 'Text1', Locked = true;
            ;
        }
        field(50; "Creation Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date of Creation';
        }
        field(51; "Creation Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Time of Creation';
        }
        field(52; "Created By User"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Created by User';
        }
        field(61; "Processing Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Time of Processing';
        }
        field(62; "Transmission Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Time of Transmission';
        }
        field(63; "Send To Target URL"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Send to Target URL';
        }
        field(64; "Submission Attempts"; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Submission Attempts';
        }
        field(65; "Submission Command ID"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Submission CommandID';
        }
        field(102; "Job ID"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'JobID';
        }
        field(103; "Job Part ID"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'JobPartID';
        }
        field(104; "Last Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Last Entry No.';
        }
        field(111; "Controller Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Controller Code';
            Editable = false;
        }
        field(200; "CIM Controller URL Code"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'CIM Controller URL Code';
        }
        field(300; "Esko BackStage Ticket Name"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Esko BackStage Ticket Name';
        }
        field(301; "PVS Esko BackStage Task Type"; enum "PVS UPG CIM Esko Task Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Esko BackStage Task Type';
            editable = false;
        }

        field(500; "External Status"; Enum "PVS UPG CIM Connector Status")
        {
            Caption = 'External Status';
            DataClassification = CustomerContent;
        }
        field(501; "File To External System"; Blob)
        {
            Caption = 'File To External System';
            DataClassification = CustomerContent;
        }
        field(502; "File From External System"; Blob)
        {
            Caption = 'File From External System';
            DataClassification = CustomerContent;
        }
        field(503; "Last Update From Connector"; DateTime)
        {
            Caption = 'Last Update From Connector';
            DataClassification = CustomerContent;
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