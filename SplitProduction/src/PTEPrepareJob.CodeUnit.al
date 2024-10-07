codeunit 80182 "PTE Prepare Job"
{
    procedure PrepareJob(var in_JobRec: Record "PVS Job"): Boolean
    var
        CaseRec: Record "PVS Case";
        CaseModificationAllowed: Codeunit "PVS Case Modification Allowed";
        CalcMgt: Codeunit "PVS Calculation Management";
        PlanMgt: Codeunit "PVS Planning Management";
        RecRef: RecordRef;
    begin
        if not CheckJobStatus(in_JobRec) then
            exit(false);

        if IsReadyForSplit(in_JobRec) then begin
            message('Preparation already done');
            exit(true);
        end;
        if not CaseRec.Get(in_JobRec.ID) then
            exit(false);

        if not CaseModificationAllowed.Case_Is_Modification_Allowed(CaseRec, CaseRec, in_JobRec.Status, in_JobRec.Active, false, RecRef) then
            exit(false);

        if not CheckProdParts(in_JobRec, true) then
            exit(false);

        in_JobRec."Skip Calc." := true;
        in_JobRec.modify();

        PrepareJobItems(in_JobRec);

        in_JobRec.get(in_JobRec.ID, in_JobRec.Job, in_JobRec.Version);
        in_JobRec."Skip Calc." := false;
        in_JobRec.modify();

        CalcMgt.Main_Calculate_Job(in_JobRec.ID, in_JobRec.Job, in_JobRec.Version);
        PlanMgt.Adjust_Limits(0, in_JobRec.ID, in_JobRec.Job);
        in_JobRec.get(in_JobRec.ID, in_JobRec.Job, in_JobRec.Version);

        message('Preparation completed');
        exit(true);

    end;

    local procedure IsReadyForSplit(var in_JobRec: Record "PVS Job"): Boolean
    var
        VariantRec: Record "PVS Job Item Variant";
        PlateChange: Record "PVS Job Item Plate Changes";
    begin
        if not AllVariantsCreated(in_JobRec) then
            exit(false);

        // Check if any platechange exits
        PlateChange.SetRange(ID, in_JobRec.ID);
        PlateChange.SetRange(Job, in_JobRec.Job);
        PlateChange.SetRange(Version, in_JobRec.Version);
        if PlateChange.IsEmpty then
            exit(false);

        // Check for unassigned variants
        VariantRec.reset();
        VariantRec.SetRange(ID, in_JobRec.id);
        VariantRec.SetRange(Job, in_JobRec.Job);
        VariantRec.SetRange(Version, in_JobRec.Version);
        VariantRec.Setfilter("Sheet ID", '>1000');
        if not VariantRec.IsEmpty then
            exit(false);

        // check for unused plate changes
        if PlateChange.FindSet(false) then
            repeat
                VariantRec.SetRange("Job Item No.", PlateChange."Job Item No.");
                VariantRec.SetRange("Sheet ID", PlateChange."Change No.");
                if VariantRec.IsEmpty then
                    exit(false);
            until PlateChange.next() = 0;

        exit(true);
    end;

    local procedure CheckProdParts(var in_JobRec: Record "PVS Job"; CreateNew: Boolean): Boolean
    var
        ProdPart: Record "PVS Job Text Description";
    begin

        ProdPart.SetRange(ID, in_JobRec.ID);
        ProdPart.SetRange(Job, in_JobRec.Job);
        ProdPart.SetRange(Version, in_JobRec.Version);
        ProdPart.SetRange(Type, ProdPart.Type::ProductParts);
        if not ProdPart.IsEmpty then
            exit(true);

        if not CreateNew then
            exit(false);

        ProdPart.init();
        ProdPart.ID := in_JobRec.ID;
        ProdPart.Job := in_JobRec.Job;
        ProdPart.Version := in_JobRec.Version;
        ProdPart.Type := ProdPart.Type::ProductParts;
        ProdPart."Entry No." := 10000;
        ProdPart.Text := 'Basis';
        ProdPart.Quantity := in_JobRec.Quantity;
        exit(ProdPart.insert());
    end;


    local procedure AllVariantsCreated(var in_JobRec: Record "PVS Job"): Boolean
    var
        ProductPartRec: Record "PVS Job Text Description";
        MappingRec: Record "PVS Job Product / Variant Map.";
        PVSJobItem: Record "PVS Job Item";
    begin
        PVSJobItem.SetRange(ID, in_JobRec.ID);
        PVSJobItem.SetRange(Job, in_JobRec.Job);
        PVSJobItem.SetRange(Version, in_JobRec.Version);
        ProductPartRec.SetRange(ID, in_JobRec.ID);
        ProductPartRec.SetRange(Job, in_JobRec.Job);
        ProductPartRec.SetRange(Version, in_JobRec.Version);
        ProductPartRec.SetRange(Type, ProductPartRec.Type::ProductParts);
        if ProductPartRec.findset(false) then begin
            repeat
                // Check if no variants exits for this product part (but allow blank values)
                MappingRec.Reset();
                MappingRec.SetRange(ID, in_JobRec.ID);
                MappingRec.SetRange(Job, in_JobRec.Job);
                MappingRec.SetRange(Version, in_JobRec.Version);
                MappingRec.SetRange("Product Version No.", ProductPartRec."Entry No.");
                if MappingRec.IsEmpty then
                    exit(false); // Mapping is missing
                if MappingRec.Count <> PVSJobItem.Count then
                    exit(false); // Mapping is missing
            until ProductPartRec.Next() = 0;
            exit(true);
        end;
        exit(false); // Product parts are missing
    end;

    local procedure CheckJobStatus(var in_JobRec: Record "PVS Job"): Boolean
    var
        OrderRec: Record "PVS Case";
        CopyMgt: Codeunit "PVS Copy Management";
        NewVersion: Integer;
    begin
        // Check prod job - make version
        if in_JobRec.ID = 0 then
            exit(false);

        if not in_JobRec."Production Calculation" then
            exit(false);
        if not in_JobRec.Active then
            exit;

        if in_JobRec.Status = in_JobRec.Status::"Production Order" then
            exit(true);

        OrderRec.get(in_JobRec.ID);
        if OrderRec.Type <> OrderRec.Type::"Production Order" then
            exit(false);

        // Make production version
        NewVersion := CopyMgt.Main_New_Job_Version(in_JobRec, in_JobRec.Status::"Production Order");

        in_JobRec.Get(in_JobRec.ID, in_JobRec.Job, NewVersion);
        if not in_JobRec."Production Calculation" then
            exit(false);
        if not in_JobRec.Active then
            exit(false);
        if in_JobRec.Status <> in_JobRec.Status::"Production Order" then
            exit(false);

        exit(true);
    end;

    procedure PrepareJobItems(var in_JobRec: Record "PVS Job"): Boolean
    var
        JobItemRec: Record "PVS Job Item";
        SheetRec: Record "PVS Job Sheet";
        SheetMgt: Codeunit "PVS Sheet Management";
    begin
        Auto_Create_Variants(in_JobRec);

        JobItemRec.SetRange(ID, in_JobRec.ID);
        JobItemRec.SetRange(Job, in_JobRec.Job);
        JobItemRec.SetRange(Version, in_JobRec.Version);
        //JobItemRec.SetRange("Entry No.", 1);
        if JobItemRec.findset(true) then
            repeat
                DivideVariantsInForms(JobItemRec);
                AssignPlateChanges(JobItemRec);
                if SheetRec.Get(JobItemRec."Sheet ID") then
                    SheetMgt.Update_Sheet_From_JobItems(SheetRec);
            until JobItemRec.next() = 0;

        exit(true);
    end;

    local procedure DivideVariantsInForms(var in_JobItemRec: Record "PVS Job Item")
    var
        VariantRec: Record "PVS Job Item Variant";
    begin
        VariantRec.init();
        VariantRec.ID := in_JobItemRec.id;
        VariantRec.Job := in_JobItemRec.Job;
        VariantRec.Version := in_JobItemRec.Version;
        VariantRec."Job Item No." := in_JobItemRec."Job Item No.";
        VariantRec.Create_Variant_Forms(false);
    end;

    local procedure AssignPlateChanges(var in_JobItemRec: Record "PVS Job Item")
    var
        VariantRec: Record "PVS Job Item Variant";
        PlateChangeRec: Record "PVS Job Item Plate Changes";
        MaxUp, Next_Entry : Integer;
    begin
        MaxUp := Get_Max_Up(in_JobItemRec);
        if MaxUp = 0 then
            exit;
        // Assign Platechanges
        VariantRec.reset();
        VariantRec.SetRange(ID, in_JobItemRec.id);
        VariantRec.SetRange(Job, in_JobItemRec.Job);
        VariantRec.SetRange(Version, in_JobItemRec.Version);
        VariantRec.SetRange("Job Item No.", in_JobItemRec."Job Item No.");
        if VariantRec.findset(true) then begin
            repeat
                PlateChangeRec.SetRange(ID, in_JobItemRec.ID);
                PlateChangeRec.SetRange(Job, in_JobItemRec.Job);
                PlateChangeRec.SetRange(Version, in_JobItemRec.Version);
                PlateChangeRec.SetRange("Job Item No.", in_JobItemRec."Job Item No.");
                PlateChangeRec.SetRange("Change No.", VariantRec."Sheet ID");
                if PlateChangeRec.IsEmpty then begin
                    // insert new platechange
                    PlateChangeRec.SetRange("Change No.");
                    if PlateChangeRec.FindLast() then
                        Next_Entry := PlateChangeRec."Change No." + 1
                    else
                        Next_Entry := 0;
                    PlateChangeRec.Init();
                    PlateChangeRec.ID := in_JobItemRec.ID;
                    PlateChangeRec.Job := in_JobItemRec.Job;
                    PlateChangeRec.Version := in_JobItemRec.Version;
                    PlateChangeRec."Job Item No." := in_JobItemRec."Job Item No.";
                    PlateChangeRec."Change No." := Next_Entry;
                    PlateChangeRec."Sorting Order" := PlateChangeRec."Change No." * 10;
                    PlateChangeRec.Insert(true);

                    // assign variant to platechange
                    VariantRec."Sheet ID" := PlateChangeRec."Change No.";
                    VariantRec."No. of Ups" := MaxUp;
                    VariantRec.modify();
                end;
            until VariantRec.next() = 0;

            RemoveUnusedPlateChanges(in_JobItemRec);
            if VariantRec.findfirst() then
                VariantRec.Calculate_PlateChange_Qty();
            in_JobItemRec.get(in_JobItemRec.ID, in_JobItemRec.Job, in_JobItemRec.Version, in_JobItemRec."Job Item No.", 1);
        end;
    end;

    local procedure RemoveUnusedPlateChanges(var in_JobItemRec: Record "PVS Job Item")
    var
        VariantRec: Record "PVS Job Item Variant";
        PlateChangeRec: Record "PVS Job Item Plate Changes";
        TempPlateChange: Record "PVS Job Item Plate Changes" temporary;
        FirstUnusedNo, NextNo : Integer;
    begin

        VariantRec.reset();
        VariantRec.SetRange(ID, in_JobItemRec.id);
        VariantRec.SetRange(Job, in_JobItemRec.Job);
        VariantRec.SetRange(Version, in_JobItemRec.Version);
        VariantRec.SetRange("Job Item No.", in_JobItemRec."Job Item No.");

        PlateChangeRec.SetRange(ID, in_JobItemRec.ID);
        PlateChangeRec.SetRange(Job, in_JobItemRec.Job);
        PlateChangeRec.SetRange(Version, in_JobItemRec.Version);
        PlateChangeRec.SetRange("Job Item No.", in_JobItemRec."Job Item No.");
        FirstUnusedNo := -1;
        if PlateChangeRec.Findset(false) then
            repeat
                VariantRec.SetRange("Sheet ID", PlateChangeRec."Change No.");
                if VariantRec.IsEmpty then begin
                    if FirstUnusedNo = -1 then
                        FirstUnusedNo := PlateChangeRec."Change No.";
                end else
                    if FirstUnusedNo <> -1 then begin
                        TempPlateChange := PlateChangeRec;
                        TempPlateChange.insert();
                    end;
            until PlateChangeRec.next() = 0;

        if FirstUnusedNo = -1 then
            exit;

        PlateChangeRec.SetFilter("Change No.", '>=%1', FirstUnusedNo);
        PlateChangeRec.DeleteAll();

        NextNo := FirstUnusedNo;
        TempPlateChange.reset();
        if TempPlateChange.findset() then
            repeat
                PlateChangeRec := TempPlateChange;
                PlateChangeRec."Change No." := NextNo;
                PlateChangeRec.insert();
                // Reassign variants to new platechange
                VariantRec.SetRange("Sheet ID", TempPlateChange."Change No.");
                if VariantRec.findset(true) then
                    repeat
                        VariantRec."Sheet ID" := PlateChangeRec."Change No.";
                        VariantRec.modify();
                    until VariantRec.next() = 0;
                NextNo += 1;
            until TempPlateChange.next() = 0;
    end;

    local procedure Get_Max_Up(var in_JobItemRec: Record "PVS Job Item") MaxUp: Integer
    var
        ImpositionRec: record "PVS Imposition Code";
        VariantRec: Record "PVS Job Item Variant";
        Forms: Integer;
        Sets: Decimal;
    begin

        VariantRec.SetRange(ID, in_JobItemRec.ID);
        VariantRec.SetRange(Job, in_JobItemRec.Job);
        VariantRec.SetRange(Version, in_JobItemRec.Version);
        VariantRec.SetRange("Job Item No.", in_JobItemRec."Job Item No.");
        if VariantRec.FindLast() then
            Forms := VariantRec."Variant Forms";

        Forms := Forms + 1;

        if in_JobItemRec."Pages In Sheet" <> 0 then
            Sets := in_JobItemRec."Pages With Print" / in_JobItemRec."Pages In Sheet"
        else
            Sets := 1;

        MaxUp := ROUND(in_JobItemRec.JobItems_On_Sheet() * Forms / ROUND(Sets, 1, '>'), 1, '>');


        // Double, tripple, .. production
        if (in_JobItemRec."Imposition Type" <> '') then
            if ImpositionRec.Get(in_JobItemRec."Imposition Type") then begin
                if ImpositionRec."Double Production" then
                    if ImpositionRec.Production = 0 then
                        ImpositionRec.Production := 2;
                if ImpositionRec.Production > 1 then
                    if ((in_JobItemRec."Pages With Print" * ImpositionRec.Production) > in_JobItemRec."Pages In Sheet") then begin
                        Sets := Sets * ImpositionRec.Production;
                        Sets := ROUND(Sets, 1, '>');

                        MaxUp := ROUND(in_JobItemRec.JobItems_On_Sheet() * ImpositionRec.Production * Forms / Sets, 1, '>');
                    end;
            end;

    end;

    local procedure Auto_Create_Variants(var in_JobRec: Record "PVS Job")
    var
        ProductPartRec: Record "PVS Job Text Description";
        VariantRec: Record "PVS Job Item Variant";
        MappingRec: Record "PVS Job Product / Variant Map.";
        JobItemRec: Record "PVS Job Item";
        AutoVariantCode: code[50];
        StartPosition: Integer;
        CreateVariants: Boolean;
    begin
        ProductPartRec.SetRange(ID, in_JobRec.ID);
        ProductPartRec.SetRange(Job, in_JobRec.Job);
        ProductPartRec.SetRange(Version, in_JobRec.Version);
        ProductPartRec.SetRange(Type, ProductPartRec.Type::ProductParts);
        if ProductPartRec.findset(false) then begin
            StartPosition := AutoVariantStartPosition(in_JobRec);
            repeat
                // Create variants only if no variants exits for this product part (but allow blank values)
                MappingRec.Reset();
                MappingRec.SetRange(ID, in_JobRec.ID);
                MappingRec.SetRange(Job, in_JobRec.Job);
                MappingRec.SetRange(Version, in_JobRec.Version);
                MappingRec.SetRange("Product Version No.", ProductPartRec."Entry No.");
                if not MappingRec.IsEmpty then begin
                    JobItemRec.SetRange(ID, in_JobRec.ID);
                    JobItemRec.SetRange(Job, in_JobRec.Job);
                    JobItemRec.SetRange(Version, in_JobRec.Version);
                    JobItemRec.SetRange("Entry No.", 1);
                    if JobItemRec.Count <> MappingRec.Count then
                        CreateVariants := true;
                end
                else
                    CreateVariants := true;
                if CreateVariants then begin
                    AutoVariantCode := CopyStr(CopyStr(ProductPartRec.Text, StartPosition), 1, 50);
                    JobItemRec.SetRange(ID, in_JobRec.ID);
                    JobItemRec.SetRange(Job, in_JobRec.Job);
                    JobItemRec.SetRange(Version, in_JobRec.Version);
                    JobItemRec.SetRange("Entry No.", 1);
                    if JobItemRec.findset(true) then
                        repeat
                            // find exiting Item Variants / Mapping
                            MappingRec.SetRange("Job Item No.", JobItemRec."Job Item No.");
                            // if no mapping then create
                            if MappingRec.IsEmpty then begin
                                // Find / Insert Variant
                                VariantRec.Reset();
                                VariantRec.SetRange(ID, JobItemRec.ID);
                                VariantRec.SetRange(Job, JobItemRec.Job);
                                VariantRec.SetRange(Version, JobItemRec.Version);
                                VariantRec.SetRange("Job Item No.", JobItemRec."Job Item No.");
                                VariantRec.SetRange("Variant Code", AutoVariantCode);
                                if not VariantRec.FindFirst() then begin
                                    VariantRec.Reset();
                                    VariantRec.Init();
                                    VariantRec.ID := JobItemRec.ID;
                                    VariantRec.Job := JobItemRec.Job;
                                    VariantRec.Version := JobItemRec.Version;
                                    VariantRec."Job Item No." := JobItemRec."Job Item No.";
                                    VariantRec."Variant Code" := AutoVariantCode;
                                    VariantRec.Insert(true);
                                end;

                                // Insert Mapping
                                MappingRec.Init();
                                MappingRec.ID := JobItemRec.ID;
                                MappingRec.Job := JobItemRec.Job;
                                MappingRec.Version := JobItemRec.Version;
                                MappingRec."Job Item No." := JobItemRec."Job Item No.";
                                MappingRec."Variant Entry No." := VariantRec."Variant Entry No.";
                                MappingRec."Product Version No." := ProductPartRec."Entry No.";
                                MappingRec.Insert(true);
                            end;
                        until JobItemRec.next() = 0;
                end;
            until ProductPartRec.Next() = 0;

            MappingRec.Calc_Qty_Variants(in_JobRec.ID, in_JobRec.Job, in_JobRec.Version);
        end;
    end;

    local procedure AutoVariantStartPosition(var in_JobRec: Record "PVS Job"): Integer
    var
        ProdPart: Record "PVS Job Text Description";
        TempTxt: Record "PVS Job Text Description" temporary;
        FirstTxt: Text;
        RemoveTxt: Text;
        cutpos: Integer;
        pos: Integer;
    begin
        cutPos := 0;
        ProdPart.SetRange(ID, in_JobRec.ID);
        ProdPart.SetRange(Job, in_JobRec.Job);
        ProdPart.SetRange(Version, in_JobRec.Version);
        ProdPart.SetRange(Type, ProdPart.Type::ProductParts);
        if not ProdPart.findset(false) then
            exit(1);

        FirstTxt := ProdPart.Text;
        repeat
            TempTxt := ProdPart;
            TempTxt.Insert();
        until ProdPart.Next() = 0;

        pos := StrPos(FirstTxt, ' ');

        if TempTxt.Count > 1 then
            while pos > 1 do begin
                RemoveTxt := CopyStr(FirstTxt, cutPos + 1, pos);

                TempTxt.FindSet();
                repeat
                    if CopyStr(TempTxt.Text, cutPos + 1, pos) <> RemoveTxt then
                        pos := 0;
                until (TempTxt.Next() = 0) or (pos = 0);

                if pos > 0 then begin
                    cutPos += pos;
                    pos := StrPos(CopyStr(FirstTxt, cutPos + 1), ' ');
                end;
            end;
        exit(cutPos + 1);
    end;

}