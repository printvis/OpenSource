pageextension 80179 "PTE Custom Sort Sheet List" extends "PVS Job Sheet List"
{
    layout
    {
        addfirst(Group)
        {
            field("PTE Custom Sorting"; Rec."PTE Custom Sorting")
            {
                ApplicationArea = All;
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("PTE Custom Sorting");
    end;
}
