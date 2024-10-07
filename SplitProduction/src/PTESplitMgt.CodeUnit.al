codeunit 80183 "PTE Split Mgt"
{
    SingleInstance = true;

    var
        TempGlobal_Split: Record "PTE Job Shift Split" temporary;
        TempGlobal_Variant: Record "PVS Job Item Variant" temporary;
        MergingOrSplittingSheet: Boolean;

    procedure GetMergingOrSplittingSheet(): boolean;
    begin
        exit(MergingOrSplittingSheet);
    end;

    procedure SetMergingOrSplittingSheet(in_MergingOrSplittingSheet: Boolean)
    begin
        MergingOrSplittingSheet := in_MergingOrSplittingSheet;
    end;

    // ide til fremtidig tilføjelse
    // o Split page needs the possibility, to combine/recombine sheets or versions
    // sub page med variants vælg ny platechange
    // platech uden vari er røde
    // vis nyt jobitem no grønt - 
    // ret jobitem no - check sammme papir mv
    // process - platech uden vari slettes
    // opret nye jobitem
    // andre slås sammen
    procedure GetTMPSplit(var out_SplitTMP: Record "PTE Job Shift Split" temporary)
    begin
        out_SplitTMP.Copy(TempGlobal_Split, true);
        out_SplitTMP.SetCurrentKey(ID, Job, Version, "Job Item No. 2", "Change No.");
    end;

    procedure GetTMPVariant(var out_VariantTMP: Record "PVS Job Item Variant" temporary)
    begin
        out_VariantTMP.Copy(TempGlobal_Variant, true);
    end;

    procedure ReadTMPSplit(in_JobRec: Record "PVS Job"): Boolean
    var
        OrderRec: Record "PVS Case";
        // OrderJobRec, ProductionJobRec : Record "PVS Job";
        JobItem: Record "PVS Job Item";
        TempJobItem: Record "PVS Job Item" temporary;
        PlateChange: record "PVS Job Item Plate Changes";
        VariantRec: Record "PVS Job Item Variant";
    begin
        TempGlobal_Split.DeleteAll();
        TempGlobal_Variant.DeleteAll();

        if in_JobRec.ID = 0 then exit;
        // Test
        in_JobRec.TestField("Production Calculation", true);
        in_JobRec.TestField(Active, true);
        OrderRec.get(in_JobRec.ID);
        OrderRec.TestField(Type, OrderRec.Type::"Production Order");

        // Can only be opened if all product parts are combined
        // #TODO

        TempGlobal_Split.reset();
        TempGlobal_Split.DeleteAll();

        JobItem.SetRange(ID, in_JobRec.ID);
        JobItem.SetRange(Job, in_JobRec.Job);
        JobItem.SetRange(Version, in_JobRec.Version);
        JobItem.SetRange("Entry No.", 1);
        if JobItem.findset() then
            repeat
                TempJobItem := JobItem;
                TempJobItem.insert();

                VariantRec.SetRange(ID, JobItem.ID);
                VariantRec.SetRange(Job, JobItem.Job);
                VariantRec.SetRange(Version, JobItem.Version);
                VariantRec.SetRange("Job Item No.", JobItem."Job Item No.");
                if VariantRec.findset() then
                    repeat
                        TempGlobal_Variant := VariantRec;
                        TempGlobal_Variant.insert();
                    until VariantRec.next() = 0;
                if TempGlobal_Variant.Count <> 0 then begin
                    PlateChange.SetRange(ID, JobItem.ID);
                    PlateChange.SetRange(Job, JobItem.Job);
                    PlateChange.SetRange(Version, JobItem.Version);
                    PlateChange.SetRange("Job Item No.", JobItem."Job Item No.");
                    PlateChange.findset(false);
                    repeat
                        InsertTMPSplitFromShift(JobItem, PlateChange, TempGlobal_Split);
                    until PlateChange.next() = 0;
                end


            until JobItem.next() = 0;

        // find orginal item no
        TempGlobal_Split.reset();
        if TempGlobal_Split.findset() then
            repeat
                if TempGlobal_Split."Expanded From Job Item No." = 0 then
                    TempGlobal_Split."Original Job Item No." := TempGlobal_Split."Job Item No. 2"
                else
                    if TempJobItem.get(TempGlobal_Split.ID, TempGlobal_Split.Job, TempGlobal_Split.Version, TempGlobal_Split."Expanded From Job Item No.", 1) then
                        TempGlobal_Split."Original Job Item No." := TempJobItem."Job Item No. 2";
                TempGlobal_Split.modify();
            until TempGlobal_Split.next() = 0;

        TempGlobal_Split.SetCurrentKey(ID, Job, Version, "Job Item No. 2", "Change No.");
        exit(true);
    end;

    local procedure InsertTMPSplitFromShift(in_JobItemRec: Record "PVS Job Item"; in_ShiftRec: Record "PVS Job Item Plate Changes"; var out_SplitTMP: Record "PTE Job Shift Split" temporary): Boolean
    begin
        clear(out_SplitTMP);
        out_SplitTMP.TransferFields(in_ShiftRec);
        Values_From_JobItem(in_JobItemRec, out_SplitTMP);

        // Find Variant entry
        TempGlobal_Variant.reset();
        TempGlobal_Variant.SetRange("Job Item No.", in_JobItemRec."Job Item No.");
        TempGlobal_Variant.SetRange("Sheet ID", in_ShiftRec."Change No.");
        if TempGlobal_Variant.Count = 1 then begin
            TempGlobal_Variant.FindFirst();
            out_SplitTMP."Variant Entry No." := TempGlobal_Variant."Variant Entry No.";
        end;
        TempGlobal_Variant.reset();

        out_SplitTMP.insert();
    end;

    local procedure Values_From_JobItem(in_JobItem: Record "PVS Job Item"; var out_SplitTMP: Record "PTE Job Shift Split" temporary)
    var
        SheetRec: Record "PVS Job Sheet";
    begin
        out_SplitTMP."Job Item No. 2" := in_JobItem."Job Item No. 2";
        out_SplitTMP."Colors Front" := in_JobItem."Colors Front";
        out_SplitTMP."Colors Back" := in_JobItem."Colors Back";
        out_SplitTMP."Imposition Type" := in_JobItem."Imposition Type";
        out_SplitTMP."No. Of Pages" := in_JobItem."No. Of Pages";
        out_SplitTMP."Pages With Print" := in_JobItem."Pages With Print";
        out_SplitTMP."Final Format Code" := in_JobItem."Final Format Code";
        out_SplitTMP."Component Type" := in_JobItem."Component Type";
        out_SplitTMP."Expanded From Job Item No." := in_JobItem."Expanded From Job Item No.";
        if SheetRec.get(in_JobItem."Sheet ID") then begin
            in_JobItem.CalcFields("Paper Item No.", "Controlling Sheet Unit");
            out_SplitTMP."Paper Item No." := SheetRec."Paper Item No.";
            out_SplitTMP.Finishing := SheetRec.Finishing;
            out_SplitTMP."Controlling Sheet Unit" := SheetRec."Controlling Unit";
        end;
    end;

    procedure Update_SplitJobItems(var in_SplitTMP: Record "PTE Job Shift Split" temporary)
    var
        TempNewJobItemNo: Record Integer temporary;
        JobRec: Record "PVS Job";
        CalculationMgt: Codeunit "PVS Calculation Management";
    begin
        // Anything to split
        in_SplitTMP.reset();
        in_SplitTMP.setfilter("Split Job Item No.", '<>0');
        if in_SplitTMP.findset() then
            repeat
                TempNewJobItemNo.Number := in_SplitTMP."Split Job Item No.";
                if TempNewJobItemNo.Insert() then;
            until in_SplitTMP.next() = 0;
        in_SplitTMP.reset();
        if TempNewJobItemNo.IsEmpty then
            exit;

        JobRec.get(in_SplitTMP.ID, in_SplitTMP.Job, in_SplitTMP.Version);
        JobRec."Skip Calc." := true;
        JobRec.Modify();

        // Split jobitems





        JobRec.get(in_SplitTMP.ID, in_SplitTMP.Job, in_SplitTMP.Version);
        if JobRec."Skip Calc." then begin
            JobRec."Skip Calc." := false;
            JobRec.Modify();
            CalculationMgt.Main_Calculate_Job(JobRec.ID, JobRec.Job, JobRec.Version);
        end;

    end;
}