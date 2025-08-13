tableextension 80280 "Split Bind Job Items" extends "PVS Job Item"
{
    fields
    {
        field(80200; "Additional Version"; Boolean)
        {
            Caption = 'Additional Version';
            Editable = false;
        }

        field(80201; "Split Version"; Text[250])
        {
            Caption = 'Split Version';
            Editable = false;
        }

        field(80202; "Common Text"; Boolean)
        {
            Caption = 'Common Text';
            Editable = false;
        }
    }
}