PageExtension 80119 "PTE SOI S. Invoice" extends "Sales Invoice"
{
    layout
    {
        addafter("Work Description")
        {
            field("PTE SOI PriceMethod"; Rec."PTE SOI Price Method")
            {
                ApplicationArea = All;
                ToolTip = 'Presents the set Pricing principle from the PrintVis Productgroup; As per Quote: In accordance with consumption: Manual Price:';
                Visible = true;

                trigger OnValidate()
                begin
                    Rec.CalcFields(Amount);
                end;
            }
        }
    }
}