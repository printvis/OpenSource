Table 80228 "PVS UPG Workflow Partner Que."
//Table 6010922 "PVS Workflow Partner Que. Ent."
{
    Caption = 'PV Workflow Partner Queue Entries';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; SenderID; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'SenderID';
        }
        field(3; "PVS Device Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PV Device Code';
        }
        field(4; "PVS Controller Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PV Controller Code';
        }
        field(5; DeviceID; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'DeviceID';
        }
        field(6; "Event TimeStamp"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'TimeStamp';
        }
        field(7; JobID; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'JobID';
        }
        field(8; JobPartID; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'JobPartID';
        }
        field(9; "Event System"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'System';
            OptionCaption = 'JDF/JMF,JDF Intent,CP2000,DCM';
            OptionMembers = "JDF/JMF","JDF Intent",CP2000,DCM;
        }
        field(20; "Queue Status"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Device Status Text';
        }
        field(21; "Queue Entry Status"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Device StatusDetails Text';
        }
        field(22; "Queue Entry Submission Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Queue Entry Submission Time';
        }
        field(23; "Queue EntryID"; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Queue EntryID';
        }
        field(24; "Queue Entry Priority"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Queue Entry Priority';
        }
        field(30; "Acknowledge Type"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Acknowledge Type';
        }
        field(60; RefID; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'RefID';
        }
        field(99; "File BLOB"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'File BLOB';
        }
        field(100; "DateTime Received"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'DateTime Received';
        }
        field(102; "Response Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Response Type';
            OptionCaption = ' ,Acknowledge,Response';
            OptionMembers = " ",Acknowledge,Response;
        }
        field(103; "Response Sub Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Response Sub Type';
            OptionCaption = ' ,SubmitQueueEntry';
            OptionMembers = " ",SubmitQueueEntry;
        }
        field(200; Status; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'PV Status';
            OptionCaption = 'New,Processed,Error';
            OptionMembers = New,Processed,Error;
        }
        field(203; "Error Text"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'PV Error Text';
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