enum 80220 "PVS UPG CIM Connector Status"
//enum 6010916 "PVS CIM Connector Status"
{
    Extensible = true;

    value(0; " ")
    {

    }
    value(1; "WaitingForExt")
    {
        Caption = 'Waiting for external';
    }
    value(2; "SentToExternal")
    {
        Caption = 'Sent to external';
    }
    value(3; "RecivedFromExternal")
    {
        Caption = 'Received from external';
    }
    value(4; "Done")
    {
        Caption = 'Done';
    }
}