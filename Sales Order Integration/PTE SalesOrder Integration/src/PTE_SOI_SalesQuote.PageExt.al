PageExtension 80125 "PTE SOI S. Quote" extends "Sales Quote" //"PVS pageextension6010135"
{
    layout
    {
        modify(SalesLines)
        {
            Visible = not PTE_PVS_ShowLinesWithPVS;
        }
        addafter("Assigned User ID")
        {
            field("PTE SOI POrderType"; Rec."PTE SOI Order Type Code")
            {
                ApplicationArea = All;
                Caption = 'Order Type';
                ToolTip = 'Displays the selected OrderType for the attached PrintVis Case - if not filled in you may select an Ordertype from a LookUp in the field.';

                trigger OnValidate()
                begin
                    // PrintVis ***
                    PTE_PVS_POrderTypeOnAfterValidate();
                    // PrintVis ***
                end;
            }
            field("PTE SOI StatusCode"; Rec."PTE SOI Status Code")
            {
                ApplicationArea = All;
                Editable = PTE_PVS_StatusCodeEDITABLE;
                Importance = Promoted;
                ToolTip = 'Displays the selected Status Code for the attached PrintVis Case - if not filled in you may select an Status Code from a LookUp in the field.';

                trigger OnValidate()
                begin
                    // PrintVis ***
                    PTE_PVS_StatusCodeOnAfterValidate();
                    // PrintVis ***
                end;
            }
            field("PTE SOI ManualResponsible"; Rec."PTE SOI Manual Responsible")
            {
                ApplicationArea = All;
                ToolTip = 'If the current responsible person has been modified manually, this field will be ticked to indicate so.';
            }
            field("PTE SOI PersonResponsible"; Rec."PTE SOI Person Responsible")
            {
                ApplicationArea = All;
                Editable = PTE_PVS_PersonResponsibleEDITABLE;
                Importance = Promoted;
                ToolTip = 'Displays the set current ''responsible person'' from the attached PrintVis Case, due to the current status.';

                trigger OnValidate()
                begin
                    // PRINTVIS ***
                    PTE_PVS_PersonResponsibleOnAfterVal();
                    // PRINTVIS ***
                end;
            }
            field("PTE SOI Deadline"; Rec."PTE SOI Deadline")
            {
                ApplicationArea = All;
                ToolTip = 'Displays the set deadline from the attached PrintVis Case, due to the current status and when it was changed.';
            }
        }
        addafter(Status)
        {
            field("PTE SOI_NextStatus"; PTE_SalesorderMgt.SalesHead_Get_Next_StatusTxt(Rec))
            {
                ApplicationArea = All;
                AssistEdit = false;
                Caption = 'Next Status';
                DrillDown = false;
                Lookup = false;
            }
            field("PTE SOI_Comments"; PTE_SalesorderMgt.Get_Page_Comments_Salesorder(Rec))
            {
                ApplicationArea = All;
                Caption = 'Comments';
                Editable = false;
                Importance = Additional;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    PTE_PVS_PageMgt.Call_Page_SalesOrder_Comments(Rec."Document Type".AsInteger(), Rec."No.");
                end;
            }
        }
        addafter(SalesLines)
        {
            part("PTE SOI_SalesLinesWithPVS"; "Sales Quote Subform")
            {
                ApplicationArea = Basic, Suite;
                Editable = Rec."Sell-to Customer No." <> '';
                Enabled = Rec."Sell-to Customer No." <> '';
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
                Visible = PTE_PVS_ShowLinesWithPVS;
            }
        }
        addafter(BillToOptions)
        {
            field("PTE SOI EndUserContact"; Rec."PVS End User Contact")
            {
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    // PRINTVIS ***
                    PTE_PVS_EndUserContactOnAfterValida();
                    // PRINTVIS ***
                end;
            }
            field("PTE SOI EndUserContactName"; Rec."PVS End User Contact Name")
            {
                ApplicationArea = All;
                Importance = Promoted;
            }
        }
    }
    actions
    {
        addfirst(Navigation)
        {
            group("PTE SOI PrintVis")
            {
                Caption = 'PrintVis';
                ToolTip = 'PrintVis';
                action("PTE SOI CustomerSale")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Sale';
                    Image = CustomerGroup;
                    ToolTip = 'Customer Sale';

                    trigger OnAction()
                    begin
                        PTE_PVS_SalesorderMgt.SalesHead_Form_Customer_Lines(Rec);
                        CurrPage.Update(false);
                    end;
                }
                separator("PTE Action6010056")
                {
                    Caption = 'PVS_SEPERATOR_II';
                }
                action("PTE SOI FreigthRates")
                {
                    ApplicationArea = All;
                    Caption = 'Freigth Rates';
                    Image = CalculateShipment;
                    RunObject = Page "PVS Customer Info";
                    RunPageLink = Type = const("Freight Contracts");
                    ToolTip = 'Freigth Rates';
                }
            }
        }
        addlast(processing)
        {
            action("PTE SOI ChangeStatus")
            {
                ApplicationArea = All;
                Caption = 'Change Status';
                Image = ChangeStatus;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Change to next status';

                trigger OnAction()
                begin
                    PTE_SalesorderMgt.SalesHead_Change_Next_Status(Rec, true);
                end;
            }

            action("PTE SOI Userfields")
            {
                ApplicationArea = All;
                Caption = 'Userfields';
                Image = PeriodStatus;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Userfields';

                trigger OnAction()
                var
                    UserFieldMgt: Codeunit "PVS Userfield Management";
                begin
                    UserFieldMgt.Form_Userfield_Edit(36, 0, '', Rec."No.", 0, 0, 0, 0, 0);
                end;
            }
        }
    }

    var
        PTE_PVS_PageMgt: Codeunit "PVS Page Management";
        PTE_SalesorderMgt: Codeunit "PTE SOI S.O. Mgt";
        PTE_PVS_SalesorderMgt: Codeunit "PVS Salesorder Management";
        PTE_PVS_SingleInstance: Codeunit "PVS SingleInstance";
        PTE_PVS_UserSetupRec: Record "PVS User Setup";
        PTE_PVS_StatusCodeEDITABLE: Boolean;
        PTE_PVS_PersonResponsibleEDITABLE: Boolean;
        PTE_PVS_ShowLinesWithPVS: Boolean;


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ActivateFields;
    SetControlAppearance;
    WorkDescription := GetWorkDescription;
    UpdateShipToBillToGroupVisibility;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4

    // PrintVis ***
    PVS_EXTOnAfterGetRecord
    // PrintVis ***
    */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF UserMgt.GetSalesFilter <> '' THEN BEGIN
      FILTERGROUP(2);
      SETRANGE("Responsibility Center",UserMgt.GetSalesFilter);
    #4..10
    SetControlAppearance;
    IsSaaS := PermissionManager.SoftwareAsAService;
    PaymentServiceVisible := PaymentServiceSetup.IsPaymentServiceVisible;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..13

    // PrintVis ***
    PVS_EXTOnOpenPage;
    // PrintVis ***
    */
    //end;

    procedure PVS_Refresh()
    var
        PVS_Global: Codeunit "PVS Global";
    begin
        if not PVS_Global.Use_PrintVis() then
            exit;

        Rec.CalcFields("PTE SOI Coordinator Name", "PTE SOI Person Respon. Name", "PTE SOI Status Text");
        Rec.CalcFields("PTE SOI Next Status", "PTE SOI Order Type Description", "PVS Rejection Text");
    end;

    local procedure PTE_PVS_StatusCodeOnAfterValidate()
    begin
        CurrPage.Update(false);
        PVS_Refresh();
    end;

    local procedure PTE_PVS_POrderTypeOnAfterValidate()
    begin
        PVS_Refresh();
    end;

    local procedure PTE_PVS_PersonResponsibleOnAfterVal()
    begin
        PVS_Refresh();
    end;

    local procedure PTE_PVS_EndUserContactOnAfterValida()
    begin
        Rec.CalcFields("PVS End User Contact Name");
    end;

    trigger OnOpenPage()
    var
        PVS_Global: Codeunit "PVS Global";
    begin
        if not PVS_Global.Use_PrintVis() then
            exit;

        if PTE_PVS_SingleInstance.Get_UserSetupRec(PTE_PVS_UserSetupRec) then begin
            PTE_PVS_StatusCodeEDITABLE := PTE_PVS_UserSetupRec."Manual Status Change Allowed";
            PTE_PVS_PersonResponsibleEDITABLE := PTE_PVS_UserSetupRec."Manual Responsible Allowed";
        end;
    end;

}