pageextension 80281 "Split Bind Job Planning" extends "PVS Job Planning"
{
    layout
    {
        addafter(JobItemDescription)
        {
            field("ProcessGroup"; Rec.ProcessGroup)
            {
                ApplicationArea = All;
                ToolTip = 'The process group for the unit.';
                Editable = false;
            }
        }
    }
}