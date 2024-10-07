Codeunit 80181 "PTE Helperfunction"
{

    procedure Change_Paper(var PvsJobItem: Record "PVS Job Item" temporary; var PVSJobSheet: Record "PVS Job Sheet" temporary; var in_ConfigRec: Record "PVS Cost Center Configuration")
    var
        ItemRec: Record Item;
        PVScreeningParameters: Record "PVS Screening Parameters";
        PVSItemTypeCode: Record "PVS Item Type Code";
    begin
        //<001> new parameter on this function </001>
        if ItemRec.Get(PVSJobSheet."Paper Item No.") then begin
            if (ItemRec."PVS Format 1" <> 0) or (ItemRec."PVS Format 2" <> 0) then begin
                PVSJobSheet."Full Sheet Format 1" := ItemRec."PVS Format 1";
                PVSJobSheet."Full Sheet Format 2" := ItemRec."PVS Format 2";
                PVSJobSheet."Full Sheet Depth" := ItemRec."PVS Depth";
                PVSJobSheet."Full Sheet Width" := ItemRec."PVS Width";
                PVSJobSheet."Full Sheet Grain Direction" := ItemRec."PVS Grain Direction";
            end;

            if ItemRec."PVS Weight" <> 0 then begin
                PVSJobSheet.Weight := ItemRec."PVS Weight";
                PVSJobSheet."Weight Unit" := ItemRec."PVS Weight Unit";
            end;

            if ItemRec."PVS Item Quality Code" <> '' then
                PVSJobSheet."Paper Quality" := ItemRec."PVS Item Quality Code";

            if ItemRec."PVS Thickness" <> 0 then
                PVSJobSheet.Thickness := ItemRec."PVS Thickness";

            PVSJobSheet."Paper Type" := ItemRec."PVS Paper Type";

            if ItemRec.Description <> '' then
                PVSJobSheet.Description := ItemRec.Description;

            if ItemRec."PVS Reel Length" <> 0 then
                PVSJobSheet."Reel Length" := ItemRec."PVS Reel Length";

            PVSJobSheet."Screening Parameter" := '';
            if ItemRec."PVS Item Type Code" <> '' then
                if PVSItemTypeCode.Get(ItemRec."PVS Item Type Code") then
                    if PVSItemTypeCode."Screening Parameter" <> '' then
                        if PVScreeningParameters.Get(PVSItemTypeCode."Screening Parameter") then
                            PVSJobSheet."Screening Parameter" := PVScreeningParameters.Code;
            CalcImposition(PvsJobItem, PVSJobSheet, in_ConfigRec);
            PVSJobSheet.Modify(false);
        end;
    end;

    procedure Check_Paper(Rec: Record "PTE Job Shift Split" temporary; in_ItemNo: code[20]; in_Machine: Code[20]; SkipMessageChecks: Boolean; var ThrowError: Boolean): Boolean
    var
        ConfigurationRec: Record "PVS Cost Center Configuration";
        ItemRec: Record Item;
        UnitSetupRec: Record "PVS Calculation Unit Setup";
        NVTR: Codeunit "PVS ML Text Resource";
        UnitFactor: Codeunit "PVS Unit Conversion";
        PaperWeight: Decimal;
    begin
        //<001> new parameter on this function </001>
        if not ItemRec.Get(in_ItemNo) then
            exit;
        if not UnitSetupRec.Get(UnitSetupRec.Type::"Price Unit", in_Machine) then
            exit;
        if not ConfigurationRec.Get(UnitSetupRec."Cost Center Code", UnitSetupRec.Configuration) then
            exit;

        // Check weight
        if (ConfigurationRec."Max Weight" <> 0) then begin
            // Europe - easy
            PaperWeight := ItemRec."PVS Weight";

            // US - not so easy
            PaperWeight := UnitFactor.Convert_PaperWeight(
                ItemRec."PVS Weight", ItemRec."PVS Weight Unit", ItemRec."PVS Format 1", ItemRec."PVS Format 2", ConfigurationRec."Weight Unit");

            if PaperWeight > ConfigurationRec."Max Weight" then begin
                if SkipMessageChecks then begin
                    ThrowError := true;
                    exit;
                end;

                case ConfigurationRec."Max Format Exceeded" of
                    1:
                        NVTR.Message0(4165);
                    2:
                        NVTR.Message0(4166);
                //NVTR.Error0(4165);
                end;
            end;
            if (PaperWeight < ConfigurationRec."Min Weight") and
               (PaperWeight > 0)
            then begin
                if SkipMessageChecks then begin
                    ThrowError := true;
                    exit;
                end;
                case ConfigurationRec."Max Format Exceeded" of
                    1:
                        NVTR.Message0(4166);
                    2:
                        NVTR.Message0(4166);
                //NVTR.Error0(4166);
                end;
            end
        end;

        // Check paper format for web press
        if not (ConfigurationRec."Process Type" in [ConfigurationRec."Process Type"::Web, ConfigurationRec."Process Type"::Continuous]) then
            exit;

        // Check it is a web paper
        ItemRec.testfield("PVS Paper Type", ItemRec."PVS Paper Type"::Web);

        if ConfigurationRec."Trimming The Sheet/Web" <> ConfigurationRec."Trimming The Sheet/Web"::"Use the whole sheet/web" then
            exit;

        if ConfigurationRec."Max Printing Format Width" < ItemRec."PVS Format 1" then begin

            if SkipMessageChecks then begin
                ThrowError := true;
                exit;
            end;
            case ConfigurationRec."Max Format Exceeded" of
                1:
                    NVTR.Message0(4150);
                2:
                    NVTR.Message0(4150);
            //                NVTR.Error0(4150);
            end
        end;

        if ConfigurationRec."Min Print Format Width" > ItemRec."PVS Format 1" then begin
            if SkipMessageChecks then begin
                ThrowError := true;
                exit;
            end;
            case ConfigurationRec."Max Format Exceeded" of
                1:
                    NVTR.Message0(4224);
                2:
                    NVTR.Message0(4224);
            //NVTR.Error0(4224);
            end
        end;
        exit(true);
    end;

    procedure Get_MinMaxFormat(in_Machine: Code[20]; out_Min: Decimal; out_Max: Decimal)
    var
        ConfigurationRec: Record "PVS Cost Center Configuration";
        UnitSetupRec: Record "PVS Calculation Unit Setup";
    begin
        out_Max := 0;
        out_Min := 0;

        if not UnitSetupRec.Get(UnitSetupRec.Type::"Price Unit", in_Machine) then
            exit;
        if not ConfigurationRec.Get(UnitSetupRec."Cost Center Code", UnitSetupRec.Configuration) then
            exit;

        out_Max := ConfigurationRec."Max Printing Format Width";
        out_Min := ConfigurationRec."Min Print Format Width";

    end;

    [EventSubscriber(ObjectType::Page, Page::"PVS Job Product Variants Map", 'OnBeforeActionEvent', 'AutoCreateVariants', false, false)]
    local procedure PagePVSJobProductVariantsMapOnBeforeActionEventAutoCreateVariants(var Rec: Record "PVS Job Text Description")
    var
        PVSJobItemVariant: Record "PVS Job Item Variant";
        PVSJobItem: Record "PVS Job Item";
        PVSJobTextDesciption: Record "PVS Job Text Description";
        ConfirmLbl: label 'You have splitted lines. Do you really want to add Variants to all Product Parts?';
    begin
        PVSJobTextDesciption.CopyFilters(Rec);
        PVSJobItem.SetRange(ID, Rec.ID);
        PVSJobItem.SetRange(Job, Rec.Job);
        PVSJobItem.SetRange(Version, Rec.Version);
        PVSJobItemVariant.SetRange(ID, Rec.ID);
        PVSJobItemVariant.SetRange(Job, Rec.Job);
        PVSJobItemVariant.SetRange(Version, Rec.Version);
        if (PVSJobTextDesciption.Count * PVSJobItem.Count) <> PVSJobItemVariant.Count then
            if not Dialog.Confirm(ConfirmLbl, false) then error('');
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Product / Variant Map.", 'OnAfterDeleteEvent', '', false, false)]
    local procedure TablePVSJobProductVariantMapOnAfterDeleteEvent(var Rec: Record "PVS Job Product / Variant Map.")
    var
        PVSJobProductionVariantMap: Record "PVS Job Product / Variant Map.";
    begin
        PVSJobProductionVariantMap.SetRange(ID, Rec.ID);
        PVSJobProductionVariantMap.SetRange(Job, Rec.Job);
        PVSJobProductionVariantMap.SetRange(Version, Rec.Version);
        PVSJobProductionVariantMap.SetRange("Job Item No.", Rec."Job Item No.");
        if PVSJobProductionVariantMap.IsEmpty then;
        // PVSJobItem.SetRange(ID, Rec.ID);
        // PVSJobItem.SetRange(Job, Rec.Job);
        // PVSJobItem.SetRange(Version, Rec.Version);
        // PVSJobItem.SetRange("Job Item No.", Rec."Job Item No.");
        // if PVSJobItem.FindFirst() then
        //     PVSSheetMgt.Event_Delete_Sheet(PVSJobItem, true);
    end;

    [EventSubscriber(ObjectType::table, DATABASE::"PVS Job Sheet", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure PVSJobSheetOnBeforeDeleteEvent(RunTrigger: Boolean; var Rec: Record "PVS Job Sheet")
    var
        PVSJobItem: Record "PVS Job Item";
        PVSJob: Record "PVS Job";
        SplitMgt: Codeunit "PTE Split Mgt";
        ErrorLabelTxt001Lbl: Label 'Please merge the line back on the Original job item. %1', Comment = '%1 is the original Job Item where it should be merged back into.';
        ErrorLabelTxt002Lbl: Label 'Please merge the other lines back on this job item.';
    begin
        if Rec.IsTemporary() then
            exit;
        if SplitMgt.GetMergingOrSplittingSheet() then
            exit;
        PVSJob.SetRange(ID, Rec.ID);
        PVSJob.SetRange(Job, Rec.Job);
        PVSJob.SetRange(Version, Rec.Version);
        if PVSJob.FindFirst() then
            if not PVSJob.Active then
                exit;

        PVSJobItem.SetRange(ID, Rec.ID);
        PVSJobItem.SetRange(Job, Rec.Job);
        PVSJobItem.SetRange(Version, Rec.Version);
        PVSJobItem.SetRange("Sheet ID", rec."Sheet ID");
        if PVSJobItem.FindFirst() then
            if PVSJobItem."Expanded From Job Item No." <> 0 then
                error(ErrorLabelTxt001Lbl, PVSJobItem."Expanded From Job Item No.");
        PVSJobItem.SetFilter("Sheet ID", '<>%1', rec."Sheet ID");
        PVSJobItem.SetRange("Expanded From Job Item No.", PVSJobItem."Job Item No.");
        if PVSJobItem.Count <> 0 then
            error(ErrorLabelTxt002Lbl);
        /*
It should not be allowed to delete if it has been split in any way: 

if the Expanded from Job Item No. field 73 is filled on the line, then give a error message(‘Please merge the line back on the Original job item.’) 

if the Expanded from Job Item No. field 73 is filled on other lines, then give a error message(‘Please merge the line back on the Original job item.’) 
        */
    end;

    [EventSubscriber(ObjectType::Codeunit, COdeunit::"PVS Table Filters", 'OnAfterSelectImpositionFromJobItem', '', false, false)]
    local procedure PVSTableFiltersOnAfterSelectImpositionFromJobItemSingleUsage(var PVSImpositionCode: Record "PVS Imposition Code")
    var
        TempPVSJobItem: Record "PVS Job Item" temporary;
        TempPVSJobSheet: Record "PVS Job Sheet" temporary;
    begin
        if not CanSingleUse then
            exit;
        GetFilterBeforeImpositionSearch(TempPVSJobItem, TempPVSJobSheet);

        //Update Sheet Filters
        PVSImpositionCode.SetFilter(Machine, '%1|%2', '', TempPVSJobSheet."Controlling Unit");
        PVSImpositionCode.SetFilter(Finishing, '%1|%2', '', TempPVSJobSheet.Finishing);
        PVSImpositionCode.SetFilter("Sheet Length", '%1|%2', 0, TempPVSJobSheet.Length);
        PVSImpositionCode.SetFilter("Sheet Width", '%1|%2', 0, TempPVSJobSheet.Width);
        PVSImpositionCode.SetFilter("Paper Weight", '%1|%2..', 0, TempPVSJobSheet.Weight);
        PVSImpositionCode.SetFilter("Paper Quality", '%1|%2', '', TempPVSJobSheet."Paper Quality");
    end;

    local procedure CalcImposition(var in_JobItemTmp: Record "PVS Job Item" temporary; var in_SheetTmp: Record "PVS Job Sheet" temporary; var in_ConfigRec: Record "PVS Cost Center Configuration"): Boolean
    var
        AppMgt: Codeunit "PVS Application Management";
        UnitFactor: Codeunit "PVS Unit Conversion";
    begin
        // Calc imposition
        if in_ConfigRec."Default Format Code" <> '' then begin
            in_SheetTmp.Length := AppMgt.Decode_Format_Code(in_ConfigRec."Default Format Code", 1);
            in_SheetTmp.Width := AppMgt.Decode_Format_Code(in_ConfigRec."Default Format Code", 2);
        end else begin
            if in_ConfigRec."Default Length" <> 0 then
                in_SheetTmp.Length := in_ConfigRec."Default Length"
            else
                if in_SheetTmp.Length = 0 then
                    in_SheetTmp.Length := in_ConfigRec."Max Printing Format Length";

            if in_ConfigRec."Default Width" <> 0 then
                in_SheetTmp.Width := in_ConfigRec."Default Width"
            else
                if in_SheetTmp.Width = 0 then
                    in_SheetTmp.Width := in_ConfigRec."Max Printing Format Width";
        end;
        in_SheetTmp."Gripper Edge" := in_ConfigRec."Gripper Edge";
        in_SheetTmp."Pull Mark" := in_ConfigRec.Pull;
        in_SheetTmp."Pull Side" := in_ConfigRec."Pull Side";
        in_SheetTmp.Strip := in_ConfigRec.Strip;
        in_SheetTmp."Cutting Distance" := in_ConfigRec."Cutting Distance";

        // Respect exitsting trim from job item and add cutting distance from machine
        if in_JobItemTmp.Trim = 0 then begin
            in_JobItemTmp.Trim := in_SheetTmp."Cutting Distance" / UnitFactor.Margin2Format() / 2;
            in_JobItemTmp."Trim Head" += in_JobItemTmp.Trim;
            in_JobItemTmp."Trim Foot" += in_JobItemTmp.Trim;
            in_JobItemTmp."Trim Face" += in_JobItemTmp.Trim;
            if in_JobItemTmp."Imposition Factor Width" < 2 then
                in_JobItemTmp."Milling Depth" += in_JobItemTmp.Trim;
        end;
    end;


    procedure Get_Min_Format_Txt(PvsJobItem: Record "PVS Job Item" temporary; PVSJobSheet: Record "PVS Job Sheet" temporary; var out_Width: Decimal; var out_Depth: Decimal) Result: Text[250]
    var
        Text001Lbl: Label '%1 x %2', Comment = '%1 and %2 represents Width and Depth';
    begin
        if not Get_Min_Format(PvsJobItem, PVSJobSheet, out_Width, out_Depth) then
            exit;

        Result := StrSubstNo(Text001Lbl, out_Width, out_Depth);
    end;

    procedure Get_Min_Format(PvsJobItem: Record "PVS Job Item" temporary; PVSJobSheet: Record "PVS Job Sheet" temporary; var out_Width: Decimal; var out_Depth: Decimal) is_Found: Boolean
    var
        IsHandled: Boolean;
    begin
        OnBefore_Get_Min_Format(PvsJobItem, PVSJobSheet, out_Width, out_Depth, IsHandled);
        if IsHandled then
            exit((out_Width > 0) and (out_Depth > 0));

        out_Width := 0;
        out_Depth := 0;
        if (PvsJobItem."Part Sheet Start Length" <> 0) or
           (PvsJobItem."Part Sheet Start Width" <> 0) or
           (PvsJobItem."Part Sheet Length" <> 0) or
           (PvsJobItem."Part Sheet Width" <> 0)
        then
            exit(false);

        if PVSJobSheet."Pull Side" = 2 then
            out_Width := PVSJobSheet."Pull Mark" * 2
        else
            out_Width := PVSJobSheet."Pull Mark";

        if PvsJobItem."Reverse Placement" then
            out_Width += PvsJobItem.ImposeX / PvsJobItem.SignatureY() * PvsJobItem.SignatureWidth()
        else
            out_Width += PvsJobItem.ImposeX / PvsJobItem.SignatureX() * PvsJobItem.SignatureWidth();

        if PVSJobSheet."Paper Type" = 1 then
            exit(out_Width > 0);

        if PVSJobSheet."Printing Method" in [PVSJobSheet."printing method"::"Work-and-Tumble", PVSJobSheet."printing method"::Perfecting] then
            if PVSJobSheet."Gripper Edge" > PVSJobSheet.Strip then
                out_Depth := PVSJobSheet."Gripper Edge" * 2
            else
                out_Depth := PVSJobSheet.Strip * 2
        else
            out_Depth := PVSJobSheet."Gripper Edge" + PVSJobSheet.Strip;

        if PvsJobItem."Reverse Placement" then
            out_Depth += PvsJobItem.ImposeY / PvsJobItem.SignatureX() * PvsJobItem.SignatureDepth()
        else
            out_Depth += PvsJobItem.ImposeY / PvsJobItem.SignatureY() * PvsJobItem.SignatureDepth();
        exit((out_Width > 0) and (out_Depth > 0));
    end;



    var
        TempSinglePVSJobItem: Record "PVS Job Item" temporary;
        TempSingleUsePVSJobSheet: Record "PVS Job Sheet" temporary;
        CanSingleUse: Boolean;


    /// <summary>
    /// This event is triggered at the beginning of the function "Get_Min_Format” in the table 6010318 “PVS Job Sheet”
    /// </summary>
    /// <param name="PVS_JobSheet">The current PVS Job Sheet Record</param>
    /// <param name="out_Width">The calculated Width from the Sheet</param>
    /// <param name="out_Depth">The calculated Depth from the Sheet </param>
    /// <param name="IsHandled">Parameter of type Boolean to enable the isHandled pattern</param>
    [IntegrationEvent(false, false)]
    local procedure OnBefore_Get_Min_Format(PvsJobItem: Record "PVS Job Item" temporary; var PVS_JobSheet: Record "PVS Job Sheet" temporary; var out_Width: Decimal; var out_Depth: Decimal; var IsHandled: Boolean)
    begin
    end;

    procedure SetFilterBeforeImpositionSearch(in_PVSJobItemTmp: Record "PVS Job Item" temporary; in_PVSJobSheetTmp: Record "PVS Job Sheet" temporary)
    begin
        TempSinglePVSJobItem := in_PVSJobItemTmp;
        TempSingleUsePVSJobSheet := in_PVSJobSheetTmp;
        CanSingleUse := true;
    end;

    procedure GetFilterBeforeImpositionSearch(out_PVSJobItemTmp: Record "PVS Job Item" temporary; out_PVSJobSheetTmp: Record "PVS Job Sheet" temporary)
    begin
        out_PVSJobItemTmp := TempSinglePVSJobItem;
        out_PVSJobSheetTmp := TempSingleUsePVSJobSheet;
        CanSingleUse := false;
        clear(TempSinglePVSJobItem);
        clear(TempSingleUsePVSJobSheet);
    end;

    // procedure CheckPaperOK(PaperSizeCheck: Boolean; Rec: Record "PTE Job Shift Split" temporary; var GlobalPVSJobItemTmp: Record "PVS Job Item" temporary;
    //     var GlobalPVSJobSheetTmp: Record "PVS Job Sheet" temporary;
    //     var GlobalCostCenterConfiguration: Record "PVS Cost Center Configuration"; var GlobalItem: Record Item): Boolean;
    // var
    //     HelperFunction: Codeunit "PTE Helperfunction";
    // begin

    //     UpdateTempRecs(rec, GlobalPVSJobItemTmp, GlobalPVSJobSheetTmp, GlobalCostCenterConfiguration, GlobalItem);
    //     if PaperSizeCheck then
    //         if not HelperFunction.Check_Paper(Rec, Rec."Paper Item No.", Rec."Controlling Sheet Unit") then
    //             exit;
    //     GlobalPVSJobSheetTmp."Paper Item No." := Rec."Paper Item No.";
    //     GlobalPVSJobSheetTmp.Modify(false);
    //     HelperFunction.Change_Paper(GlobalPVSJobItemTmp, GlobalPVSJobSheetTmp, GlobalCostCenterConfiguration);
    //     GlobalPVSJobSheetTmp.Check_ECO_Label();
    //     exit(true);
    // end;


    // procedure UpdateTempRecs(Rec: Record "PTE Job Shift Split" temporary; var GlobalPVSJobItemTmp: Record "PVS Job Item" temporary;
    //     var GlobalPVSJobSheetTmp: Record "PVS Job Sheet" temporary;
    //     var GlobalCostCenterConfiguration: Record "PVS Cost Center Configuration"; var GlobalItem: Record Item)
    // var
    //     UnitSetupRec: Record "PVS Calculation Unit Setup";
    //     PaperWeight: Decimal;
    //     PVSJobSheet: Record "PVS Job Sheet";
    //     PVSJobItem: Record "PVS Job Item";
    // begin
    //     if not UnitSetupRec.Get(UnitSetupRec.Type::"Price Unit", Rec."Controlling Sheet Unit") then
    //         exit;
    //     if not GlobalCostCenterConfiguration.Get(UnitSetupRec."Cost Center Code", UnitSetupRec.Configuration) then
    //         exit;
    //     if GlobalItem.get(Rec."Paper Item No.") then;
    //     if PVSJobItem.get(Rec.ID, Rec.Job, Rec.Version, Rec."Job Item No.", 1) then;
    //     if PVSJobSheet.get(PVSJobItem."Sheet ID") then;
    //     GlobalPVSJobItemTmp := PVSJobItem;
    //     GlobalPVSJobSheetTmp := PVSJobSheet;
    //     GlobalPVSJobSheetTmp."Paper Item No." := Rec."Paper Item No.";
    //     GlobalPVSJobItemTmp."Imposition Type" := Rec."Imposition Type";
    //     GlobalPVSJobSheetTmp."Controlling Unit" := Rec."Controlling Sheet Unit";
    //     GlobalPVSJobSheetTmp.Finishing := Rec.Finishing;
    //     if not GlobalPVSJobItemTmp.Insert(false) then
    //         if GlobalPVSJobItemTmp.Modify(false) then;
    //     if not GlobalPVSJobSheetTmp.Insert(false) then
    //         if GlobalPVSJobSheetTmp.Modify(false) then;
    // end;

}