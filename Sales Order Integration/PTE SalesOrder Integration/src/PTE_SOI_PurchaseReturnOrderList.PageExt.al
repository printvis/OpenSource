PageExtension 80116 "PTE SOI P. Return O. List" extends "Purchase Return Order List" //"PVS pageextension6010197"
{
    layout
    {
        addafter("Posting Description")
        {
            field("PTE SOIProductionOrder"; PTE_PVS_Is_Production_Order())
            {
                ApplicationArea = All;
                Caption = 'Production Order';
                Visible = false;
            }
            field("PTE SOIStatusCode"; Rec."PTE SOI Status Code")
            {
                ApplicationArea = All;
                ToolTip = 'Display or select the PrintVis Status Code set for the Purchase Order. The Status code is used to indicate where if the flow the order si';
            }
            field("PTE SOIStatusDescription"; Rec."PTE SOI Status Text")
            {
                ApplicationArea = All;
            }
            field("PTE SOIDeadline"; Rec."PTE SOI Deadline")
            {
                ApplicationArea = All;
                ToolTip = 'Displays the deadline as set for the current Statuscode - the deadline indicates when the order must be dealt with in the current status.';
            }
            field("PTE SOIResponsible"; Rec."PTE SOI Person Responsible")
            {
                ApplicationArea = All;
                ToolTip = 'Displays who is responsible for the Purchase Order (in the current status)';
            }
            field("PTE SOI_Received"; PTE_PVS_Is_Recieved(Rec))
            {
                ApplicationArea = All;
                Caption = 'Received';
            }
            field("PTE SOIOrderPlanner"; Rec."PTE SOI Coordinator")
            {
                ApplicationArea = All;
                ToolTip = 'Displays who is the coordinator on the PrintVis case, if such is linked to the Purchase Order.';
            }
            field("PTE SOIProductionOrderNo"; PTE_PVS_Get_Production_Order())
            {
                ApplicationArea = All;
                Caption = 'Production Order No.';
            }
            field("PTE SOIPayToAddress"; Rec."Pay-to Address")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("PTE SOIPayToCity"; Rec."Pay-to City")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("PTE SOISellToCustomerNo"; Rec."Sell-to Customer No.")
            {
                ApplicationArea = All;
            }
            field("PTE SOIOrderType"; Rec."PTE SOI P-Order Type")
            {
                ApplicationArea = All;
            }
            field("PTE SOIAmount"; Rec.Amount)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            group("PTE SOIPrintVis")
            {
                Caption = 'PrintVis';
                action("PTE SOIChangeStatus")
                {
                    ApplicationArea = All;
                    Caption = 'Change Status';
                    Enabled = false;
                    Image = ChangeStatus;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Change to next status';
                    Visible = false;

                    trigger OnAction()
                    begin
                        xRec."PTE SOI Status Code" := Rec."PTE SOI Status Code";
                        // RETTES NVKS.Salgshoved_SkiftTilNæsteStatus(Rec,TRUE);
                    end;
                }
                action("PTE SOIApprovePurchase")
                {
                    ApplicationArea = All;
                    Caption = 'Approve Purchase';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
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
                action("PTE SOIUserFields")
                {
                    ApplicationArea = All;
                    Caption = 'User Fields';
                    Image = PeriodStatus;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'User Fields';

                    trigger OnAction()
                    var
                        UserFieldMgt: Codeunit "PVS Userfield Management";
                    begin
                        UserFieldMgt.Form_Userfield_Edit(38, 0, '', Rec."No.", 0, 0, 0, 0, 0);
                    end;
                }
                action("PTE SOILog")
                {
                    ApplicationArea = All;
                    Caption = 'Log';
                    Image = History;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Log';

                    trigger OnAction()
                    var
                        Log_Management: Codeunit "PVS Change Log Management";
                    begin
                        Log_Management.Show_Log_PurchaseHeader(Rec);
                    end;
                }
                action("PTE SOIVendor")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor';
                    Image = Vendor;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Vendor Card";
                    RunPageLink = "No." = field("Buy-from Vendor No.");
                    ToolTip = 'Vendor Card';
                }
                action("PTE SOIUpdate")
                {
                    ApplicationArea = All;
                    Caption = 'Update';
                    Image = Refresh;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Refresh Screen';

                    trigger OnAction()
                    begin
                        CurrPage.Update(false);
                    end;
                }
                action("PTE SOIPrint")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Order List';
                    Image = "Report";
                    ToolTip = 'Purchase Order List';

                    trigger OnAction()
                    var
                        PH: Record "Purchase Header";
                        NVS_ObjectManager: Codeunit "PVS Custom Objects Management";
                    begin
                        PH.CopyFilters(Rec);
                        NVS_ObjectManager.Report_Run_PurchaseOrder_List(PH);
                    end;
                }
            }
            group("PTE SOIFilter")
            {
                Caption = 'Filter';
                action("PTE SOIShowAll")
                {
                    ApplicationArea = All;
                    Caption = 'Show All';
                    Enabled = PTE_PVS_ShowAllEnabled;
                    Image = ShowList;
                    ToolTip = 'Show All';

                    trigger OnAction()
                    begin
                        PTE_PVS_Is_Use_Filter := true;
                        PTE_PVS_SET_FILTER();
                    end;
                }
                action("PTE SOIShowFiltered")
                {
                    ApplicationArea = All;
                    Caption = 'Show Filtered';
                    Enabled = PTE_PVS_ShowFilterEnabled;
                    Image = ShowSelected;
                    ToolTip = 'Show Filtered';

                    trigger OnAction()
                    begin
                        PTE_PVS_Is_Use_Filter := false;
                        PTE_PVS_SET_FILTER();
                    end;
                }
                separator("PTE Action6010062")
                {
                }
                action("PTE SOIResponsibleAction")
                {
                    ApplicationArea = All;
                    Caption = 'Responsible';
                    Enabled = PTE_PVS_ShowResponsible;
                    Image = Employee;
                    ToolTip = 'Responsible';

                    trigger OnAction()
                    begin
                        PTE_PVS_Show_What := PTE_PVS_Show_What::Responsible;
                        PTE_PVS_SET_FILTER();
                    end;
                }
                action("PTE SOICoordinator")
                {
                    ApplicationArea = All;
                    Caption = 'Coordinator';
                    Enabled = PTE_PVS_ShowOrderManager;
                    Image = Employee;
                    ToolTip = 'Order Planner';

                    trigger OnAction()
                    begin
                        PTE_PVS_Show_What := PTE_PVS_Show_What::Coordinator;
                        PTE_PVS_SET_FILTER();
                    end;
                }
                action("PTE SOIPurchaser")
                {
                    ApplicationArea = All;
                    Caption = 'Purchaser';
                    Enabled = PTE_PVS_ShowPurchaser;
                    Image = Employee;
                    ToolTip = 'Purchaser';

                    trigger OnAction()
                    begin
                        PTE_PVS_Show_What := PTE_PVS_Show_What::Purchaser;
                        PTE_PVS_SET_FILTER();
                    end;
                }
            }
        }
    }

    var
        PTE_SOIntProdOrderMgt: Codeunit "PTE SOI SOint Prod Order Mgt";
        PTE_PVS_StatusRec: Record "PVS Status Code";
        PTE_PVS_SetupRec: Record "PVS General Setup";
        PTE_PVS_UserSetupRec: Record "PVS User Setup";
        PTE_PVS_Show_What: Option Responsible,Coordinator,Purchaser;
        PTE_PVS_Filter_Code: Code[50];
        PTE_PVS_Is_Use_Filter: Boolean;
        PTE_PVS_ShowAllEnabled: Boolean;
        PTE_PVS_ShowFilterEnabled: Boolean;
        PTE_PVS_ShowResponsible: Boolean;
        PTE_PVS_ShowOrderManager: Boolean;
        PTE_PVS_ShowPurchaser: Boolean;
        PTE_PVS_APPROVE_PURCHASEVisible: Boolean;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetSecurityFilterOnRespCenter;

    JobQueueActive := PurchasesPayablesSetup.JobQueueActive;

    CopyBuyFromVendorFilter;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..5

    // Printvis
    PVS_EXTOnOpenPage;
    // Printvis
    */
    //end;

    procedure PTE_PVS_Is_Production_Order(): Boolean
    var
        SaleslineRec_Temp: Record "Sales Line" temporary;
    begin
        PTE_SOIntProdOrderMgt.READ_Tmp_Saleslines(SaleslineRec_Temp, Rec."Document Type", Rec."No.");
        SaleslineRec_Temp.SetFilter("PVS ID", '<>0');
        exit(SaleslineRec_Temp.FindFirst());
    end;

    procedure PTE_PVS_Get_Production_Order(): Text[250]
    var
        OrderRec: Record "PVS Case";
        SaleslineRec_Temp: Record "Sales Line" temporary;
        Txt: Text[250];
    begin
        PTE_SOIntProdOrderMgt.READ_Tmp_Saleslines(SaleslineRec_Temp, Rec."Document Type", Rec."No.");
        SaleslineRec_Temp.SetFilter("PVS ID", '<>0');
        if not SaleslineRec_Temp.FindFirst() then
            exit('');

        repeat
            if OrderRec.Get(SaleslineRec_Temp."PVS ID") then
                Txt := Txt + ' ' + OrderRec."Order No.";
        until SaleslineRec_Temp.Next() = 0;

        exit(Txt);
    end;

    procedure PTE_PVS_Get_Next_Status(var KH: Record "Purchase Header"): Code[20]
    begin
        exit(PTE_PVS_StatusRec.Get_Next_Status(0, KH."PTE SOI Status Code", KH."PTE SOI P-Order Type", '', ''));
    end;

    procedure PTE_PVS_Is_Recieved(var KH: Record "Purchase Header"): Boolean
    var
        KL: Record "Purchase Line";
    begin
        KL.SetRange("Document Type", KH."Document Type");
        KL.SetRange("Document No.", KH."No.");
        KL.SetRange(Type, 2);
        KL.SetFilter("Outstanding Qty. (Base)", '<>0');
        if KL.FindFirst() then
            exit(false)
        else
            exit(true);
    end;

    procedure PTE_PVS_Get_User_Setup()
    var
        PVS_SingleInstance: Codeunit "PVS SingleInstance";
    begin
        if not PVS_SingleInstance.Get_UserSetupRec(PTE_PVS_UserSetupRec) then
            exit;
    end;

    procedure PTE_PVS_SET_FILTER()
    var
        PVS_SingleInstance: Codeunit "PVS SingleInstance";
        PurchaseHeader: Record "Purchase Header";
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
        Rec.SetRange("Purchaser Code");
        Rec.SetRange("PTE SOI Person Responsible");
        Rec.SetRange("PTE SOI Status Code");

        case PTE_PVS_Show_What of
            0:
                Rec.SetCurrentkey("PTE SOI Person Responsible", "PTE SOI Deadline");
            1:
                Rec.SetCurrentkey("PTE SOI Coordinator", "PTE SOI Deadline");
            2:
                Rec.SetCurrentkey("Purchaser Code", "PTE SOI Deadline");
            3:
                Rec.SetCurrentkey("PTE SOI Status Code", "PTE SOI Deadline");
        end;

        if PTE_PVS_Filter_Code = '' then
            exit;

        case PTE_PVS_Show_What of
            0:
                begin
                    PTE_PVS_UserSetupRec.Get(PTE_PVS_Filter_Code);
                    if PTE_PVS_UserSetupRec."Responsibility Areas" = '' then
                        PTE_PVS_UserSetupRec."Responsibility Areas" := PTE_PVS_Filter_Code;
                    Rec.SetFilter("PTE SOI Person Responsible", ConvertStr(PTE_PVS_UserSetupRec."Responsibility Areas", ',', '|'));

                    PTE_PVS_ShowResponsible := false;
                    PTE_PVS_ShowOrderManager := true;
                    PTE_PVS_ShowPurchaser := true;
                end;
            1:
                begin
                    Rec.SetRange("PTE SOI Coordinator", PTE_PVS_Filter_Code);
                    PTE_PVS_ShowResponsible := true;
                    PTE_PVS_ShowOrderManager := false;
                    PTE_PVS_ShowPurchaser := true;
                end;
            2:
                begin
                    if PTE_PVS_UserSetupRec."Salesperson Code" <> '' then
                        PTE_PVS_Filter_Code := PTE_PVS_UserSetupRec."Salesperson Code";
                    Rec.SetRange("Purchaser Code", CopyStr(PTE_PVS_Filter_Code, 1, MaxStrLen(Rec."Purchaser Code")));
                    PTE_PVS_ShowResponsible := true;
                    PTE_PVS_ShowOrderManager := true;
                    PTE_PVS_ShowPurchaser := false;
                end;
            3:
                begin
                    Rec.SetRange("PTE SOI Status Code", PTE_PVS_Filter_Code);
                    PTE_PVS_ShowResponsible := true;
                    PTE_PVS_ShowOrderManager := true;
                    PTE_PVS_ShowPurchaser := true;
                end;
        end;

        if StrLen(PTE_PVS_Filter_Code) <= MaxStrLen(PurchaseHeader."On Hold") then begin
            PurchaseHeader.Reset();
            if PurchaseHeader.SetCurrentkey("On Hold") then;
            PurchaseHeader.SetFilter("On Hold", PTE_PVS_Filter_Code);
            PTE_PVS_APPROVE_PURCHASEVisible := PurchaseHeader.FindFirst();
        end else
            PTE_PVS_APPROVE_PURCHASEVisible := false;

        if NAVuserSetup.Get(UserId) then
            if NAVuserSetup."Purchase Resp. Ctr. Filter" <> '' then
                if NAVresponsCntr.Get(NAVuserSetup."Purchase Resp. Ctr. Filter") then
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