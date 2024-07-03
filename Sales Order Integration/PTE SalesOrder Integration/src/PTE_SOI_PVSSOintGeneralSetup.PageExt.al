pageextension 80117 "PTE SOI SOint General Setup" extends "PVS General Setup"
{
    layout
    {
        addlast(SalesPurchOrder)
        {
            field("PTE SOISalesOrderCalcWait"; Rec."PTE Sales Order Calc. Wait")
            {
                Importance = Additional;
                ApplicationArea = All;
            }
        }
    }
}
