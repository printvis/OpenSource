pageextension 80196 "PTE Case Card" extends "PVS Case Card"
{
    layout
    {
        addlast(GeneralGroup)
        {
            field(ShowOnlyOrders; ShowOnlyOrders)
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    if ShowOnlyOrders and (Rec.Type < Rec.Type::Order) then
                        Rec.FieldError(Type);
                    CurrPage.SUB_JOBS.Page.SetShowOnlyOrders(ShowOnlyOrders);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ShowOnlyOrders := Rec.Type = Rec.Type::Order;
        if ShowOnlyOrders then
            CurrPage.SUB_JOBS.Page.SetShowOnlyOrders(true);
    end;

    var
        ShowOnlyOrders: Boolean;
}