pageextension 80175 "PTE RFG Job Item General Setup" extends "PVS General Setup"
{
    layout
    {
        addlast(Production)
        {
            field("PTE Use Job Item"; Rec."PTE Use Job Item")
            {
                ApplicationArea = All;
            }
        }
    }
}
