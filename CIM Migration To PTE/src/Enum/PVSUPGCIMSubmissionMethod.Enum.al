enum 80217 "PVS UPG CIM Submission Method"
//enum 6010919 "PVS CIM Submission Method"
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