codeunit 80260 "PTE PVS FG Valuation Mngt."
{
    trigger OnRun()
    var
        LText001: Label 'Do you want run script to adjust cost of PV Finished goods';
        LText002: Label 'Processing... #1########## \ #2######### \ #3######## \ #4########';
    begin
        if GuiAllowed = true then begin
            if not confirm(LText001) then
                exit;
        end;

        IF GuiAllowed = true then
            GWinP.open(LText002);

        LoopForAdjustCostingPVFinishedGood;

        IF GuiAllowed = true THEN
            GWinP.close;
    end;

    var
        GWinP: Dialog;
        Text001: Label 'Copying...';
        Text002: Label 'Adjusting...';
        Text003: Label 'Getting Level...';
        Text004: Label 'Level %1';

    /* CASE Adjustment call from report and wip function*/
    procedure AdjustCostingPVSCase(IN_CaseRecP: Record "PVS Case")
    var
        PVInvFinishedL: Record "PTE PVS FG Valuation";
    begin
        //Check if at least one non adjusted to avoid non necessary call
        PVInvFinishedL.SetRange("PVS ID", IN_CaseRecP.ID);
        PVInvFinishedL.SetRange("Cost is Adjusted", false);
        if PVInvFinishedL.IsEmpty then
            exit;

        if PVInvFinishedL.FindFirst() then
            repeat
                PVInvFinishedL.CalcFields("Quantity Output");
                AdjustCostingPVFinishedGood(PVInvFinishedL, true, false);
            until PVInvFinishedL.Next() = 0;
    end;

    //Simple assembly case with skip in variance
    procedure AdjustCostingPVSCaseSimple(IN_CaseRecP: Record "PVS Case"): Boolean
    var
        PVInvFinishedL: Record "PTE PVS FG Valuation";
    begin

        //Check if at least one non adjusted to avoid non necessary call
        PVInvFinishedL.SetRange("PVS ID", IN_CaseRecP.ID);
        PVInvFinishedL.SetRange("Cost is Adjusted", false);
        if PVInvFinishedL.IsEmpty then
            exit(true);

        if PVInvFinishedL.Count > 1 then begin
            exit(false);
        end;

        if PVInvFinishedL.FindFirst() then begin
            PVInvFinishedL.CalcFields("Quantity Output");
            AdjustCostingPVFinishedGood(PVInvFinishedL, true, true);
        end;
        exit(true);
    end;

    /* Line Adjustment */
    procedure AdjustCostingPVFinishedGood(var IN_PVInvFinishedP: Record "PTE PVS FG Valuation"; IN_UpdateTableP: Boolean; in_ForceRecalcBoolP: Boolean)
    var
        ItemRecL: Record Item;
        ItemLedgerEntryRecL: Record "Item Ledger Entry";
        TempOutputRecL: Record "PVS Sorting Buffer" temporary;
        PVJobCostingEntryRecL: Record "PVS Job Costing Entry";
        ItemEntryL: Record "Item Ledger Entry";
        KeyIntL: Integer;
        ItemJnlRecL: Record "Item Journal Line";
        ValueEntryRecL: Record "Value Entry";
        JobRecL: Record "PVS Job";
        ItemCostMngtL: Codeunit "Inventory Adjustment";
        DecAjdL: Decimal;
        DecAdjACYL: Decimal;
        SumQtyL: Decimal;
        SumQtyPosL: Decimal;
        SumValueL: Decimal;
        Cost2BeL: Decimal;
        SumCheckL: Decimal;
        DecCurrentValueL: Decimal;
    begin

        //GET ALL OUTPUT
        TempOutputRecL.DELETEALL;
        ItemLedgerEntryRecL.SETRANGE("Item No.", IN_PVInvFinishedP."Item No.");
        ItemLedgerEntryRecL.SETRANGE("Entry Type", ItemLedgerEntryRecL."Entry Type"::Purchase);
        ItemLedgerEntryRecL.SETRANGE("PVS ID", IN_PVInvFinishedP."PVS ID");
        //LRecItemLedgerEntry.SETRANGE("Batch Code", IN_PVInvFinished.Batch);
        if ItemLedgerEntryRecL.FindFirst() then
            repeat
                KeyIntL += 1;
                TempOutputRecL.INIT;
                TempOutputRecL.PK1_Integer1 := KeyIntL;
                TempOutputRecL.Integer1 := ItemLedgerEntryRecL."Entry No.";
                //CALC
                ItemLedgerEntryRecL.CalcFields("Cost Amount (Actual)");
                TempOutputRecL.Decimal1 := ItemLedgerEntryRecL.Quantity;
                TempOutputRecL.Decimal2 := ItemLedgerEntryRecL."Cost Amount (Actual)";
                TempOutputRecL.INSERT;
                SumValueL += ItemLedgerEntryRecL."Cost Amount (Actual)";
                SumQtyL += ItemLedgerEntryRecL.Quantity;
            until ItemLedgerEntryRecL.NEXT = 0;


        if not ItemRecL.GET(IN_PVInvFinishedP."Item No.") then
            exit;   //should be error

        DecCurrentValueL := getAmountValueToBePut(IN_PVInvFinishedP, SumQtyL);

        //if SumValueL <> DecCurrentValueL then begin
        if ((Round(SumValueL) <> Round(DecCurrentValueL)) or in_ForceRecalcBoolP) then begin
            SumValueL := DecCurrentValueL;
            CLEAR(SumCheckL);
            if TempOutputRecL.FindFirst() then
                repeat
                    ItemEntryL.GET(TempOutputRecL.Integer1);
                    //ADJUST ALL TEMP
                    with ItemEntryL do begin
                        Cost2BeL := ROUND((SumValueL / SumQtyL) * ItemEntryL.Quantity);
                        ItemEntryL.CalcFields("Cost Amount (Actual)");
                        IF Cost2BeL <> "Cost Amount (Actual)" THEN BEGIN
                            DecAjdL := (Cost2BeL - "Cost Amount (Actual)");
                            //GET ORIGINAL VALUE ENTRY
                            ValueEntryRecL.SetCurrentKey("Item Ledger Entry No.", "Entry Type");
                            ValueEntryRecL.SETRANGE("Item Ledger Entry Type", "Entry Type");
                            ValueEntryRecL.SETRANGE("Item Ledger Entry No.", "Entry No.");
                            ValueEntryRecL.FindFirst();
                            ItemJnlRecL.INIT;
                            ItemJnlRecL."Posting Date" := "Posting Date";
                            PostItemJnlLine(ItemJnlRecL, ValueEntryRecL, DecAjdL, DecAdjACYL);
                        END;
                        ItemEntryL.CalcFields("Cost Amount (Actual)");
                        SumCheckL += "Cost Amount (Actual)";
                    end;
                until TempOutputRecL.NEXT = 0;

            with ItemEntryL do
                //ROUNDING PROBLEM
                if (SumCheckL <> -SumValueL) then begin
                    DecAjdL := (SumValueL - SumCheckL);
                    //GET ORIGINAL VALUE ENTRY
                    ValueEntryRecL.SetCurrentKey("Item Ledger Entry No.", "Entry Type");
                    ValueEntryRecL.SETRANGE("Item Ledger Entry Type", "Entry Type");
                    ValueEntryRecL.SETRANGE("Item Ledger Entry No.", "Entry No.");
                    ValueEntryRecL.FindFirst();
                    ItemJnlRecL.INIT;
                    ItemJnlRecL."Posting Date" := "Posting Date";
                    if DecAjdL <> 0 then
                        PostItemJnlLine(ItemJnlRecL, ValueEntryRecL, DecAjdL, DecAdjACYL);
                end;
        end;

        if IN_UpdateTableP = TRUE then begin
            IN_PVInvFinishedP."Cost is Adjusted" := TRUE;
            IN_PVInvFinishedP.MODIFY;
        end;

        //ITEM NEED TO BE ADJUSTED
        ItemRecL."Cost is Adjusted" := FALSE;
        ItemRecL.MODIFY;

    end;

    //Duplicate to use working date tmp function.
    procedure OutputLineAdjustement(var IN_PVInvFinishedP: Record "PTE PVS FG Valuation"; IN_UpdateTableP: Boolean)
    var
        ItemRecL: Record Item;
        ItemLedgerEntryRecL: Record "Item Ledger Entry";
        TempOutputRecL: Record "PVS Sorting Buffer" temporary;
        PVJobCostingEntryRecL: Record "PVS Job Costing Entry";
        ItemEntryL: Record "Item Ledger Entry";
        KeyIntL: Integer;
        ItemJnlRecL: Record "Item Journal Line";
        ValueEntryRecL: Record "Value Entry";
        JobRecL: Record "PVS Job";
        ItemCostMngtL: Codeunit "Inventory Adjustment";
        DecAjdL: Decimal;
        DecAdjACYL: Decimal;
        SumQtyL: Decimal;
        SumQtyPosL: Decimal;
        SumValueL: Decimal;
        Cost2BeL: Decimal;
        SumCheckL: Decimal;
        DecCurrentValueL: Decimal;
    begin

        //GET ALL OUTPUT
        TempOutputRecL.DELETEALL;
        ItemLedgerEntryRecL.SETRANGE("Item No.", IN_PVInvFinishedP."Item No.");
        ItemLedgerEntryRecL.SETRANGE("Entry Type", ItemLedgerEntryRecL."Entry Type"::Purchase);
        ItemLedgerEntryRecL.SETRANGE("PVS ID", IN_PVInvFinishedP."PVS ID");
        //LRecItemLedgerEntry.SETRANGE("Batch Code", IN_PVInvFinished.Batch);
        if ItemLedgerEntryRecL.FindFirst() then
            repeat
                KeyIntL += 1;
                TempOutputRecL.INIT;
                TempOutputRecL.PK1_Integer1 := KeyIntL;
                TempOutputRecL.Integer1 := ItemLedgerEntryRecL."Entry No.";
                //CALC
                ItemLedgerEntryRecL.CalcFields("Cost Amount (Actual)");
                TempOutputRecL.Decimal1 := ItemLedgerEntryRecL.Quantity;
                TempOutputRecL.Decimal2 := ItemLedgerEntryRecL."Cost Amount (Actual)";
                TempOutputRecL.INSERT;
                SumValueL += ItemLedgerEntryRecL."Cost Amount (Actual)";
                SumQtyL += ItemLedgerEntryRecL.Quantity;
            until ItemLedgerEntryRecL.NEXT = 0;


        if not ItemRecL.GET(IN_PVInvFinishedP."Item No.") then
            exit;   //should be error

        DecCurrentValueL := getAmountValueToBePut(IN_PVInvFinishedP, SumQtyL);

        //if SumValueL <> DecCurrentValueL then begin
        if (Round(SumValueL) <> Round(DecCurrentValueL)) then begin
            SumValueL := DecCurrentValueL;
            CLEAR(SumCheckL);
            if TempOutputRecL.FindFirst() then
                repeat
                    ItemEntryL.GET(TempOutputRecL.Integer1);
                    //AJDUST ALL TEMP
                    with ItemEntryL do begin
                        Cost2BeL := ROUND((SumValueL / SumQtyL) * ItemEntryL.Quantity);
                        ItemEntryL.CalcFields("Cost Amount (Actual)");
                        IF Cost2BeL <> "Cost Amount (Actual)" THEN BEGIN
                            DecAjdL := (Cost2BeL - "Cost Amount (Actual)");
                            //GET ORIGINAL VALUE ENTRY
                            ValueEntryRecL.SetCurrentKey("Item Ledger Entry No.", "Entry Type");
                            ValueEntryRecL.SETRANGE("Item Ledger Entry Type", "Entry Type");
                            ValueEntryRecL.SETRANGE("Item Ledger Entry No.", "Entry No.");
                            ValueEntryRecL.FindFirst();
                            ItemJnlRecL.INIT;
                            ItemJnlRecL."Posting Date" := WorkDate();
                            PostItemJnlLine(ItemJnlRecL, ValueEntryRecL, DecAjdL, DecAdjACYL);
                        END;
                        ItemEntryL.CalcFields("Cost Amount (Actual)");
                        SumCheckL += "Cost Amount (Actual)";
                    end;
                until TempOutputRecL.NEXT = 0;

            with ItemEntryL do
                //ROUNDING PROBLEM
                if (SumCheckL <> -SumValueL) then begin
                    DecAjdL := (SumValueL - SumCheckL);
                    //GET ORIGINAL VALUE ENTRY
                    ValueEntryRecL.SetCurrentKey("Item Ledger Entry No.", "Entry Type");
                    ValueEntryRecL.SETRANGE("Item Ledger Entry Type", "Entry Type");
                    ValueEntryRecL.SETRANGE("Item Ledger Entry No.", "Entry No.");
                    ValueEntryRecL.FindFirst();
                    ItemJnlRecL.INIT;
                    ItemJnlRecL."Posting Date" := "Posting Date";
                    if DecAjdL <> 0 then
                        PostItemJnlLine(ItemJnlRecL, ValueEntryRecL, DecAjdL, DecAdjACYL);
                end;
        end;

        if IN_UpdateTableP = TRUE then begin
            IN_PVInvFinishedP."Cost is Adjusted" := TRUE;
            IN_PVInvFinishedP.MODIFY;
        end;

        //ITEM NEED TO BE ADJUSTED
        ItemRecL."Cost is Adjusted" := FALSE;
        ItemRecL.MODIFY;

    end;

    procedure getItemVarianceToSkip(InItemCodeP: Code[20]): Boolean
    var
        ItemRecL: Record Item;
        PVSItemQualities: Record "PVS Item Quality";
    begin

        if not ItemRecL.Get(InItemCodeP) then
            exit(true);

        if PVSItemQualities.get(ItemRecL."PVS Item Quality Code") then begin
            case PVSItemQualities."Put In Stock Value" of
                PVSItemQualities."Put In Stock Value"::"Estimated direct cost":
                    begin
                        exit(false);
                    end;
                PVSItemQualities."Put In Stock Value"::"Estimated total cost":
                    begin
                        exit(false);
                    end;
                PVSItemQualities."Put In Stock Value"::"Job Costing Total":
                    begin
                        exit(true);
                    end;
                PVSItemQualities."Put In Stock Value"::"Joc Costing Direct":
                    begin
                        exit(true);
                    end;
                PVSItemQualities."Put In Stock Value"::"Item cost":
                    begin
                        exit(true);
                    end;
                PVSItemQualities."Put In Stock Value"::"Item standard cost":
                    begin
                        exit(false);
                    end;
                PVSItemQualities."Put In Stock Value"::"Zero value":
                    begin
                        exit(true);
                    end;
            end;
        end else begin
            if ItemRecL."Inventory Value Zero" then
                exit(true)
            else
                exit(true);
        end;

        exit(false);
    end;

    procedure getAmountValueToBePut(SFHPVSOutput: Record "PTE PVS FG Valuation"; InQtyP: Decimal): Decimal
    var
        ItemRecL: Record Item;
        PVSItemQualities: Record "PVS Item Quality";
        JCmgtL: Codeunit "PVS Job Costing Mgt.";
        d1, d2, d3, d4, d5 : decimal;
        JobRecL: Record "PVS Job";
        ItemUnitCost: Decimal;
        test: Codeunit "Type Helper";
    begin

        //Now the valuation should be alwasy the fg uc
        //exit(SFHPVSOutput."SFG standard unit cost amount" * SFHPVSOutput."Quantity Output");
        /* FROM PRINTVIS
        3:
            BEGIN // Estimated direct cost,
            JCmgt.Calc_JobCosting(JobRec.ID,1,0,0,d1,d2,d3,d4,d5);
            ItemCost := d3 / Qty;
            END;
        4:
            BEGIN // Estimated total cost,
            JCmgt.Calc_JobCosting(JobRec.ID,1,0,0,d1,d2,d3,d4,d5);
            ItemCost := d4 / Qty;
            END;
        5:
            BEGIN // Joc Costing Direct,
            JCmgt.Calc_JobCosting(JobRec.ID,2,0,0,d1,d2,d3,d4,d5);
            ItemCost := d3 / Qty;
            END;
        6:
            BEGIN // Job Costing Total
            JCmgt.Calc_JobCosting(JobRec.ID,2,0,0,d1,d2,d3,d4,d5);
            ItemCost := d4 / Qty;
            END;

             JobRecL.SetRange(ID,IN_PVInvFinishedP."PVS ID");
            JobRecL.Setrange(Active,true);
            JobRecL.SetRange(Status,JobRecL.Status::Order,JobRecL.Status::"Production Order");
        */
        JobRecL.SetRange(ID, SFHPVSOutput."PVS ID");
        JobRecL.Setrange(Active, true);
        JobRecL.SetRange(Status, JobRecL.Status::Order, JobRecL.Status::"Production Order");
        if not JobRecL.FindSet() then
            exit(0.0);

        if JobRecL.Quantity = 0 then
            exit(0.0);

        if not ItemRecL.Get(SFHPVSOutput."Item No.") then
            exit(0.0);

        if PVSItemQualities.get(ItemRecL."PVS Item Quality Code") then begin
            case PVSItemQualities."Put In Stock Value" of
                PVSItemQualities."Put In Stock Value"::"Estimated direct cost":
                    begin
                        JCmgtL.Calc_JobCosting(SFHPVSOutput."PVS ID", 1, 0, 0, d1, d2, d3, d4, d5);
                        ItemUnitCost := d3 / JobRecL.Quantity;
                        exit(round(ItemUnitCost * InQtyP));
                    end;
                PVSItemQualities."Put In Stock Value"::"Estimated total cost":
                    begin
                        JCmgtL.Calc_JobCosting(SFHPVSOutput."PVS ID", 1, 0, 0, d1, d2, d3, d4, d5);
                        ItemUnitCost := d4 / JobRecL.Quantity;
                        exit(round(ItemUnitCost * InQtyP));
                    end;
                PVSItemQualities."Put In Stock Value"::"Job Costing Total":
                    begin
                        JCmgtL.Calc_JobCosting(SFHPVSOutput."PVS ID", 2, 0, 0, d1, d2, d3, d4, d5);
                        exit(d4);
                    end;
                PVSItemQualities."Put In Stock Value"::"Joc Costing Direct":
                    begin
                        JCmgtL.Calc_JobCosting(SFHPVSOutput."PVS ID", 2, 0, 0, d1, d2, d3, d4, d5);
                        exit(d3);
                    end;
                PVSItemQualities."Put In Stock Value"::"Item cost":
                    begin
                        exit(round(ItemRecL."Unit Cost" * InQtyP));
                    end;
                PVSItemQualities."Put In Stock Value"::"Item standard cost":
                    begin
                        exit(round(ItemRecL."Standard Cost" * InQtyP));
                    end;
                PVSItemQualities."Put In Stock Value"::"Zero value":
                    begin
                        exit(0);
                    end;
            end;
        end else begin
            if ItemRecL."Inventory Value Zero" then
                exit(0)
            else
                exit(round(ItemRecL."Standard Cost" * InQtyP));
        end;
    end;

    local procedure LoopForAdjustCostingPVFinishedGood()
    var
        PVInvFinishedL: Record "PTE PVS FG Valuation";
        MaximumLevelL: Integer;
        i: Integer;
    begin
        MaximumLevelL := 1;

        //COPY TO TEMP
        PVInvFinishedL.SetCurrentKey("Cost is Adjusted", "PVS ID");
        PVInvFinishedL.SetRange("Cost is Adjusted", false);
        if PVInvFinishedL.FindFirst() then
            repeat
                if GuiAllowed = TRUE then begin
                    GWinP.UPDATE(1, Text003);
                    GWinP.UPDATE(2, PVInvFinishedL."PVS ID");
                    GWinP.UPDATE(3, PVInvFinishedL."Item No.");
                end;
                PVInvFinishedL.Level := GetLevelSFH(PVInvFinishedL, 0);
                if PVInvFinishedL.Level > MaximumLevelL then
                    MaximumLevelL := PVInvFinishedL.Level;
                PVInvFinishedL.MODIFY;
            until PVInvFinishedL.NEXT = 0;

        //WE START FOR 1 to Maximum level if the lastlevel return some adjustement try next level
        i := 1;
        repeat
            GWinP.UPDATE(1, Text002);
            GWinP.UPDATE(2, '');
            GWinP.UPDATE(3, '');
            GWinP.UPDATE(4, STRSUBSTNO(Text004, i));
            if (LoopForAdjustCostingPVFinishedGoodLevel(i) > 0) AND (i = MaximumLevelL) then
                MaximumLevelL += 1;
            i += 1;
        until i > MaximumLevelL;
    end;

    local procedure LoopForAdjustCostingPVFinishedGoodLevel(InLevelP: Integer) AdjustCntR: Integer
    var
        PVInvFinishedL: Record "PTE PVS FG Valuation";
        PVInvFinishedTmpL: Record "PTE PVS FG Valuation" temporary;
        MaximumLevelL: Integer;
        i: Integer;
    begin
        AdjustCntR := 0;

        //DELETE TEMP
        PVInvFinishedTmpL.RESET;
        PVInvFinishedTmpL.DELETEALL;

        //COPY TO TEMP
        PVInvFinishedL.SetCurrentKey("Cost is Adjusted", Level);
        PVInvFinishedL.SETRANGE("Cost is Adjusted", FALSE);
        PVInvFinishedL.SETRANGE(Level, InLevelP);
        IF PVInvFinishedL.FindFirst() THEN
            REPEAT
                IF GUIALLOWED = TRUE THEN BEGIN
                    GWinP.UPDATE(1, Text001);
                    GWinP.UPDATE(2, PVInvFinishedL."PVS ID");
                    GWinP.UPDATE(3, PVInvFinishedL."Item No.");
                END;
                PVInvFinishedTmpL.INIT;
                PVInvFinishedTmpL.TransferFields(PVInvFinishedL, TRUE);
                PVInvFinishedTmpL.INSERT;
            UNTIL PVInvFinishedL.NEXT = 0;


        //ADJUSTING COST
        PVInvFinishedTmpL.RESET;
        PVInvFinishedTmpL.SetCurrentKey("Cost is Adjusted", Level);
        PVInvFinishedTmpL.SETRANGE(Level, InLevelP);
        IF PVInvFinishedTmpL.FindFirst() THEN
            REPEAT
                IF PVInvFinishedTmpL."Cost is Adjusted" = FALSE THEN BEGIN
                    IF GUIALLOWED = TRUE THEN BEGIN
                        GWinP.UPDATE(1, Text002);
                        GWinP.UPDATE(2, PVInvFinishedTmpL."PVS ID");
                        GWinP.UPDATE(3, PVInvFinishedTmpL."Item No.");
                    END;
                    CLEAR(PVInvFinishedL);
                    PVInvFinishedL.RESET;
                    IF PVInvFinishedL.GET(PVInvFinishedTmpL."PVS ID", PVInvFinishedTmpL."Item No.", '') THEN BEGIN
                        PVInvFinishedL.CalcFields("Quantity Output");
                        PVInvFinishedL.Level := PVInvFinishedTmpL.Level;
                        AdjustCostingPVFinishedGood(PVInvFinishedL, true, false);
                        AdjustCntR += 1;
                    END;
                END;
            UNTIL PVInvFinishedTmpL.NEXT = 0;

        //RUN COST ENTRY
        RunStandardCostAdjustment();

        EXIT(AdjustCntR);
    end;

    local procedure PostItemJnlLine(ItemJnlLineP: Record "Item Journal line"; OrigValueEntryP: Record "Value Entry"; NewAdjustedCostP: Decimal; NewAdjustedCostACYP: Decimal)
    var
        InvtPeriodL: Record "Inventory Period";
        GLSetupL: Record "General Ledger Setup";
        PostingDateForClosedPeriodL: Date;
        ItemJnlPostLineL: Codeunit "Item Jnl.-Post Line";
    begin
        GLSetupL.GET;
        //SchureFlexibleSetup.GET;

        PostingDateForClosedPeriodL := GLSetupL.FirstAllowedPostingDate;

        WITH OrigValueEntryP DO BEGIN
            ItemJnlLineP."Value Entry Type" := "Entry Type";
            ItemJnlLineP.Description := Description;
            ItemJnlLineP."Source Posting Group" := "Source Posting Group";
            ItemJnlLineP."Source No." := "Source No.";
            ItemJnlLineP."Salespers./Purch. Code" := "Salespers./Purch. Code";
            ItemJnlLineP."Source Type" := "Source Type";
            ItemJnlLineP."Reason Code" := "Reason Code";
            ItemJnlLineP."Drop Shipment" := "Drop Shipment";
            ItemJnlLineP."Document Date" := "Document Date";
            ItemJnlLineP."External Document No." := "External Document No.";
            ItemJnlLineP."Quantity (Base)" := "Valued Quantity";
            ItemJnlLineP."Invoiced Qty. (Base)" := "Invoiced Quantity";
            IF "Item Ledger Entry Type" = "Item Ledger Entry Type"::Output THEN
                ItemJnlLineP."Output Quantity (Base)" := ItemJnlLineP."Quantity (Base)";
            ItemJnlLineP."Item Charge No." := "Item Charge No.";
            ItemJnlLineP."Variance Type" := "Variance Type";
            ItemJnlLineP.Adjustment := TRUE;
            ItemJnlLineP."Applies-to Value Entry" := "Entry No.";
            ItemJnlLineP."Return Reason Code" := "Return Reason Code";

            ItemJnlLineP."Item No." := "Item No.";
            ItemJnlLineP."Location Code" := "Location Code";
            ItemJnlLineP."Variant Code" := "Variant Code";
            IF GLSetupL.IsPostingAllowed("Posting Date") AND InvtPeriodL.IsValidDate("Posting Date") THEN
                ItemJnlLineP."Posting Date" := "Posting Date"
            ELSE
                ItemJnlLineP."Posting Date" := PostingDateForClosedPeriodL;
            IF ItemJnlLineP."Posting Date" = 0D THEN
                ItemJnlLineP."Posting Date" := OrigValueEntryP."Posting Date";

            ItemJnlLineP."Entry Type" := OrigValueEntryP."Item Ledger Entry Type";
            ItemJnlLineP."Document No." := "Document No.";
            ItemJnlLineP."Document Type" := "Document Type";
            ItemJnlLineP."Document Line No." := "Document Line No.";
            ItemJnlLineP."Source Currency Code" := GLSetupL."Additional Reporting Currency";
            /*
            IF SchureFlexibleSetup."Source Code For Cut Paper Adj."<>'' THEN
              ItemJnlLine."Source Code" := SchureFlexibleSetup."Source Code For Cut Paper Adj."
            ELSE
              ItemJnlLine."Source Code" := OrigValueEntry."Source Code";
              */
            ItemJnlLineP."Source Code" := OrigValueEntryP."Source Code";

            ItemJnlLineP."Inventory Posting Group" := "Inventory Posting Group";
            ItemJnlLineP."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
            ItemJnlLineP."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
            //temJnlLine."Prod. Order No." := "Prod. Order No.";
            //ItemJnlLine."Prod. Order Line No." := "Prod. Order Line No.";
            IF ItemJnlLineP."Value Entry Type" = ItemJnlLineP."Value Entry Type"::"Direct Cost" THEN
                ItemJnlLineP."Item Shpt. Entry No." := "Item Ledger Entry No."
            ELSE
                ItemJnlLineP."Applies-to Entry" := "Item Ledger Entry No.";
            ItemJnlLineP.Amount := NewAdjustedCostP;
            ItemJnlLineP."Amount (ACY)" := NewAdjustedCostACYP;

            IF ItemJnlLineP."Quantity (Base)" <> 0 THEN BEGIN
                ItemJnlLineP."Unit Cost" :=
                  ROUND(NewAdjustedCostP / ItemJnlLineP."Quantity (Base)", GLSetupL."Unit-Amount Rounding Precision");
                //ItemJnlLine."Unit Cost (ACY)" :=
                //  ROUND(NewAdjustedCostACY / ItemJnlLine."Quantity (Base)",Currency."Unit-Amount Rounding Precision");
            END;

            ItemJnlLineP."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
            ItemJnlLineP."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
            ItemJnlLineP."Dimension Set ID" := OrigValueEntryP."Dimension Set ID";

            ItemJnlPostLineL.RunWithCheck(ItemJnlLineP);
        END;

    end;

    procedure CheckOutputItem(IN_ItemCodeP: Code[20]; IN_IDP: Integer): Boolean
    var
        PVJobRecL: Record "PVS Job";
        ItemRecL: Record Item;
    begin
        ItemRecL.GET(IN_ItemCodeP);
        IF ItemRecL."Inventory Value Zero" = TRUE THEN
            EXIT(TRUE);

        PVJobRecL.SETRANGE(ID, IN_IDP);
        PVJobRecL.SETRANGE(Status, PVJobRecL.Status::Order);
        PVJobRecL.SETRANGE(Active, TRUE);
        IF NOT PVJobRecL.FindFirst() THEN
            EXIT(FALSE);

        IF PVJobRecL."Item No." <> ItemRecL."No." THEN
            EXIT(FALSE);

        EXIT(TRUE);
    end;

    procedure GetLevelSFH(var IN_PVInvFinishedP: Record "PTE PVS FG Valuation"; IN_ParentIDP: Integer): Integer
    var
        PVInvFinishedL: Record "PTE PVS FG Valuation";
        curLevel: Integer;
    begin
        PVInvFinishedL.SetRange("PVS ID", IN_PVInvFinishedP."PVS ID");
        if PVInvFinishedL.FindFirst() then
            repeat
                curLevel += 1;
                PVInvFinishedL.Level := curLevel;
                PVInvFinishedL.Modify();
            until PVInvFinishedL.Next() = 0;

        curLevel += 1;

        exit(curLevel);
    end;

    procedure GetLevel(var IN_PVInvFinishedP: Record "PTE PVS FG Valuation"; IN_ParentIDP: Integer): Integer
    var
        PVJobCostingEntryL: Record "PVS Job Costing Entry";
        ItemLedgerEntryL: Record "Item Ledger Entry";
        mLevelL: Integer;
        PVInvFinishedL: Record "PTE PVS FG Valuation";
        mLevelRetL: Integer;
        ItemAppEntryL: Record "Item Application Entry";
        SourceEntryNoL: Integer;
        ItemLedgerEntrySourceL: Record "Item Ledger Entry";
    begin
        // RECURSIVE FONCTION TO GET LEVEL OF PRODUCTION ORDER
        // RETURN -1 means a cycling error
        // So it can be used before posting consumption to avoid cycling error during the cost adjustement

        IF IN_ParentIDP = IN_PVInvFinishedP."PVS ID" THEN
            EXIT(-1); //ERROR !!!

        mLevelL := 1;
        //CHECK PV JOB COSTING ENTRY T32
        //Tabel ID,ID,Alternative Rates Code,Posting date,Type,Unit of Measure,Cost Center Code,Department,Sub Contracting,Job Costing Type
        PVJobCostingEntryL.SetCurrentKey(
        "Table ID", ID, "Alternative Rates Code", "Posting date", Type,
        UOM, "Cost Center Code", Department, "Sub Contracting", "Job Cost Type");
        PVJobCostingEntryL.SETRANGE(ID, IN_PVInvFinishedP."PVS ID");
        PVJobCostingEntryL.SETRANGE("Table ID", 32);
        PVJobCostingEntryL.SETRANGE("Job Cost Type", PVJobCostingEntryL.Type::Cost);
        //PVJobCostingEntry.SETRANGE("Batch Code", IN_PVInvFinished.Batch);
        IF PVJobCostingEntryL.FindFirst() THEN
            REPEAT
                CLEAR(ItemLedgerEntryL);
                IF ItemLedgerEntryL.GET(PVJobCostingEntryL."Table Entry No.") THEN BEGIN
                    IF (ItemLedgerEntryL."Item No." <> IN_PVInvFinishedP."Item No.") THEN BEGIN
                        //FOR ALL APPLICATION ENTRY
                        ItemAppEntryL.RESET;
                        ItemAppEntryL.SetCurrentKey("Item Ledger Entry No.", "Output Completely Invd. Date");
                        ItemAppEntryL.SETRANGE("Item Ledger Entry No.", ItemLedgerEntryL."Entry No.");
                        IF ItemAppEntryL.FindFirst() THEN
                            REPEAT
                                IF (ItemAppEntryL."Inbound Item Entry No." <> 0) AND (ItemAppEntryL."Inbound Item Entry No." <> ItemLedgerEntryL."Entry No.") THEN BEGIN
                                    SourceEntryNoL := GetSourceEntry(ItemAppEntryL);
                                    CLEAR(ItemLedgerEntrySourceL);
                                    IF ItemLedgerEntrySourceL.GET(SourceEntryNoL) THEN
                                        IF (ItemLedgerEntrySourceL."PVS ID" <> 0) AND (ItemLedgerEntrySourceL."Entry Type" = ItemLedgerEntrySourceL."Entry Type"::Purchase)
                                        THEN BEGIN
                                            CLEAR(PVInvFinishedL);
                                            mLevelRetL := 0;
                                            //SCHURE CHANGE
                                            IF PVInvFinishedL.GET(ItemLedgerEntrySourceL."PVS ID", ItemLedgerEntryL."Item No.", '') THEN
                                                //SCHURE CHANGE END
                                                IF PVInvFinishedL."Item No." <> IN_PVInvFinishedP."Item No." THEN
                                                    mLevelRetL := GetLevel(PVInvFinishedL, IN_PVInvFinishedP."PVS ID");
                                            IF mLevelRetL < 0 THEN
                                                EXIT(-1); //ERROR !!!
                                            IF mLevelL <= mLevelRetL THEN
                                                mLevelL += mLevelRetL;
                                        END;
                                END;
                            UNTIL ItemAppEntryL.NEXT = 0;
                    END;
                END;
            UNTIL PVJobCostingEntryL.NEXT = 0;
        EXIT(mLevelL);
    end;

    procedure GetSourceEntry(var In_FromApplicationEntryP: Record "Item Application Entry"): Integer
    var
        ApplicationEntryRecL: Record "Item Application Entry";
    begin
        IF (In_FromApplicationEntryP."Item Ledger Entry No." = In_FromApplicationEntryP."Inbound Item Entry No.") AND
          (In_FromApplicationEntryP."Outbound Item Entry No." = 0) THEN
            EXIT(In_FromApplicationEntryP."Item Ledger Entry No.");

        ApplicationEntryRecL.RESET;
        ApplicationEntryRecL.SetCurrentKey("Item Ledger Entry No.", "Output Completely Invd. Date");
        IF (In_FromApplicationEntryP."Inbound Item Entry No." <> 0) AND
          (In_FromApplicationEntryP."Inbound Item Entry No." <> In_FromApplicationEntryP."Item Ledger Entry No.") THEN BEGIN
            ApplicationEntryRecL.SETRANGE("Item Ledger Entry No.", In_FromApplicationEntryP."Inbound Item Entry No.");
            IF ApplicationEntryRecL.FindFirst() THEN
                EXIT(GetSourceEntry(ApplicationEntryRecL));
        END ELSE
            IF (In_FromApplicationEntryP."Outbound Item Entry No." <> 0) AND
     (In_FromApplicationEntryP."Outbound Item Entry No." <> In_FromApplicationEntryP."Item Ledger Entry No.") THEN BEGIN
                ApplicationEntryRecL.SETRANGE("Item Ledger Entry No.", In_FromApplicationEntryP."Outbound Item Entry No.");
                IF ApplicationEntryRecL.FindFirst() THEN
                    EXIT(GetSourceEntry(ApplicationEntryRecL));
            END;

        EXIT(-1);   //NO SOURCE SHOULD BE NOT OCCUR
    end;

    local procedure RunStandardCostAdjustment()
    var
        InvtSetupL: Record "Inventory Setup";
        InvtAdjmtL: Codeunit "Inventory Adjustment";
    begin
        InvtSetupL.GET;
        IF InvtSetupL."Automatic Cost Adjustment" <>
           InvtSetupL."Automatic Cost Adjustment"::Never
        THEN BEGIN
            InvtAdjmtL.SetProperties(TRUE, InvtSetupL."Automatic Cost Posting");
            InvtAdjmtL.MakeMultiLevelAdjmt;
        END;
    end;


    procedure checkCaseAndCreateValuationEntries(IN_ID: Integer)
    var
        ItemEntries: Record "Item Ledger Entry";
        ItemRec: Record Item;
    begin
        ItemEntries.SetRange("Entry Type", ItemEntries."Entry Type"::Purchase);
        ItemEntries.SetRange("PVS ID", IN_ID);
        if ItemEntries.FindSet() then
            repeat
                if ItemRec.Get(ItemEntries."Item No.") then
                    if ItemRec."PVS Item Type" = ItemRec."PVS Item Type"::"Finished Good" then
                        AssignLedgerEntryToPVCaseRelFinished(ItemEntries, false);
            until ItemEntries.Next() = 0;
    end;

    procedure AssignLedgerEntryToPVCaseRelFinished(IN_ItemLedgerEntryP: Record "Item Ledger Entry"; inPrompt: Boolean)
    var
        PVRelFinishedRecL: Record "PTE PVS FG Valuation";
        ItemRecL: Record Item;
    begin

        IN_ItemLedgerEntryP.TestField(Positive, TRUE);
        ItemRecL.GET(IN_ItemLedgerEntryP."Item No.");
        ItemRecL.TestField(ItemRecL."Inventory Value Zero", FALSE);

        IF NOT PVRelFinishedRecL.GET(IN_ItemLedgerEntryP."PVS ID", IN_ItemLedgerEntryP."Item No.") THEN BEGIN
            PVRelFinishedRecL.INIT;
            PVRelFinishedRecL."PVS ID" := IN_ItemLedgerEntryP."PVS ID";
            PVRelFinishedRecL."Item No." := IN_ItemLedgerEntryP."Item No.";
            //LRecPVRelFinished.Batch := IN_ItemLedgerEntry."Batch Code";
            PVRelFinishedRecL.Level := 1;
            PVRelFinishedRecL."Cost is Adjusted" := FALSE;
            PVRelFinishedRecL.INSERT;
        END;

        PVRelFinishedRecL.TestField(PVRelFinishedRecL."Item No.", IN_ItemLedgerEntryP."Item No.");
    end;


    procedure getCurrentValuation(IN_PVInvFinishedP: Record "PTE PVS FG Valuation"): Decimal
    var
        ItemLedgerEntryRecL: Record "Item Ledger Entry";
        SumValueL: Decimal;
    begin
        SumValueL := 0;
        ItemLedgerEntryRecL.SETRANGE("Item No.", IN_PVInvFinishedP."Item No.");
        ItemLedgerEntryRecL.SETRANGE("Entry Type", ItemLedgerEntryRecL."Entry Type"::Purchase);
        ItemLedgerEntryRecL.SETRANGE("PVS ID", IN_PVInvFinishedP."PVS ID");
        ItemLedgerEntryRecL.SETRANGE("Item No.", IN_PVInvFinishedP."Item No.");
        //LRecItemLedgerEntry.SETRANGE("Batch Code", IN_PVInvFinished.Batch);
        if ItemLedgerEntryRecL.FindFirst() then
            repeat
                ItemLedgerEntryRecL.CalcFields("Cost Amount (Actual)");
                SumValueL += ItemLedgerEntryRecL."Cost Amount (Actual)";
            until ItemLedgerEntryRecL.NEXT = 0;

        exit(SumValueL);
    end;

    local procedure CalcCostAmount(IN_ItemLedgerEntryP: Record "Item Ledger Entry"; IN_GenBusPostingGroupP: Code[10]): Decimal
    var
        ValueEntryRecL: Record "Value Entry";
        DecSumL: Decimal;
    begin
        //Item Ledger Entry No.,Entry Type
        DecSumL := 0;
        ValueEntryRecL.SetCurrentKey("Item Ledger Entry No.", "Entry Type");
        ValueEntryRecL.SETRANGE("Item Ledger Entry No.", IN_ItemLedgerEntryP."Entry No.");
        IF IN_GenBusPostingGroupP <> '' THEN
            ValueEntryRecL.SETRANGE("Gen. Bus. Posting Group", IN_GenBusPostingGroupP);
        IF ValueEntryRecL.FindFirst() THEN
            REPEAT
                DecSumL += (ValueEntryRecL."Cost Amount (Actual)" + ValueEntryRecL."Cost Amount (Expected)");
            UNTIL ValueEntryRecL.NEXT = 0;
        EXIT(DecSumL);
    end;

    procedure getOutPutQuantity(IN_PVSIDIntP: Integer; IN_ItemCodeP: Code[20]): Decimal
    var
        ItemLedgerEntryRecL: Record "Item Ledger Entry";
        SumValueL: Decimal;
    begin
        SumValueL := 0;
        ItemLedgerEntryRecL.SetRange("Item No.", IN_ItemCodeP);
        ItemLedgerEntryRecL.SetRange("Entry Type", ItemLedgerEntryRecL."Entry Type"::Purchase);
        ItemLedgerEntryRecL.SetRange("PVS ID", IN_PVSIDIntP);
        if ItemLedgerEntryRecL.FindFirst() then
            repeat
                SumValueL += ItemLedgerEntryRecL.Quantity
            until ItemLedgerEntryRecL.NEXT = 0;

        exit(SumValueL);
    end;

    procedure getConsumpQuantity(IN_PVSIDIntP: Integer; IN_ItemCodeP: Code[20]): Decimal
    var
        ItemLedgerEntryRecL: Record "Item Ledger Entry";
        SumValueL: Decimal;
    begin
        SumValueL := 0;
        ItemLedgerEntryRecL.SetRange("Item No.", IN_ItemCodeP);
        ItemLedgerEntryRecL.SetRange("Entry Type", ItemLedgerEntryRecL."Entry Type"::Sale);
        ItemLedgerEntryRecL.SetRange("PVS ID", IN_PVSIDIntP);
        if ItemLedgerEntryRecL.FindFirst() then
            repeat
                SumValueL += ItemLedgerEntryRecL.Quantity
            until ItemLedgerEntryRecL.Next() = 0;

        exit(SumValueL);
    end;

    procedure getConsumpQuantityFromPVS(IN_PVSIDIntP: Integer; IN_ItemCodeP: Code[20]): Decimal
    var
        PVSJobCostingEntryRecL: Record "PVS Job Costing Entry";
        ItemLedgerEntryRecL: Record "Item Ledger Entry";
        SumValueL: Decimal;
    begin
        SumValueL := 0;
        PVSJobCostingEntryRecL.SetCurrentKey("Table ID", ID, "Alternative Rates Code", "Posting Date", Type, UOM,
        "Cost Center Code", Department, "Sub Contracting", "Job Cost Type");
        PVSJobCostingEntryRecL.SetRange("Table ID", 32);
        PVSJobCostingEntryRecL.SetRange(ID, IN_PVSIDIntP);
        PVSJobCostingEntryRecL.SetRange(Type, PVSJobCostingEntryRecL.Type::Cost);
        PVSJobCostingEntryRecL.SetRange("Item No.", IN_ItemCodeP);
        if PVSJobCostingEntryRecL.FindFirst() then
            repeat
                if ItemLedgerEntryRecL.Get(PVSJobCostingEntryRecL."Table Entry No.") then
                    if ItemLedgerEntryRecL."Entry Type" = ItemLedgerEntryRecL."Entry Type"::Sale then
                        SumValueL := PVSJobCostingEntryRecL.Quantity;
            until PVSJobCostingEntryRecL.Next() = 0;

        exit(SumValueL);
    end;

    //GET FIRST OUTPUT ENTRY TO REVERSE
    procedure getAllAvailOutPutQuantity(IN_PVSIDIntP: Integer; IN_ItemCodeP: Code[20];
        var Out_PVSBufferRecTempP: Record "PVS Sorting Buffer" temporary): Boolean
    var
        ItemLedgerEntryRecL: Record "Item Ledger Entry";
        SumValueL: Decimal;
        SumPVSValueL: Decimal;
    begin
        SumValueL := 0;
        ItemLedgerEntryRecL.SetRange("Item No.", IN_ItemCodeP);
        ItemLedgerEntryRecL.SetRange("Entry Type", ItemLedgerEntryRecL."Entry Type"::Purchase);
        ItemLedgerEntryRecL.SetRange("PVS ID", IN_PVSIDIntP);
        if ItemLedgerEntryRecL.FindFirst() then
            repeat
                //Check in PVS Job Costing Entry
                SumPVSValueL := getJobCostingQtyFromTableEntryNo(ItemLedgerEntryRecL);
                if (ItemLedgerEntryRecL.Quantity - SumPVSValueL) > 0 then begin
                    ItemLedgerEntryRecL.CalcFields("Cost Amount (Actual)");
                    Out_PVSBufferRecTempP.Init();
                    Out_PVSBufferRecTempP.PK1_Integer1 := ItemLedgerEntryRecL."Entry No.";
                    Out_PVSBufferRecTempP.Decimal1 := ItemLedgerEntryRecL.Quantity - SumPVSValueL;
                    Out_PVSBufferRecTempP.Decimal2 := ItemLedgerEntryRecL.Quantity;
                    Out_PVSBufferRecTempP.Decimal3 := ItemLedgerEntryRecL."Cost Amount (Actual)";
                    Out_PVSBufferRecTempP.Insert();
                end;
            until ItemLedgerEntryRecL.Next() = 0;
        exit(false);
    end;

    procedure getJobCostingQtyFromTableEntryNo(IN_ItemLedgerEntry: Record "Item Ledger Entry"): Decimal
    var
        PVSJobCostingEntryRecL: Record "PVS Job Costing Entry";
        SumValueL: Decimal;
    begin
        SumValueL := 0;
        PVSJobCostingEntryRecL.SetCurrentKey("Table ID", "Table Entry No.", "Alternative Rates Code", ID);
        PVSJobCostingEntryRecL.SetRange("Table ID", 32);
        PVSJobCostingEntryRecL.SetRange("Table Entry No.", IN_ItemLedgerEntry."Entry No.");
        if PVSJobCostingEntryRecL.FindFirst() then
            repeat

                if (PVSJobCostingEntryRecL.Type = PVSJobCostingEntryRecL.Type::Cost) then
                    SumValueL := PVSJobCostingEntryRecL.Quantity;

            until PVSJobCostingEntryRecL.Next() = 0;

        exit(SumValueL);
    end;

    procedure getFirstAvailConsumpQuantity(IN_PVSIDIntP: Integer; IN_ItemCodeP: Code[20];
        var Out_PVSJobCostingEntryRecP: Record "Item Ledger Entry"; var Out_RemainQty: Decimal): Boolean
    var
        PVSJobCostingEntryRecL: Record "PVS Job Costing Entry";
        SumValueL: Decimal;
    begin
        SumValueL := 0;
        PVSJobCostingEntryRecL.SetCurrentKey("Table ID", ID, "Alternative Rates Code", "Posting Date", Type, UOM,
        "Cost Center Code", Department, "Sub Contracting", "Job Cost Type");
        PVSJobCostingEntryRecL.SetRange("Table ID", 32);
        PVSJobCostingEntryRecL.SetRange(ID, IN_PVSIDIntP);
        PVSJobCostingEntryRecL.SetRange(Type, PVSJobCostingEntryRecL.Type::Cost);
        PVSJobCostingEntryRecL.SetRange("Item No.", IN_ItemCodeP);
        if PVSJobCostingEntryRecL.FindFirst() then
            repeat
                SumValueL := PVSJobCostingEntryRecL.Quantity;
            until PVSJobCostingEntryRecL.Next() = 0;

        exit(false);
    end;

    procedure getTotalPostMaterials(PVSJobRecP: Record "PVS Job"; ItemNoCodeP: Code[20]; CostCenterCode: Code[20]; UOMCodeP: Code[20]; inPlanIDP: Integer): Decimal
    var
        PVSJobCostingEntryRecL: Record "PVS Job Costing Entry";
        totalQtyDecL: Decimal;
    begin
        PVSJobCostingEntryRecL.SetCurrentKey(ID, "Table ID", UOM, Overtime);
        PVSJobCostingEntryRecL.SetRange(ID, PVSJobRecP.ID);
        PVSJobCostingEntryRecL.SetRange("Table ID", 32);
        PVSJobCostingEntryRecL.SetRange(Type, PVSJobCostingEntryRecL.Type::Cost);
        PVSJobCostingEntryRecL.SetRange("Item No.", ItemNoCodeP);
        PVSJobCostingEntryRecL.SetRange(UOM, UOMCodeP);
        if inPlanIDP <> 0 then
            PVSJobCostingEntryRecL.SetRange("Plan ID", inPlanIDP);
        if PVSJobCostingEntryRecL.FindFirst() then
            repeat
                totalQtyDecL += PVSJobCostingEntryRecL.Quantity;
            until PVSJobCostingEntryRecL.Next() = 0;

        exit(totalQtyDecL);
    end;


    procedure getTotalOutputFGQuantity(PVSJobRecP: Record "PVS Job"): Decimal
    var
        PVSInvTableRecL: Record "PTE PVS FG Valuation";
        totalSum: Decimal;
    begin
        //TO DO
        PVSInvTableRecL.SetRange("PVS ID", PVSJobRecP.ID);
        //PVSInvTableRecL.SetRange(SemiFinished, false);
        if PVSInvTableRecL.FindSet() then
            repeat
                PVSInvTableRecL.CalcFields("Quantity Output");
                totalSum += PVSInvTableRecL."Quantity Output";
            until PVSInvTableRecL.Next() = 0;

        exit(totalSum);
    end;
}