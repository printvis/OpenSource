/* tableextension 6010920 "PVSCIMProductGroup" extends "PVS Product Group"
{
    fields
    {
        field(6010910; "PVS Esko ProductType"; Option)
        {
            Caption = 'Esko ProductType';
            OptionMembers = " ",Label,FoldingCarton;
            OptionCaption = ' ,Label,Folding Carton';
            DataClassification = CustomerContent;
        }
    }
} */
table 80216 "PVSUPGCIMProductGroupExt"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(6010910; "PVS Esko ProductType"; Option)
        {
            Caption = 'Esko ProductType';
            OptionMembers = " ",Label,FoldingCarton;
            OptionCaption = ' ,Label,Folding Carton';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }

}