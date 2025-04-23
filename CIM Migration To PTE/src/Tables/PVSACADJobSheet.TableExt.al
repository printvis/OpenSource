/* TableExtension 6010153 "PVS ACAD Job Sheet" extends "PVS Job Sheet"
{
    fields
    {
        field(6010500; "PVS Mfg. Sheet No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Manufacturing No.'; 
        }

    }
} */
table 80210 "PVS UPG ACAD Job Sheet Ext"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(80100; "Sheet ID"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(80101; "PVS Mfg. Sheet No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Manufacturing No.';
        }
    }

    keys
    {
        key(Key1; "Sheet ID")
        {
            Clustered = true;
        }
    }

}