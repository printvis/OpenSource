pageextension 80197 "PTE Job ListPart" extends "PVS Job ListPart"
{
    procedure SetShowOnlyOrders(Value: Boolean)
    begin
        ShowOnlyOrders := Value;
        if ShowOnlyOrders then
            Rec.SetRange(Status, Rec.Status::Order)
        else
            Rec.SetRange(Status);
        CurrPage.Update(false);
    end;

    var
        ShowOnlyOrders: Boolean;
}