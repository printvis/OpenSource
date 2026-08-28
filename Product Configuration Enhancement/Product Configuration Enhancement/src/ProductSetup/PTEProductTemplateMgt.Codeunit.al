codeunit 75004 "PTE Product Template Mgt"
{
    trigger OnRun()
    begin
    end;

    /// <summary>
    /// When a product is validated on a PVS Job, apply the product header fields
    /// (Format Code / Colors), transfer the product user fields to the job, and sync
    /// all matching PVS Job Item records with the field values from the corresponding
    /// PTE Product Job Item template lines.
    /// Matching is by Job Item No. Only primary lines (Entry No. = 1) are targeted.
    /// Extra existing PVS Job Items without a template match are left untouched.
    /// </summary>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Product Management", OnAfterValidateProductPVSJob, '', false, false)]
    local procedure OnAfterValidateProductPVSJob(var Job: Record "PVS Job"; var xJob: Record "PVS Job")
    var
        ProductSetupState: Codeunit "PTE Product Setup State";
    begin
        // 1. Copy product header fields (Format Code / Colors) to the job header.
        ApplyProductHeaderFields(Job);

        // 2. Transfer the product user field values to the job.
        ProductSetupState.Transfer_Product_Userfields_To_Job(Job."Product Code", Job.ID, Job.Job, Job.Version);

        // 3. Sync template lines to the job items.
        SyncTemplateLinesToJobItems(Job);
    end;

    /// <summary>
    /// Copies the product header fields (Format Code, Colors Front, Colors Back) to the
    /// PVS Job when a product is applied. Formerly executed inside
    /// PVS Product Management.ValidateProductPVSJob; moved here so the base app remains
    /// unchanged. Persisted with Modify(false) so the values survive the subsequent
    /// Job.Get refresh performed by SyncTemplateLinesToJobItems.
    /// </summary>
    local procedure ApplyProductHeaderFields(var Job: Record "PVS Job")
    var
        Product: Record "PVS Product";
        Changed: Boolean;
    begin
        if Job."Product Code" = '' then
            exit;
        if not Product.Get(Job."Product Code") then
            exit;

        if (Product."Format Code" <> '') and (Job."Format Code" <> Product."Format Code") then begin
            Job.Validate("Format Code", Product."Format Code");
            Changed := true;
        end;

        if (Product."Colors Front" <> 0) or (Product."Colors Back" <> 0) then begin
            if Job."Colors Front" <> Product."Colors Front" then begin
                Job.Validate("Colors Front", Product."Colors Front");
                Changed := true;
            end;
            if Job."Colors Back" <> Product."Colors Back" then begin
                Job.Validate("Colors Back", Product."Colors Back");
                Changed := true;
            end;
        end;

        if Changed then
            Job.Modify(false);

        OnAfterApplyProductHeaderFields(Job);
    end;

    local procedure SyncTemplateLinesToJobItems(var Job: Record "PVS Job")
    var
        TmplLine: Record "PTE Product Job Item";
        JobItem: Record "PVS Job Item";
        JobSheet: Record "PVS Job Sheet";
        PageMgt: Codeunit "PVS Page Management";
        SheetMgt: Codeunit "PVS Sheet Management";
        SingleInstance: Codeunit "PVS SingleInstance";
        UnitCode: Code[20];
        Changed: Boolean;
        SheetChanged: Boolean;
        PrevGUINotAllowed: Boolean;
    begin
        if Job."Product Code" = '' then
            exit;

        TmplLine.SetRange("Product Code", Job."Product Code");
        TmplLine.SetCurrentKey("Product Code", "Job Item No.");
        if not TmplLine.FindSet() then
            exit;

        // Suppress any base-app popups (e.g. "PVS Calculation Configurations" ambiguity
        // prompt, or List Of Units surcharge prompts) while template lines are applied
        // automatically. The base app is left to auto-resolve a default silently; there
        // is no writable Configuration field on "PVS Job Sheet" to force a specific value.
        PrevGUINotAllowed := SingleInstance.Get_GUINOTALLOWED();
        SingleInstance.Set_GUINOTALLOWED(true);

        repeat
            // Locate primary PVS Job Item for this job + template line number
            JobItem.SetRange(ID, Job.ID);
            JobItem.SetRange(Job, Job.Job);
            JobItem.SetRange(Version, Job.Version);
            JobItem.SetRange("Job Item No.", TmplLine."Job Item No.");
            JobItem.SetRange("Entry No.", 1);
            if not JobItem.FindFirst() then begin
                // Job Item does not exist: create a new Sheet + Job Item via PVS Sheet Management.
                // Event_Create_Sheet takes var in_Rec and calls FindLast() before returning,
                // so JobItem is already positioned on the newly created record afterwards.
                JobItem.Reset();
                JobItem.ID := Job.ID;
                JobItem.Job := Job.Job;
                JobItem.Version := Job.Version;
                SheetMgt.Event_Create_Sheet(JobItem, false);

                // If the record was not repositioned (creation failed), skip this line.
                if JobItem."Entry No." = 0 then
                    continue;
            end;

            Clear(Changed);

            // --- 1. Component Type ---
            // Apply first: sets description only, no size or calc cascades.
            if (TmplLine."Component Type" <> '') and (JobItem."Component Type" <> TmplLine."Component Type") then begin
                JobItem.Validate("Component Type", TmplLine."Component Type");
                Changed := true;
            end;

            // --- 2. No. Of Pages ---
            // Standalone even-number validation. Must precede Pages With Print.
            if JobItem."No. Of Pages" <> TmplLine."No. Of Pages" then
                if (TmplLine."No. Of Pages" <> 0) and ((TmplLine."No. Of Pages" mod 2) = 0) then begin
                    JobItem.Validate("No. Of Pages", TmplLine."No. Of Pages");
                    Changed := true;
                end;

            // --- 3. Pages With Print ---
            // Logically depends on No. Of Pages; validate after.
            if (TmplLine."Pages With Print" <> 0) and (JobItem."Pages With Print" <> TmplLine."Pages With Print") then begin
                JobItem.Validate("Pages With Print", TmplLine."Pages With Print");
                Changed := true;
            end;

            // --- 4-5. Size: Length and Width ---
            // Resolved from template using priority: Imposition wins > Format Code > direct Length/Width.
            // Length validated before Width to trigger imposition recalc only once.
            ApplyTemplateSizeToJobItem(TmplLine, JobItem, Changed);

            // --- 6-7. Colors ---
            // Standalone; no cascades between front and back.
            if (TmplLine."Colors Front" <> 0) and (JobItem."Colors Front" <> TmplLine."Colors Front") then begin
                JobItem.Validate("Colors Front", TmplLine."Colors Front");
                Changed := true;
            end;
            if (TmplLine."Colors Back" <> 0) and (JobItem."Colors Back" <> TmplLine."Colors Back") then begin
                JobItem.Validate("Colors Back", TmplLine."Colors Back");
                Changed := true;
            end;

            // --- 8. Paper ---
            // The Job Item's "Paper Item No." is a non-editable FlowField into the Sheet,
            // so Paper (like Weight) is applied at sheet level below - see step 19.

            // --- 9-12. Tools ---
            // All standalone; no cascades between tool slots.
            if (TmplLine."Tool 1" <> '') and (JobItem.Tool <> TmplLine."Tool 1") then begin
                JobItem.Validate(Tool, TmplLine."Tool 1");
                Changed := true;
            end;
            if (TmplLine."Tool 2" <> '') and (JobItem."Tool 2" <> TmplLine."Tool 2") then begin
                JobItem.Validate("Tool 2", TmplLine."Tool 2");
                Changed := true;
            end;
            if (TmplLine."Tool 3" <> '') and (JobItem."Tool 3" <> TmplLine."Tool 3") then begin
                JobItem.Validate("Tool 3", TmplLine."Tool 3");
                Changed := true;
            end;
            if (TmplLine."Tool 4" <> '') and (JobItem."Tool 4" <> TmplLine."Tool 4") then begin
                JobItem.Validate("Tool 4", TmplLine."Tool 4");
                Changed := true;
            end;

            // --- 13-18. Media / Envelope / Opacity ---
            // All standalone; grouped by functional area to minimize record traffic.
            if (TmplLine."Media Type" <> TmplLine."Media Type"::" ") and (JobItem."Media Type" <> TmplLine."Media Type") then begin
                JobItem.Validate("Media Type", TmplLine."Media Type");
                Changed := true;
            end;
            if (TmplLine."Envelope Window Shape Type" <> TmplLine."Envelope Window Shape Type"::" ") and (JobItem."Envelope Window Shape Type" <> TmplLine."Envelope Window Shape Type") then begin
                JobItem.Validate("Envelope Window Shape Type", TmplLine."Envelope Window Shape Type");
                Changed := true;
            end;
            if (TmplLine."Envelope Window Size X" <> 0) and (JobItem."Envelope Window Size X" <> TmplLine."Envelope Window Size X") then begin
                JobItem.Validate("Envelope Window Size X", TmplLine."Envelope Window Size X");
                Changed := true;
            end;
            if (TmplLine."Envelope Window Size Y" <> 0) and (JobItem."Envelope Window Size Y" <> TmplLine."Envelope Window Size Y") then begin
                JobItem.Validate("Envelope Window Size Y", TmplLine."Envelope Window Size Y");
                Changed := true;
            end;
            if (TmplLine.Opacity <> TmplLine.Opacity::" ") and (JobItem.Opacity <> TmplLine.Opacity) then begin
                JobItem.Validate(Opacity, TmplLine.Opacity);
                Changed := true;
            end;
            if (TmplLine."Opacity Level" <> 0) and (JobItem."Opacity Level" <> TmplLine."Opacity Level") then begin
                JobItem.Validate("Opacity Level", TmplLine."Opacity Level");
                Changed := true;
            end;

            // Persist all field changes in a single Modify before List Of Units.
            // Use Modify(false) to avoid triggering PVS Job Item's OnModify cascade,
            // which would call Modify() on the parent PVS Job record and cause an
            // optimistic concurrency conflict when the page tries to save Product Code.
            // Field-level triggers have already run via Validate() above.
            if Changed then
                JobItem.Modify(false);

            // --- 19. List Of Units ---
            // Assigns the Controlling (Sheet) Unit and, through it, resolves the Cost
            // Center Configuration for the sheet. Must run BEFORE Finishing/Paper/Weight:
            // the base app's "PVS Calculation Configurations" selection page is prompted
            // when Finishing/Paper/Weight are validated on a sheet whose Configuration has
            // not been resolved yet. Manually picking List Of Units first (as done on the
            // Product Job Item sub page / base Job Items list) avoids that prompt, so the
            // same order is used here. Must be after Modify so Job_Item_Input_Unit reads
            // the persisted state. Skipped silently when no Sheet exists yet (Sheet ID = 0).
            if TmplLine."List Of Units" <> '' then
                if JobItem."Sheet ID" <> 0 then begin
                    UnitCode := TmplLine."List Of Units";
                    PageMgt.Job_Item_Input_Unit(JobItem, UnitCode);
                end;

            // --- 20. Finishing / Paper / Weight ---
            // All three are stored on the PVS Job Sheet (the Job Item's "Paper Item No." and
            // "Paper Weight" are FlowField lookups into it). Applied at sheet level, after
            // List Of Units above, so the sheet's Configuration is already resolved and the
            // "PVS Calculation Configurations" selection page does not get triggered. Finishing
            // is applied before Paper/Weight since it is the more likely input to that
            // configuration resolution. Paper is applied before Weight because changing paper
            // (Change_Paper) can reset the default weight, which we then override.
            // Skipped silently when no Sheet exists yet (Sheet ID = 0).
            if JobItem."Sheet ID" <> 0 then
                if JobSheet.Get(JobItem."Sheet ID") then begin
                    Clear(SheetChanged);
                    if (TmplLine.Finishing <> '') and (JobSheet.Finishing <> TmplLine.Finishing) then begin
                        JobSheet.Validate(Finishing, TmplLine.Finishing);
                        SheetChanged := true;
                    end;
                    if (TmplLine."Paper No." <> '') and (JobSheet."Paper Item No." <> TmplLine."Paper No.") then begin
                        JobSheet.Validate("Paper Item No.", TmplLine."Paper No.");
                        SheetChanged := true;
                    end;
                    if (TmplLine.Weight <> 0) and (JobSheet.Weight <> TmplLine.Weight) then begin
                        JobSheet.Validate(Weight, TmplLine.Weight);
                        SheetChanged := true;
                    end;
                    if SheetChanged then
                        JobSheet.Modify(true);
                end;

        until TmplLine.Next() = 0;

        SingleInstance.Set_GUINOTALLOWED(PrevGUINotAllowed);

        // Refresh the Job record from the database.  SheetMgt.Event_Create_Sheet and
        // field Validate cascades may have internally called Modify() on the PVS Job
        // record, bumping its DB timestamp.  Because Job is passed as var, re-reading it
        // here updates the caller's (PVS Product Management) copy so its subsequent
        // Modify() uses the current timestamp and avoids the optimistic concurrency
        // conflict on the case card page.
        if Job.Get(Job.ID, Job.Job, Job.Version) then;
    end;

    /// <summary>
    /// Resolves the final Length and Width for a PVS Job Item from the template line.
    /// Priority: Imposition Code (wins) > Format Code > direct Length/Width values.
    /// Validates Length before Width to trigger imposition recalculation only once.
    /// </summary>
    local procedure ApplyTemplateSizeToJobItem(TmplLine: Record "PTE Product Job Item"; var JobItem: Record "PVS Job Item"; var Changed: Boolean)
    var
        GeneralSetup: Record "PVS General Setup";
        ImpositionRec: Record "PVS Imposition Code";
        FormatCode: Record "PVS Format Code";
        FinalLength: Decimal;
        FinalWidth: Decimal;
    begin
        if not GeneralSetup.Get() then
            GeneralSetup.Init();

        FinalLength := 0;
        FinalWidth := 0;

        // Imposition Code wins: read Format 1 / Format 2 from imposition record
        if TmplLine."Imposition Code" <> '' then begin
            if ImpositionRec.Get(TmplLine."Imposition Code") then
                if GeneralSetup."Format Entry" = GeneralSetup."format entry"::"Depth x Width" then begin
                    // Depth x Width: Format 1 = depth/length, Format 2 = width
                    FinalLength := ImpositionRec."Format 1";
                    FinalWidth := ImpositionRec."Format 2";
                end else begin
                    // Width x Length (default): Format 1 = width, Format 2 = length
                    FinalWidth := ImpositionRec."Format 1";
                    FinalLength := ImpositionRec."Format 2";
                end;
        end else
            if TmplLine."Format Code" <> '' then begin
                // Format Code: resolve centimeters via setup
                if FormatCode.Get(TmplLine."Format Code") then
                    if GeneralSetup."Manual Grain Direction" then begin
                        FinalWidth := FormatCode."Width Centimeter";
                        FinalLength := FormatCode."Length Centimeter";
                    end else
                        if GeneralSetup."Format Entry" = GeneralSetup."format entry"::"Depth x Width" then begin
                            FinalLength := FormatCode."Length Centimeter";
                            FinalWidth := FormatCode."Width Centimeter";
                        end else begin
                            FinalWidth := FormatCode."Width Centimeter";
                            FinalLength := FormatCode."Length Centimeter";
                        end;
            end else begin
                // No format driver: use template Length/Width directly
                FinalLength := TmplLine.Length;
                FinalWidth := TmplLine.Width;
            end;

        // Apply Length first (triggers imposition recalculation internally once),
        // then Width; skip zero values to avoid clearing existing data.
        if (FinalLength <> 0) and (JobItem.Length <> FinalLength) then begin
            JobItem.Validate(Length, FinalLength);
            Changed := true;
        end;
        if (FinalWidth <> 0) and (JobItem.Width <> FinalWidth) then begin
            JobItem.Validate(Width, FinalWidth);
            Changed := true;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterApplyProductHeaderFields(var Job: Record "PVS Job")
    begin
    end;
}
