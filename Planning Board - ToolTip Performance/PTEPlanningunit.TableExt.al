tableextension 80800 "PTE Job Planning Unit" extends "PVS Job Planning Unit"
{
    fields
    {
        field(80800; "PTE ToolTipTxt"; Text[1024])
        {
            Caption = 'ToolTip Text';
            DataClassification = ToBeClassified;
        }
        field(80801; "PTE SearchTxt"; Text[1024])
        {
            Caption = 'Search Text';
            DataClassification = ToBeClassified;
        }

    }
}
