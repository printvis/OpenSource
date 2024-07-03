PageExtension 80120 "PTE SOI S. Invoice Sub" extends "Sales Invoice Subform" //"PVS pageextension6010140"
{
    actions
    {
        addlast("&Line")
        {
            group("PTE SOI PrintVisI")
            {
                Caption = 'PrintVis';
                Image = DisableAllBreakpoints;
                ToolTip = 'PrintVis';
                action("PTE SOI ProductionOrder")
                {
                    ApplicationArea = All;
                    Caption = 'Production Order';
                    Image = SpecialOrder;
                    ToolTip = 'Production Order';

                    trigger OnAction()
                    begin
                        PTE_SalesorderMgt.Salesline_Call_Form_Order(Rec);
                    end;
                }
                action("PTE SOI JobCosting")
                {
                    ApplicationArea = All;
                    Caption = 'Job Costing';
                    Image = Statistics;
                    RunObject = Page "PVS Job Costing Totals";
                    RunPageLink = "Entry No." = field("PVS ID");
                    ToolTip = 'Job Costing';

                    trigger OnAction()
                    begin
                        PTE_SalesorderMgt.Salesline_Call_Form_Job(Rec);
                    end;
                }
            }
        }
    }

    var
        PTE_PVS_SalesorderMgt: Codeunit "PVS Salesorder Management";
        PTE_SalesorderMgt: Codeunit "PTE SOI S.O. Mgt";
        PTE_PVS_Estimate_Quantity: Decimal;
        PTE_PVS_Estimate_Hours: Decimal;
        PTE_PVS_Estimate_Cost: Decimal;
        PTE_PVS_Estimate_MarkUp: Decimal;
        PTE_PVS_Estimate_Sale: Decimal;
        PTE_PVS_Actual_Quantity: Decimal;
        PTE_PVS_Actual_Hours: Decimal;
        PTE_PVS_Actual_Cost: Decimal;
        PTE_PVS_Actual_MarkUp: Decimal;
        PTE_PVS_Actual_Sale: Decimal;
        PTE_PVS_Actual_Invoiced: Decimal;


    trigger OnAfterGetRecord()
    begin
        PTE_PVS_SalesorderMgt.Salesline_Calculate_Job_Values(Rec, PTE_PVS_Estimate_Quantity, PTE_PVS_Estimate_Hours, PTE_PVS_Estimate_Cost, PTE_PVS_Estimate_MarkUp, PTE_PVS_Estimate_Sale, PTE_PVS_Actual_Quantity, PTE_PVS_Actual_Hours, PTE_PVS_Actual_Cost, PTE_PVS_Actual_MarkUp, PTE_PVS_Actual_Sale,
        PTE_PVS_Actual_Invoiced);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        PTE_PVS_SalesorderMgt.Salesline_Calculate_Job_Values(Rec, PTE_PVS_Estimate_Quantity, PTE_PVS_Estimate_Hours, PTE_PVS_Estimate_Cost, PTE_PVS_Estimate_MarkUp, PTE_PVS_Estimate_Sale, PTE_PVS_Actual_Quantity, PTE_PVS_Actual_Hours, PTE_PVS_Actual_Cost, PTE_PVS_Actual_MarkUp, PTE_PVS_Actual_Sale,
        PTE_PVS_Actual_Invoiced);
    end;
}

