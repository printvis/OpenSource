enum 80216 "PVS UPG CIM Receiving Method"
//enum 6010920 "PVS CIM Receiving Method"
{
    Extensible = true;

    value(0; "HotfolderOnPrem")
    {
        Caption = 'Hotfolder (OnPrem)', Locked = true;
    }
    value(1; "JMF")
    {
        Caption = 'JMF', Locked = true;
    }

}