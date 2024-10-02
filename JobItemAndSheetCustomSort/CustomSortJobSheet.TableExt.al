namespace JobItemAndSheetCustomSort.JobItemAndSheetCustomSort;

tableextension 80179 "PTE Custom Sort Sheet" extends "PVS Job Sheet"
{
    fields
    {
        field(80179; "PTE Custom Sorting"; Integer)
        {
            Caption = 'Custom Sorting';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PTESort; "PTE Custom Sorting")
        { }
    }
}
