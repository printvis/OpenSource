enum 80215 "PVS UPG CIM Partner Command"
//enum 6010921 "PVS CIM Partner Command"
{
    Extensible = true;

    value(0; "Send Case")
    {
        Caption = 'Send Case', Locked = true;
    }
    value(1; "SubmitQueueEntry")
    {
        Caption = 'SubmitQueueEntry', Locked = true;
    }
    value(2; "ReSend Case")
    {
        Caption = 'ReSend Case', Locked = true;
    }
    value(3; "ReSubmitQueueEntry")
    {
        Caption = 'ReSubmitQueueEntry', Locked = true;
    }
    value(4; "Send Esko Task")
    {
        Caption = 'SendEskoTask', Locked = true;
    }
    value(5; "EskoTask")
    {
        Caption = 'EskoTask', Locked = true;
    }
    value(6; "Ping")
    {
        Caption = 'Ping', Locked = true;
    }
    value(7; "JMFCommand")
    {
        Caption = 'JMFCommand', Locked = true;
    }

}