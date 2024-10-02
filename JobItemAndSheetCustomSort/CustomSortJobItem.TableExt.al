namespace JobItemAndSheetCustomSort.JobItemAndSheetCustomSort;

tableextension 80177 "PTE Custom Sort Job Item" extends "PVS Job Item"
{
    fields
    {
        field(80177; "PTE Custom Sorting"; Integer)
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
