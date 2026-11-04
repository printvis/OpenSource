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
    begin
        // 1. Copy product header fields (Format Code / Colors) to the job header.
        ApplyProductHeaderFields(Job);

        // 2. Transfer the product user field values to the job.
        ApplyProductUserFields(Job);

        // 3. Sync template lines to the job items.
        SyncTemplateLinesToJobItems(Job);
    end;

    /// <summary>
    /// Deletes a product's stored default User Field values (table "PTE Product Userfield
    /// ID") when the product itself is deleted, so no orphaned default value rows are left
    /// behind pointing at a Product Code that no longer exists.
    /// </summary>
    [EventSubscriber(ObjectType::Table, Database::"PVS Product", OnAfterDeleteEvent, '', false, false)]
    local procedure OnAfterDeleteProduct(var Rec: Record "PVS Product"; RunTrigger: Boolean)
    var
        ProductUserfieldValue: Record "PTE Product Userfield ID";
        ProductJobItem: Record "PTE Product Job Item";
    begin
        if Rec.IsTemporary() then
            exit;

        ProductUserfieldValue.SetRange("Product Code", Rec.Code);
        ProductUserfieldValue.DeleteAll(false);

        // Remove the product's job item template lines (with trigger, so dependent
        // extensions can clean up data linked to each template line).
        ProductJobItem.SetRange("Product Code", Rec.Code);
        if not ProductJobItem.IsEmpty() then
            ProductJobItem.DeleteAll(true);
    end;

    /// <summary>
    /// Creates a copy of a product job item template line on the same product with the next
    /// free Job Item No. Raises OnAfterCopyProductJobItem so dependent extensions can copy
    /// their own data linked to the template line.
    /// </summary>
    procedure CopyProductJobItem(SourceProductJobItem: Record "PTE Product Job Item"; var NewProductJobItem: Record "PTE Product Job Item")
    begin
        SourceProductJobItem.TestField("Product Code");
        NewProductJobItem := SourceProductJobItem;
        NewProductJobItem."Job Item No." := 0;
        NewProductJobItem.Insert(true);
        OnAfterCopyProductJobItem(SourceProductJobItem, NewProductJobItem);
    end;

    /// <summary>
    /// Copies the default userfield values stored for the product (table "PTE Product
    /// Userfield ID", see <see cref="EditProductUserFields"/>) into a job. "PVS Userfield
    /// Management".Copy_Record_UserFields only copies between two identities within the
    /// SAME "PVS Userfield Field Value" table, so the product's own defaults (which live in
    /// our own table, not in "PVS Userfield Field Value") are first materialized there as
    /// temporary rows tagged Table ID = "PVS Job", ID1 = SessionId() (see
    /// <see cref="StageProductUserFieldsAsJob"/>), then copied from that identity to the
    /// real job's identity, then the temporary rows are removed again. SessionId() is
    /// already guaranteed unique for the duration of this call - no reserved/looked-up
    /// surrogate ID is needed.
    /// </summary>
    local procedure ApplyProductUserFields(var Job: Record "PVS Job")
    var
        ProductUserfieldID: Record "PTE Product Userfield ID";
        UserfieldMgt: Codeunit "PVS Userfield Management";
        StagingId: Integer;
    begin
        if Job."Product Code" = '' then
            exit;

        // No default User Field values have ever been saved for this product - nothing to
        // transfer.
        if not ProductUserfieldID.HasValues(Job."Product Code") then
            exit;

        StagingId := SessionId();
        StageProductUserFieldsAsJob(StagingId, Job."Product Code");
        UserfieldMgt.Copy_Record_UserFields(Database::"PVS Job", '', '', StagingId, 0, 0, 0, 0, '', Job.ID, Job.Job, Job.Version, 0, 0, false);
        DeleteStagedJobUserFields(StagingId);
    end;

    /// <summary>
    /// Opens the Userfield edit form for a Product using the Job User Field 1/2/3 group
    /// setup/labels (table 6010313, "PVS Job"). "PVS Userfield Management".Form_Userfield_Edit
    /// only works against "PVS Userfield Field Value" (table 6010313), so the product's
    /// existing default values (stored in our own table "PTE Product Userfield ID") are first
    /// materialized there as temporary rows tagged Table ID = "PVS Job" before the edit form
    /// is opened; afterwards, whatever the form left staged is saved back into "PTE Product
    /// Userfield ID" as the product's new default values, and the temporary rows are removed.
    /// InputProductCode is the full Product Code (Code[50], matching "PVS Product".Code). It
    /// is never truncated or length-checked: staging/committing is keyed by SessionId(), not
    /// by the Product Code string itself, so no reserved/looked-up surrogate ID is needed.
    /// </summary>
    procedure EditProductUserFields(InputProductCode: Code[50]; GroupIndex: Integer)
    var
        UserFieldMgt: Codeunit "PVS Userfield Management";
        StagingId: Integer;
    begin
        StagingId := SessionId();
        StageProductUserFieldsAsJob(StagingId, InputProductCode);
        UserFieldMgt.Form_Userfield_Edit(Database::"PVS Job", GroupIndex, '', '', StagingId, 0, 0, 0, 0);
        CommitStagedJobUserFieldsToProduct(StagingId, InputProductCode);
    end;

    /// <summary>
    /// Materializes the product's stored default values (table "PTE Product Userfield ID")
    /// as rows in "PVS Userfield Field Value" tagged Table ID = "PVS Job", ID1 = StagingId,
    /// so base app procedures that only operate on "PVS Userfield Field Value" (Form_Userfield_
    /// Edit, Copy_Record_UserFields) can read them as their source/current values. ID1 (an
    /// Integer) is used instead of Code1 (Code[20]) so the full Product Code (Code[50])
    /// never needs to be truncated or length-checked. Each staged row's "Table Subtype" is set
    /// from the stored "Group Index" so that Form_Userfield_Edit (which filters by subtype per
    /// User Field group) only ever operates on the single group being edited, while the other
    /// two groups' defaults stay staged untouched alongside it.
    /// </summary>
    local procedure StageProductUserFieldsAsJob(StagingId: Integer; ProductCode: Code[50])
    var
        ProductUserfieldValue: Record "PTE Product Userfield ID";
    begin
        ProductUserfieldValue.SetRange("Product Code", ProductCode);
        if ProductUserfieldValue.FindSet() then
            repeat
                InsertOrUpdateStagedValue(StagingId, ProductUserfieldValue."Group Index", ProductUserfieldValue."Field No.", ProductUserfieldValue."Value Entry No.", ProductUserfieldValue.Text);
            until ProductUserfieldValue.Next() = 0;
    end;

    /// <summary>
    /// Inserts or updates a single staged value row in "PVS Userfield Field Value", tagged
    /// Table ID = "PVS Job", Table Subtype = GroupIndex, ID1 = StagingId - the transient
    /// identity used to materialize a product's defaults there. See
    /// <see cref="StageProductUserFieldsAsJob"/>.
    /// </summary>
    local procedure InsertOrUpdateStagedValue(StagingId: Integer; GroupIndex: Integer; FieldNo: Integer; ValueEntryNo: Integer; Value: Text[250])
    var
        StagedRec: Record "PVS Userfield Field Value";
    begin
        StagedRec.SetRange("Table ID", Database::"PVS Job");
        StagedRec.SetRange("Table Subtype", GroupIndex);
        StagedRec.SetRange(ID1, StagingId);
        StagedRec.SetRange("Field No.", FieldNo);
        StagedRec.SetRange("Entry No.", ValueEntryNo);
        if StagedRec.FindFirst() then begin
            StagedRec.Text := Value;
            StagedRec.Modify(false);
        end else begin
            StagedRec.Init();
            StagedRec."Table ID" := Database::"PVS Job";
            StagedRec."Table Subtype" := GroupIndex;
            StagedRec.ID1 := StagingId;
            StagedRec."Field No." := FieldNo;
            StagedRec."Entry No." := ValueEntryNo;
            StagedRec.Text := Value;
            StagedRec.Insert(false);
        end;
    end;

    /// <summary>
    /// Removes the temporary "PVS Userfield Field Value" rows tagged Table ID = "PVS Job",
    /// ID1 = StagingId, once their content has been safely copied elsewhere (see
    /// <see cref="CommitStagedJobUserFieldsToProduct"/> and <see cref="ApplyProductUserFields"/>).
    /// Must only be called AFTER the data has been copied out - never before, or the
    /// rows would be lost with nothing to restore them.
    /// </summary>
    local procedure DeleteStagedJobUserFields(StagingId: Integer)
    var
        JobRec: Record "PVS Userfield Field Value";
    begin
        JobRec.SetRange("Table ID", Database::"PVS Job");
        JobRec.SetRange(ID1, StagingId);
        JobRec.DeleteAll(false);
    end;

    /// <summary>
    /// Saves the staged "PVS Userfield Field Value" rows (Table ID = "PVS Job", ID1 =
    /// StagingId) - i.e. whatever Form_Userfield_Edit just added or changed - as the
    /// product's new default values in "PTE Product Userfield ID", then removes the staged
    /// rows. This is a full replace (existing default value rows for the product are deleted
    /// first) rather than a pure upsert, so a field that was cleared during editing does not
    /// remain behind as a stale default.
    /// </summary>
    local procedure CommitStagedJobUserFieldsToProduct(StagingId: Integer; ProductCode: Code[50])
    var
        StagedRec: Record "PVS Userfield Field Value";
        ProductUserfieldValue: Record "PTE Product Userfield ID";
    begin
        ProductUserfieldValue.SetRange("Product Code", ProductCode);
        ProductUserfieldValue.DeleteAll(false);

        StagedRec.SetRange("Table ID", Database::"PVS Job");
        StagedRec.SetRange(ID1, StagingId);
        if StagedRec.FindSet() then
            repeat
                ProductUserfieldValue.Init();
                ProductUserfieldValue."Product Code" := ProductCode;
                ProductUserfieldValue."Group Index" := StagedRec."Table Subtype";
                ProductUserfieldValue."Field No." := StagedRec."Field No.";
                ProductUserfieldValue."Value Entry No." := StagedRec."Entry No.";
                ProductUserfieldValue.Text := StagedRec.Text;
                // RunTrigger must be true here: "Entry No." is deliberately left unassigned
                // above and is only ever set by the table's OnInsert trigger (FindLast()+1).
                // Insert(false) would skip that trigger, leaving every row at "Entry No." = 0
                // and causing a "record already exists" error on the second row inserted for
                // the same product.
                ProductUserfieldValue.Insert(true);
            until StagedRec.Next() = 0;

        DeleteStagedJobUserFields(StagingId);
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
        // Raised before the blank-product exit so subscribers can clean up data from a
        // previously applied product (also when the product is cleared).
        OnBeforeSyncTemplateLinesToJobItems(Job);

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

            // --- 21. Extension point ---
            // Raised while GUI is still suppressed, with both the template line and the
            // PVS Job Item it was applied to (Job Item No. may differ from the template).
            OnAfterSyncTemplateLineToJobItem(TmplLine, JobItem, Job);

        until TmplLine.Next() = 0;

        OnAfterSyncTemplateLinesToJobItems(Job);

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

    /// <summary>
    /// Raised before the product template lines are synced to the job items, also when the
    /// job has no product (product cleared).
    /// </summary>
    [IntegrationEvent(false, false)]
    local procedure OnBeforeSyncTemplateLinesToJobItems(var Job: Record "PVS Job")
    begin
    end;

    /// <summary>
    /// Raised after a template line has been applied to its PVS Job Item (incl. List Of Units
    /// and sheet fields). GUI is suppressed while this event runs.
    /// </summary>
    [IntegrationEvent(false, false)]
    local procedure OnAfterSyncTemplateLineToJobItem(TemplateLine: Record "PTE Product Job Item"; var JobItem: Record "PVS Job Item"; var Job: Record "PVS Job")
    begin
    end;

    /// <summary>
    /// Raised after all template lines have been synced, before the Job record is refreshed.
    /// GUI is suppressed while this event runs.
    /// </summary>
    [IntegrationEvent(false, false)]
    local procedure OnAfterSyncTemplateLinesToJobItems(var Job: Record "PVS Job")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyProductJobItem(SourceProductJobItem: Record "PTE Product Job Item"; var NewProductJobItem: Record "PTE Product Job Item")
    begin
    end;
}
