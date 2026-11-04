tableextension 75005 "PTE Product Materials Ext" extends "PVS Product Materials"
{
    fields
    {
        field(75010; "Job Item No."; Integer)
        {
            Caption = 'Job Item No.';
            DataClassification = SystemMetadata;
            TableRelation = "PTE Product Job Item"."Job Item No." where("Product Code" = field("Product Code"));
        }
    }
}
