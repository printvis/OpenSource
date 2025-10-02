page 80136 "SIEP Customs Items"
{
    ApplicationArea = All;
    Caption = 'Customs Items';
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "SIEP Customs Item";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description; Rec.Description)
                {
                    ShowMandatory = true;
                }
                field("Tariff Number"; Rec."Tariff Number") { }
                field("Origin Country"; Rec."Origin Country") { }
                field(Quantity; Rec.Quantity) { }
                field(Value; Rec.Value) { }
                field(Weight; Rec.Weight) { }
            }
        }
    }
}
