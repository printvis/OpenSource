codeunit 75201 "PTE PVS FG Val. Event Sub."
{

    SingleInstance = true;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Costing Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure PVSJobCostingEntry_OnAfterInsert(RunTrigger: Boolean; var Rec: Record "PVS Job Costing Entry")
    var
        PTEPVSFGValueRec: Record "PTE PVS FG Valuation";
    begin
        if Rec.IsTemporary then
            exit;

        PTEPVSFGValueRec.SetRange("PVS ID", Rec.ID);
        PTEPVSFGValueRec.ModifyAll("Cost is Adjusted", false, false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Costing Entry", 'OnAfterModifyEvent', '', false, false)]
    local procedure PVSJobCostingEntry_OnAfterModify(RunTrigger: Boolean; var Rec: Record "PVS Job Costing Entry")
    var
        PTEPVSFGValueRec: Record "PTE PVS FG Valuation";
    begin
        if Rec.IsTemporary then
            exit;

        PTEPVSFGValueRec.SetRange("PVS ID", Rec.ID);
        PTEPVSFGValueRec.ModifyAll("Cost is Adjusted", false, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterPostItem', '', true, true)]
    local procedure CduItemJnlPostLineOnAfterPostItem(var ItemJournalLine: Record "Item Journal Line")
    var
        BongPVFinGoodsOutputL: Record "PTE PVS FG Valuation";
        PVSJobRecL: Record "PVS Job";
        ItemRecL: Record Item;
        BongFGCduL: Codeunit "PTE PVS FG Valuation Mngt.";

    begin
        //create ouptut
        if ItemRecL.Get(ItemJournalLine."Item No.") then
            if
            (ItemRecL."PVS Item Type" = ItemRecL."PVS Item Type"::"Finished Good") and
            (ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Purchase) and
            (ItemJournalLine."Source Type" = ItemJournalLine."Source Type"::" ") and
            (ItemJournalLine."PVS ID" <> 0) then begin
                if not BongPVFinGoodsOutputL.Get(PVSJobRecL.ID, ItemJournalLine."Item No.", '') then begin
                    BongPVFinGoodsOutputL.Init();
                    BongPVFinGoodsOutputL."PVS ID" := PVSJobRecL.ID;
                    BongPVFinGoodsOutputL."Item No." := PVSJobRecL."Item No.";
                    if BongPVFinGoodsOutputL.Insert() then;
                end;
                BongPVFinGoodsOutputL."Cost is Adjusted" := false;
                BongPVFinGoodsOutputL.Modify();
            end;
    end;
}