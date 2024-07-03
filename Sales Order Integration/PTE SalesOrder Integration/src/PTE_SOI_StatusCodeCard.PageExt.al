pageextension 80133 "PTE SOI Status Code Card" extends "PVS Status Code Card"
{
    layout
    {
        addfirst(Integration)
        {
            group("PTE SOOrderIntergration")
            {
                Caption = 'Order Integration';
                field("PTE SOProdeqSale"; Rec."Prod eq. Sale")
                {
                    ApplicationArea = All;
                    ToolTip = 'In the Sales order integration section, you may select the field to ensure that if a sales order changes status to the indicated Status code this automatically entails that the corresponding case gets the same status or vice versa. This means that the field is only used if you actually use Sales/Production order integration';
                }
            }
        }
    }
}
