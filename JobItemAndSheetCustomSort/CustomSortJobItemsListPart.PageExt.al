namespace JobItemAndSheetCustomSort.JobItemAndSheetCustomSort;

pageextension 80178 "PTE Custom Sort Job ItemsLP" extends "PVS Job Items ListPart"
{
    layout
    {
        addfirst(Repeater_Control)
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
