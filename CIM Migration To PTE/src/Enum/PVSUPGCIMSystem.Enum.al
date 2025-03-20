enum 80218 "PVS UPG CIM System"
//enum 6010910 "PVS CIM System" implements "PVS CIM System"
{
    Extensible = true;

    value(0; JDF) { Caption = 'JDF'; }
    // value(1; CP2000)
    // {
    //     Caption = 'CP2000 Heidelberg';
    // }
    value(2; "Digital Input") { Caption = 'Digital Input'; }

    value(3; AutoCount)
    {
        Caption = '', Locked = true;
    }

}