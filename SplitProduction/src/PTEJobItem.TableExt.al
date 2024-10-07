tableextension 80180 "PTE Job Item" extends "PVS Job Item"
{
    fields
    {
        field(80180; "PTE Controlling Sheet Text"; Text[100])
        {
            Caption = 'Machine';
            Editable = false;
            CalcFormula = lookup("PVS Calculation Unit Setup".Text where(Type = const(0), "List Of Units" = const(true), code = field("Controlling Sheet Unit")));
            FieldClass = FlowField;

        }
    }
}
