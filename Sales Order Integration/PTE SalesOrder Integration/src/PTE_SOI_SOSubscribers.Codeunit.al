Codeunit 80105 "PTE SOI S.O. Sub"
{
    var
        PVSSingleInstance: Codeunit "PVS SingleInstance";
        SalesorderManagement: Codeunit "PTE SOI S.O. Mgt";
        PVSEventsBuffer: Codeunit "PVS Events Buffer";
        PVSInterceptMisc: Codeunit "PVS Intercept Misc.";
        PVSJobCostingMgt: Codeunit "PVS Job Costing Mgt.";

    // Codeunits
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterCheckSalesDoc', '', true, false)]
    local procedure PVS_CU80_OnAfterCheckSalesDoc(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean)
    var
        SalesLine: Record "Sales Line";
        InvoicedFullTemp: Record "Integer" temporary;
        ShippedFullTemp: Record "Integer" temporary;
        ShippedPartTemp: Record "Integer" temporary;
    begin
        if SalesHeader."Document Type" <> SalesHeader."Document Type"::Order then
            exit;

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetFilter(Type, '<>%1', SalesLine.Type::" ");
        SalesLine.SetRange(SalesLine."PTE SOI Production Order", true);
        SalesLine.SetFilter("PVS ID", '<>0');

        if SalesLine.FindSet then
            repeat
                // Save tmp's for later status change
                if (SalesLine."Qty. to Invoice" + SalesLine."Quantity Invoiced") = SalesLine.Quantity then begin
                    InvoicedFullTemp.Number := SalesLine."PVS ID";
                    if InvoicedFullTemp.Insert() then;
                end else
                    if (SalesLine.Type = SalesLine.Type::Item) and (SalesLine."Qty. to Ship" > 0) then
                        if SalesLine."Qty. to Ship" = SalesLine."Outstanding Quantity" then begin
                            ShippedFullTemp.Number := SalesLine."PVS ID";
                            if ShippedFullTemp.Insert() then;
                        end else begin
                            ShippedPartTemp.Number := SalesLine."PVS ID";
                            if ShippedPartTemp.Insert() then;
                        end;

            until SalesLine.Next() = 0;

        // Initiate Posting Buffer (Single Instance) to be picked up by next Event
        PVSEventsBuffer.Set_IntegerTemp1(InvoicedFullTemp);
        PVSEventsBuffer.Set_IntegerTemp2(ShippedFullTemp);
        PVSEventsBuffer.Set_IntegerTemp3(ShippedPartTemp);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterFinalizePosting', '', true, false)]
    local procedure PVS_CU80_OnAfterFinalizePosting(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    var
        StatusMgt: Codeunit "PTE SOI Status Management";
        SalesLine: Record "Sales Line";
        SO_Shipped_Full: Boolean;
        SO_Shipped_Part: Boolean;
    begin
        SO_Shipped_Full := true;
        SO_Shipped_Part := false;

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet(false) then
            repeat
                if (SalesLine.Type = SalesLine.Type::Item) and (SalesLine."PVS ID" = 0) then begin // Item & no prod. order
                    if SalesLine."Quantity Shipped" > 0 then
                        SO_Shipped_Part := true;
                    if (SalesLine.Quantity > 0) and (SalesLine."Outstanding Quantity" > 0) then
                        SO_Shipped_Full := false;
                end;
            until SalesLine.Next() = 0;

        if SO_Shipped_Part then
            if SO_Shipped_Full then
                StatusMgt.Set_SOstatus_Shipped_Full(SalesHeader)
            else
                StatusMgt.Set_SOstatus_Shipped_Part(SalesHeader);
    end;
    /* herher
        [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Intent Management", 'OnBeforeCreateCaseFromIntent', '', true, false)]
    */
    procedure OnBeforeCreateCaseFromIntent(var in_Rec: Record "PVS Intent Product"; var out_CaseRec: Record "PVS Case"; var IsHandled: Boolean)
    var
        SalesHeadRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        CaseRec: Record "PVS Case";
        PVmgt: Codeunit "PTE SOI SOint Prod Order Mgt";
    begin
        // Insert Case from Intent
        if SalesHeadRec.Get(in_Rec."Sales Order Type", in_Rec."Sales Order No.") then begin
            if not SalesLineRec.Get(in_Rec."Sales Order Type", in_Rec."Sales Order No.", in_Rec."Sales Order Line No.") then
                SalesLineRec.Init();

            SalesLineRec."PVS Product Group Code" := in_Rec."Product Group";
            SalesLineRec.Description := CopyStr(in_Rec."Job Name", 1, MaxStrLen(SalesLineRec.Description));
            SalesLineRec."PTE SOI Production Order" := true;

            PVmgt."Find/Insert_P-Order"(SalesLineRec, SalesHeadRec, CaseRec);

            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order (Yes/No)", 'OnAfterSalesQuoteToOrderRun', '', true, false)]
    local procedure PVS_CU83_OnAfterSalesQuoteToOrderRun(var SalesHeader2: Record "Sales Header"; var SalesHeader: Record "Sales Header")
    begin
        if not PVSSingleInstance.Is_PrintVis_Active() then
            exit;

        PVSSingleInstance.Set_Global_SalesHeader(SalesHeader2);
    end;

    // Pages


    // Tables
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeModifySalesHeader', '', true, false)]
    local procedure PVS_CU6620_CopySOFieldsOnBeforeModifySalesHeader(var ToSalesHeader: Record "Sales Header"; FromDocType: Option; FromDocNo: Code[20]; IncludeHeader: Boolean)
    var
        SalesDocType: Option Quote,"Blanket Order","Order",Invoice,"Return Order","Credit Memo","Posted Shipment","Posted Invoice","Posted Return Receipt","Posted Credit Memo";
    begin

        if FromDocType in [Salesdoctype::"Blanket Order", Salesdoctype::"Credit Memo", Salesdoctype::Invoice, Salesdoctype::Order] then begin
            ToSalesHeader."PTE SOI Order Type Code" := '';
            ToSalesHeader."PTE SOI Status Code" := '';
            ToSalesHeader."PTE SOI Deadline" := 0D;
            ToSalesHeader."PTE SOI Person Responsible" := '';
            ToSalesHeader."PTE SOI Manual Responsible" := false;
            ToSalesHeader."PTE SOI Coordinator" := '';
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Customer No.', true, false)]
    local procedure PVS_T36_OnAfterValidateField_SellToNoCustomerNo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        Customer: Record Customer;
        UserSetup: Record "PVS User Setup";
    begin
        if not Customer.Get(rec."Sell-to Customer No.") then
            exit;
        rec."PVS Customer Group Code" := Customer."PVS Customer Group Code";
        if Customer."PVS Order Planner" <> '' then
            rec."PTE SOI Coordinator" := Customer."PVS Order Planner"
        else begin
            PVSSingleInstance.Get_UserSetupRec(UserSetup);
            Rec."PTE SOI Coordinator" := UserSetup."Case Default Coordinator";
        end;
    end;



    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterCreateSalesLine', '', true, false)]
    local procedure PVS_T36_OnAfterCreateSalesLine(var TempSalesLine: Record "Sales Line" temporary; var SalesLine: Record "Sales Line")
    var
        PVmgt: Codeunit "PTE SOI SOint Prod Order Mgt";
    begin
        SalesLine."PTE SOI Production Order" := TempSalesLine."PTE SOI Production Order";
        SalesLine."PTE SOI Paper" := TempSalesLine."PTE SOI Paper";
        SalesLine."PTE SOI Unchanged Reprint" := TempSalesLine."PTE SOI Unchanged Reprint";
        SalesLine."PTE SOI Pages" := TempSalesLine."PTE SOI Pages";
        SalesLine."PTE SOI Format Code" := TempSalesLine."PTE SOI Format Code";
        SalesLine."PTE SOI Colors Front" := TempSalesLine."PTE SOI Colors Front";
        SalesLine."PTE SOI Colors Back" := TempSalesLine."PTE SOI Colors Back";
        SalesLine."PTE SOI Production Qty." := TempSalesLine."PTE SOI Production Qty.";
        SalesLine.Modify();

        // -> From PVS_T37_OnAfterInsertEvent
        if SalesLine."PTE SOI Production Order" then
            PVmgt.SalesLine_Insert_PrintVis(SalesLine);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateTypeOnCopyFromTempSalesLine', '', true, false)]
    local procedure PVS_T37_OnValidateTypeOnCopyFromTempSalesLine(var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary)
    begin
        SalesLine."PTE SOI Production Order" := TempSalesLine."PTE SOI Production Order";
        SalesLine."PTE SOI Page Unit" := TempSalesLine."PTE SOI Page Unit";
        SalesLine."PTE SOI Pages" := TempSalesLine."PTE SOI Pages";
        SalesLine."PTE SOI Format Code" := TempSalesLine."PTE SOI Format Code";
        SalesLine."PTE SOI Colors Front" := TempSalesLine."PTE SOI Colors Front";
        SalesLine."PTE SOI Colors Back" := TempSalesLine."PTE SOI Colors Back";
        SalesLine."PTE SOI Paper" := TempSalesLine."PTE SOI Paper";

        if (SalesLine.Type <> SalesLine.Type::" ") and (SalesLine."No." <> '') then begin
            SalesLine.Validate("PTE SOI Unit", TempSalesLine."PTE SOI Unit");
            SalesLine.Validate("PTE SOI Qty. Order", TempSalesLine."PTE SOI Qty. Order");
            SalesLine.Validate("PTE SOI Sales Price", TempSalesLine."PTE SOI Sales Price");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateNoOnCopyFromTempSalesLine', '', true, false)]
    local procedure PVS_T37_OnValidateNoOnCopyFromTempSalesLine(var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary)
    begin
        SalesLine."PTE SOI Production Order" := TempSalesLine."PTE SOI Production Order";
        SalesLine."PTE SOI Page Unit" := TempSalesLine."PTE SOI Page Unit";
        SalesLine."PTE SOI Pages" := TempSalesLine."PTE SOI Pages";
        SalesLine."PTE SOI Format Code" := TempSalesLine."PTE SOI Format Code";
        SalesLine."PTE SOI Colors Front" := TempSalesLine."PTE SOI Colors Front";
        SalesLine."PTE SOI Colors Back" := TempSalesLine."PTE SOI Colors Back";
        SalesLine."PTE SOI Paper" := TempSalesLine."PTE SOI Paper";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInsertEvent', '', true, false)]
    local procedure PVS_T37_OnAfterInsert(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    var
        TempSalesLine: Record "Sales Line" temporary;
        PVSCase: Record "PVS Case";
    begin
        if not RunTrigger then
            exit;

        if not PVSSingleInstance.Is_PrintVis_Active() then
            exit;

        if Rec.IsTemporary() then
            exit;

        if not Rec."PTE SOI Production Order" then
            exit;

        if Rec."PVS ID" = 0 then
            exit;

        if not PVSCase.Get(Rec."PVS ID") then
            exit;

        if (PVSCase."Sales Order No." <> Rec."Document No.") or
           (PVSCase."Sales Order Type" <> PVSCase."sales order type"::Order)
        then begin
            PVSCase."Sales Order No." := Rec."Document No.";
            PVSCase."Sales Order Type" := PVSCase."sales order type"::Order;
            PVSCase.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeModifyEvent', '', true, false)]
    local procedure PVS_T37_OnBeforeModify(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; RunTrigger: Boolean)
    begin
        if not RunTrigger then
            exit;

        if not PVSSingleInstance.Is_PrintVis_Active() then
            exit;

        SalesorderManagement.SalesLine_OnModify(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterDeleteEvent', '', true, false)]
    local procedure PVS_T37_OnAfterDelete(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    begin
        if not RunTrigger then
            exit;

        if not PVSSingleInstance.Is_PrintVis_Active() then
            exit;

        if Rec.IsTemporary() then
            exit;

        SalesorderManagement.SalesLine_OnDelete(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Quantity', true, false)]
    local procedure PVS_T37_OnAfterValidateField_Quantity(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        if not PVSSingleInstance.Is_PrintVis_Active() then
            exit;

        SalesorderManagement.SalesLine_Validate_Quantity(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Unit Price', true, false)]
    local procedure PVS_T37_OnAfterValidateField_UnitPrice(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        if not PVSSingleInstance.Is_PrintVis_Active() then
            exit;

        SalesorderManagement.SalesLine_Validate_Unit_Price(Rec, xRec);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'PVS Product Group Code', true, false)]
    local procedure PVS_T37_OnAfterValidateField_PVSProductGroupCode(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        SalesorderManagement.SalesLine_Validate_ProductGrp(Rec, xRec);

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Main", 'OnCaseAfterStatusChange', '', false, false)]
    local procedure OnCaseAfterStatusChange(StatusCodeFromRec: Record "PVS Status Code"; StatusCodeToRec: Record "PVS Status Code"; var CaseRec: Record "PVS Case"; var IsHandled: Boolean);
    var
        SH: Record "Sales Header";
        SL_Tmp: Record "Sales Line" temporary;
        OrderRec: Record "PVS Case";
        StatusRec_SalesOrderCheck: Record "PVS Status Code";
        CacheMgt: Codeunit "PVS Cache Management";
        Quote_To_Order: Codeunit "Sales-Quote to Order (Yes/No)";
        SOIntProdOrderMgt: Codeunit "PTE SOI SOint Prod Order Mgt";
        Lowest_Deadline: Date;
        Lowest_Responsible: Code[20];
        Lowest_StatusCode: Code[20];
        Lowest_SortingOrder: Integer;
        Is_Quote_Raised_To_Order: Boolean;
        ok: Boolean;
    begin


        if not StatusCodeToRec."Prod eq. Sale" then
            exit;

        if (StatusCodeFromRec.Status = StatusCodeFromRec.Status::Quote) and (CaseRec.Type = CaseRec.Type::Order) then
            Is_Quote_Raised_To_Order := true;

        // Maintain Sales Order
        if (CaseRec."Created By Sales Order" <> '') then begin
            ok := SH.Get(0, CaseRec."Created By Sales Order");
            if not ok then
                ok := SH.Get(1, CaseRec."Created By Sales Order");

            if not ok then
                ok := SH.Get(4, CaseRec."Created By Sales Order");

            if not ok then
                if CaseRec."Sales Order No." <> '' then
                    ok := SH.Get(CaseRec."Sales Order Type", CaseRec."Sales Order No.");

            if ok then begin
                Lowest_StatusCode := CaseRec."Status Code";
                Lowest_SortingOrder := StatusCodeToRec."Sorting Order";
                Lowest_Responsible := CopyStr(CaseRec.Responsible, 1, 20);
                Lowest_Deadline := CaseRec.Deadline;

                SOIntProdOrderMgt.READ_Tmp_Saleslines(SL_Tmp, SH."Document Type", SH."No.");
                SL_Tmp.SetFilter("PVS ID", '<>0');
                SL_Tmp.SetRange("PTE SOI Production Order", true);

                if SL_Tmp.FindSet(false) then
                    repeat
                        if OrderRec.Get(SL_Tmp."PVS ID") then begin
                            if CaseRec.ID = OrderRec.ID then
                                OrderRec := CaseRec;
                            StatusRec_SalesOrderCheck.Get('', OrderRec."Status Code");
                            if StatusRec_SalesOrderCheck."Sorting Order" < Lowest_SortingOrder then begin
                                Lowest_StatusCode := StatusRec_SalesOrderCheck.Code;
                                Lowest_SortingOrder := StatusRec_SalesOrderCheck."Sorting Order";
                                Lowest_Responsible := CopyStr(CaseRec.Responsible, 1, 20);
                                Lowest_Deadline := OrderRec.Deadline;
                            end;
                        end;
                    until SL_Tmp.Next() = 0;

                if Lowest_StatusCode <> SH."PTE SOI Status Code" then begin
                    SH."PTE SOI Status Code" := Lowest_StatusCode;
                    SH."PTE SOI Person Responsible" := Lowest_Responsible;
                    SH."PTE SOI Deadline" := Lowest_Deadline;
                    SH.Modify();
                end;
                if Is_Quote_Raised_To_Order then
                    if SH."Document Type" = SH."Document Type"::Quote then
                        Quote_To_Order.Run(SH);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job", 'OnAfterModifyEvent', '', true, false)]
    local procedure PVS_T6010313_OnAfterModify(var Rec: Record "PVS Job"; var xRec: Record "PVS Job"; RunTrigger: Boolean)
    begin
        if not RunTrigger then
            exit;
        if xRec."Product Group" <> Rec."Product Group" then
            SalesorderManagement.Job_Redundant_To_SalesLines(Rec);
    end;


}
