PageExtension 80123 "PTE SOI S.O. Subform" extends "Sales Order Subform" //"PVS pageextension6010139"
{
    layout
    {
        addafter(Quantity)
        {
            field("PTE SOI ID"; Rec."PVS ID")
            {
                ApplicationArea = All;
                ToolTip = 'Displays which PrintVis Case ID is linked to the current Line (if any).';
            }
            field("PTE SOI ProductionOrder"; Rec."PTE SOI Production Order")
            {
                ApplicationArea = All;
                ToolTip = 'Displays if the current purchase line is linked to a specific PrintVis Case.';

                trigger OnValidate()
                begin
                    PTE_PVS_Display();
                end;
            }
            field("PTE SOI ProductGroup"; Rec."PVS Product Group Code")
            {
                ApplicationArea = All;
                ToolTip = 'Displays which PrintVis Product Group, the line is linked to, if any.';
                Visible = false;
            }
            field("PTE SOI Job"; Rec."PVS Job")
            {
                ApplicationArea = All;
                ToolTip = 'Displays which PrintVis Case Job number is linked to the current Line (if any).';
                Visible = false;
            }
            field("PTE SOI_ID_Text"; PTE_PVS_SalesorderMgt.Salesline_ID1_OnFormat(Rec, PTE_PVS_DummyText))
            {
                ApplicationArea = All;
                captionclass = Rec.FIELDCAPTION("PVS ID");
                Visible = false;
            }
            field("PTE SOI PageUnit"; Rec."PTE SOI Page Unit")
            {
                ApplicationArea = All;
                ToolTip = 'Displays how to count the pages - either as; Pages w. print, leafs (sheets) or as Total Pages';
                Visible = false;
            }
            field("PTE SOI Pages"; Rec."PTE SOI Pages")
            {
                ApplicationArea = All;
                CaptionClass = PTE_CFIMgt.GetCaption(0, Enum::"PVS CFI"::Pages);
                ToolTip = 'Displays the No. of Pages (matter) of the product, as set on the PrintVis Case linked to the line.';
                Visible = false;
            }
            field("PTE SOI FormatCode"; Rec."PTE SOI Format Code")
            {
                ApplicationArea = All;
                CaptionClass = PTE_CFIMgt.GetCaption(0, Enum::"PVS CFI"::FormatCode);
                ToolTip = 'Displays the size of the product, as set on the PrintVis Case linked to the line.';
                Visible = false;
            }
            field("PTE SOI ColorsFront"; Rec."PTE SOI Colors Front")
            {
                ApplicationArea = All;
                CaptionClass = PTE_CFIMgt.GetCaption(0, Enum::"PVS CFI"::ColorsFront);
                ToolTip = 'Displays the Colors Front on the product, as set on the PrintVis Case linked to the line.';
                Visible = false;
            }
            field("PTE SOI ColorsBack"; Rec."PTE SOI Colors Back")
            {
                ApplicationArea = All;
                CaptionClass = PTE_CFIMgt.GetCaption(0, Enum::"PVS CFI"::ColorsBack);
                ToolTip = 'Displays the Colors Back on the product, as set on the PrintVis Case linked to the line.';
                Visible = false;
            }
            field("PTE SOI Paper"; Rec."PTE SOI Paper")
            {
                ApplicationArea = All;
                CaptionClass = PTE_CFIMgt.GetCaption(0, Enum::"PVS CFI"::Paper);
                ToolTip = 'Displays the Paper item No. for the product, as set on the PrintVis Case linked to the line.';
                Visible = false;
            }
            field("PTE SOI UnchangedRePrint"; Rec."PTE SOI Unchanged Reprint")
            {
                ApplicationArea = All;
                ToolTip = 'Displays if the linked PrintVis Case is marked as ''Unchanged Reissue''';
                Visible = false;
            }
            field("PTE SOI PriceProductionOrder"; Rec."PTE SOI Price Production Order")
            {
                ApplicationArea = All;
                ToolTip = 'Displays the Estimated Price for the product, as set on the PrintVis Case linked to the line.';
                Visible = false;
            }
            field("PTE SOI QuantityOrder"; Rec."PTE SOI Qty. Order")
            {
                ApplicationArea = All;
                ToolTip = 'n/a, deprecated';
                Visible = false;
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
                Image = DisableAllBreakpoints;
                ToolTip = 'PrintVis';
                action("PTE SOI ProductionOrderAction")
                {
                    ApplicationArea = All;
                    Caption = 'Production Order';
                    Image = SpecialOrder;
                    ToolTip = 'Production Order';

                    trigger OnAction()
                    var
                        PVSSingleInstance: Codeunit "PVS SingleInstance";
                        SalesorderManagement: Codeunit "PTE SOI S.O. Mgt";
                    begin
                        if not PVSSingleInstance.Is_PrintVis_Active() then
                            exit;

                        SalesorderManagement.Salesline_Call_Form_Order(Rec);
                    end;
                }
                action("PTE SOI JobAction")
                {
                    ApplicationArea = All;
                    Caption = 'Job';
                    Image = Job;
                    ToolTip = 'Job';

                    trigger OnAction()
                    var
                        PVSSingleInstance: Codeunit "PVS SingleInstance";
                        SalesorderManagement: Codeunit "PTE SOI S.O. Mgt";
                    begin
                        if not PVSSingleInstance.Is_PrintVis_Active() then
                            exit;

                        SalesorderManagement.Salesline_Call_Form_Job(Rec);
                    end;
                }
                action("PTE SOI Estimation")
                {
                    ApplicationArea = All;
                    Caption = 'Estimation';
                    Image = Questionaire;
                    ShortCutKey = 'Alt+F9';
                    ToolTip = 'Estimation';

                    trigger OnAction()
                    var
                        PVSSingleInstance: Codeunit "PVS SingleInstance";
                        SalesorderManagement: Codeunit "PTE SOI S.O. Mgt";
                    begin
                        if not PVSSingleInstance.Is_PrintVis_Active() then
                            exit;

                        SalesorderManagement.Salesline_Call_Form_Est(Rec);
                    end;
                }
                action("PTE SOI Milestone")
                {
                    ApplicationArea = All;
                    Caption = 'Milestone';
                    Image = ExpandDepositLine;
                    ToolTip = 'Milestone';

                    trigger OnAction()
                    var
                        PVSSingleInstance: Codeunit "PVS SingleInstance";
                        SalesorderManagement: Codeunit "PTE SOI S.O. Mgt";
                    begin
                        if not PVSSingleInstance.Is_PrintVis_Active() then
                            exit;

                        SalesorderManagement.Salesline_Call_Form_Milestones(Rec);
                    end;
                }
                action("PTE SOI CopyProductionOrder")
                {
                    ApplicationArea = All;
                    Caption = 'Copy Production Order';
                    Image = CopyBudget;
                    ToolTip = 'Copy Production Order';

                    trigger OnAction()
                    var
                        PVSSingleInstance: Codeunit "PVS SingleInstance";
                        SalesorderManagement: Codeunit "PTE SOI S.O. Mgt";
                    begin
                        if not PVSSingleInstance.Is_PrintVis_Active() then
                            exit;

                        SalesorderManagement.Salesline_CopyProductionOrder(Rec);
                    end;
                }
                separator("PTE Action6010081")
                {
                }
                action("PTE SOI ItemCard")
                {
                    ApplicationArea = All;
                    Caption = 'Item Card';
                    Image = Item;
                    ToolTip = 'Item Card';

                    trigger OnAction()
                    var
                        PVSSingleInstance: Codeunit "PVS SingleInstance";
                        PVSSalesorderManagement: Codeunit "PVS Salesorder Management";
                    begin
                        if not PVSSingleInstance.Is_PrintVis_Active() then
                            exit;

                        PVSSalesorderManagement.Salesline_Call_Form_Item_Card(Rec);
                    end;
                }
                separator("PTE Action6010056")
                {
                }
                action("PTE SOI FreightRates")
                {
                    ApplicationArea = All;
                    Caption = 'Freight Rates';
                    Image = CalculateShipment;
                    RunObject = Page "PVS Customer Info";
                    RunPageLink = Type = const("Freight Contracts");
                    ToolTip = 'Freight Rates';
                }
                action("PTE SOI NoSeries")
                {
                    ApplicationArea = All;
                    Caption = 'No. Series';
                    Image = SerialNo;
                    ToolTip = 'No. Series';

                    trigger OnAction()
                    var
                        PVSSingleInstance: Codeunit "PVS SingleInstance";
                        PVSPageManagement: Codeunit "PVS Page Management";
                    begin
                        if not PVSSingleInstance.Is_PrintVis_Active() then
                            exit;

                        PVSPageManagement.Call_Number_Series_Salesline(Rec);
                    end;
                }
            }
        }
    }

    var
        PTE_CFIMgt: Codeunit "PVS CFI Mgt";
        PTE_PVS_DummyText: Text[1024];
        PTE_PVS_SalesorderMgt: Codeunit "PVS Salesorder Management";

    local procedure PTE_PVS_Display()
    begin
        CurrPage.Update(true);
    end;

}