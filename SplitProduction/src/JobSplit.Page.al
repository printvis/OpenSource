Page 80181 "PTE Job Split"
{
    Caption = 'Job Item Split';
    PageType = List;
    ShowFilter = false;
    SourceTable = "PTE Job Shift Split";
    SourceTableTemporary = true;
    SourceTableView = sorting(ID, Job, Version, "Job Item No. 2", "Change No.");
    DeleteAllowed = false;
    InsertAllowed = false;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Plate Changes';
                Editable = IsNotCopySettings;

                field(Job; Rec.Job)
                {
                    StyleExpr = Style01;
                    Visible = false;
                    ApplicationArea = all;
                }
                field("Original Job Item No."; Rec."Original Job Item No.")
                {
                    Caption = 'Original Job Item No';
                    StyleExpr = Style01;
                    ApplicationArea = all;
                }
                field("Job Item No. 2"; Rec."Job Item No. 2")
                {
                    Caption = 'Job Item No';
                    StyleExpr = Style01;
                    ApplicationArea = all;
                }
                field("Split Job Item No."; Rec."Split Job Item No.")
                {
                    Caption = 'New Job Item No';
                    StyleExpr = 'Unfavorable';
                    BlankZero = true;
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        Rec.Check_Manuel_SplitNo();

                        Rec.Modify(true);
                        CurrPage.Update(false);
                    end;
                }
                field(Description; Rec.Description)
                {
                    StyleExpr = Style01;
                    Visible = false;
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    BlankZero = true;
                    DecimalPlaces = 0 : 0;
                    StyleExpr = Style01;
                    ApplicationArea = all;
                }
                field("Controlling Sheet Unit"; Rec."Controlling Sheet Unit")
                {
                    StyleExpr = Style_ControlUnit;
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        if CheckPaperOK(true) then;
                        rec.Modify(true);
                        CurrPage.Update(false);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        AutoMgt: Codeunit "PVS Automation Management";
                        PAPER: Code[20];
                        TOOL1: Code[20];
                        TOOL2: Code[20];
                        TOOL3: Code[20];
                        TOOL4: Code[20];
                        UNIT: Code[20];
                    begin
                        if AutoMgt.Show_ListOfUnits(GlobalPVSJobItemtmp, UNIT, PAPER, TOOL1, TOOL2, TOOL3, TOOL4) then
                            if UNIT <> '' then begin
                                Rec."Lookup Controlling Sheet Unit" := true;
                                Rec.validate("Controlling Sheet Unit", Unit);
                                Rec.SelectMachineManually(true);
                                if CheckPaperOK(true) then;
                                Rec.Modify(true);
                                Rec."Lookup Controlling Sheet Unit" := false;
                                Rec.Modify(false);
                                CurrPage.Update(false);
                            end;
                    end;
                }
                field("Controlling Sheet Text"; Rec."Controlling Sheet Text")
                {
                    StyleExpr = Style_ControlUnit;
                    ApplicationArea = all;

                }
                field("Imposition Type"; Rec."Imposition Type")
                {
                    Editable = False;
                    AssistEdit = true;
                    Lookup = true;
                    StyleExpr = Style_Imposition;
                    ApplicationArea = all;
                    trigger OnAssistEdit()
                    var
                        HelperFunction: Codeunit "PTE Helperfunction";
                    begin
                        HelperFunction.SetFilterBeforeImpositionSearch(GlobalPVSJobItemTmp, GlobalPVSJobSheetTmp);
                        // 002
                        if Page.RunModal(Page::"PVS Imposition Search", GlobalPVSJobItemTmp) = Action::LookupOK then begin
                            rec.validate("Imposition Type", GlobalPVSJobItemTmp."Imposition Type");
                            if CheckPaperOK(true) then;
                            Rec.Modify(true);
                            CurrPage.Update(false);
                        end
                        // 002
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        JobItemTmp: Record "PVS Job Item" temporary;
                    begin
                        JobItemTmp := GlobalPVSJobItem;
                        JobItemTmp.validate("Paper Item No.", JobItemTmp."Paper Item No.");
                        JobItemTmp.Insert(false);
                        // 002
                        if Page.RunModal(Page::"PVS Imposition Search", JobItemTmp) = Action::LookupOK then begin
                            rec.validate("Imposition Type", JobItemTmp."Imposition Type");
                            if CheckPaperOK(true) then;
                            Rec.Modify(true);
                            CurrPage.Update(false);
                        end
                        // 002
                    end;
                }
                field("Paper Item No."; Rec."Paper Item No.")
                {
                    StyleExpr = Style_Paper;
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        if CheckPaperOK(true) then
                            Rec.Modify(true);
                        CurrPage.Update(true);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PageMgt: Codeunit "PVS Page Management";
                        ItemRec: Record Item;
                    begin
                        PageMgt.Set_Item_Sheet_Filters(ItemRec, GlobalPVSJobSheetTmp);
                        Commit();
                        if Page.RunModal(Page::"PVS Item Lookup", ItemRec) = Action::LookupOK then begin
                            Rec.validate("Paper Item No.", ItemRec."No.");
                            if CheckPaperOK(true) then;
                            rec.Modify(true);
                            CurrPage.Update(false);
                        end;
                    end;
                }
                field("Paper Sheet Format 1"; GlobalItem."PVS Format 1")
                {
                    Caption = 'Full Sheet Format 1';
                    StyleExpr = Style_Format1;
                    Editable = False;
                    ApplicationArea = all;
                    //Folding Pages 16 = 16 allowed
                    //Check Original Job Item No <> New JOb Item No.
                    //Check if other Original Job Item No = New JOb Item No. then error 
                    //Change Paper Item --> Update Format 1 + 2 + trigger
                }
                field("Paper Sheet Format 2"; GlobalItem."PVS Format 2")
                {
                    Caption = 'Full Sheet Format 2';
                    StyleExpr = Style_Format2;
                    Editable = False;
                    ApplicationArea = all;
                }
                field(Min_Format_Txt; MinFormatText)
                {
                    Caption = 'Minimum Format';
                    Editable = false;
                    ApplicationArea = all;
                }

                field(Finishing; Rec.Finishing)
                {
                    StyleExpr = Style_Finishing;
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        if CheckPaperOK(true) then;
                        Rec.Modify(true);
                        CurrPage.Update(false);
                    end;
                }
                field("Colors Front"; Rec."Colors Front")
                {
                    ApplicationArea = all;
                }
                field("Colors Back"; Rec."Colors Back")
                {
                    ApplicationArea = all;
                }
                field("No. Of Pages"; Rec."No. Of Pages")
                {
                    ApplicationArea = all;
                }
                field("Pages With Print"; Rec."Pages With Print")
                {
                    ApplicationArea = all;
                }
                field("Final Format Code"; Rec."Final Format Code")
                {
                    ApplicationArea = all;
                }
                field("Component Type"; Rec."Component Type")
                {
                    ApplicationArea = all;
                }
                field("Component Type Description"; Rec."Component Type Description")
                {
                    ApplicationArea = all;
                }
                field("Job Item Description"; Rec."Job Item Description")
                {
                    ApplicationArea = all;
                }
                field("Paper Description"; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Paper Weight"; Rec."Paper Weight")
                {
                    ApplicationArea = all;
                }
                field("Paper Quality"; Rec."Paper Quality")
                {
                    ApplicationArea = all;
                }
                field("Weight Unit"; Rec."Weight Unit")
                {
                    ApplicationArea = all;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = all;
                }
            }
            part(Variants; "PTE Job Item Combined Variants")
            {
                Visible = false;
                ApplicationArea = All;
                SubPageLink = ID = field(ID),
                              Job = field(Job),
                              Version = field(Version),
                              "Job Item No." = field("Job Item No."),
                              "Sheet ID" = field("Change No.");
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(PREPARE)
            {
                Caption = 'Prepare Job for Split Production';
                Image = AdjustEntries;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Enabled = IsNotCopySettings;
                Visible = IsNotCopySettings;

                trigger OnAction()
                var
                    PrepareMgt: Codeunit "PTE Prepare Job";
                begin
                    PrepareMgt.PrepareJob(Global_Job);
                end;
            }
            action(SPLIT)
            {
                ApplicationArea = All;
                Caption = 'Create Split JobItems';
                Image = Add;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Enabled = IsNotCopySettings;
                Visible = IsNotCopySettings;

                trigger OnAction()
                var
                    ProcessSplit: Codeunit "PTE Split Process";
                    VariantTMP: Record "PVS Job Item Variant" temporary;
                    HelperFunction: Codeunit "PTE Helperfunction";
                    ThrowError: Boolean;
                    Rec2: Record "PTE Job Shift Split" temporary;
                begin
                    Rec2.Copy(rec, true);
                    if Rec2.FindSet(false) then
                        repeat
                            if HelperFunction.Check_Paper(rec, Rec."Paper Item No.", Rec."Controlling Sheet Unit", true, ThrowError) then;
                            if ThrowError then
                                Error('Please correct the Lines, format issues detected between Machines and Paper of 1 or more lines.');
                        until Rec2.Next() = 0;
                    ProcessSplit.Update_SplitJobItem(Rec);
                    InitSplit();
                    CurrPage.Update(false);
                end;
            }
            action(UNDO)
            {
                ApplicationArea = All;
                Caption = 'Undo changes';
                Image = Restore;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Enabled = IsNotCopySettings;
                Visible = IsNotCopySettings;
                trigger OnAction()
                var
                    RevertedChangesLbl: Label 'Changes reset';
                begin
                    InitSplit();
                    CurrPage.Update(false);
                    Message(RevertedChangesLbl);
                end;
            }
            action(CopySettingsMode)
            {
                ApplicationArea = All;
                Caption = 'Copy Mode';
                Image = CopyToTask;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Enabled = IsNotCopySettings;
                Visible = IsNotCopySettings;
                trigger OnAction()
                begin
                    IsCopySettings := true;
                    IsNotCopySettings := not IsCopySettings;
                    TmpEntryToCopySettingsFrom := Rec;
                    Rec.Delete(false);
                    Rec.SetRange("Original Job Item No.", Rec."Original Job Item No.");
                    CurrPage.update(true);
                end;
            }
            action(NormalMode)
            {
                ApplicationArea = All;
                Caption = 'Normal Mode';
                Image = CopyToTask;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Enabled = IsCopySettings;
                Visible = IsCopySettings;
                trigger OnAction()
                begin
                    Rec.SetRange("Original Job Item No.");
                    IsCopySettings := false;
                    IsNotCopySettings := not IsCopySettings;
                    Rec := TmpEntryToCopySettingsFrom;
                    Rec.Insert(false);
                    TmpEntryToCopySettingsFrom := TmpEntry;
                    CurrPage.update(false);
                end;
            }
            action(CopySettingsToMarked)
            {
                ApplicationArea = All;
                Caption = 'Copy Settings to Marked lines';
                Image = Copy;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Enabled = IsCopySettings;
                Visible = IsCopySettings;
                trigger OnAction()
                var
                    TempRec: Record "PTE Job Shift Split" temporary;
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    if Rec.FindSet() then
                        repeat
                            TempRec := Rec;
                            TempRec.Insert;
                        until Rec.Next() = 0
                    else begin
                        TempRec := Rec;
                        TempRec.Insert;
                    end;
                    if TempRec.findset(false) then
                        repeat
                            // New values Set
                            Rec := TmpEntryToCopySettingsFrom;
                            // Restore Old Data that should not be changed
                            Rec.ID := TempRec.ID;
                            Rec.Job := TempRec.Job;
                            Rec.Version := TempRec.Version;
                            Rec."Job Item No." := TempRec."Job Item No.";
                            Rec."Change No." := TempRec."Change No.";
                            Rec."Job Item No. 2" := TempRec."Job Item No. 2";
                            Rec."Variant Entry No." := TempRec."Variant Entry No.";
                            Rec.Description := TempRec.Description;
                            Rec.Quantity := TempRec.Quantity;

                            if TmpEntryToCopySettingsFrom."Job Item No." <> TempRec."Job Item No." then
                                Rec."Split Job Item No." := TmpEntryToCopySettingsFrom."Job Item No.";
                            if TmpEntryToCopySettingsFrom."Split Job Item No." <> 0 then
                                Rec."Split Job Item No." := TmpEntryToCopySettingsFrom."Split Job Item No.";
                            Rec.SetChangedFields();
                            Rec.Modify(false);
                            Rec.Validate("Split Job Item No.");
                            Rec.Modify(false);
                        until TempRec.Next() = 0;


                    Rec.MarkedOnly(false);
                    Rec.Reset();
                    IsCopySettings := false;
                    IsNotCopySettings := not IsCopySettings;
                    Rec := TmpEntryToCopySettingsFrom;
                    Rec.Insert(false);
                    // Rec.Modify(false);
                    TmpEntryToCopySettingsFrom := TmpEntry;
                    CurrPage.update(false);
                end;
            }


        }
    }
    trigger OnOpenPage()
    begin
        InitSplit();
        IsCopySettings := false;
        IsNotCopySettings := not IsCopySettings;

    end;

    trigger OnAfterGetRecord()
    begin
        rec.CalcFields("Paper Sheet Format 1", "Paper Sheet Format 2", "Min Print Format Length", "Min Print Format Width", "Max Print Format Length", "Max Print Format Width", "Weight Unit", "Job Item Description", "Controlling Sheet Text");
        if GlobalPVSJobItem.get(Rec.ID, Rec.Job, Rec.Version, Rec."Job Item No.", 1) then;
        if Global_PVSJobSheet.get(GlobalPVSJobItem."Sheet ID") then;
        if CheckPaperOK(false) then;
    end;

    procedure CheckPaperOK(PaperSizeCheck: Boolean): Boolean;
    var
        HelperFunction: Codeunit "PTE Helperfunction";
        ThrowError: Boolean;
    begin
        UpdateTempRecs();
        if GlobalItem.get(Rec."Paper Item No.") then;
        if PaperSizeCheck then
            if not HelperFunction.Check_Paper(rec, Rec."Paper Item No.", Rec."Controlling Sheet Unit", false, ThrowError) then
                exit;
        GlobalPVSJobSheetTmp."Paper Item No." := Rec."Paper Item No.";
        GlobalPVSJobSheetTmp.Modify(false);
        HelperFunction.Change_Paper(GlobalPVSJobItemTmp, GlobalPVSJobSheetTmp, GlobalCostCenterConfiguration);
        GlobalPVSJobSheetTmp.Check_ECO_Label();
        MinFormatText := Get_Min_Format_Txt();
        Set_StyleExpression();
        exit(true);
    end;

    var
        SplitMgt: Codeunit "PTE Split Mgt";
        Global_Job: Record "PVS Job";
        Style01: Text[50];
        Style_Imposition, Style_Paper, Style_ControlUnit, Style_Finishing, Style_Format1, Style_Format2 : Text[50];

        GlobalPVSJobItemTmp: Record "PVS Job Item" temporary;
        GlobalPVSJobSheetTmp: Record "PVS Job Sheet" temporary;
        Global_PVSJobSheet: Record "PVS Job Sheet";
        GlobalPVSJobItem: Record "PVS Job Item";
        GlobalCostCenterConfiguration: Record "PVS Cost Center Configuration";
        f1: Decimal;
        f2: Decimal;
        GlobalItem: Record Item;
        MinFormatText: Text;
        IsNotCopySettings, IsCopySettings : Boolean;
        TmpEntryToCopySettingsFrom: Record "PTE Job Shift Split" temporary;
        TmpEntry: Record "PTE Job Shift Split" temporary;

    procedure Set_StyleExpression()
    begin
        Style01 := Get_StyleExpression();

        if Rec."Changed Imposition Type" then
            Style_Imposition := 'Unfavorable'
        else
            Style_Imposition := Style01;
        if Rec."Changed Paper Item No." then
            Style_Paper := 'Unfavorable'
        else
            Style_Paper := Style01;
        if Rec."Changed Controlling Sheet Unit" then
            Style_ControlUnit := 'Unfavorable'
        else
            Style_ControlUnit := Style01;
        if Rec."Changed Finishing" then
            Style_Finishing := 'Unfavorable'
        else
            Style_Finishing := Style01;
        if (f1 > GlobalItem."PVS Format 1") then
            Style_Format1 := 'Unfavorable'
        else
            Style_Format1 := Style01;
        if (f2 > GlobalItem."PVS Format 2") then
            Style_Format2 := 'Unfavorable'
        else
            Style_Format2 := Style01;
    end;

    procedure Get_StyleExpression() Result: Text[250]
    var
        UseJobItemNo: Integer;
        i: Integer;
    begin
        // i := (Rec."Change No." MOD 8);
        // i := (Rec."Split No." MOD 7);

        if Rec."Split Job Item No." = 0 then
            UseJobItemNo := Rec."Job Item No. 2"
        else
            UseJobItemNo := Rec."Split Job Item No.";

        i := ((UseJobItemNo - 1) MOD 5);

        if UseJobItemNo = 0 then
            Result := 'Standard'
        else
            case i of
                0:
                    Result := 'Standard';
                1:
                    Result := 'StandardAccent';
                2:
                    Result := 'Favorable';
                3:
                    Result := 'Ambiguous';
                4:
                    Result := 'Subordinate';

            end;
    end;

    procedure Get_Min_Format_Txt() Result: Text[250]
    var
        HelperFunction: Codeunit "PTE Helperfunction";
    begin
        exit(HelperFunction.Get_Min_Format_Txt(GlobalPVSJobItemTmp, GlobalPVSJobSheetTmp, f1, f2));
    end;

    procedure SetJob(in_Job: Record "PVS Job")
    begin
        Global_Job := in_Job;
    end;

    procedure InitSplit()
    var
        VariantTMP: Record "PVS Job Item Variant" temporary;
    begin
        rec.Reset();
        rec.DeleteAll();
        if not SplitMgt.ReadTMPSplit(Global_Job) then
            CurrPage.Close();
        SplitMgt.GetTMPSplit(Rec);
        SplitMgt.GetTMPVariant(VariantTMP);
        CurrPage.Variants.Page.SetTmp(VariantTMP);
    end;

    procedure UpdateTempRecs()
    var
        UnitSetupRec: Record "PVS Calculation Unit Setup";
        PaperWeight: Decimal;
    begin
        if not UnitSetupRec.Get(UnitSetupRec.Type::"Price Unit", Rec."Controlling Sheet Unit") then
            exit;
        if not GlobalCostCenterConfiguration.Get(UnitSetupRec."Cost Center Code", UnitSetupRec.Configuration) then
            exit;
        GlobalPVSJobItemTmp := GlobalPVSJobItem;
        GlobalPVSJobSheetTmp := Global_PVSJobSheet;
        GlobalPVSJobSheetTmp."Paper Item No." := Rec."Paper Item No.";
        GlobalPVSJobItem."Imposition Type" := Rec."Imposition Type";
        GlobalPVSJobSheetTmp."Controlling Unit" := Rec."Controlling Sheet Unit";
        GlobalPVSJobSheetTmp.Finishing := Rec.Finishing;
        if not GlobalPVSJobItemTmp.Insert(false) then
            if GlobalPVSJobItemTmp.Modify(false) then;
        if not GlobalPVSJobSheetTmp.Insert(false) then
            if GlobalPVSJobSheetTmp.Modify(false) then;
    end;

    //Point 1 + 2
    //Controlling Unit Lookup - not putting value correctly in line
    //Check if updating 
}