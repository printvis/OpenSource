PageExtension 80128 "PTE SOI S. Return Order" extends "Sales Return Order" //"PVS pageextension6010177"
{
    layout
    {
        addafter("Job Queue Status")
        {
            field("PTE SOIStatusCode"; Rec."PTE SOI Status Code")
            {
                ApplicationArea = All;
                ToolTip = 'Displays the selected Status Code for the attached PrintVis Case - if not filled in you may select an Status Code from a LookUp in the field.';
            }
        }
    }
}