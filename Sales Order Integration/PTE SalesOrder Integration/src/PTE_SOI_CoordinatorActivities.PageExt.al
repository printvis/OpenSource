pageextension 80104 "PTE SOI SOint Coordinator Act" extends "PVS Coordinator Activities"
{
    layout
    {
        addlast(Cases)
        {

            field("PTE PurchaseApproval"; Rec."PTE User ID Purchase Approval")
            {
                ApplicationArea = All;
                Caption = 'Purchase Approval';
                DrillDownPageID = "Purchase List";
                Image = Checklist;
                ToolTip = 'Specifies the number of pending purchase approvals that are assigned to you.';
            }
        }


    }
    trigger OnAfterGetRecord()
    begin
        PTE_CalculateCueFieldValues();
    end;


    local procedure PTE_CalculateCueFieldValues()
    begin
        if Rec.FieldActive("Average Days Delayed") then
            Rec."Average Days Delayed" := Rec.PTE_CalculateAverageDaysDelayed();

        if Rec.FieldActive("PTE Ready To Ship") then
            Rec."PTE Ready To Ship" := Rec.PTE_CountOrders(Rec.FieldNo("PTE Ready To Ship"));

        if Rec.FieldActive("PTE Partially Shipped") then
            Rec."PTE Partially Shipped" := Rec.PTE_CountOrders(Rec.FieldNo("PTE Partially Shipped"));

        if Rec.FieldActive("PTE Delayed") then
            Rec."PTE Delayed" := Rec.PTE_CountOrders(Rec.FieldNo("PTE Delayed"));
    end;

}