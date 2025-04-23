Table 80221 "PVS UPG JMF Known Messages"
//Table 6010918 "PVS JMF Known Messages"
{
    Caption = 'JMF Known Messages';

    fields
    {
        field(1; "Controller Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Controller Code';
        }
        field(5; Type; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Type';
        }
        field(10; JMFRole; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'JMFRole';
            OptionCaption = ' ,Receiver,Sender';
            OptionMembers = " ",Receiver,Sender;
        }
        field(11; Acknowledge; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Acknowledge';
        }
        field(12; Command; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Command';
        }
        field(13; Persistent; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Persistent';
        }
        field(14; "Query"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Query';
        }
        field(15; Registration; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Registration';
        }
        field(16; Signal; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Signal';
        }
        field(17; "URLSchema File"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'URLSchema File';
        }
        field(18; "URLSchema FTP"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'URLSchema FTP';
        }
        field(19; "URLSchema HTTP"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'URLSchema HTTP';
        }
        field(20; "URLSchema HTTPS"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'URLSchema HTTPS';
        }
    }

    keys
    {
        key(Key1; "Controller Code", Type)
        {
            Clustered = true;
        }
    }
}