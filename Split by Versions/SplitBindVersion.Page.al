page 80280 "Split Bind Versions"
{
    PageType = List;
    SourceTable = "PVS Job Text Description";
    ApplicationArea = All;
    Editable = true;
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Text; Rec."Text")
                {
                    ApplicationArea = All;
                    Caption = 'Text';
                }
                field(Quantity; Rec."Quantity")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}