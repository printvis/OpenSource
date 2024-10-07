codeunit 80183 "PTE Split Mgt"
{
    SingleInstance = true;

    var
        Global_SplitTMP: Record "PTE Job Shift Split" temporary;
        Global_VariantTMP: Record "PVS Job Item Variant" temporary;
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
        out_SplitTMP.Copy(Global_SplitTMP, true);
        out_SplitTMP.SetCurrentKey(ID, Job, Version, "Job Item No. 2", "Change No.");
    end;

    procedure GetTMPVariant(var out_VariantTMP: Record "PVS Job Item Variant" temporary)
    begin
        out_VariantTMP.Copy(Global_VariantTMP, true);
    end;

    procedure ReadTMPSplit(in_JobRec: Record "PVS Job"): Boolean
    var
        StatusRec: Record "PVS Status Code";
        OrderRec: Record "PVS Case";
        // OrderJobRec, ProductionJobRec : Record "PVS Job";
        JobItem: Record "PVS Job Item";
        JobItemTMP: Record "PVS Job Item" temporary;
        PlateChange: record "PVS Job Item Plate Changes";
        VariantRec: Record "PVS Job Item Variant";
    begin
        Global_SplitTMP.DeleteAll();
        Global_VariantTMP.DeleteAll();

        if in_JobRec.ID = 0 then exit;
        // Test
        in_JobRec.TestField("Production Calculation", true);
        in_JobRec.TestField(Active, true);
        OrderRec.get(in_JobRec.ID);
        OrderRec.TestField(Type, OrderRec.Type::"Production Order");

        // Can only be opened if all product parts are combined
        // #TODO

        Global_SplitTMP.reset;
        Global_SplitTMP.DeleteAll();

        JobItem.SetRange(ID, in_JobRec.ID);
        JobItem.SetRange(Job, in_JobRec.Job);
        JobItem.SetRange(Version, in_JobRec.Version);
        JobItem.SetRange("Entry No.", 1);
        if JobItem.findset then
            repeat
                JobItemTMP := JobItem;
                JobItemTMP.insert;

                VariantRec.SetRange(ID, JobItem.ID);
                VariantRec.SetRange(Job, JobItem.Job);
                VariantRec.SetRange(Version, JobItem.Version);
                VariantRec.SetRange("Job Item No.", JobItem."Job Item No.");
                if VariantRec.findset then
                    repeat
                        Global_VariantTMP := VariantRec;
                        Global_VariantTMP.insert;
                    until VariantRec.next = 0;
                if Global_VariantTMP.Count <> 0 then begin
                    PlateChange.SetRange(ID, JobItem.ID);
                    PlateChange.SetRange(Job, JobItem.Job);
                    PlateChange.SetRange(Version, JobItem.Version);
                    PlateChange.SetRange("Job Item No.", JobItem."Job Item No.");
                    PlateChange.findset(false);
                    repeat
                        InsertTMPSplitFromShift(JobItem, PlateChange, Global_SplitTMP);
                    until PlateChange.next = 0;
                end


            until JobItem.next = 0;

        // find orginal item no
        Global_SplitTMP.reset;
        if Global_SplitTMP.findset then
            repeat
                if Global_SplitTMP."Expanded From Job Item No." = 0 then
                    Global_SplitTMP."Original Job Item No." := Global_SplitTMP."Job Item No. 2"
                else begin
                    if JobItemTMP.get(Global_SplitTMP.ID, Global_SplitTMP.Job, Global_SplitTMP.Version, Global_SplitTMP."Expanded From Job Item No.", 1) then
                        Global_SplitTMP."Original Job Item No." := JobItemTMP."Job Item No. 2";
                end;
                Global_SplitTMP.modify;
            until Global_SplitTMP.next = 0;

        Global_SplitTMP.SetCurrentKey(ID, Job, Version, "Job Item No. 2", "Change No.");
        exit(true);
    end;

    local procedure InsertTMPSplitFromShift(in_JobItemRec: Record "PVS Job Item"; in_ShiftRec: Record "PVS Job Item Plate Changes"; var out_SplitTMP: Record "PTE Job Shift Split" temporary): Boolean
    begin
        clear(out_SplitTMP);
        out_SplitTMP.TransferFields(in_ShiftRec);
        Values_From_JobItem(in_JobItemRec, out_SplitTMP);

        // Find Variant entry
        Global_VariantTMP.reset;
        Global_VariantTMP.SetRange("Job Item No.", in_JobItemRec."Job Item No.");
        Global_VariantTMP.SetRange("Sheet ID", in_ShiftRec."Change No.");
        if Global_VariantTMP.Count = 1 then begin
            Global_VariantTMP.FindFirst();
            out_SplitTMP."Variant Entry No." := Global_VariantTMP."Variant Entry No.";
        end;
        Global_VariantTMP.reset;

        out_SplitTMP.insert;
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
        NewJobItemNo: Record Integer temporary;
        JobItemRec: Record "PVS Job Item";
        CalculationMgt: Codeunit "PVS Calculation Management";
        OrderRec: Record "PVS Case";
        JobRec, MasterJobRec : Record "PVS Job";
        SplitFromJobTmp: Record "PVS Job" temporary;
        SplitRec: Record "PTE Job Shift Split";
    begin
        // Anything to split
        in_SplitTMP.reset;
        in_SplitTMP.setfilter("Split Job Item No.", '<>0');
        if in_SplitTMP.findset then
            repeat
                NewJobItemNo.Number := in_SplitTMP."Split Job Item No.";
                if NewJobItemNo.Insert() then;
            until in_SplitTMP.next = 0;
        in_SplitTMP.reset;
        if NewJobItemNo.IsEmpty then
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




    /*



        procedure Update_SplitOrders(var in_SplitTMP: Record "PTE Job Shift Split" temporary)
        var
            CalculationMgt: Codeunit "PVS Calculation Management";
            OrderRec: Record "PVS Case";
            JobRec, MasterJobRec : Record "PVS Job";
            SplitFromJobTmp: Record "PVS Job" temporary;
            SplitRec: Record "PTE Job Shift Split";
        begin
            // Find Jobs
            in_SplitTMP.reset;
            in_SplitTMP.SetRange(Changed, true);
            if in_SplitTMP.IsEmpty then
                exit;
            in_SplitTMP.findfirst;

            if in_SplitTMP.ID = 0 then exit;
            OrderRec.get(in_SplitTMP.ID);
            OrderRec.TestField(Type, OrderRec.Type::"Production Order");
            GetMasterJob(OrderRec.ID, MasterJobRec);
            if MasterJobRec.Status = MasterJobRec.Status::Order then
                CreateMasterJob(MasterJobRec, in_SplitTMP);

            MasterJobRec.TestField(Status, MasterJobRec.Status::"Production Order");

            in_SplitTMP.reset;
            in_SplitTMP.SetRange(Changed, true);

            in_SplitTMP.SetRange(ID, MasterJobRec.ID);
            in_SplitTMP.SetRange(Job, MasterJobRec.Job);
            in_SplitTMP.SetRange(Changed, true);
            if in_SplitTMP.findset then
                repeat
                    if in_SplitTMP.IsCreated then begin
                        SplitFromJobTmp.ID := in_SplitTMP."Split ID";
                        SplitFromJobTmp.Job := in_SplitTMP."Split Job";
                        SplitFromJobTmp.Version := in_SplitTMP."Split Version";
                    end else
                        SplitFromJobTmp := MasterJobRec;

                    if SplitFromJobTmp.insert then;
                until in_SplitTMP.next = 0;
            in_SplitTMP.reset;

            if SplitFromJobTmp.findset then
                repeat
                    if JobRec.get(SplitFromJobTmp.ID, SplitFromJobTmp.Job, SplitFromJobTmp.version) then begin
                        JobRec.TestField(Active, true);
                        Split_Job(JobRec, in_SplitTMP);
                    end;
                until SplitFromJobTmp.next = 0;

            // Update split values
            in_SplitTMP.reset;
            if in_SplitTMP.findset then
                repeat
                    if SplitRec.get(in_SplitTMP.ID, in_SplitTMP.Job, in_SplitTMP.Version, in_SplitTMP."Split No.", in_SplitTMP."Job Item No.", in_SplitTMP."Change No.") then begin
                        SplitRec.TransferFields(in_SplitTMP);

                        SplitRec."Changed Controlling Sheet Unit" := false;
                        SplitRec."Changed Finishing" := false;
                        SplitRec."Changed Imposition Type" := false;
                        SplitRec."Changed Paper Item No." := false;
                        SplitRec.Changed := false;
                        SplitRec.modify;
                    end else begin
                        SplitRec := in_SplitTMP;
                        SplitRec.Changed := false;
                        SplitRec."Changed Controlling Sheet Unit" := false;
                        SplitRec."Changed Finishing" := false;
                        SplitRec."Changed Imposition Type" := false;
                        SplitRec."Changed Paper Item No." := false;
                        SplitRec.IsCreated := true;
                        SplitRec.insert;
                    end;

                until in_SplitTMP.next = 0;

            // Recalculate all jobs
            JobRec.reset;
            JobRec.SetRange(ID, OrderRec.ID);
            JobRec.SetRange(Active, true);
            JobRec.SetRange("Production Calculation", true);
            if JobRec.findset then
                repeat
                    if JobRec."Skip Calc." then begin
                        JobRec."Skip Calc." := false;
                        JobRec.Modify();
                        CalculationMgt.Main_Calculate_Job(JobRec.ID, JobRec.Job, JobRec.Version);
                    end;
                until JobRec.Next() = 0;

        end;



 

        local procedure CreateSplitJob(var FromJobRec: Record "PVS Job"; SplitParam: Record "PTE Job Shift Split"; var in_SplitTMP: Record "PTE Job Shift Split" temporary)
        var
            NewJobRec: Record "PVS Job";
            CopyMgt: Codeunit "PVS Copy Management";
            NewJob: Integer;
            Move_SplitTMP, Keep_SplitTMP : Record "PTE Job Shift Split" temporary;
        begin
            if not FromJobRec."Skip Calc." then begin
                FromJobRec."Skip Calc." := true;
                FromJobRec.modify;
            end;

            // Find which splits to delete
            in_SplitTMP.reset;
            in_SplitTMP.SetRange("Split ID", FromJobRec.ID);
            in_SplitTMP.SetRange("Split Job", FromJobRec.Job);
            in_SplitTMP.SetRange("Split Version", FromJobRec.Version);
            if in_SplitTMP.findfirst then
                repeat
                    if in_SplitTMP.Changed and
                    (in_SplitTMP."Imposition Type" = SplitParam."Imposition Type") and
                    (in_SplitTMP."Controlling Sheet Unit" = SplitParam."Controlling Sheet Unit") and
                    (in_SplitTMP.Finishing = SplitParam.Finishing) and
                    (in_SplitTMP."Paper Item No." = SplitParam."Paper Item No.") then begin
                        // moved to new job
                        Move_SplitTMP := in_SplitTMP;
                        Move_SplitTMP.insert;
                    end else begin
                        // stay on old job
                        Keep_SplitTMP := in_SplitTMP;
                        Keep_SplitTMP.insert;
                    end;
                until in_SplitTMP.next = 0;


            if Keep_SplitTMP.IsEmpty then begin
                // Change only on existing job
                NewJobRec := FromJobRec;
            end else begin
                // Split job in two
                NewJob := CopyMgt.Main_Copy_New_Job(FromJobRec);

                NewJobRec.Get(FromJobRec.ID, NewJob, 1);
                NewJobRec.TestField(Active, true);
                NewJobRec.TestField(Status, NewJobRec.Status::"Production Order");

                NewJobRec."Skip Calc." := true;
                NewJobRec.modify;

                // Delete on old Job
                DeleteShifts(FromJobRec, Keep_SplitTMP);

                // Delete on New Job
                DeleteShifts(NewJobRec, Move_SplitTMP);

                Move_SplitTMP.reset;
                Move_SplitTMP.modifyall("Split ID", NewJobRec.ID);
                Move_SplitTMP.modifyall("Split Job", NewJobRec.Job);
                Move_SplitTMP.modifyall("Split Version", NewJobRec.Version);

                // Reassign values on new and old job
                Move_SplitTMP.reset;
                if Move_SplitTMP.findset then
                    repeat
                        // Update Split values
                        if in_SplitTMP.get(Move_SplitTMP.ID, Move_SplitTMP.Job, Move_SplitTMP.Version, Move_SplitTMP."Split No.", Move_SplitTMP."Job Item No.", Move_SplitTMP."Change No.") then begin
                            in_SplitTMP.TransferFields(Move_SplitTMP);
                            in_SplitTMP.modify;
                        end;
                    until Move_SplitTMP.next = 0;
                Keep_SplitTMP.reset;
                if Keep_SplitTMP.findset then
                    repeat
                        // Update Split values
                        if in_SplitTMP.get(Keep_SplitTMP.ID, Keep_SplitTMP.Job, Keep_SplitTMP.Version, Keep_SplitTMP."Split No.", Keep_SplitTMP."Job Item No.", Keep_SplitTMP."Change No.") then begin
                            in_SplitTMP.TransferFields(Keep_SplitTMP);
                            in_SplitTMP.modify;
                        end;
                    until Keep_SplitTMP.next = 0;
            end;

            UpdateShift(NewJobRec, SplitParam);

        end;

        local procedure DeleteShifts(var in_JobRec: Record "PVS Job"; var in_KeepSplitTMP: Record "PTE Job Shift Split" temporary)
        var
            JobItemRec: Record "PVS Job Item";
            JobItemTMP: Record "PVS Job Item" temporary;
            SheetMgt: Codeunit "PVS Sheet Management";
            ChangeRec: Record "PVS Job Item Plate Changes";
            ChangeTMP: Record "PVS Job Item Plate Changes" temporary;
            qty: Decimal;
            Total, Last : integer;
        begin
            in_KeepSplitTMP.reset;

            // Delete JobItems
            JobItemRec.SetRange(ID, in_JobRec.ID);
            JobItemRec.SetRange(Job, in_JobRec.Job);
            JobItemRec.SetRange(Version, in_JobRec.Version);
            if JobItemRec.FindSet(true, false) then
                repeat
                    // Is still used?
                    in_KeepSplitTMP.SetRange("Job Item No.", JobItemRec."Job Item No.");
                    if in_KeepSplitTMP.IsEmpty then begin
                        JobItemTMP := JobItemRec;
                        JobItemTMP.insert;
                    end;
                until JobItemRec.next = 0;

            if JobItemTMP.findset then
                repeat
                    JobItemRec.get(JobItemTMP.ID, JobItemTMP.Job, JobItemTMP.Version, JobItemTMP."Job Item No.", JobItemTMP."Entry No.");
                    //JobItemRec.Delete(true);
                    SheetMgt.Event_Delete_Sheet(JobItemRec, false);
                until JobItemTMP.next = 0;

            // Delete PlateChanges

            ChangeRec.SetRange(ID, in_JobRec.ID);
            ChangeRec.SetRange(Job, in_JobRec.Job);
            ChangeRec.SetRange(Version, in_JobRec.Version);
            if ChangeRec.FindSet(true, false) then
                repeat
                    // Is still used?
                    in_KeepSplitTMP.SetRange("Job Item No.", ChangeRec."Job Item No.");
                    in_KeepSplitTMP.SetRange("Change No.", ChangeRec."Change No.");
                    if in_KeepSplitTMP.IsEmpty then begin
                        ChangeTMP := ChangeRec;
                        ChangeTMP.insert;
                    end;
                until ChangeRec.next = 0;

            if ChangeTMP.findset then
                repeat
                    ChangeRec.get(ChangeTMP.ID, ChangeTMP.Job, ChangeTMP.Version, ChangeTMP."Job Item No.", ChangeTMP."Change No.");
                    ChangeRec.Delete(true);
                until ChangeTMP.next = 0;


            // Update qty + Colors
            in_KeepSplitTMP.reset;
            JobItemRec.SetRange(ID, in_JobRec.ID);
            JobItemRec.SetRange(Job, in_JobRec.Job);
            JobItemRec.SetRange(Version, in_JobRec.Version);
            JobItemRec.SetRange("Entry No.", 1);
            if JobItemRec.FindSet(true, false) then
                repeat
                    qty := 0;
                    Total := 0;
                    last := 0;
                    in_KeepSplitTMP.SetRange("Split Job Item No.", JobItemRec."Job Item No.");
                    if in_KeepSplitTMP.findset(true) then
                        repeat
                            qty += in_KeepSplitTMP.Quantity;
                            in_KeepSplitTMP."Split Change No." := Total;
                            // in_SplitTMP."Reassigned Change No." := Total;
                            in_KeepSplitTMP.modify;

                            Total += 1;
                            Last := in_KeepSplitTMP."Split Change No.";
                        until in_KeepSplitTMP.next = 0;

                    // change qty
                    if (qty <> 0) and (qty < JobItemRec.Quantity) then begin
                        JobItemRec.validate(Quantity, qty);
                        JobItemRec.modify(true)
                    end;

                    // change no of plate changes
                    ChangeRec.SetRange(ID, JobItemRec.ID);
                    ChangeRec.SetRange(Job, JobItemRec.Job);
                    ChangeRec.SetRange(Version, JobItemRec.Version);
                    ChangeRec.SetRange("Job Item No.", JobItemRec."Job Item No.");
                    if ChangeRec.Findlast then begin
                        ChangeRec.Maintain_JobItem_PlateChanges();
                    end;

                    // clear new change 0
                    if ChangeRec.get(JobItemRec.ID, JobItemRec.Job, JobItemRec.Version, JobItemRec."Job Item No.", 0) then begin
                        ChangeRec."Changes Back" := 0;
                        ChangeRec."Changes Front" := 0;
                        ChangeRec.modify;
                    end;
                until JobItemRec.next = 0;

        end;

        local procedure UpdateShift(var in_JobRec: Record "PVS Job"; SplitParam: Record "PTE Job Shift Split")
        //var in_UpdateSplitTMP: Record "PTE Job Shift Split" temporary
        var
            pp: Codeunit "PVS Page Management";
            ppp: Page "PVS Job Item List2 SUB";
            JobItemRec: Record "PVS Job Item";
            ChangeRec: Record "PVS Job Item Plate Changes";
            ChangeTmp: Record "PVS Job Item Plate Changes" temporary;
            SheetRec: Record "PVS Job Sheet";
        //        qty: Decimal;
        //        Total, Last : integer;
        begin

            // Update qty + Colors
            //in_SplitTMP."Split Change No." :=
            JobItemRec.SetRange(ID, in_JobRec.ID);
            JobItemRec.SetRange(Job, in_JobRec.Job);
            JobItemRec.SetRange(Version, in_JobRec.Version);
            JobItemRec.SetRange("Entry No.", 1);
            if JobItemRec.FindSet(true, false) then
                repeat

                                    // qty := 0;
                                    // Total := 0;
                                    // last := 0;
                                    // in_UpdateSplitTMP.SetRange("Split Job Item No.", JobItemRec."Job Item No.");
                                    // if in_UpdateSplitTMP.findset(true) then
                                    //     repeat
                                    //         qty += in_UpdateSplitTMP.Quantity;
                                    //         in_UpdateSplitTMP."Split Change No." := Total;
                                    //                                 in_UpdateSplitTMP.modify;

                                    //         Total += 1;
                                    //         Last := in_UpdateSplitTMP."Split Change No.";
                                    //     until in_UpdateSplitTMP.next = 0;

                                    // // change qty
                                    // if (qty <> 0) and (qty < JobItemRec.Quantity) then begin
                                    //     JobItemRec.validate(Quantity, qty);
                                    //     JobItemRec.modify(true)
                                    // end;

                                    // // change no of plate changes
                                    // ChangeRec.SetRange(ID, JobItemRec.ID);
                                    // ChangeRec.SetRange(Job, JobItemRec.Job);
                                    // ChangeRec.SetRange(Version, JobItemRec.Version);
                                    // ChangeRec.SetRange("Job Item No.", JobItemRec."Job Item No.");
                                    // if ChangeRec.Findlast then begin
                                    //     ChangeRec.Maintain_JobItem_PlateChanges();
                                    // end;

                                    // // clear new change 0
                                    // if ChangeRec.get(JobItemRec.ID, JobItemRec.Job, JobItemRec.Version, JobItemRec."Job Item No.", 0) then begin
                                    //     ChangeRec."Changes Back" := 0;
                                    //     ChangeRec."Changes Front" := 0;
                                    //     ChangeRec.modify;
                                    // end;

                    If SplitParam."Changed Paper Item No." then begin
                        SheetRec.get(JobItemRec."Sheet ID");
                        SheetRec.Validate("Paper Item No.", SplitParam."Paper Item No.");
                    end;

                    if SplitParam."Changed Controlling Sheet Unit" then begin
                        SheetRec.get(JobItemRec."Sheet ID");
                        SheetRec.Validate("Controlling Unit", SplitParam."Controlling Sheet Unit");
                    end;

                    if SplitParam."Changed Imposition Type" then begin
                        JobItemRec."Manual Imposition Type" := true;
                        JobItemRec.Validate("Imposition Type", SplitParam."Imposition Type");
                    end;

                    if SplitParam."Changed Finishing" then begin
                        SheetRec.get(JobItemRec."Sheet ID");
                        SheetRec.Validate(Finishing, SplitParam.Finishing);
                    end;
                until JobItemRec.next = 0;
        end;
    */


}