PageExtension 80126 "PTE SOI S. Quotes" extends "Sales Quotes" //"PVS pageextension6010190"
{
    layout
    {
        addafter(Status)
        {
            field("PTE SOI ProductionOrder"; Rec."PTE SOI Production Order")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("PTE SOI_PurchaseOrder"; PTE_SOMgt.SalesHead_Has_PurchaseOrdreNo(Rec))
            {
                ApplicationArea = All;
                Caption = 'Purchase Order';
                Editable = false;
            }
            field("PTE SOI StatusCode"; Rec."PTE SOI Status Code")
            {
                ApplicationArea = All;
                ToolTip = 'Displays the selected Status Code for the attached PrintVis Case - if not filled in you may select an Status Code from a LookUp in the field.';
                Visible = false;
            }
            field("PTE SOI StatusDescription"; Rec."PTE SOI Status Text")
            {
                ApplicationArea = All;
                AssistEdit = false;
                DrillDown = false;
                Editable = false;
                Lookup = false;
                MultiLine = true;
                ToolTip = 'Displays the description to the selected Status Code.';
            }
            field("PTE SOI Responsible"; Rec."PTE SOI Person Responsible")
            {
                ApplicationArea = All;
                AssistEdit = false;
                DrillDown = false;
                Lookup = false;
                ToolTip = 'Displays the set current ''responsible person'' from the attached PrintVis Case, due to the current status.';
            }
            field("PTE SOI Deadline"; Rec."PTE SOI Deadline")
            {
                ApplicationArea = All;
                ToolTip = 'Displays the set deadline from the attached PrintVis Case, due to the current status and when it was changed.';
            }
            field("PTE SOI YourReference"; Rec."Your Reference")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("PTE SOI_CommentForPersonResponsible"; PTE_SOMgt.Get_Page_Comments_Salesorder(Rec))
            {
                ApplicationArea = All;
                Caption = 'Comment for Person Responsible';
                Editable = false;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    PTE_PVS_PageMgt.Call_Page_SalesOrder_Comments(Rec."Document Type".AsInteger(), Rec."No.");
                end;
            }
            field("PTE SOI OrderDate"; Rec."Order Date")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("PTE SOI PromisedDeliveryDate"; Rec."Promised Delivery Date")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("PTE SOI OrderType"; Rec."PTE SOI Order Type Code")
            {
                ApplicationArea = All;
                AssistEdit = false;
                DrillDown = false;
                Editable = false;
                Lookup = false;
                ToolTip = 'Displays the selected OrderType for the attached PrintVis Case - if not filled in you may select an Ordertype from a LookUp in the field.';
            }
            field("PTE SOI_ProductionOrderNo"; PTE_SOMgt.SalesHead_Get_ProductionOrderN(Rec))
            {
                ApplicationArea = All;
                Caption = 'Production Order No.';
                Editable = false;
            }
            field("PTE SOI OrderPlanner"; Rec."PTE SOI Coordinator")
            {
                ApplicationArea = All;
                AssistEdit = false;
                DrillDown = false;
                Lookup = false;
                ToolTip = 'Displays the set Coordinator from the attached PrintVis Case, to indicate who is in charge of the current job.';
            }
            field("PTE SOI Amount"; Rec.Amount)
            {
                ApplicationArea = All;
                BlankZero = true;
                Editable = false;
                Visible = false;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action("PTE SOI UserFields")
            {
                ApplicationArea = All;
                Caption = 'User Fields';
                Image = PeriodStatus;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'User Fields';

                trigger OnAction()
                var
                    UserFieldMgt: Codeunit "PVS Userfield Management";
                begin
                    UserFieldMgt.Form_Userfield_Edit(36, 0, '', Rec."No.", 0, 0, 0, 0, 0);
                end;
            }
            action("PTE SOI APPROVEPURCHASE")
            {
                ApplicationArea = All;
                Caption = 'Approve Purchase';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Approve Purchase Invoices';
                Visible = PTE_PVS_APPROVE_PURCHASEVisible;

                trigger OnAction()
                var
                    PH: Record "Purch. Inv. Header";
                begin
                    PH.Reset();
                    PH.SetFilter("On Hold", PTE_PVS_Filter_Code);
                    Page.Run(Page::"PVS Purchase Order List", PH);
                end;
            }
            action("PTE SOI Log")
            {
                ApplicationArea = All;
                Caption = 'Log';
                Image = History;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Log';

                trigger OnAction()
                var
                    Log_Management: Codeunit "PVS Change Log Management";
                begin
                    Log_Management.Show_Log_SalesHeader(Rec);
                end;
            }
            action("PTE SOI Print")
            {
                ApplicationArea = All;
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Print';

                trigger OnAction()
                var
                    SH: Record "Sales Header";
                    NVS_ObjectManager: Codeunit "PVS Custom Objects Management";
                begin
                    SH.CopyFilters(Rec);
                    NVS_ObjectManager.Report_Run_SalesOrder_List(SH);
                end;
            }
            action("PTE SOI Customer")
            {
                ApplicationArea = All;
                Caption = 'Customer';
                Image = Customer;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "PVS Customer Sub";
                RunPageLink = "No." = field("Sell-to Customer No.");
                ToolTip = 'Customer Card';
            }
            action("PTE SOI Update")
            {
                ApplicationArea = All;
                Caption = 'Update';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Refresh Screen';

                trigger OnAction()
                begin
                    CurrPage.Update(false);
                end;
            }
            action("PTE SOI Milestones")
            {
                ApplicationArea = All;
                Caption = 'Milestones';
                Image = ExpandDepositLine;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "PVS Job Milestones";
                RunPageLink = ID = field("PVS Order ID"),
                              Archived = const(true);
                ToolTip = 'Milestones';

                trigger OnAction()
                var
                    SaleLineRec: Record "Sales Line";
                begin
                    SaleLineRec.SetRange("Document Type", Rec."Document Type");
                    SaleLineRec.SetRange("Document No.", Rec."No.");
                    SaleLineRec.SetFilter("PVS ID", '<>0');
                    SaleLineRec.SetFilter("PVS Job", '<>0');

                    if SaleLineRec.FindFirst() then
                        PTE_PVS_PageMgt.Call_Page_Job_Planning_Small(SaleLineRec."PVS ID", SaleLineRec."PVS Job", true, false);
                end;
            }
            action("PTE SOI ChangeStatus")
            {
                ApplicationArea = All;
                Caption = 'Change Status';
                Image = ChangeStatus;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Change to next status';

                trigger OnAction()
                begin
                    xRec."PTE SOI Status Code" := Rec."PTE SOI Status Code";
                    PTE_SOMgt.SalesHead_Change_Next_Status(Rec, true);
                end;
            }
            separator("PTE Action6010066")
            {
            }
            action("PTE SOI ShowAll")
            {
                ApplicationArea = All;
                Caption = 'Show All';
                Enabled = PTE_PVS_ShowAllEnabled;
                Image = ClearFilter;
                Promoted = true;
                PromotedCategory = Category5;
                ToolTip = 'Show All';

                trigger OnAction()
                begin
                    PTE_PVS_Is_Use_Filter := true;
                    PTE_PVS_SET_FILTER();
                end;
            }
            action("PTE SOI ShowFiltered")
            {
                ApplicationArea = All;
                Caption = 'Show Filtered';
                Enabled = PTE_PVS_ShowFilterEnabled;
                Image = Process;
                Promoted = true;
                PromotedCategory = Category5;
                ToolTip = 'Show Filtered';

                trigger OnAction()
                begin
                    PTE_PVS_Is_Use_Filter := false;
                    PTE_PVS_SET_FILTER();
                end;
            }
            separator("PTE Action6010063")
            {
            }
            action("PTE SOI ResponsibleAction")
            {
                ApplicationArea = All;
                Caption = 'Responsible';
                Enabled = PTE_PVS_ShowResponsible;
                Image = Employee;
                Promoted = true;
                PromotedCategory = Category5;
                ToolTip = 'Responsible';

                trigger OnAction()
                begin
                    PTE_PVS_Show_What := PTE_PVS_Show_What::Responsible;
                    PTE_PVS_SET_FILTER();
                end;
            }
            action("PTE SOI Coordinator")
            {
                ApplicationArea = All;
                Caption = 'Coordinator';
                Enabled = PTE_PVS_ShowOrderManager;
                Image = AbsenceCategory;
                Promoted = true;
                PromotedCategory = Category5;
                ToolTip = 'Order Planner';

                trigger OnAction()
                begin
                    PTE_PVS_Show_What := PTE_PVS_Show_What::Coordinator;
                    PTE_PVS_SET_FILTER();
                end;
            }
            action("PTE SOI SalesPerson")
            {
                ApplicationArea = All;
                Caption = 'Sales Person';
                Enabled = PTE_PVS_ShowSalesPerson;
                Image = SalesPerson;
                Promoted = true;
                PromotedCategory = Category5;
                ToolTip = 'Sales Person';

                trigger OnAction()
                begin
                    PTE_PVS_Show_What := PTE_PVS_Show_What::"Sales Person";
                    PTE_PVS_SET_FILTER();
                end;
            }
        }
    }

    var
        PTE_SOMgt: Codeunit "PTE SOI S.O. Mgt";
        PTE_PVS_PageMgt: Codeunit "PVS Page Management";
        PTE_PVS_SetupRec: Record "PVS General Setup";
        PTE_PVS_UserSetupRec: Record "PVS User Setup";
        PTE_PVS_Show_What: Option Responsible,Coordinator,"Sales Person";
        PTE_PVS_Filter_Code: Code[50];
        PTE_PVS_Is_Use_Filter: Boolean;
        PTE_PVS_APPROVE_PURCHASEVisible: Boolean;
        PTE_PVS_ShowAllEnabled: Boolean;
        PTE_PVS_ShowFilterEnabled: Boolean;
        PTE_PVS_ShowResponsible: Boolean;
        PTE_PVS_ShowOrderManager: Boolean;
        PTE_PVS_ShowSalesPerson: Boolean;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetSecurityFilterOnRespCenter;
    IsOfficeAddin := OfficeMgt.IsAvailable;

    CopySellToCustomerFilter;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4

    // Printvis
    PVS_EXTOnOpenPage;
    // Printvis
    */
    //end;

    procedure PTE_PVS_SET_FILTER()
    var
        PVS_SingleInstance: Codeunit "PVS SingleInstance";
        PH: Record "Purch. Inv. Header";
        NAVuserSetup: Record "User Setup";
        NAVresponsCntr: Record "Responsibility Center";
    begin
        case PTE_PVS_Is_Use_Filter of
            true:
                PTE_PVS_Filter_Code := '';
            false:
                if PTE_PVS_Filter_Code = '' then
                    PTE_PVS_Filter_Code := PVS_SingleInstance.Get_Current_Logical_Login_User();
        end;

        PTE_PVS_ShowAllEnabled := not PTE_PVS_Is_Use_Filter;
        PTE_PVS_ShowFilterEnabled := PTE_PVS_Is_Use_Filter;

        Rec.SetRange("PTE SOI Coordinator");
        Rec.SetRange("Salesperson Code");
        Rec.SetRange("PTE SOI Person Responsible");
        Rec.SetRange("PTE SOI Status Code");

        case PTE_PVS_Show_What of
            0:
                Rec.SetCurrentkey("PTE SOI Person Responsible", "PTE SOI Deadline");
            1:
                Rec.SetCurrentkey("PTE SOI Coordinator", "PTE SOI Deadline");
            2:
                Rec.SetCurrentkey("Salesperson Code", "PTE SOI Deadline");
            3:
                Rec.SetCurrentkey("PTE SOI Status Code", "PTE SOI Deadline");
        end;

        if PTE_PVS_Filter_Code = '' then
            exit;

        case PTE_PVS_Show_What of
            0:
                begin
                    if not PTE_PVS_UserSetupRec.Get(PTE_PVS_Filter_Code) then
                        exit;
                    if PTE_PVS_UserSetupRec."Responsibility Areas" = '' then
                        PTE_PVS_UserSetupRec."Responsibility Areas" := PTE_PVS_Filter_Code;
                    Rec.SetFilter("PTE SOI Person Responsible", ConvertStr(PTE_PVS_UserSetupRec."Responsibility Areas", ',', '|'));

                    PTE_PVS_ShowResponsible := false;
                    PTE_PVS_ShowOrderManager := true;
                    PTE_PVS_ShowSalesPerson := true;
                end;
            1:
                begin
                    Rec.SetRange("PTE SOI Coordinator", PTE_PVS_Filter_Code);
                    PTE_PVS_ShowResponsible := true;
                    PTE_PVS_ShowOrderManager := false;
                    PTE_PVS_ShowSalesPerson := true;
                end;
            2:
                begin
                    if PTE_PVS_UserSetupRec."Salesperson Code" <> '' then
                        PTE_PVS_Filter_Code := PTE_PVS_UserSetupRec."Salesperson Code";
                    Rec.SetRange("Salesperson Code", CopyStr(PTE_PVS_Filter_Code, 1, MaxStrLen(Rec."Salesperson Code")));
                    PTE_PVS_ShowResponsible := true;
                    PTE_PVS_ShowOrderManager := true;
                    PTE_PVS_ShowSalesPerson := false;
                end;
            3:
                begin
                    Rec.SetRange("PTE SOI Status Code", PTE_PVS_Filter_Code);
                    PTE_PVS_ShowResponsible := true;
                    PTE_PVS_ShowOrderManager := true;
                    PTE_PVS_ShowSalesPerson := true;
                end;
        end;

        if StrLen(PTE_PVS_Filter_Code) <= MaxStrLen(PH."On Hold") then begin
            PH.Reset();
            PH.SetCurrentkey("On Hold");
            PH.SetFilter("On Hold", PTE_PVS_Filter_Code);
            PTE_PVS_APPROVE_PURCHASEVisible := PH.FindFirst();
        end else
            PTE_PVS_APPROVE_PURCHASEVisible := false;

        if NAVuserSetup.Get(UserId) then
            if NAVuserSetup."Sales Resp. Ctr. Filter" <> '' then
                if NAVresponsCntr.Get(NAVuserSetup."Sales Resp. Ctr. Filter") then
                    if NAVresponsCntr."Location Code" <> '' then
                        Rec.SetRange("Location Code", NAVresponsCntr."Location Code");

        CurrPage.Update(false);
    end;

    trigger OnOpenPage()
    var
        PVS_SingleInstance: Codeunit "PVS SingleInstance";
    begin
        PVS_SingleInstance.Get_SetupRec(PTE_PVS_SetupRec);
        PVS_SingleInstance.Get_UserSetupRec(PTE_PVS_UserSetupRec);

        PTE_PVS_Show_What := PTE_PVS_UserSetupRec."PTE SOI Case Management Start";
        if PTE_PVS_Show_What > 2 then
            PTE_PVS_Show_What := 0;

        PTE_PVS_Filter_Code := PTE_PVS_UserSetupRec."User ID";

        PTE_PVS_SET_FILTER();
    end;
}