tableextension 80278 "PTE Status Responsiblity Area" extends "PVS Status Responsiblity Area"
{
    fields
    {
        field(80278; "Product Group"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "PVS Product Group";
            Caption = 'Product Group';
            trigger OnValidate()
            begin
                Rec."Customer Group" := Rec."Product Group";
            end;
        }
    }
}
