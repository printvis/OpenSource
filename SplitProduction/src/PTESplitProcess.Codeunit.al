codeunit 80180 "PTE Split Process"
{
    var
        TempFixVariantTMP: Record "PVS Job Item Variant" temporary;
        SplitMgt: Codeunit "PTE Split Mgt";

    procedure Update_SplitJobItem(var in_SplitTMP: Record "PTE Job Shift Split" temporary)
    var
        JobRec: Record "PVS Job";
        MappingRec: Record "PVS Job Product / Variant Map.";
        TempNewJobItemNo: Record Integer temporary;
        TempChangedJobItemNo: Record Integer temporary;
        FromJobItemRec, ToJobItemRec : Record "PVS Job Item";
        CalculationMgt: Codeunit "PVS Calculation Management";
        PointerMgt: Codeunit "PVS Pointer Management";
        PlanningMgt: Codeunit "PVS Planning Management";
    begin
        // Anything to split or Change
        in_SplitTMP.reset();
        if in_SplitTMP.findset() then
            repeat
                if in_SplitTMP."Split Job Item No." <> 0 then begin
                    TempNewJobItemNo.Number := in_SplitTMP."Split Job Item No.";
                    if TempNewJobItemNo.Insert() then;
                end;
                if in_SplitTMP.Changed then begin
                    if in_SplitTMP."Split Job Item No." <> 0 then
                        TempChangedJobItemNo.Number := in_SplitTMP."Split Job Item No."
                    else
                        TempChangedJobItemNo.Number := in_SplitTMP."Job Item No. 2";
                    if TempChangedJobItemNo.insert() then;
                end;
            until in_SplitTMP.next() = 0;
        in_SplitTMP.reset();
        if TempNewJobItemNo.IsEmpty and TempChangedJobItemNo.IsEmpty then
            exit;

        JobRec.get(in_SplitTMP.ID, in_SplitTMP.Job, in_SplitTMP.Version);
        JobRec."Skip Calc." := true;
        JobRec.Modify();

        // Split jobitems
        if TempNewJobItemNo.findset() then begin
            repeat
                in_SplitTMP.Reset();
                in_SplitTMP.SetRange("Split Job Item No.", TempNewJobItemNo.Number);
                in_SplitTMP.FindFirst();
                in_SplitTMP.SetRange("Split Job Item No.");
                FromJobItemRec.get(in_SplitTMP.ID, in_SplitTMP.Job, in_SplitTMP.Version, in_SplitTMP."Job Item No.", 1);

                if ToJobItemRec.get(in_SplitTMP.ID, in_SplitTMP.Job, in_SplitTMP.Version, TempNewJobItemNo.Number, 1) then
                    MovePlateChanges(FromJobItemRec, ToJobItemRec, in_SplitTMP)
                else
                    // New job item should be created
                    SplitJobItem(FromJobItemRec, TempNewJobItemNo.Number, in_SplitTMP);

            until TempNewJobItemNo.next() = 0;

            // Finalize job
            MappingRec.Calc_Qty_JobItem(JobRec.ID, JobRec.Job, JobRec.Version);
            PointerMgt.Build_PointerSequence_Job(JobRec.ID, JobRec.Job, JobRec.Version);
            PlanningMgt.Create_PlanUnits_Job_Version(JobRec);
        end;

        if TempChangedJobItemNo.findset() then
            repeat
                // Change attributes
                ChangeNewJobItem(TempChangedJobItemNo.Number, in_SplitTMP);
            until TempChangedJobItemNo.next() = 0;

        JobRec.get(in_SplitTMP.ID, in_SplitTMP.Job, in_SplitTMP.Version);
        if JobRec."Skip Calc." then begin
            JobRec."Skip Calc." := false;
            JobRec.Modify();
            CalculationMgt.Main_Calculate_Job(JobRec.ID, JobRec.Job, JobRec.Version);
        end;
    end;

    local procedure SplitJobItem(FromJobItemRec: Record "PVS Job Item"; NewJobItemNo: Integer; var in_SplitTMP: Record "PTE Job Shift Split" temporary)
    var
        TempMovePlateChange: Record Integer temporary;
        ToJobItem: Record "PVS Job Item";
        SheetRec: Record "PVS Job Sheet";
        New_VariantRec: Record "PVS Job Item Variant";
        TempPlateChange: Record "PVS Job Item Plate Changes" temporary;
        SheetMgt: Codeunit "PVS Sheet Management";
    begin
        in_SplitTMP.Check_Manuel_SplitNo();
        // Read platechanges to move
        in_SplitTMP.reset();
        in_SplitTMP.SetRange("Job Item No.", FromJobItemRec."Job Item No.");
        in_SplitTMP.SetRange("Split Job Item No.", NewJobItemNo);
        in_SplitTMP.FindSet();
        repeat
            TempMovePlateChange.Number := in_SplitTMP."Change No.";
            TempMovePlateChange.insert();
        until in_SplitTMP.next() = 0;
        // copy job item
        Copy_JobItem(FromJobItemRec, NewJobItemNo, TempMovePlateChange, in_SplitTMP);

        // delete plate changes
        Delete_PlateChanges_From_JobItem(FromJobItemRec, TempMovePlateChange, NewJobItemNo);

        New_VariantRec.SetRange(ID, FromJobItemRec.ID);
        New_VariantRec.SetRange(Job, FromJobItemRec.Job);
        New_VariantRec.SetRange(Version, FromJobItemRec.Version);
        New_VariantRec.SetRange("Job Item No.", FromJobItemRec."Job Item No.");
        if New_VariantRec.FindFirst() then begin

            // reassign plate no + adjust qty on Item
            Simulate_Renumber_fix(New_VariantRec, TempPlateChange, in_SplitTMP);
            New_VariantRec.Calculate_PlateChange_Qty();
            After_Renumber_fix(New_VariantRec);
        end;

        //Update plates
        UpdatePlatesOnJobItem(FromJobItemRec);
        if ToJobItem.Get(FromJobItemRec.ID, FromJobItemRec.Job, FromJobItemRec.Version, NewJobItemNo, 1) then
            UpdatePlatesOnJobItem(ToJobItem);
        // Adjust Sheet qty from JobItems
        if SheetRec.get(FromJobItemRec."Sheet ID") then
            SheetMgt.Update_Sheet_From_JobItems(SheetRec);
    end;

    local procedure MovePlateChanges(var FromJobItemRec: Record "PVS Job Item"; var ToJobItemRec: Record "PVS Job Item"; var in_SplitTMP: Record "PTE Job Shift Split" temporary)
    var
        TempMovePlateChange: Record Integer temporary;
        TempJobItemsToIterate: Record Integer temporary;
    begin
        in_SplitTMP.Check_Manuel_SplitNo();

        //Check all entries with a input value in the New Job Item value, store the current Job Item for later
        in_SplitTMP.reset();
        in_SplitTMP.SetRange("Split Job Item No.", ToJobItemRec."Job Item No.");
        in_SplitTMP.FindSet();
        repeat
            TempJobItemsToIterate.Number := in_SplitTMP."Job Item No.";
            if TempJobItemsToIterate.Insert() then;
        until in_SplitTMP.next() = 0;

        // Iterate all Job Items
        // to avoid plate changes being the same no from erroring out
        if TempJobItemsToIterate.FindSet() then
            repeat
                TempMovePlateChange.Reset();
                TempMovePlateChange.DeleteAll();
                in_SplitTMP.reset();
                in_SplitTMP.SetRange("Job Item No.", TempJobItemsToIterate.Number);
                in_SplitTMP.SetRange("Split Job Item No.", ToJobItemRec."Job Item No.");
                in_SplitTMP.FindSet();
                repeat
                    TempMovePlateChange.Number := in_SplitTMP."Change No.";
                    TempMovePlateChange.insert();
                until in_SplitTMP.next() = 0;
                if FromJobItemRec.get(in_SplitTMP.ID, in_SplitTMP.Job, in_SplitTMP.Version, in_SplitTMP."Job Item No.", 1) then;
                //Fetch updated plate change no if present

                // copy job item
                Move_JobItem(FromJobItemRec, ToJobItemRec, TempMovePlateChange, in_SplitTMP);

                // delete plate changes
                Delete_PlateChanges_From_JobItem(FromJobItemRec, TempMovePlateChange, ToJobItemRec."Job Item No.");
            until TempJobItemsToIterate.Next() = 0;
    end;

    local procedure Move_JobItem(From_JobItemRec: Record "PVS Job Item"; To_JobItemRec: Record "PVS Job Item"; var MovePlateChange: Record Integer temporary; var in_SplitTMP: Record "PTE Job Shift Split" temporary)
    var
        TempFrom_PlateChange: Record "PVS Job Item Plate Changes" temporary;
        TempFrom_Variant: Record "PVS Job Item Variant" temporary;
        TempFrom_Mapping: Record "PVS Job Product / Variant Map." temporary;
        TempRenumberedPlateChange: Record "PVS Job Item Plate Changes" temporary;
        SheetRec: Record "PVS Job Sheet";
        New_PlateChangeRec: Record "PVS Job Item Plate Changes";
        New_VariantRec: Record "PVS Job Item Variant";
        New_MappingRec: Record "PVS Job Product / Variant Map.";
        SheetMgt: Codeunit "PVS Sheet Management";
    begin
        // Read tmp plate, changes, variants and mapping
        MovePlateChange.reset();
        MovePlateChange.FindSet();
        repeat
            New_PlateChangeRec.get(From_JobItemRec.ID, From_JobItemRec.Job, From_JobItemRec.Version, From_JobItemRec."Job Item No.", MovePlateChange.Number);
            TempFrom_PlateChange := New_PlateChangeRec;
            TempFrom_PlateChange.insert();

            New_VariantRec.SetRange(ID, TempFrom_PlateChange.ID);
            New_VariantRec.SetRange(Job, TempFrom_PlateChange.Job);
            New_VariantRec.SetRange(Version, TempFrom_PlateChange.Version);
            New_VariantRec.SetRange("Job Item No.", TempFrom_PlateChange."Job Item No.");
            New_VariantRec.SetRange("Sheet ID", TempFrom_PlateChange."Change No.");
            if New_VariantRec.FindSet() then
                repeat
                    TempFrom_Variant := New_VariantRec;
                    TempFrom_Variant.insert();
                until New_VariantRec.Next() = 0;
        until MovePlateChange.next() = 0;

        New_MappingRec.SetRange(ID, TempFrom_PlateChange.ID);
        New_MappingRec.SetRange(Job, TempFrom_PlateChange.Job);
        New_MappingRec.SetRange(Version, TempFrom_PlateChange.Version);
        New_MappingRec.SetRange("Job Item No.", TempFrom_PlateChange."Job Item No.");

        if TempFrom_Variant.FindSet() then
            repeat
                New_MappingRec.SetRange("Variant Entry No.", TempFrom_Variant."Variant Entry No.");
                if New_MappingRec.FindSet() then
                    repeat
                        TempFrom_Mapping := New_MappingRec;
                        if TempFrom_Mapping.insert() then;
                    until New_MappingRec.next() = 0;
            until TempFrom_Variant.next() = 0;


        // Plate change
        if TempFrom_PlateChange.findset() then
            repeat
                New_PlateChangeRec := TempFrom_PlateChange;
                New_PlateChangeRec."Job Item No." := To_JobItemRec."Job Item No.";
                New_PlateChangeRec."Change No." := New_PlateChangeRec."Change No." + 10000;
                New_PlateChangeRec.insert();
            until TempFrom_PlateChange.next() = 0;

        if TempFrom_Mapping.findset() then
            repeat
                New_MappingRec := TempFrom_Mapping;
                New_MappingRec."Job Item No." := To_JobItemRec."Job Item No.";
                New_MappingRec.insert();
            until TempFrom_Mapping.next() = 0;

        if TempFrom_Variant.FindSet() then
            repeat
                New_VariantRec := TempFrom_Variant;
                New_VariantRec."Job Item No." := To_JobItemRec."Job Item No.";
                New_VariantRec."Sheet ID" := New_VariantRec."Sheet ID" + 10000;
                New_VariantRec.insert();
            until TempFrom_Variant.next() = 0;

        // reassign plate no + adjust qty on Item
        Simulate_Renumber_fix(New_VariantRec, TempRenumberedPlateChange, in_SplitTMP);
        New_VariantRec.Calculate_PlateChange_Qty();
        After_Renumber_fix(New_VariantRec);
        // todo

        //Update plates
        UpdatePlatesOnJobItem(From_JobItemRec);
        UpdatePlatesOnJobItem(To_JobItemRec);

        // Adjust Sheet qty from JobItems
        if SheetRec.get(To_JobItemRec."Sheet ID") then
            SheetMgt.Update_Sheet_From_JobItems(SheetRec);
    end;

    procedure UpdatePlatesOnJobItem(In_JobItem: record "PVS Job Item")
    var
        PlateChangeRec: Record "PVS Job Item Plate Changes";
    begin
        PlateChangeRec.SetRange(ID, In_JobItem.ID);
        PlateChangeRec.SetRange(Job, In_JobItem.Job);
        PlateChangeRec.SetRange(Version, In_JobItem.Version);
        PlateChangeRec.SetRange("Job Item No.", In_JobItem."Job Item No.");
        if PlateChangeRec.findset() then
            repeat
                if PlateChangeRec."Change No." <> 0 then begin
                    PlateChangeRec."Changes Front" := In_JobItem."Colors Front";
                    PlateChangeRec."Changes Back" := In_JobItem."Colors Back";
                    PlateChangeRec."Sorting Order" := PlateChangeRec."Change No." * 10;
                end
                else begin
                    PlateChangeRec."Changes Back" := 0;
                    PlateChangeRec."Changes Front" := 0;
                    PlateChangeRec."Sorting Order" := 0;
                end;
                PlateChangeRec.modify();

            until (PlateChangeRec.Next() = 0);
    end;


    local procedure Copy_JobItem(From_JobItemRec: Record "PVS Job Item"; NewJobItemNo: Integer; var MovePlateChange: Record Integer temporary; var in_SplitTMP: Record "PTE Job Shift Split" temporary)
    var
        TempFrom_Process: Record "PVS Job Process" temporary;
        From_SheetRec: Record "PVS Job Sheet";
        TempFrom_Color: Record "PVS Job Item Color Entry" temporary;
        TempFrom_PlateChange: Record "PVS Job Item Plate Changes" temporary;
        TempFrom_Format: Record "PVS Job Item Format" temporary;
        TempFrom_CalcUnit: Record "PVS Job Calculation Unit" temporary;
        TempFrom_CalcLine: Record "PVS Job Calculation Detail" temporary;
        TempFrom_Variant: Record "PVS Job Item Variant" temporary;
        TempFrom_Mapping: Record "PVS Job Product / Variant Map." temporary;
        TempRenumberedPlateChange: Record "PVS Job Item Plate Changes" temporary;
        New_JobItemRec: Record "PVS Job Item";
        New_SheetRec: Record "PVS Job Sheet";
        New_ProcessRec: Record "PVS Job Process";
        New_ColorRec: Record "PVS Job Item Color Entry";
        New_PlateChangeRec: Record "PVS Job Item Plate Changes";
        New_FormatRec: Record "PVS Job Item Format";
        New_CalcUnitRec: Record "PVS Job Calculation Unit";
        New_CalcLineRec: Record "PVS Job Calculation Detail";
        New_VariantRec: Record "PVS Job Item Variant";
        New_MappingRec: Record "PVS Job Product / Variant Map.";
        SheetMgt: Codeunit "PVS Sheet Management";
        Last_JobItemNo: Integer;
        Last_CalcUnitNo: Integer;
    begin
        // Read tmp plate, changes, variants and mapping
        MovePlateChange.reset();
        MovePlateChange.FindSet();
        repeat
            in_SplitTMP.Reset();
            in_SplitTMP.SetRange(ID, From_JobItemRec.ID);
            in_SplitTMP.SetRange(Job, From_JobItemRec.Job);
            in_SplitTMP.SetRange(Version, From_JobItemRec.Version);
            in_SplitTMP.SetRange("Job Item No.", From_JobItemRec."Job Item No.");
            in_SplitTMP.SetRange("Old Change No.", MovePlateChange.Number);
            if in_SplitTMP.FindFirst() then
                New_PlateChangeRec.get(From_JobItemRec.ID, From_JobItemRec.Job, From_JobItemRec.Version, From_JobItemRec."Job Item No.", in_SplitTMP."OLD Change No.")
            else
                New_PlateChangeRec.get(From_JobItemRec.ID, From_JobItemRec.Job, From_JobItemRec.Version, From_JobItemRec."Job Item No.", MovePlateChange.Number);
            TempFrom_PlateChange := New_PlateChangeRec;
            TempFrom_PlateChange.insert();

            New_VariantRec.SetRange(ID, TempFrom_PlateChange.ID);
            New_VariantRec.SetRange(Job, TempFrom_PlateChange.Job);
            New_VariantRec.SetRange(Version, TempFrom_PlateChange.Version);
            New_VariantRec.SetRange("Job Item No.", TempFrom_PlateChange."Job Item No.");
            New_VariantRec.SetRange("Sheet ID", TempFrom_PlateChange."Change No.");
            if New_VariantRec.FindSet() then
                repeat
                    TempFrom_Variant := New_VariantRec;
                    TempFrom_Variant.insert();
                until New_VariantRec.Next() = 0;
        until MovePlateChange.next() = 0;

        New_MappingRec.SetRange(ID, TempFrom_PlateChange.ID);
        New_MappingRec.SetRange(Job, TempFrom_PlateChange.Job);
        New_MappingRec.SetRange(Version, TempFrom_PlateChange.Version);
        New_MappingRec.SetRange("Job Item No.", TempFrom_PlateChange."Job Item No.");

        if TempFrom_Variant.FindSet() then
            repeat
                New_MappingRec.SetRange("Variant Entry No.", TempFrom_Variant."Variant Entry No.");
                if New_MappingRec.FindSet() then
                    repeat
                        TempFrom_Mapping := New_MappingRec;
                        if TempFrom_Mapping.insert() then;
                    until New_MappingRec.next() = 0;
            until TempFrom_Variant.next() = 0;

        From_SheetRec.Get(From_JobItemRec."Sheet ID");

        New_ProcessRec.SetRange("Sheet ID", From_SheetRec."Sheet ID");
        if New_ProcessRec.FindSet() then
            repeat
                TempFrom_Process := New_ProcessRec;
                TempFrom_Process.insert();
            until New_ProcessRec.next() = 0;

        New_ColorRec.SetRange(ID, From_JobItemRec.ID);
        New_ColorRec.SetRange(Job, From_JobItemRec.Job);
        New_ColorRec.SetRange(Version, From_JobItemRec.Version);
        New_ColorRec.SetRange("Job Item No.", From_JobItemRec."Job Item No.");
        if New_ColorRec.FindSet() then
            repeat
                TempFrom_Color := New_ColorRec;
                TempFrom_Color.insert();
            until New_ColorRec.next() = 0;

        New_FormatRec.SetRange(ID, From_JobItemRec.ID);
        New_FormatRec.SetRange(Job, From_JobItemRec.Job);
        New_FormatRec.SetRange(Version, From_JobItemRec.Version);
        New_FormatRec.SetRange("Job Item No.", From_JobItemRec."Job Item No.");
        if New_FormatRec.findset() then
            repeat
                TempFrom_Format := New_FormatRec;
                TempFrom_Format.insert();
            until New_FormatRec.next() = 0;


        New_CalcUnitRec.reset();
        New_CalcUnitRec.SetRange(ID, From_JobItemRec.ID);
        New_CalcUnitRec.SetRange(Job, From_JobItemRec.Job);
        New_CalcUnitRec.SetRange(Version, From_JobItemRec.Version);
        if New_CalcUnitRec.FindLast() then
            Last_CalcUnitNo := New_CalcUnitRec."Entry No.";

        New_CalcUnitRec.SetRange("Sheet ID", From_JobItemRec."Sheet ID");

        New_CalcLineRec.SetRange(ID, From_JobItemRec.ID);
        New_CalcLineRec.SetRange(Job, From_JobItemRec.Job);
        New_CalcLineRec.SetRange(Version, From_JobItemRec.Version);

        if New_CalcUnitRec.findset() then
            repeat
                TempFrom_CalcUnit := New_CalcUnitRec;
                TempFrom_CalcUnit.insert();
                New_CalcLineRec.SetRange("Unit Entry No.", New_CalcUnitRec."Entry No.");
                if New_CalcLineRec.findset() then
                    repeat
                        TempFrom_CalcLine := New_CalcLineRec;
                        TempFrom_CalcLine.insert();
                    until New_CalcLineRec.next() = 0;
            until New_CalcUnitRec.next() = 0;

        // Find Last JobItem
        New_JobItemRec.SetRange(ID, From_JobItemRec.ID);
        New_JobItemRec.SetRange(Job, From_JobItemRec.Job);
        New_JobItemRec.SetRange(Version, From_JobItemRec.Version);
        if not New_JobItemRec.FindLast() then
            exit;

        Last_JobItemNo := New_JobItemRec."Job Item No.";

        // Copy sub-tables

        // Sheet
        New_SheetRec := From_SheetRec;
        New_SheetRec."Sheet ID" := 0;
        New_SheetRec."Creation Date" := Today;
        New_SheetRec."Created by User" := CopyStr(UserId(), 1, MaxStrLen(New_SheetRec."Created By User"));
        New_SheetRec."Gang Job" := New_SheetRec."gang job"::" ";
        New_SheetRec."Gang Job Possible" := false;
        New_SheetRec."Ganged on Sheet ID" := 0;
        New_SheetRec."Ganged Pct." := 0;
        New_SheetRec.insert();

        // Process
        if TempFrom_Process.findset() then
            repeat
                New_ProcessRec := TempFrom_Process;
                New_ProcessRec."Process ID" := 0;
                New_ProcessRec."Creation Date" := Today;
                New_ProcessRec."Created by User" := CopyStr(UserId(), 1, MaxStrLen(New_ProcessRec."Created By User"));
                New_ProcessRec."Last Date Modified" := 0D;
                New_ProcessRec."Modified by User" := '';

                New_ProcessRec."Sheet ID" := New_SheetRec."Sheet ID";
                New_ProcessRec.insert();

                TempFrom_Process."Sheet ID" := New_ProcessRec."Process ID";
                TempFrom_Process.modify();
            until TempFrom_Process.next() = 0;

        if TempFrom_Process.Get(New_SheetRec."First Process ID") then
            New_SheetRec."First Process ID" := TempFrom_Process."Sheet ID"
        else
            New_SheetRec."First Process ID" := 0;
        New_SheetRec.modify();



        // Job Item
        New_JobItemRec := From_JobItemRec;
        New_JobItemRec."Creation Date" := Today;
        New_JobItemRec."Created by User" := CopyStr(UserId(), 1, MaxStrLen(New_JobItemRec."Created By User"));
        New_JobItemRec."Last Date Modified" := 0D;
        New_JobItemRec."Modified by User" := '';
        New_JobItemRec."Ganged from Sheet ID" := 0;
        New_JobItemRec."Entry No." := 1;
        New_JobItemRec."Sheet ID" := New_SheetRec."Sheet ID";
        Last_JobItemNo += 1;
        New_JobItemRec."Job Item No." := Last_JobItemNo;
        New_JobItemRec."Job Item No." := NewJobItemNo;
        if New_JobItemRec."Expanded From Job Item No." = 0 then
            New_JobItemRec."Expanded From Job Item No." := From_JobItemRec."Job Item No.";
        New_JobItemRec."Job Item No. 2" := NewJobItemNo;
        New_JobItemRec.insert();


        // Colors
        if TempFrom_Color.findset() then
            repeat
                New_ColorRec := TempFrom_Color;
                New_ColorRec."Job Item No." := New_JobItemRec."Job Item No.";
                New_ColorRec."Entry No." := New_JobItemRec."Entry No.";

                if New_ColorRec."Sheet ID" = From_SheetRec."Sheet ID" then
                    New_ColorRec."Sheet ID" := New_SheetRec."Sheet ID"
                else
                    New_ColorRec."Sheet ID" := 0;

                if TempFrom_Process.Get(New_ColorRec."Process ID") then
                    New_ColorRec."Process ID" := TempFrom_Process."Sheet ID"
                else
                    New_ColorRec."Process ID" := 0;

                New_ColorRec.insert();
            until TempFrom_Color.next() = 0;

        // Job Item Formats
        if TempFrom_Format.findset() then
            repeat
                New_FormatRec := TempFrom_Format;
                New_FormatRec."Job Item No." := New_JobItemRec."Job Item No.";
                New_FormatRec."Job Item Entry No." := New_JobItemRec."Entry No.";
                New_FormatRec.insert();
            until TempFrom_Format.next() = 0;


        // Calc Units
        if TempFrom_CalcUnit.findset() then
            repeat
                New_CalcUnitRec := TempFrom_CalcUnit;
                Last_CalcUnitNo += 1;
                New_CalcUnitRec."Entry No." := Last_CalcUnitNo;
                New_CalcUnitRec."Sheet ID" := New_SheetRec."Sheet ID";

                if TempFrom_Process.Get(New_CalcUnitRec."Process ID") then
                    New_CalcUnitRec."Process ID" := TempFrom_Process."Sheet ID"
                else
                    New_CalcUnitRec."Process ID" := 0;

                New_CalcUnitRec."Plan ID" := 0;
                New_CalcUnitRec."Creation Date" := Today;
                New_CalcUnitRec."Created by User" := CopyStr(UserId(), 1, MaxStrLen(New_CalcUnitRec."Created By User"));
                New_CalcUnitRec.insert();

                TempFrom_CalcLine.SetRange("Unit Entry No.", TempFrom_CalcUnit."Entry No.");
                if TempFrom_CalcLine.findset() then
                    repeat
                        New_CalcLineRec := TempFrom_CalcLine;
                        New_CalcLineRec."Unit Entry No." := New_CalcUnitRec."Entry No.";
                        New_CalcLineRec."Creation Date" := Today;
                        New_CalcLineRec."Created by User" := CopyStr(UserId(), 1, MaxStrLen(New_CalcLineRec."Created By User"));
                        New_CalcLineRec."Last Date Modified" := 0D;
                        New_CalcLineRec."Modified by User" := '';
                        New_CalcLineRec."Sheet ID" := New_CalcUnitRec."Sheet ID";
                        New_CalcLineRec."Process ID" := New_CalcUnitRec."Process ID";
                        New_CalcLineRec."Error Text" := '';
                        New_CalcLineRec.insert();
                    until TempFrom_CalcLine.next() = 0;
            until TempFrom_CalcUnit.next() = 0;

        From_SheetRec.Assign_SheetNo();

        // copy plate, changes, variants and mapping

        // Plate change
        if TempFrom_PlateChange.findset() then
            repeat
                New_PlateChangeRec := TempFrom_PlateChange;
                New_PlateChangeRec."Job Item No." := New_JobItemRec."Job Item No.";
                New_PlateChangeRec.insert();
            until TempFrom_PlateChange.next() = 0;

        if TempFrom_Mapping.findset() then
            repeat
                New_MappingRec := TempFrom_Mapping;
                New_MappingRec."Job Item No." := New_JobItemRec."Job Item No.";
                New_MappingRec.insert();
            until TempFrom_Mapping.next() = 0;

        if TempFrom_Variant.FindSet() then
            repeat
                New_VariantRec := TempFrom_Variant;
                New_VariantRec."Job Item No." := New_JobItemRec."Job Item No.";
                New_VariantRec.insert();
            until TempFrom_Variant.next() = 0;

        // reassign plate no + adjust qty on Item
        Simulate_Renumber_fix(New_VariantRec, TempRenumberedPlateChange, in_SplitTMP);
        New_VariantRec.Calculate_PlateChange_Qty();
        After_Renumber_fix(New_VariantRec);
        // todo

        //Update plates
        UpdatePlatesOnJobItem(From_JobItemRec);
        UpdatePlatesOnJobItem(New_JobItemRec);


        // Adjust Sheet qty from JobItems
        SheetMgt.Update_Sheet_From_JobItems(New_SheetRec);
    end;


    local procedure Simulate_Renumber_fix(in_VariantRec: Record "PVS Job Item Variant"; var PlateChangeTmp: Record "PVS Job Item Plate Changes" temporary; var in_SplitTMP: Record "PTE Job Shift Split" temporary);
    var
        TempFoundOrMovedEntriesSplit: Record "PTE Job Shift Split" temporary;
        TempJobItemsToUpdate: record Integer temporary;
        VariantRec: Record "PVS Job Item Variant";
        PlateChangeRec: Record "PVS Job Item Plate Changes";
        i: Integer;
    begin
        i := 0;
        TempFixVariantTMP.DeleteAll();
        // Simulate platechange renumber
        PlateChangeRec.SetRange(ID, in_VariantRec.ID);
        PlateChangeRec.SetRange(Job, in_VariantRec.Job);
        PlateChangeRec.SetRange(Version, in_VariantRec.Version);
        PlateChangeRec.SetRange("Job Item No.", in_VariantRec."Job Item No.");

        VariantRec.SetRange(ID, in_VariantRec.ID);
        VariantRec.SetRange(Job, in_VariantRec.Job);
        VariantRec.SetRange(Version, in_VariantRec.Version);
        VariantRec.SetRange("Job Item No.", in_VariantRec."Job Item No.");

        in_SplitTMP.Reset();
        in_SplitTMP.SetRange(ID, in_VariantRec.ID);
        in_SplitTMP.SetRange(Job, in_VariantRec.Job);
        in_SplitTMP.SetRange(Version, in_VariantRec.Version);

        //Entries moved
        if PlateChangeRec.FindSet(false) then
            repeat
                //if in_SplitTMP."Change No." <> PlateChangeRec."Change No." then begin
                PlateChangeTmp := PlateChangeRec;
                PlateChangeTmp.ID := i;
                PlateChangeTmp.Insert();

                VariantRec.SetRange("Sheet ID", PlateChangeRec."Change No.");
                if VariantRec.FindSet(false) then
                    repeat
                        //Get existing entry if exists 
                        //Entries either not going to be modified or is awaiting next iteration
                        in_SplitTMP.SetRange("Change No.", PlateChangeTmp.ID);
                        in_SplitTMP.SetRange("Job Item No.", in_VariantRec."Job Item No.");
                        if in_SplitTMP.IsEmpty() then begin
                            in_SplitTMP.SetRange("Job Item No.");
                            in_SplitTMP.SetRange("Split Job Item No.", in_VariantRec."Job Item No.");
                            in_SplitTMP.SetRange("Change No.");
                        end;
                        if in_SplitTMP.FindFirst() then begin

                            TempFixVariantTMP := VariantRec;
                            TempFixVariantTMP.ID := i;
                            TempFixVariantTMP.Insert();
                            if in_SplitTMP."Split Job Item No." <> 0 then begin
                                TempJobItemsToUpdate.Number := in_SplitTMP."Job Item No.";
                                if TempJobItemsToUpdate.insert() then;
                            end;
                            TempFoundOrMovedEntriesSplit := in_SplitTMP;
                            in_SplitTMP.Delete();
                            TempFoundOrMovedEntriesSplit."Job Item No." := in_VariantRec."Job Item No.";
                            if (TempFoundOrMovedEntriesSplit."Job Item No." = TempFoundOrMovedEntriesSplit."Split Job Item No.") and
                            (TempFoundOrMovedEntriesSplit."Job Item No." = in_VariantRec."Job Item No.") then
                                TempFoundOrMovedEntriesSplit."Split Job Item No." := 0;
                            if TempFoundOrMovedEntriesSplit."Old Change No." = 0 then
                                TempFoundOrMovedEntriesSplit."Old Change No." := TempFoundOrMovedEntriesSplit."Change No.";
                            TempFoundOrMovedEntriesSplit."Change No." := i;
                            TempFoundOrMovedEntriesSplit.Insert();

                        end;
                    until VariantRec.Next() = 0;
                //end;
                i += 1;
            until PlateChangeRec.Next() = 0;



        //Update Old Job Item Tmp entries
        if TempJobItemsToUpdate.FindSet() then
            repeat
                i := 0;
                in_SplitTMP.Reset();

                //Check if any entries have been moved already
                TempFoundOrMovedEntriesSplit.Reset();
                TempFoundOrMovedEntriesSplit.SetRange("Job Item No.", TempJobItemsToUpdate.Number);
                if TempFoundOrMovedEntriesSplit.FindFirst() then
                    i := TempFoundOrMovedEntriesSplit."Change No." + 1;
                TempFoundOrMovedEntriesSplit.Reset();
                in_SplitTMP.SetRange("Job Item No.", TempJobItemsToUpdate.Number);
                if in_SplitTMP.FindSet() then
                    repeat
                        TempFoundOrMovedEntriesSplit := in_SplitTMP;
                        if TempFoundOrMovedEntriesSplit."Old Change No." = 0 then
                            TempFoundOrMovedEntriesSplit."Old Change No." := TempFoundOrMovedEntriesSplit."Change No.";
                        TempFoundOrMovedEntriesSplit."Change No." := i;
                        TempFoundOrMovedEntriesSplit.Insert();
                        in_SplitTMP.Delete();
                        i += 1;
                    until in_SplitTMP.Next() = 0;
            until TempJobItemsToUpdate.Next() = 0;

        TempFoundOrMovedEntriesSplit.Reset();
        if TempFoundOrMovedEntriesSplit.FindSet() then
            repeat
                in_SplitTMP := TempFoundOrMovedEntriesSplit;
                in_SplitTMP.Insert();
            until TempFoundOrMovedEntriesSplit.next() = 0;
    end;

    local procedure After_Renumber_fix(in_VariantRec: Record "PVS Job Item Variant");
    var
        VariantRec: Record "PVS Job Item Variant";
    begin
        if TempFixVariantTMP.FindSet() then
            repeat
                VariantRec.Get(in_VariantRec.ID, in_VariantRec.Job, in_VariantRec.Version, TempFixVariantTMP."Job Item No.", TempFixVariantTMP."Variant Entry No.", TempFixVariantTMP."Variant Forms");
                if VariantRec."Sheet ID" <> TempFixVariantTMP.ID then begin
                    VariantRec."Sheet ID" := TempFixVariantTMP.ID;
                    VariantRec.Modify();
                end;
            until TempFixVariantTMP.Next() = 0;
    end;


    local procedure Delete_PlateChanges_From_JobItem(var in_JobItemRec: Record "PVS Job Item"; var DeletePlateChange: Record Integer temporary; NewJobItemNo: Integer)
    var
        SheetRec: Record "PVS Job Sheet";
        PlateChangeRec: Record "PVS Job Item Plate Changes";
        VariantRec: Record "PVS Job Item Variant";
        TempVariant: Record "PVS Job Item Variant" temporary;
        MappingRec: Record "PVS Job Product / Variant Map.";
        SHEET: Codeunit "PVS Sheet Management";
        SheetMgt: Codeunit "PVS Sheet Management";
        EmptyJob: Boolean;
    begin

        // Will this empty the entime job item 
        // then delete job item and exit
        EmptyJob := true;
        PlateChangeRec.SetRange(ID, in_JobItemRec.ID);
        PlateChangeRec.SetRange(job, in_JobItemRec.Job);
        PlateChangeRec.SetRange(version, in_JobItemRec.Version);
        PlateChangeRec.SetRange("Job Item No.", in_JobItemRec."Job Item No.");
        if PlateChangeRec.findset() then
            repeat
                if not
                DeletePlateChange.Get(PlateChangeRec."Change No.") then
                    EmptyJob := false;
            until PlateChangeRec.next() = 0;

        if EmptyJob then begin
            //Delete sheet - otherwise it will error out potentially
            JobItemUpdateExpandedFromJobItemNo(in_JobItemRec, NewJobItemNo);
            SplitMgt.SetMergingOrSplittingSheet(true);
            SHEET.Event_Delete_Sheet(in_JobItemRec, true);
            SplitMgt.SetMergingOrSplittingSheet(false);
            // if in_JobItemRec."Expanded From Job Item No." = 0 then begin
            //     NewJobItem.SetRange(ID, in_JobItemRec.ID);
            //     NewJobItem.SetRange(Job, in_JobItemRec.Job);
            //     NewJobItem.SetRange(Version, in_JobItemRec.Version);
            //     NewJobItem.SetRange("Job item No.", NewJobItemNo);
            //     if NewJobItem.FindFirst() then begin
            //         //NewJobItem."Expanded From Job Item No." := 0;
            //         //NewJobItem.Modify(false);
            //     end;
            // end;
            exit;
        end;

        DeletePlateChange.reset();
        DeletePlateChange.findset();
        repeat
            // Find Variants to delete
            VariantRec.SetRange(ID, in_JobItemRec.ID);
            VariantRec.SetRange(Job, in_JobItemRec.Job);
            VariantRec.SetRange(Version, in_JobItemRec.Version);
            VariantRec.SetRange("Job Item No.", in_JobItemRec."Job Item No.");
            VariantRec.SetRange("Sheet ID", DeletePlateChange.Number);

            if VariantRec.findset(true) then
                repeat
                    TempVariant := VariantRec;
                    TempVariant.insert();
                until VariantRec.next() = 0;

            PlateChangeRec.Get(in_JobItemRec.ID, in_JobItemRec.Job, in_JobItemRec.Version, in_JobItemRec."Job Item No.", DeletePlateChange.Number);
            PlateChangeRec.Delete(true);

        until DeletePlateChange.next() = 0;

        // Delete Variants
        if TempVariant.findset() then
            repeat
                VariantRec.Get(TempVariant.ID, TempVariant.Job, TempVariant.Version, TempVariant."Job Item No.", TempVariant."Variant Entry No.", TempVariant."Variant Forms");
                VariantRec.delete(false);
            until TempVariant.next() = 0;

        // Delete  mapping
        MappingRec.Reset();
        MappingRec.SetRange(ID, in_JobItemRec.ID);
        MappingRec.SetRange(Job, in_JobItemRec.Job);
        MappingRec.SetRange(Version, in_JobItemRec.Version);
        MappingRec.SetRange("Job Item No.", in_JobItemRec."Job Item No.");

        VariantRec.Reset();
        VariantRec.SetRange(ID, in_JobItemRec.ID);
        VariantRec.SetRange(Job, in_JobItemRec.Job);
        VariantRec.SetRange(Version, in_JobItemRec.Version);
        VariantRec.SetRange("Job Item No.", in_JobItemRec."Job Item No.");

        if MappingRec.FindSet(true) then
            repeat
                VariantRec.SetRange("Variant Entry No.", MappingRec."Variant Entry No.");
                if VariantRec.IsEmpty then
                    MappingRec.delete(true);
            until MappingRec.next() = 0;

        // reassign plate no + adjust qty on Item
        VariantRec.SetRange("Variant Entry No.");
        if VariantRec.findset() then
            //Before_Renumber_fix(VariantRec);
            VariantRec.Calculate_PlateChange_Qty();
        //After_Renumber_fix(VariantRec);
        // todo

        // clear new change 0
        if PlateChangeRec.get(in_JobItemRec.ID, in_JobItemRec.Job, in_JobItemRec.Version, in_JobItemRec."Job Item No.", 0) then begin
            PlateChangeRec."Changes Back" := 0;
            PlateChangeRec."Changes Front" := 0;
            PlateChangeRec.modify();
        end;

        // Adjust Sheet qty from JobItems
        SheetRec.get(in_JobItemRec."Sheet ID");
        SheetMgt.Update_Sheet_From_JobItems(SheetRec);
    end;

    local procedure ChangeNewJobItem(ChangeJobItemNo: Integer; var in_SplitTMP: Record "PTE Job Shift Split" temporary)
    var
        JobItemRec: Record "PVS Job Item";
        SheetRec: Record "PVS Job Sheet";
        TempSplit: Record "PTE Job Shift Split" temporary;
        SplitOldFound: Boolean;
    begin
        in_SplitTMP.Reset();
        in_SplitTMP.SetRange(Changed, false);
        in_SplitTMP.SetRange("Job Item No.", ChangeJobItemNo);
        if in_SplitTMP.FindFirst() then begin
            TempSplit := in_SplitTMP;
            SplitOldFound := true;
        end;
        in_SplitTMP.SetRange(Changed, true);
        in_SplitTMP.SetRange("Job Item No.", ChangeJobItemNo);
        if not in_SplitTMP.FindFirst() then begin
            in_SplitTMP.SetRange("Job Item No.", 0);
            in_SplitTMP.SetRange("Job Item No. 2");
            in_SplitTMP.FindFirst();
        end;

        JobItemRec.SetRange(ID, in_SplitTMP.ID);
        JobItemRec.SetRange(Job, in_SplitTMP.Job);
        JobItemRec.SetRange(Version, in_SplitTMP.Version);
        JobItemRec.SetRange("Job Item No. 2", ChangeJobItemNo);
        JobItemRec.SetRange("Entry No.", 1);
        JobItemRec.FindFirst();

        If in_SplitTMP."Changed Paper Item No." and not SplitOldFound then begin
            SheetRec.get(JobItemRec."Sheet ID");
            SheetRec.Validate("Paper Item No.", in_SplitTMP."Paper Item No.");
        end;


        if in_SplitTMP."Changed Controlling Sheet Unit" and not SplitOldFound then begin
            SheetRec.get(JobItemRec."Sheet ID");
            SheetRec.Validate("Controlling Unit", in_SplitTMP."Controlling Sheet Unit");
        end;

        if in_SplitTMP."Changed Imposition Type" then begin
            JobItemRec.get(JobItemRec.ID, JobItemRec.Job, JobItemRec.Version, JobItemRec."Job Item No. 2", 1);
            JobItemRec."Manual Imposition Type" := true;
            JobItemRec.Validate("Imposition Type", in_SplitTMP."Imposition Type");
        end;

        if in_SplitTMP."Changed Finishing" then begin
            SheetRec.get(JobItemRec."Sheet ID");
            SheetRec.Validate(Finishing, in_SplitTMP.Finishing);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Signatures", 'OnBeforeBuild_Entries', '', false, false)]
    local procedure PVSJobSignaturesOnBeforeBuild_Entries(in_BuildEntriesForJob: Boolean; in_SheetRec: Record "PVS Job Sheet"; var IsHandled: Boolean; var out_RecTmp: Record "PVS Job Signatures" temporary)
    var
        PVSJobItem: Record "PVS Job Item";
        PVSJobItem2: Record "PVS Job Item";
        PVSJobSheet: Record "PVS Job Sheet";
        PVSJobSignatures: Record "PVS Job Signatures";
        GAF: Codeunit "PVS Table Filters";
        Counter: Integer;
        SheetSetID: Integer;
    begin

        if in_SheetRec."Sheet ID" = 0 then
            exit;
        GAF.SELECT_JobItems2Job(PVSJobItem, in_SheetRec.ID, in_SheetRec.Job, in_SheetRec.Version, true);
        // PVSJobItem.SetFilter("Expanded From Job Item No.", '<>%1', 0);
        //PVSJobItem.SetCurrentkey("Job Item No. 2");
        //ID: 322, Job: 1, Version: 3, Expanded from Entry No.: <>0
        IsHandled := true;
        out_RecTmp.reset();

        Counter := 0;
        if PVSJobItem.FindSet(false) then
            repeat
                if PVSJobSheet.get(PVSJobItem."Sheet ID") then begin
                    PVSJobItem2.SetRange("Sheet ID", PVSJobSheet."Sheet ID");
                    PVSJobItem2.SetFilter("Expanded From Job Item No.", '%1', 0);
                    if not PVSJobItem2.IsEmpty() then
                        for SheetSetID := 1 to PVSJobSheet."No. Of Sheet Sets" do begin
                            Counter += 1;

                            if in_BuildEntriesForJob or (PVSJobSheet."Sheet ID" = in_SheetRec."Sheet ID") then
                                if PVSJobSignatures.Get(PVSJobSheet."Sheet ID", SheetSetID, 0) then begin
                                    // use the stored value
                                    out_RecTmp := PVSJobSignatures;
                                    if out_RecTmp.insert() then;
                                end else
                                    // try to insert() a tmp record
                                    if not out_RecTmp.Get(PVSJobSheet."Sheet ID", SheetSetID, 0) then begin
                                        // insert() new tmp record
                                        out_RecTmp.Init();
                                        out_RecTmp."Sheet ID" := PVSJobSheet."Sheet ID";
                                        out_RecTmp."Sheet Set ID" := SheetSetID;
                                        out_RecTmp."Signature No." := Counter;
                                        out_RecTmp."Assembly Order" := Counter;
                                        out_RecTmp.ID := PVSJobSheet.ID;
                                        out_RecTmp.Job := PVSJobSheet.Job;
                                        out_RecTmp.Version := PVSJobSheet.Version;
                                        out_RecTmp."Job Item No." := PVSJobItem."Job Item No.";
                                        out_RecTmp."Entry No." := PVSJobItem."Entry No.";
                                        if out_RecTmp.Insert() then;

                                        GetPrintSignatureID(out_RecTmp);
                                        out_RecTmp."Print Signature Name" := CopyStr(SheetName(out_RecTmp), 1, MaxStrLen(out_RecTmp."Print Signature Name"));

                                        out_RecTmp.Modify(true);

                                        // later insert() extra records for finishing

                                    end else
                                        // the tmp record has already been inserted by another job item
                                        if (not PVSJobItem.MultipleJobItemsOnSheet()) or (PVSJobItem.FirstOfMultipleJobItemsOnSheet()) then begin
                                            // if the current job item is the first.. then update values on tmp record
                                            out_RecTmp."Assembly Order" := Counter;
                                            out_RecTmp."Print Signature Name" := CopyStr(SheetName(out_RecTmp), 1, MaxStrLen(out_RecTmp."Print Signature Name"));
                                            out_RecTmp.Modify(true);
                                        end;
                        end;
                end;
            until PVSJobItem.Next() = 0;
    end;

    local procedure SheetName(var in_PVSJobSignatures: Record "PVS Job Signatures") Result: Text
    var
        JobItemRec: Record "PVS Job Item";
        SheetRec: Record "PVS Job Sheet";
        Text005Lbl: label 'pp';
    begin
        if SheetRec.Get(in_PVSJobSignatures."Sheet ID") then begin
            SheetRec.CalcFields("Component Type Description");
            SheetRec.CalcFields("Job Item Description");
            Result := CopyStr((Format(SheetRec."Component Type") + '_'), 1, 250);
            JobItemRec.SetRange(ID, SheetRec.ID);
            JobItemRec.SetRange(Job, SheetRec.Job);
            JobItemRec.SetRange(Version, SheetRec.Version);
            JobItemRec.SetRange("Sheet ID", SheetRec."Sheet ID");
            if JobItemRec.FindFirst() then begin
                if JobItemRec.Description <> '' then
                    Result := CopyStr(((Format(JobItemRec.Description) + '_')), 1, 250);

                Result := CopyStr(((Result + Format(JobItemRec."Pages With Print") + Text005Lbl + '_')), 1, 250);
            end;

            Result := CopyStr(((Result + Format(SheetRec."Colors Front") + '-' + Format(SheetRec."Colors Back"))), 1, 250);

            Result := CopyStr(((Result + '-' + Format(in_PVSJobSignatures."Print Signature ID"))), 1, 250);
            Result := ConvertStr(Result, ' ', '_');
        end else
            Result := 'SHT' + Format(in_PVSJobSignatures."Sheet ID");
    end;

    local procedure GetPrintSignatureID(var in_PVSJobSignatures: Record "PVS Job Signatures")
    begin
        in_PVSJobSignatures.CalcFields("Sheet No.");
        in_PVSJobSignatures."Print Signature ID" := Format((in_PVSJobSignatures."Sheet No." * 1000) + in_PVSJobSignatures."Signature No.");
    end;

    local procedure JobItemUpdateExpandedFromJobItemNo(var FromJobItemRec: Record "PVS Job Item"; NewJobItemNo: Integer)
    var
        PVSJobItem: Record "PVS Job Item";
        JobItemNo: Integer;
    begin
        // Is it expanded / split
        if FromJobItemRec."Expanded From Job Item No." <> 0 then
            exit;
        //Check if there is other expanded entries
        //Get the lowest Job Item No.
        PVSJobItem.SetRange(ID, FromJobItemRec.ID);
        PVSJobItem.SetRange(Job, FromJobItemRec.Job);
        PVSJobItem.SetRange(Version, FromJobItemRec.Version);
        PVSJobItem.SetFilter("Job Item No.", '<>%1', FromJobItemRec."Job Item No.");
        PVSJobItem.SetRange("Expanded From Job Item No.", FromJobItemRec."Job Item No.");
        if PVSJobItem.FindFirst() then
            JobItemNo := PVSJobItem."Job Item No.";
        if JobItemNo >= NewJobItemNo then
            JobItemNo := NewJobItemNo
        else begin
            // Modify the new job item entry, so it gets the correct Expanded Job Item No. 
            PVSJobItem.SetRange("Job Item No.", NewJobItemNo);
            if PVSJobItem.FindSet() then
                PVSJobItem.ModifyAll("Expanded From Job Item No.", JobItemNo, true);

        end;
        // Modify the other job item entries, so it gets the correct Expanded Job Item No. 
        PVSJobItem.SetFilter("Job Item No.", '<>%1', JobItemNo);
        if PVSJobItem.FindSet() then
            PVSJobItem.ModifyAll("Expanded From Job Item No.", JobItemNo, true);

        //Update Job Item
        PVSJobItem.SetRange("Job Item No.", JobItemNo);
        if PVSJobItem.FindSet() then
            PVSJobItem.ModifyAll("Expanded From Job Item No.", 0, true);
    end;
}