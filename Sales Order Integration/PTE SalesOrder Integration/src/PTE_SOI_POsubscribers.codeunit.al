Codeunit 80102 "PTE SOI Purchase Order Sub"
{
    // Pages
    [EventSubscriber(Objecttype::Page, 49, 'OnInsertRecordEvent', '', true, false)]
    local procedure PVS_P49_OnInsertRecord(var Rec: Record "Purchase Header"; BelowxRec: Boolean; var xRec: Record "Purchase Header"; var AllowInsert: Boolean)
    var
        PurchaseManagement: Codeunit "PTE SOI Purchase Order Mgt";
    begin
        if Rec.IsTemporary() then
            exit;

        PurchaseManagement.PurchHead_Insert(Rec);
    end;

    [EventSubscriber(Objecttype::Page, 50, 'OnInsertRecordEvent', '', true, false)]
    local procedure PVS_P50_OnInsertRecord(var Rec: Record "Purchase Header"; BelowxRec: Boolean; var xRec: Record "Purchase Header"; var AllowInsert: Boolean)
    var
        PurchaseManagement: Codeunit "PTE SOI Purchase Order Mgt";
    begin
        if Rec.IsTemporary() then
            exit;

        PurchaseManagement.PurchHead_Insert(Rec);
    end;

    // Tables

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterInsertEvent', '', true, false)]
    local procedure PVS_T38_OnAfterInsert(var Rec: Record "Purchase Header"; RunTrigger: Boolean)
    var
        PurchaseManagement: Codeunit "PTE SOI Purchase Order Mgt";
    begin
        if not RunTrigger then
            exit;

        PurchaseManagement.PurchHead_Insert(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Buy-from Vendor No.', true, false)]
    local procedure OnAfterValidateField_VendorNo(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        ShippingAgentSetup: Record "PVS Shipping Agent Setup";
    begin
        // Find ShipmentAgent and use status code
        ShippingAgentSetup.SetRange("Vendor No.", rec."Buy-from Vendor No.");
        if not ShippingAgentSetup.FindFirst() then
            exit;
        if ShippingAgentSetup."Status Code" = '' then
            exit;

        rec.Validate("PTE SOI Status Code", ShippingAgentSetup."Status Code");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'PVS ID', true, false)]
    local procedure OnAfterValidateField_PVSID(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        CaseRec: Record "PVS Case";
    begin
        if rec."PVS ID" = 0 then
            exit;
        if not CaseRec.get(rec."PVS ID") then
            exit;

        Rec."PTE SOI Coordinator" := CaseRec.Coordinator;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterRecreatePurchLine', '', false, false)]
    local procedure PVS_T38_OnAfterRecreatePurchLine(var PurchLine: Record "Purchase Line"; var TempPurchLine: Record "Purchase Line" temporary)
    begin
        PurchLine."PTE SOI Production Order" := TempPurchLine."PTE SOI Production Order";
        PurchLine."PTE SOI Page Unit" := TempPurchLine."PTE SOI Page Unit";
        PurchLine."PTE SOI Pages" := TempPurchLine."PTE SOI Pages";
        PurchLine."PTE SOI Format Code" := TempPurchLine."PTE SOI Format Code";
        PurchLine."PTE SOI Colors Front" := TempPurchLine."PTE SOI Colors Front";
        PurchLine."PTE SOI Colors Back" := TempPurchLine."PTE SOI Colors Back";
        PurchLine."PTE SOI Paper" := TempPurchLine."PTE SOI Paper";
        PurchLine."PTE SOI Unchanged Reprint" := TempPurchLine."PTE SOI Unchanged Reprint";
        PurchLine.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnValidateNoOnCopyFromTempPurchLine', '', true, false)]
    local procedure PVS_T39_OnValidateNoOnCopyFromTempPurchLine(var PurchLine: Record "Purchase Line"; TempPurchaseLine: Record "Purchase Line" temporary)
    begin
        PurchLine."PTE SOI Production Order" := TempPurchaseLine."PTE SOI Production Order";
        PurchLine."PTE SOI Page Unit" := TempPurchaseLine."PTE SOI Page Unit";
        PurchLine."PTE SOI Pages" := TempPurchaseLine."PTE SOI Pages";
        PurchLine."PTE SOI Format Code" := TempPurchaseLine."PTE SOI Format Code";
        PurchLine."PTE SOI Colors Front" := TempPurchaseLine."PTE SOI Colors Front";
        PurchLine."PTE SOI Colors Back" := TempPurchaseLine."PTE SOI Colors Back";
        PurchLine."PTE SOI Paper" := TempPurchaseLine."PTE SOI Paper";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnValidateTypeOnCopyFromTempPurchLine', '', true, false)]
    local procedure PVS_T39_OnValidateTypeOnCopyFromTempPurchLine(var PurchLine: Record "Purchase Line"; TempPurchaseLine: Record "Purchase Line" temporary)
    begin
        PurchLine."PTE SOI Production Order" := TempPurchaseLine."PTE SOI Production Order";
        PurchLine."PTE SOI Page Unit" := TempPurchaseLine."PTE SOI Page Unit";
        PurchLine."PTE SOI Pages" := TempPurchaseLine."PTE SOI Pages";
        PurchLine."PTE SOI Format Code" := TempPurchaseLine."PTE SOI Format Code";
        PurchLine."PTE SOI Colors Front" := TempPurchaseLine."PTE SOI Colors Front";
        PurchLine."PTE SOI Colors Back" := TempPurchaseLine."PTE SOI Colors Back";
        PurchLine."PTE SOI Paper" := TempPurchaseLine."PTE SOI Paper";
    end;

}
