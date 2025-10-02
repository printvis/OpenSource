pageextension 80185 "SISM Shipping Agent Services" extends "Shipping Agent Services"
{
    layout
    {
        addlast(Control1)
        {
            field("SISM Required Services"; Rec."SISM Required Services")
            {
                ApplicationArea = All;
                Visible = ShipmondoEnabled;
            }
            field("SISM Req. Service Point"; Rec."SISM Req. Service Point")
            {
                ApplicationArea = All;
                Visible = ShipmondoEnabled;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ShipmondoEnabled := ShipmondoMgt.IsEnabled();
    end;

    var
        ShipmondoMgt: Codeunit "SISM Mgt";
        ShipmondoEnabled: Boolean;
}