tableextension 80110 "PTE SOI User setup" extends "PVS User setup"
{
    fields
    {
        field(80101; "PTE SOI Case Management Start"; Option)
        {
            DataClassification = SystemMetadata;
            Caption = 'Case Management Start';
            OptionCaption = 'Responsible,Order Manager,Sales Person';
            OptionMembers = Responsible,"Order Manager","Sales Person";
        }
        field(80102; "PTE SOI Status Code New P."; Code[20])
        {
            DataClassification = SystemMetadata;
            Caption = 'Status Code for new Purchase Order';
            TableRelation = "PVS Status Code".Code where(User = const(''));
        }
        field(80103; "PTE SOI Man P. List Filter"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Manual Purchase List Filtering';
        }
    }
}