codeunit 80109 "PTE UBG Move Data"
{
    trigger OnRun()
    begin
        MoveTableDataSalesLineArchive();
        MoveTableDataPurchaseHeader();
        MoveTableDataPurchaseLine();
        MoveTableDataPurchaseHeaderArchive();
        MoveTableDataPurchaseLineArchive();
        MoveTableDataSalesHeader();
        MoveTableDataSalesLine();
        MoveTableDataSalesHeaderArchive();
#if NOT CLEAN26
        MoveUserSetupFields();
#endif
        MoveTableDataSPVSGeneralSetup();
    end;

    local procedure MoveTableDataSalesLineArchive()
    var
        SalesLineArchive: Record "Sales Line Archive";
    begin
        SalesLineArchive.Reset();
        if SalesLineArchive.IsEmpty() then
            exit;

        if SalesLineArchive.FindSet() then
            repeat
                SalesLineArchive."PTE SOI Colors Front" := SalesLineArchive."PTE UBG  Colors Front";
                SalesLineArchive."PTE SOI Format Code" := SalesLineArchive."PTE UBG  Format Code";
                SalesLineArchive."PTE SOI Page Unit" := SalesLineArchive."PTE UBG  Page Unit";
                SalesLineArchive."PTE SOI Pages" := SalesLineArchive."PTE UBG  Pages";
                SalesLineArchive."PTE SOI Paper" := SalesLineArchive."PTE UBG  Paper";
                SalesLineArchive."PTE SOI Production Order" := SalesLineArchive."PTE UBG  Production Order";
                SalesLineArchive."PTE SOI Production Qty." := SalesLineArchive."PTE UBG  Production Qty.";
                SalesLineArchive."PTE SOI Sales Price" := SalesLineArchive."PTE UBG  Sales Price";
                SalesLineArchive."PTE SOI Unchanged Reprint" := SalesLineArchive."PTE UBG  Unchanged Reprint";
                SalesLineArchive."PTE SOI Colors Back" := SalesLineArchive."PTE UBG  Colors Back";

                SalesLineArchive.Modify(false);
            until SalesLineArchive.Next() = 0;
    end;

    local procedure MoveTableDataPurchaseHeader()
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeader.Reset();
        if PurchaseHeader.IsEmpty() then
            exit;

        if PurchaseHeader.FindSet() then
            repeat
                PurchaseHeader."PTE SOI Coordinator" := PurchaseHeader."PTE UBG  Coordinator";
                PurchaseHeader."PTE SOI Control Qty Incl. VAT" := PurchaseHeader."PTE UBG  Cont Amount Incl. VAT";
                PurchaseHeader."PTE SOI Deadline" := PurchaseHeader."PTE UBG  Deadline";
                PurchaseHeader."PTE SOI Expected Receipt Time" := PurchaseHeader."PTE UBG  Expected Receipt Time";
                PurchaseHeader."PTE SOI Manual Responsible" := PurchaseHeader."PTE UBG  Manual Responsible";
                PurchaseHeader."PTE SOI P-Order Type" := PurchaseHeader."PTE UBG  P-Order Type";
                PurchaseHeader."PTE SOI Person Responsible" := PurchaseHeader."PTE UBG  Person Responsible";
                PurchaseHeader."PTE SOI Status" := PurchaseHeader."PTE UBG  Status";
                PurchaseHeader."PTE SOI Status Code" := PurchaseHeader."PTE UBG  Status Code";

                PurchaseHeader.Modify(false);
            until PurchaseHeader.Next() = 0;
    end;

    local procedure MoveTableDataPurchaseLine()
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.Reset();
        if PurchaseLine.IsEmpty() then
            exit;

        if PurchaseLine.FindSet() then
            repeat
                PurchaseLine."PTE SOI Colors Front" := PurchaseLine."PTE UBG  Colors Front";
                PurchaseLine."PTE SOI Format Code" := PurchaseLine."PTE UBG  Format Code";
                PurchaseLine."PTE SOI Page Unit" := PurchaseLine."PTE UBG  Page Unit";
                PurchaseLine."PTE SOI Pages" := PurchaseLine."PTE UBG  Pages";
                PurchaseLine."PTE SOI Paper" := PurchaseLine."PTE UBG  Paper";
                PurchaseLine."PTE SOI Production Order" := PurchaseLine."PTE UBG  Production Order";
                PurchaseLine."PTE SOI Unchanged Reprint" := PurchaseLine."PTE UBG  Unchanged Reprint";
                PurchaseLine."PTE SOI Colors Back" := PurchaseLine."PTE UBG  Colors Back";

                PurchaseLine.Modify(false);
            until PurchaseLine.Next() = 0;

    end;

    local procedure MoveTableDataPurchaseHeaderArchive()
    var
        PurchaseHeaderArchive: Record "Purchase Header Archive";
    begin
        PurchaseHeaderArchive.Reset();
        if PurchaseHeaderArchive.IsEmpty() then
            exit;

        if PurchaseHeaderArchive.FindSet() then
            repeat
                PurchaseHeaderArchive."PTE SOI Archived" := PurchaseHeaderArchive."PTE UBG  Archived";
                PurchaseHeaderArchive."PTE SOI Control Qty Incl. VAT" := PurchaseHeaderArchive."PTE UBG  Cont Amount Incl. VAT";
                PurchaseHeaderArchive."PTE SOI Coordinator" := PurchaseHeaderArchive."PTE UBG  Coordinator";
                PurchaseHeaderArchive."PTE SOI Deadline" := PurchaseHeaderArchive."PTE UBG  Deadline";
                PurchaseHeaderArchive."PTE SOI Expected Receipt Time" := PurchaseHeaderArchive."PTE UBG  Expected Receipt Time";
                PurchaseHeaderArchive."PTE SOI Manual Responsible" := PurchaseHeaderArchive."PTE UBG  Manual Responsible";
                PurchaseHeaderArchive."PTE SOI Order Type Code" := PurchaseHeaderArchive."PTE UBG  Order Type Code";
                PurchaseHeaderArchive."PTE SOI Person Responsible" := PurchaseHeaderArchive."PTE UBG  Person Responsible";
                PurchaseHeaderArchive."PTE SOI Status" := PurchaseHeaderArchive."PTE UBG  Status";
                PurchaseHeaderArchive."PTE SOI Status Code" := PurchaseHeaderArchive."PTE UBG  Status Code";

                PurchaseHeaderArchive.Modify(false);
            until PurchaseHeaderArchive.Next() = 0;

    end;

    local procedure MoveTableDataPurchaseLineArchive()
    var
        PurchaseLineArchive: Record "Purchase Line Archive";
    begin
        PurchaseLineArchive.Reset();
        if PurchaseLineArchive.IsEmpty() then
            exit;

        if PurchaseLineArchive.FindSet() then
            repeat
                PurchaseLineArchive."PTE SOI Colors Front" := PurchaseLineArchive."PTE UBG  Colors Front";
                PurchaseLineArchive."PTE SOI Format Code" := PurchaseLineArchive."PTE UBG  Format Code";
                PurchaseLineArchive."PTE SOI Page Unit" := PurchaseLineArchive."PTE UBG  Page Unit";
                PurchaseLineArchive."PTE SOI Pages" := PurchaseLineArchive."PTE UBG  Pages";
                PurchaseLineArchive."PTE SOI Paper" := PurchaseLineArchive."PTE UBG  Paper";
                PurchaseLineArchive."PTE SOI Production Order" := PurchaseLineArchive."PTE UBG  Production Order";
                PurchaseLineArchive."PTE SOI Unchanged Reprint" := PurchaseLineArchive."PTE UBG  Unchanged Reprint";
                PurchaseLineArchive."PTE SOI Colors Back" := PurchaseLineArchive."PTE UBG  Colors Back";
                PurchaseLineArchive."PTE SOI Expected Receipt Time" := PurchaseLineArchive."PTE UBG  Expected Receipt Time";

                PurchaseLineArchive.Modify(false);
            until PurchaseLineArchive.Next() = 0;

    end;

    local procedure MoveTableDataSalesHeader()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Reset();
        if SalesHeader.IsEmpty() then
            exit;

        if SalesHeader.FindSet() then
            repeat
                SalesHeader."PTE SOI Calc. Status" := SalesHeader."PTE UBG  Calc. Status";
                SalesHeader."PTE SOI Coordinator" := SalesHeader."PTE UBG  Coordinator";
                SalesHeader."PTE SOI Deadline" := SalesHeader."PTE UBG  Deadline";
                SalesHeader."PTE SOI Manual Responsible" := SalesHeader."PTE UBG  Manual Responsible";
                SalesHeader."PTE SOI Order Type Code" := SalesHeader."PTE UBG  Order Type Code";
                SalesHeader."PTE SOI Person Responsible" := SalesHeader."PTE UBG  Person Responsible";
                SalesHeader."PTE SOI Price Method" := SalesHeader."PTE UBG  Price Method";
                SalesHeader."PTE SOI Status Code" := SalesHeader."PTE UBG  Status Code";

                SalesHeader.Modify(false);
            until SalesHeader.Next() = 0;
    end;

    local procedure MoveTableDataSalesLine()
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Reset();
        if SalesLine.IsEmpty() then
            exit;

        if SalesLine.FindSet() then
            repeat
                SalesLine."PTE SOI Colors Front" := SalesLine."PTE UBG  Colors Front";
                SalesLine."PTE SOI Format Code" := SalesLine."PTE UBG  Format Code";
                SalesLine."PTE SOI Page Unit" := SalesLine."PTE UBG  Page Unit";
                SalesLine."PTE SOI Pages" := SalesLine."PTE UBG  Pages";
                SalesLine."PTE SOI Paper" := SalesLine."PTE UBG  Paper";
                SalesLine."PTE SOI Production Order" := SalesLine."PTE UBG  Production Order";
                SalesLine."PTE SOI Production Qty." := SalesLine."PTE UBG  Production Qty.";
                SalesLine."PTE SOI Sales Price" := SalesLine."PTE UBG  Sales Price";
                SalesLine."PTE SOI Unchanged Reprint" := SalesLine."PTE UBG  Unchanged Reprint";
                SalesLine."PTE SOI Colors Back" := SalesLine."PTE UBG  Colors Back";
                SalesLine."PTE SOI Qty. Order" := SalesLine."PTE UBG  Qty. Order";
                SalesLine."PTE SOI Unit" := SalesLine."PTE UBG  Unit";

                SalesLine.Modify(false);
            until SalesLine.Next() = 0;
    end;

    local procedure MoveTableDataSalesHeaderArchive()
    var
        SalesHeaderArchive: Record "Sales Header Archive";
    begin
        SalesHeaderArchive.Reset();
        if SalesHeaderArchive.IsEmpty() then
            exit;

        if SalesHeaderArchive.FindSet() then
            repeat
                SalesHeaderArchive."PTE SOI Calc. Status" := SalesHeaderArchive."PTE UBG  Calc. Status";
                SalesHeaderArchive."PTE SOI Coordinator" := SalesHeaderArchive."PTE UBG  Coordinator";
                SalesHeaderArchive."PTE SOI Deadline" := SalesHeaderArchive."PTE UBG  Deadline";
                SalesHeaderArchive."PTE SOI Manual Responsible" := SalesHeaderArchive."PTE UBG  Manual Responsible";
                SalesHeaderArchive."PTE SOI Order Type Code" := SalesHeaderArchive."PTE UBG  Order Type Code";
                SalesHeaderArchive."PTE SOI Person Responsible" := SalesHeaderArchive."PTE UBG  Person Responsible";
                SalesHeaderArchive."PTE SOI Price Method" := SalesHeaderArchive."PTE UBG  Price Method";
                SalesHeaderArchive."PTE SOI Status Code" := SalesHeaderArchive."PTE UBG  Status Code";
                SalesHeaderArchive."PTE SOI End User Contact" := SalesHeaderArchive."PTE UBG  End User Contact";
                SalesHeaderArchive."PTE SOI Reception" := SalesHeaderArchive."PTE UBG  Reception";
                SalesHeaderArchive."PTE SOI Rejection Code" := SalesHeaderArchive."PTE UBG  Rejection Code";
                SalesHeaderArchive."PTE SOI Customer Group Code" := SalesHeaderArchive."PTE UBG  Customer Group Code";

                SalesHeaderArchive.Modify(false);
            until SalesHeaderArchive.Next() = 0;
    end;
#if NOT CLEAN26
    local procedure MoveUserSetupFields()
    var
        PVSUserSetup: Record "PVS User Setup";
    begin
        PVSUserSetup.Reset();
        if PVSUserSetup.FindSet() then
            repeat
                PVSUserSetup."PTE SOI Case Management Start" := PVSUserSetup."Case Management Start";
            until PVSUserSetup.Next() = 0;
    end;
#endif
    local procedure MoveTableDataSPVSGeneralSetup()
    var
        PVSGeneralSetup: Record "PVS General Setup";
    begin
        PVSGeneralSetup.Reset();
        if PVSGeneralSetup.IsEmpty() then
            exit;

        if PVSGeneralSetup.FindSet() then
            repeat
                PVSGeneralSetup."PTE Sales Order Calc. Wait" := PVSGeneralSetup."Sales Order Calc. Wait";
                PVSGeneralSetup.Modify(false);
            until PVSGeneralSetup.Next() = 0;
    end;
}