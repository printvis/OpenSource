tableextension 80175 "PTE RFG Job Item General Setup" extends "PVS General Setup"
{
    fields
    {
        field(80175; "PTE Use Job Item"; Boolean)
        {
            Caption = 'Use Job Item';
            ToolTip = 'Selecting this would instead of pulling the Items from the PrintVis Jobs pull from the PrintVis Job Items';
            DataClassification = CustomerContent;
        }
    }
}
