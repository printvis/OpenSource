pageextension 80130 "PVS SOI Warehouse P. Rcpt" extends "PVS Warehouse Purchase Receipt"
{

    actions
    {
        addlast(processing)
        {
            action("PTE ChangeSalesOrderStatus")
            {
                ApplicationArea = All;
                Caption = 'Change Sales Order Status';
                Image = ChangeStatus;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Change Sales Order Status';
                Visible = PTE_PUSH_RETURNVISIBLE;

                trigger OnAction()
                begin
                    PTE_Purchase_Management.PurchHead_Recieve_ReturnStatus(Rec);
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        PTE_SingleInstance.Get_UserSetupRec(PTE_UserRec);
        if PTE_UserRec."Status Code Goods Received" <> '' then
            if PTE_ReturnStatus.Get(PTE_UserRec."User ID", PTE_UserRec."Status Code Goods Received") then;
        PTE_PUSH_RETURNVISIBLE := PTE_ReturnStatus.Text <> '';
    end;

    var
        PTE_UserRec: Record "PVS User Setup";
        PTE_ReturnStatus: Record "PVS Status Code";
        PTE_SingleInstance: Codeunit "PVS SingleInstance";
        PTE_Purchase_Management: Codeunit "PTE SOI Purchase Order Mgt";
        PTE_PUSH_RETURNVISIBLE: Boolean;
}