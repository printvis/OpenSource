tableextension 80281 "Split Bind Plan" extends "PVS Job Planning Unit"
{
    fields
    {
        field(80201; ProcessGroup; Text[250])
        {
            FieldClass = FlowField;
            Caption = 'Process Group';
            CalcFormula = lookup("PVS Job Calculation Unit"."Process Group" where("Plan ID" = field("Plan ID")));
            Editable = false;
        }
    }
}