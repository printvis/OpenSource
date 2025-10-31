codeunit 80800 "PTE ToolTip"
{
    [EventSubscriber(ObjectType::Page, Page::"PVS Planning Board", 'OnBeforeSetJSONSettings', '', true, true)]
    local procedure OnBeforeSetJSONSettings(var out_settings: JsonObject)
    var
        PlanningUnit: Record "PVS Job Planning Unit";
    begin
        PlanningUnit.modifyall("PTE ToolTipTxt", '');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS planning Board Data", 'OnAfterTooltipText2', '', true, true)]
    local procedure OnAfterTooltipText2(PVSJobPlanningUnit: Record "PVS Job Planning Unit"; var OutToolTipTxt: text; var OutSearchTxt: text)
    var
        PlanningUnit: Record "PVS Job Planning Unit";
    begin
        if (OutSearchTxt = '') and (OutToolTipTxt = '') then
            exit;

        if PlanningUnit.get(PVSJobPlanningUnit."Simulation Version", PVSJobPlanningUnit.ID, PVSJobPlanningUnit."Plan ID", PVSJobPlanningUnit."Entry No.") then begin
            PlanningUnit."PTE ToolTipTxt" := OutToolTipTxt;
            PlanningUnit."PTE SearchTxt" := OutSearchTxt;
            PlanningUnit.Modify();
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS planning Board Data", 'OnBeforeTooltipText', '', true, true)]
    local procedure OnBeforeTooltipText(PVSJobPlanningUnit: Record "PVS Job Planning Unit"; var OutToolTipTxt: text; var OutSearchTxt: text; var IsHandled: Boolean)
    var
        PlanningUnit: Record "PVS Job Planning Unit";
    begin
        if PlanningUnit.get(PVSJobPlanningUnit."Simulation Version", PVSJobPlanningUnit.ID, PVSJobPlanningUnit."Plan ID", PVSJobPlanningUnit."Entry No.") then
            if (PlanningUnit."PTE ToolTipTxt" <> '') then begin
                OutSearchTxt := PlanningUnit."PTE SearchTxt";
                OutToolTipTxt := PlanningUnit."PTE ToolTipTxt";
                IsHandled := true;
            end;
    end;

















    [EventSubscriber(ObjectType::Table, Database::"PVS Job Signatures", 'OnBeforeBuild_Entries', '', true, true)]
    local procedure OnBeforeBuild_Entries(in_SheetRec: Record "PVS Job Sheet"; in_BuildEntriesForJob: boolean; var out_RecTmp: Record "PVS Job Signatures" temporary; var isHandled: Boolean)
    begin
        IsHandled := Build_Entries(in_SheetRec, in_BuildEntriesForJob, out_RecTmp);
    end;

    local procedure Build_Entries(in_SheetRec: Record "PVS Job Sheet"; in_BuildEntriesForJob: boolean; var out_RecTmp: Record "PVS Job Signatures" temporary): Boolean
    var
        CalcUnit: Record "PVS Job Calculation Unit";
        CalcUnitSetup: Record "PVS Calculation Unit Setup";
        Configuration: Record "PVS Cost Center Configuration";
        JobRec: Record "PVS Job";
        FinishingRec: Record "PVS Finishing Types";
        JobItemRec: Record "PVS Job Item";
        JobItemTMP: Record "PVS Job Item" temporary;
        ComponentTypeRec: Record "PVS Component Types";
        SheetRec: Record "PVS Job Sheet";
        JobSignaturesRec: Record "PVS Job Signatures";
        LastSignatureTMP: Record "PVS Job Signatures" temporary;
        GAF: Codeunit "PVS Table Filters";
        AssemblyOrder, Indentation : Integer;
        Counter, SheetSetID : Integer;
        AssemblyStyleFound: Boolean;
        AssemblyStyle: Option Gathering,Collecting,List;
        AssemblyOrderUsed: List of [Integer];
        FinishingSignatureCounter, FinishingSignaturesPerSheet : integer;
    begin

        if in_SheetRec.ID = 0 then
            exit;
        LastSignatureTMP.Copy(out_RecTmp, true);

        // Find finishingtype
        CalcUnit.SetRange(ID, in_SheetRec.ID);
        CalcUnit.SetRange(Job, in_SheetRec.Job);
        CalcUnit.SetRange(Version, in_SheetRec.Version);
        CalcUnit.SetRange("Process Type", CalcUnit."Process Type"::Finishing);
        if CalcUnit.FindSet() then
            repeat
                if CalcUnitSetup.get(CalcUnitSetup.Type::"Price Unit", CalcUnit.Unit) then
                    if Configuration.get(CalcUnitSetup."Cost Center Code", CalcUnitSetup.Configuration) then begin
                        AssemblyStyleFound := true;

                        case Configuration."CIP4 Binding" of
                            Configuration."CIP4 Binding"::HardCover:
                                AssemblyStyle := AssemblyStyle::List;
                            Configuration."CIP4 Binding"::SaddleStitch:
                                AssemblyStyle := AssemblyStyle::Collecting;
                            Configuration."CIP4 Binding"::SoftCover:
                                AssemblyStyle := AssemblyStyle::List;
                            else
                                AssemblyStyleFound := false;
                        end;
                    end;
            until AssemblyStyleFound or (CalcUnit.next = 0);

        if not AssemblyStyleFound then
            // Try to check the job
            if JobRec.get(in_SheetRec.ID, in_SheetRec.Job, in_SheetRec.Version) then
                if JobRec.Finishing <> '' then
                    if FinishingRec.Get(JobRec.Finishing) then begin
                        AssemblyStyleFound := true;

                        case FinishingRec."CIP4 Binding" of

                            FinishingRec."CIP4 Binding"::HardCover:
                                AssemblyStyle := AssemblyStyle::List;

                            FinishingRec."CIP4 Binding"::SaddleStitch:
                                AssemblyStyle := AssemblyStyle::Collecting;

                            FinishingRec."CIP4 Binding"::SoftCover:
                                AssemblyStyle := AssemblyStyle::List;
                            else
                                AssemblyStyleFound := false;
                        end;
                    end;
        if not AssemblyStyleFound then
            AssemblyStyle := AssemblyStyle::Gathering;


        GAF.SELECT_JobItems2Job(JobItemRec, in_SheetRec.ID, in_SheetRec.Job, in_SheetRec.Version, true);
        JobItemRec.SetCurrentkey("Job Item No. 2");
        if not JobItemRec.FindSet(false) then
            exit;

        // Multiple jobitems on the same sheet is not supported
        repeat
            if (JobItemRec.MultipleJobItemsOnSheet()) then begin
                out_RecTmp.DeleteAll();
                exit;
            end;

            // store assembly order assigned manually
            JobSignaturesRec.reset;
            JobSignaturesRec.SetRange("Sheet ID", JobItemRec."Sheet ID");
            if JobSignaturesRec.findset(false) then
                repeat
                    AssemblyOrderUsed.Add(JobSignaturesRec."Assembly Order");
                until JobSignaturesRec.next = 0;
        until JobItemRec.next = 0;

        // Build sorting order for job items
        // First find covers 
        JobItemRec.FindSet(false);
        repeat
            if ComponentTypeRec.get(JobItemRec."Component Type") then
                if ComponentTypeRec."Component Of Cover" then begin
                    JobItemTMP := JobItemRec;
                    Counter += 1;
                    JobItemTMP."Job Item No. 2" := Counter;
                    JobItemTMP.insert;
                end;
        // An alternative is to look at the jdf product type
        // case ComponentTypeRec."JDF Product Type" of
        //     ComponentTypeRec."JDF Product Type"::BackCover,
        //     ComponentTypeRec."JDF Product Type"::Cover,
        //     ComponentTypeRec."JDF Product Type"::FrontCover:
        //         begin
        //         end;
        // end;
        until JobItemRec.next = 0;

        // Now find other job items
        JobItemRec.FindSet();
        repeat
            if not JobItemTMP.get(JobItemRec.ID, JobItemRec.Job, JobItemRec.Version, JobItemRec."Job Item No.", JobItemRec."Entry No.") then begin
                JobItemTMP := JobItemRec;
                Counter += 1;
                JobItemTMP."Job Item No. 2" := Counter;
                JobItemTMP.insert;
            end;
        until JobItemRec.next = 0;

        out_RecTmp.reset;


        Counter := 0;
        Indentation := 0;
        JobItemTMP.Reset();
        JobItemTMP.SetCurrentkey("Job Item No. 2");
        if JobItemTMP.FindSet() then
            repeat
                if SheetRec.get(JobItemTMP."Sheet ID") then begin
                    FinishingSignaturesPerSheet := GetFinishingSignaturesPerSheet(JobItemTMP, SheetRec);
                    if FinishingSignaturesPerSheet = 0 then
                        FinishingSignaturesPerSheet := 1;
                    for SheetSetID := 1 to SheetRec."No. Of Sheet Sets" do begin
                        for FinishingSignatureCounter := 0 to (FinishingSignaturesPerSheet - 1) do begin
                            Counter += 1;


                            if JobSignaturesRec.Get(SheetRec."Sheet ID", SheetSetID, FinishingSignatureCounter) then begin
                                // use the stored value
                                out_RecTmp := JobSignaturesRec;
                                if out_RecTmp.insert() then;
                            end else begin

                                AssemblyOrder := 0;
                                repeat
                                    AssemblyOrder += 1;
                                until not AssemblyOrderUsed.Contains(AssemblyOrder);


                                // try to insert a tmp record
                                if not out_RecTmp.Get(SheetRec."Sheet ID", SheetSetID, FinishingSignatureCounter) then begin
                                    // insert new tmp record
                                    out_RecTmp.Init();
                                    out_RecTmp."Sheet ID" := SheetRec."Sheet ID";
                                    out_RecTmp."Sheet Set ID" := SheetSetID;
                                    out_RecTmp."Finishing Signature No." := FinishingSignatureCounter;
                                    out_RecTmp."Signature No." := Counter;
                                    out_RecTmp."Assembly Order" := AssemblyOrder;
                                    out_RecTmp.ID := SheetRec.ID;
                                    out_RecTmp.Job := SheetRec.Job;
                                    out_RecTmp.Version := SheetRec.Version;
                                    out_RecTmp."Job Item No." := JobItemTMP."Job Item No.";
                                    out_RecTmp."Entry No." := JobItemTMP."Entry No.";
                                    if out_RecTmp.Insert() then
                                        AssemblyOrderUsed.Add(out_RecTmp."Assembly Order");

                                    GetPrintSignatureID(out_RecTmp);
                                end;

                                case AssemblyStyle of
                                    AssemblyStyle::Collecting:
                                        begin
                                            // Collecting = 0123
                                            Indentation := AssemblyOrder - 1;
                                        end;
                                    AssemblyStyle::Gathering:
                                        begin
                                            // Gathering = 0000
                                            Indentation := 0;
                                        end;
                                    AssemblyStyle::List:
                                        begin
                                            // List = 0111
                                            if AssemblyOrder = 1 then
                                                Indentation := 0
                                            else
                                                Indentation := 1;
                                        end;
                                end;

                                out_RecTmp."Assembly Order" := AssemblyOrder;
                                out_RecTmp."Print Signature Name" := SheetName(out_RecTmp);
                                out_RecTmp.Indent := Indentation;
                                out_RecTmp.Modify(true);

                                // Special rule for residual sheet
                                if JobItemTMP."Entry No." = 1 then
                                    LastSignatureTMP := out_RecTmp
                                else begin
                                    // Switch values with last signature
                                    out_RecTmp."Assembly Order" := LastSignatureTMP."Assembly Order";
                                    out_RecTmp.Indent := LastSignatureTMP.Indent;
                                    out_RecTmp.Modify();
                                    LastSignatureTMP."Assembly Order" := AssemblyOrder;
                                    LastSignatureTMP.Indent := Indentation;
                                    LastSignatureTMP.Modify();
                                end;
                            end;
                        end;
                    end;
                end;
            until JobItemTMP.Next() = 0;
        exit(true);
    end;

    local procedure GetFinishingSignaturesPerSheet(JobItem: Record "PVS Job Item"; Sheet: Record "PVS Job Sheet") FoldingSignatures: Integer
    var
        ImpositionRec: Record "PVS Imposition Code";
        SheetForms, ImpositionForms : Integer;
    begin

        if ((JobItem."Pages In Sheet" = 0) or
           (JobItem."Pages With Print" = 0) or
           (JobItem."Pages In Sheet" <= JobItem."Pages With Print"))
        then
            SheetForms := 1
        else
            SheetForms := JobItem."Pages In Sheet" DIV ROUND(JobItem."Pages With Print", 1);

        if JobItem."Manual Signatures" then begin
            if SheetForms <> 0 then
                FoldingSignatures := JobItem.Signatures DIV SheetForms;
        end else
            if JobItem."Imposition Type" <> '' then
                if JobItem.GET_ImpositionRec(ImpositionRec, JobItem."Imposition Type") then
                    if (ImpositionRec."Folding Items Length" <> 0) and
                       (ImpositionRec."Folding Items Width" <> 0)
                    then begin
                        ImpositionForms := (ImpositionRec."Leaves Length" * ImpositionRec."Leaves Width") DIV
                            (ImpositionRec."Folding Items Length" * ImpositionRec."Folding Items Width");

                        if ImpositionRec."Double Production" then
                            ImpositionRec.Production := 2;
                        if ImpositionRec.Production = 0 then
                            ImpositionRec.Production := 1;

                        SheetForms := SheetForms DIV ImpositionRec.Production;

                        if SheetForms <> 0 then
                            FoldingSignatures := ImpositionForms DIV SheetForms;
                    end;

        if FoldingSignatures = 0 then
            FoldingSignatures := 1;
    end;

    local procedure GetPrintSignatureID(var in_PVSJobSignatures: Record "PVS Job Signatures")
    begin
        in_PVSJobSignatures.CalcFields("Sheet No.");
        in_PVSJobSignatures."Print Signature ID" := Format((in_PVSJobSignatures."Sheet No." * 1000) + in_PVSJobSignatures."Signature No.");
    end;

    local procedure SheetName(var in_PVSJobSignatures: Record "PVS Job Signatures") Result: Text
    var
        JobItemRec: Record "PVS Job Item";
        SheetRec: Record "PVS Job Sheet";
        Text005: label 'pp';
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

                Result := CopyStr(((Result + Format(JobItemRec."Pages With Print") + Text005 + '_')), 1, 250);
            end;

            Result := CopyStr(((Result + Format(SheetRec."Colors Front") + '-' + Format(SheetRec."Colors Back"))), 1, 250);

            Result := CopyStr(((Result + '-' + Format(in_PVSJobSignatures."Print Signature ID"))), 1, 250);
            Result := ConvertStr(Result, ' ', '_');
        end else
            Result := 'SHT' + Format(in_PVSJobSignatures."Sheet ID");
    end;
}
