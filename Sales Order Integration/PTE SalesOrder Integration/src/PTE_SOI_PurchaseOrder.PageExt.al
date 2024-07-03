PageExtension 80113 "PTE SOI Purchase Order" extends "Purchase Order" //"PVS pageextension6010141"
{
    layout
    {
        addafter("Responsibility Center")
        {
            field("PTE SOIStatusCode"; Rec."PTE SOI Status Code")
            {
                ApplicationArea = All;
                ToolTip = 'Display or select the PrintVis Status Code set for the Purchase Order. The Status code is used to indicate where if the flow the order si';
            }
            field("PTE SOIPOrderType"; Rec."PTE SOI P-Order Type")
            {
                ApplicationArea = All;
            }
            field("PTE SOIPersonResponsible"; Rec."PTE SOI Person Responsible")
            {
                ApplicationArea = All;
                ToolTip = 'Displays who is responsible for the Purchase Order (in the current status)';
            }
            field("PTE SOICoordinator"; Rec."PTE SOI Coordinator")
            {
                ApplicationArea = All;
                ToolTip = 'Displays who is the coordinator on the PrintVis case, if such is linked to the Purchase Order.';
            }
            field("PTE SOISellToCustomerNo"; Rec."Sell-to Customer No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Expected Receipt Date")
        {
            field("PTE SOIExpectedReceiptTime"; Rec."PTE SOI Expected Receipt Time")
            {
                ApplicationArea = All;
                Importance = Additional;
                ToolTip = 'Displays the set date, and will when filled in update all underlying purchase Lines, with the set date.';
            }
        }
    }


    var
        PTE_PVS_PurchMgt: Codeunit "PVS Purchase Management";
        PTE_PVS_ShowEProcurement: Boolean;


    //Unsupported feature: Code Modification on "OnAfterGetCurrRecord".

    //trigger OnAfterGetCurrRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetControlAppearance;
    CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
    CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(RECORDID);
    ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(RECORDID);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4

    // <PRINTVIS>
    PVS_EXTOnAfterGetCurrRecord;
    // </PRINTVIS>
    */
    //end;

    trigger OnAfterGetCurrRecord()
    var
        PurchaseManagement: Codeunit "PTE SOI Purchase Order Mgt";
    begin
        CurrPage.PurchLines.Page.PVS_SetShowPVS(PurchaseManagement.PurchHead_Has_PrintVisCaseLink(Rec));
    end;
}