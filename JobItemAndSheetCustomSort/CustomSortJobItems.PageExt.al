namespace JobItemAndSheetCustomSort.JobItemAndSheetCustomSort;

pageextension 80177 "PTE Custom Sort Job Items" extends "PVS Job Items"
{
    layout
    {
        addfirst(Control1)
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
