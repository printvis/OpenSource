pageextension 80186 "SISM Shipping Agents" extends "Shipping Agents"
{
    layout
    {
        addlast(Control1)
        {
            field("SISM External Service Id"; Rec."SISM External Service Id")
            {
                ApplicationArea = All;
            }
        }
    }
}