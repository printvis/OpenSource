enum 80219 "PVS UPG Part Comman Entry Type"
//enum 6010917 "PVS CIM Partner Command Entry Type"
{
    Extensible = true;

    value(0; Prepress)
    {
        Caption = 'Prepress', Locked = true;
    }
    value(1; Production)
    {
        Caption = 'Production', Locked = true;
    }
    value(2; EskoTask)
    {
        Caption = 'EskoTask', Locked = true;
    }
    value(3; Ping)
    {
        Caption = 'Ping', Locked = true;
    }
    value(4; JMFCommand)
    {
        Caption = 'JMFCommand', Locked = true;
    }
    value(5; QueryKnownDevices)
    {
        Caption = 'QueryKnownDevices', Locked = true;
    }
    value(6; QueryKnownControllers)
    {
        Caption = 'QueryKnownControllers', Locked = true;
    }
    value(7; "QueryStatus")
    {
        Caption = 'QueryStatus', Locked = true;
    }
    value(8; "QueryEvents")
    {
        Caption = 'QueryEvents', Locked = true;
    }
    value(9; "QueryNotifications")
    {
        Caption = 'QueryNotifications', Locked = true;
    }
    value(10; "QueryResource")
    {
        Caption = 'QueryResource', Locked = true;
    }
    value(11; "QueryKnownMessages")
    {
        Caption = 'QueryKnownMessages', Locked = true;
    }
    value(12; "SendQuerySubmisMethods")
    {
        Caption = 'SendQuerySubmisMethods', Locked = true;
    }
    value(13; "StopPersistentChannel")
    {
        Caption = 'StopPersistentChannel', Locked = true;
    }
    value(14; "JobCompletedSuccessfully")
    {
        Caption = 'JobCompletedSuccessfully', Locked = true;
    }
    value(15; "AbortQueueEntry")
    {
        Caption = 'AbortQueueEntry', Locked = true;
    }
}