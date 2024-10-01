codeunit 80175 "PTE RFG Job Item Sub"
{
    SingleInstance = true;

    var
        GlobalJob: Integer;

    [EventSubscriber(ObjectType::Page, Page::"PVS Release finished goods", 'OnBeforeBuildItemVariantTMP', '', false, false)]
    local procedure OnBeforeBuildItemVariantTMP(in_ID: Integer; in_Job: Integer; var IsHandled: Boolean; var out_ItemVariantTMP: Record "Item Variant" temporary)
    var
        PVSGeneralSetup: Record "PVS General Setup";
        PVSJob: Record "PVS Job";
        PVSJobItem: Record "PVS Job item";
        InsertedJobs: List of [Integer];
    begin
        PVSGeneralSetup.FindFirst();
        if not PVSGeneralSetup."PTE Use Job Item" then
            exit;
        IsHandled := true;

        PVSJob.SetRange(ID, in_ID);
        GlobalJob := in_Job;
        if in_Job <> 0 then
            PVSJob.SetRange(Job, in_Job);

        PVSJob.SetRange(Active, true);
        if PVSJob.FindSet() then
            repeat
                if not InsertedJobs.Contains(PVSJob.Job) then begin
                    InsertedJobs.Add(PVSJob.Job);
                    PVSJobItem.SetRange(ID, PVSJob.ID);
                    PVSJobItem.SetRange(Job, PVSJob.Job);
                    PVSJobItem.SetRange(Version, PVSJob.Version);
                    PVSJobItem.SetFilter("Item No.", '<>%1', '');
                    if PVSJobItem.FindSet(false) then
                        repeat
                            out_ItemVariantTMP.SetRange("Item No.", PVSJobItem."Item No.");
                            if out_ItemVariantTMP.IsEmpty() then begin
                                out_ItemVariantTMP."Item No." := PVSJobItem."Item No.";
                                out_ItemVariantTMP.Insert(false);
                            end
                        until PVSJobItem.Next() = 0;
                end
            until PVSJob.Next() = 0;


    end;

    procedure ReleaseFinishedGoodsSuggest_Quantity(var ItemJournalLine: Record "Item Journal Line"; var OutQuantity: Decimal; var OutQuantityPosted: Decimal; var OutQuantityEstimated: Decimal; var PVSJob: Record "PVS Job"; var IsHandled: Boolean)
    var
        PVSGeneralSetup: Record "PVS General Setup";
        ItemPost: Record "Item Ledger Entry";
        TextRec: Record "PVS Job Text Description";
        JobItemRec: Record "PVS Job Item";
        JobQuantityEstimated: Decimal;
        InsertedJobs: List of [Integer];
    begin
        PVSGeneralSetup.FindFirst();
        if not PVSGeneralSetup."PTE Use Job Item" then
            exit;

        if ItemJournalLine."PVS ID" = 0 then
            exit;

        if ItemJournalLine."Item No." = '' then
            exit;

        IsHandled := true;
        OutQuantity := 0;
        OutQuantityPosted := 0;
        OutQuantityEstimated := 0;
        PVSJob.SetRange(ID, ItemJournalLine."PVS ID");
        if GlobalJob <> 0 then
            PVSJob.SetRange(Job, GlobalJob);
        PVSJob.SetRange(Active, true);
        if PVSJob.FindSet() then
            repeat
                if not InsertedJobs.Contains(PVSJob.Job) then begin
                    InsertedJobs.Add(PVSJob.Job);

                    if PVSJob.ID <> 0 then begin
                        TextRec.SetRange("Table ID", 0);
                        TextRec.SetRange(Code, '');
                        TextRec.SetRange(ID, PVSJob.ID);
                        TextRec.SetRange(Job, PVSJob.Job);
                        TextRec.SetRange(Version, PVSJob.Version);
                        TextRec.SetRange("No.", 0);
                        TextRec.SetRange(Type, TextRec.Type::ProductParts);
                        TextRec.SetRange(Department, '');
                        TextRec.SetRange("Finished Goods Item No.", ItemJournalLine."Item No.");
                        if TextRec.FindSet(false) then
                            repeat
                                JobQuantityEstimated += TextRec.Quantity;
                            until TextRec.Next() = 0;

                        if JobQuantityEstimated = 0 then begin
                            JobItemRec.SetRange(ID, PVSJob.ID);
                            JobItemRec.SetRange(Job, PVSJob.Job);
                            JobItemRec.SetRange(Version, PVSJob.Version);
                            if JobItemRec.FindSet(false) then
                                repeat
                                    if JobItemRec."Item No." = ItemJournalLine."Item No." then
                                        JobQuantityEstimated += JobItemRec.Quantity;
                                until JobItemRec.Next() = 0;
                        end;

                        if JobQuantityEstimated = 0 then
                            if (PVSJob."Item No." = ItemJournalLine."Item No.") or (PVSJob."Item No." = '') then
                                JobQuantityEstimated := PVSJob.Quantity;

                    end;
                end;
                OutQuantityEstimated += JobQuantityEstimated;
            until PVSJob.Next() = 0;
        ItemPost.Reset();
        ItemPost.SetCurrentkey("PVS ID");
        ItemPost.SetRange("PVS ID", PVSJob.ID);
        ItemPost.SetRange("Item No.", ItemJournalLine."Item No.");
        ItemPost.SetRange("Entry Type", ItemJournalLine."Entry Type");
        if ItemPost.FindSet(false) then
            repeat
                OutQuantityPosted += ItemPost.Quantity;
            until ItemPost.Next() = 0;

        OutQuantity := OutQuantityEstimated - OutQuantityPosted;
        if OutQuantity < 0 then
            OutQuantity := 0;

        ItemJournalLine.Validate(Quantity, OutQuantity);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Warehouse Mgt", 'OnBeforeSuggest_Quantity', '', false, false)]
    local procedure OnBeforeSuggest_Quantity(var IsHandled: Boolean; var ItemJournalLine: Record "Item Journal Line"; var OutQuantity: Decimal; var OutQuantityEstimated: Decimal; var OutQuantityPosted: Decimal; var PVSJob: Record "PVS Job")
    begin
        ReleaseFinishedGoodsSuggest_Quantity(ItemJournalLine, OutQuantity, OutQuantityPosted, OutQuantityEstimated, PVSJob, IsHandled);
    end;
}