page 75200 "PTE PVS FG Valuation List"
{
    ApplicationArea = All;
    Caption = 'PTE PVS Finished Goods Valuation List';
    PageType = List;
    Editable = true;
    SourceTable = "PTE PVS FG Valuation";
    InsertAllowed = false;
    DeleteAllowed = true;
    UsageCategory = Tasks;
    AdditionalSearchTerms = 'PVS Finished Goods Output';
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("PVS ID"; Rec."PVS ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Level; Rec.Level)
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Quantity Output"; Rec."Quantity Output")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(ValuationShouldBeDecG; ValuationShouldBeDecG)
                {
                    Editable = false;
                    caption = 'Valuation';
                    ApplicationArea = All;
                }
                field(CurrentValueDecG; CurrentValueDecG)
                {
                    Editable = false;
                    caption = 'Current Valuation';
                    ApplicationArea = All;
                }
                field(GDecDirectCostMat; GDecDirectCostMatG)
                {
                    Caption = 'Actual Direct Cost';
                    Visible = false;
                    BlankZero = true;
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        LRecPVJobCosting: Record "PVS Job Costing Entry";
                    begin
                        LRecPVJobCosting.SetCurrentKey(
                          //ID, "SemiFinished Released", "Batch Code", "Tabel ID", Type, "Calculation Unit Sorting No.", "Unit of Measure", Overtime
                          ID, "Table ID", UOM, Overtime
                        );
                        LRecPVJobCosting.SETRANGE(ID, Rec."PVS ID");
                        LRecPVJobCosting.SETRANGE(Type, LRecPVJobCosting.Type::Cost);
                        LRecPVJobCosting.SETRANGE("Table ID", 17, 32);
                        PAGE.RUNMODAL(0, LRecPVJobCosting);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        LRecPVJobCosting: Record "PVS Job Costing Entry";
                    begin
                        LRecPVJobCosting.SetCurrentKey(
                          ID, "Table ID", UOM, Overtime
                        );
                        LRecPVJobCosting.SETRANGE(ID, Rec."PVS ID");
                        LRecPVJobCosting.SETRANGE(Type, LRecPVJobCosting.Type::Cost);
                        LRecPVJobCosting.SETRANGE("Table ID", 17, 32);
                        PAGE.RUNMODAL(0, LRecPVJobCosting);
                    end;
                }
                field(GDecDirectCostLabor; GDecDirectCostLaborG)
                {
                    Caption = 'Labor Cost';
                    Visible = false;
                    BlankZero = true;
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        LRecPVJobCosting: Record "PVS Job Costing Entry";
                    begin
                        LRecPVJobCosting.RESET;
                        LRecPVJobCosting.SetCurrentKey(
                        ID, "Table ID", UOM, Overtime
                        );
                        LRecPVJobCosting.SETRANGE(ID, Rec."PVS ID");
                        LRecPVJobCosting.SETRANGE(Type, LRecPVJobCosting.Type::Cost);
                        LRecPVJobCosting.SETRANGE("Table ID", 6010325);
                        PAGE.RUNMODAL(0, LRecPVJobCosting);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        LRecPVJobCosting: Record "PVS Job Costing Entry";
                    begin
                        LRecPVJobCosting.RESET;
                        LRecPVJobCosting.SetCurrentKey(
                        ID, "Table ID", UOM, Overtime
                        );
                        LRecPVJobCosting.SETRANGE(ID, Rec."PVS ID");
                        LRecPVJobCosting.SETRANGE(Type, LRecPVJobCosting.Type::Cost);
                        LRecPVJobCosting.SETRANGE("Table ID", 6010325);
                        PAGE.RUNMODAL(0, LRecPVJobCosting);
                    end;
                }
                field(GDecDirectTotalSelfCost; GDecDirectTotalSelfCostG)
                {
                    Caption = 'Total Cost (with Overhead)';
                    BlankZero = true;
                    Visible = false;
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        LRecPVJobCosting: Record "PVS Job Costing Entry";
                    begin
                        LRecPVJobCosting.RESET;
                        LRecPVJobCosting.SetCurrentKey(
                        ID, "Table ID", UOM, Overtime
                        );
                        LRecPVJobCosting.SETRANGE(ID, Rec."PVS ID");
                        LRecPVJobCosting.SETRANGE(Type, LRecPVJobCosting.Type::Cost);
                        //LRecPVJobCosting.SETRANGE("Batch Code", Batch);
                        LRecPVJobCosting.SETRANGE("Table ID", 6010325);
                        PAGE.RUNMODAL(0, LRecPVJobCosting);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        LRecPVJobCosting: Record "PVS Job Costing Entry";
                    begin
                        LRecPVJobCosting.RESET;
                        LRecPVJobCosting.SetCurrentKey(
                        ID, "Table ID", UOM, Overtime
                        );
                        LRecPVJobCosting.SETRANGE(ID, Rec."PVS ID");
                        LRecPVJobCosting.SETRANGE(Type, LRecPVJobCosting.Type::Cost);
                        //LRecPVJobCosting.SETRANGE("Batch Code", Batch);
                        LRecPVJobCosting.SETRANGE("Table ID", 6010325);
                        PAGE.RUNMODAL(0, LRecPVJobCosting);
                    end;
                }

                field("Cost is Adjusted"; Rec."Cost is Adjusted")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Line adjutement")
            {
                Image = Calculate;
                ShortCutKey = 'Shift+F8';
                ApplicationArea = All;

                trigger OnAction()
                var
                    LCduPVInvMngt: Codeunit "PTE PVS FG Valuation Mngt.";
                    LWin: Dialog;
                    ProcessingLabelL: Label 'Processing...';
                begin
                    LWin.OPEN(ProcessingLabelL);
                    LCduPVInvMngt.AdjustCostingPVFinishedGood(Rec, true, true);
                    LWin.CLOSE;
                end;
            }
            action("Line adjutement (Working Date)")
            {
                Image = Calculate;
                ApplicationArea = All;

                trigger OnAction()
                var
                    LCduPVInvMngt: Codeunit "PTE PVS FG Valuation Mngt.";
                    LWin: Dialog;
                begin
                    LWin.OPEN('Processing...');
                    LCduPVInvMngt.OutputLineAdjustement(Rec, TRUE);
                    LWin.CLOSE;
                end;
            }
            action("Run Adjustement")
            {
                Image = CalculateCost;
                ApplicationArea = All;

                trigger OnAction()
                var
                    LCduPVInvMngt: Codeunit "PTE PVS FG Valuation Mngt.";
                begin
                    CurrPage.Update();

                    LCduPVInvMngt.RUN;
                end;
            }
            action(CheckCase)
            {
                Image = Check;
                ApplicationArea = All;
                trigger OnAction()
                var
                    PVSCaseRec: Record "PVS Case";
                    PTEPVSFGValMngt: Codeunit "PTE PVS FG Valuation Mngt.";
                begin
                    if Page.RunModal(0, PVSCaseRec) = Action::LookupOK then begin
                        PTEPVSFGValMngt.checkCaseAndCreateValuationEntries(PVSCaseRec.ID);
                    end;

                end;
            }
            action(TestOnly)
            {
                Caption = 'Test only';
                ApplicationArea = All;
                trigger OnAction()
                var
                    szBuffer: Text;
                    char10: Char;
                    char13: char;
                    char9: Char;
                begin
                    char10 := 10;
                    char13 := 13;
                    char9 := 9;
                    szBuffer :=
                    strsubstno('This is a line \ this is line with val: %1 %1 %1 val %2 this is new line with val longer: %1 val', char9, char10);
                    Message(szBuffer);
                end;
            }
        }
        area(navigation)
        {
            action("Item Ledger Entries")
            {
                Image = Entries;
                ApplicationArea = All;
                trigger OnAction()
                var
                    LRecItemLedgerEntries: Record "Item Ledger Entry";
                begin
                    LRecItemLedgerEntries.SETRANGE("PVS ID", Rec."PVS ID");
                    LRecItemLedgerEntries.SETRANGE("Item No.", Rec."Item No.");
                    //LRecItemLedgerEntries.SETRANGE("Batch Code", Batch);
                    LRecItemLedgerEntries.SETRANGE(LRecItemLedgerEntries."Entry Type", LRecItemLedgerEntries."Entry Type"::Purchase);
                    PAGE.RUN(0, LRecItemLedgerEntries);
                end;
            }

            action("Item Card")
            {
                Image = Card;
                ApplicationArea = All;
                trigger OnAction()
                var
                    ItemRecL: Record Item;
                begin
                    if ItemRecL.Get(Rec."Item No.") then begin
                        Page.Run(Page::"Item Card", ItemRecL);
                    end;

                end;
            }

            action("PVS Case Card")
            {
                image = Order;
                ApplicationArea = All;
                trigger OnAction()
                var
                    PVSCaseRecL: Record "PVS Case";
                begin
                    if PVSCaseRecL.Get(Rec."PVS ID") then begin
                        Page.Run(Page::"PVS Case Card", PVSCaseRecL);
                    end;

                end;
            }


        }
    }

    trigger OnAfterGetRecord()
    var
        PVJobCostingRecL: Record "PVS Job Costing Entry";
        SFHFinGoodsMngt: Codeunit "PTE PVS FG Valuation Mngt.";
    begin
        CLEAR(GDecDirectCostLaborG);
        CLEAR(GDecDirectCostMatG);
        CLEAR(GDecDirectTotalSelfCostG);

        PVJobCostingRecL.SetCurrentKey(
        ID, "Table ID", UOM, Overtime
        );
        PVJobCostingRecL.SETRANGE(ID, Rec."PVS ID");
        PVJobCostingRecL.SETRANGE(Type, PVJobCostingRecL.Type::Cost);

        PVJobCostingRecL.CALCSUMS("Total Self Cost");
        GDecDirectTotalSelfCostG := PVJobCostingRecL."Total Self Cost";
        GDecDirectTotalSelfCostG := PVJobCostingRecL."Total Self Cost";
        PVJobCostingRecL.SETRANGE("Table ID", 17, 32);
        PVJobCostingRecL.CALCSUMS("Direct Cost total");
        GDecDirectCostMatG := PVJobCostingRecL."Direct Cost total";
        PVJobCostingRecL.SETRANGE("Table ID", 6010325);
        PVJobCostingRecL.CALCSUMS("Direct Cost total", "Total Self Cost");
        GDecDirectCostLaborG := PVJobCostingRecL."Direct Cost total";

        ValuationShouldBeDecG := SFHFinGoodsMngt.getAmountValueToBePut(rec, Rec."Quantity Output");
        CurrentValueDecG := SFHFinGoodsMngt.getCurrentValuation(Rec);
    end;

    var
        GDecDirectCostMatG: Decimal;
        GDecDirectCostLaborG: Decimal;
        GDecDirectTotalSelfCostG: Decimal;
        GDecDirectTotalSelfCostALLG: Decimal;
        CurrentValueDecG: Decimal;
        ValuationShouldBeDecG: Decimal;
}