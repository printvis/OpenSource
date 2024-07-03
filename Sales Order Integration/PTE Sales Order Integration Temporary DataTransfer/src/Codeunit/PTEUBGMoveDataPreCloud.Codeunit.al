codeunit 80108 "PTE UBG Move Data Pre Cloud"
{
    trigger OnRun()
    begin
        if IsSalesOrderIntegrationInstalled() then begin
            MoveTableDataSalesLineArchive();
            MoveTableDataPurchaseHeader();
            MoveTableDataPurchaseLine();
            MoveTableDataPurchaseHeaderArchive();
            MoveTableDataPurchaseLineArchive();
            MoveTableDataSalesHeader();
            MoveTableDataSalesLine();
            MoveTableDataSalesHeaderArchive()
        end;
    end;

    local procedure IsSalesOrderIntegrationInstalled(): Boolean
    begin
        if IsPrintVisSalesOrderIntegrationinstalled() then
            exit(true);
        if IsPTEPrintVisSalesOrderIntegrationinstalled() then
            exit(true);
    end;

    local procedure IsPrintVisSalesOrderIntegrationinstalled(): Boolean
    var
        ModuleInfo: ModuleInfo;
    begin
        if not NavApp.GetModuleInfo('40B0253D-910D-43DB-92CE-03682508A75E', ModuleInfo) then
            exit(IsPVSSalesOrderIntegrationInstalled);
        if ModuleInfo.Name <> 'PrintVis SalesOrder Integration' then
            exit(IsPVSSalesOrderIntegrationInstalled);
        if ModuleInfo.Publisher <> 'NovaVision Software A/S' then
            exit(IsPVSSalesOrderIntegrationInstalled);

        IsPVSSalesOrderIntegrationInstalled := true;
        exit(IsPVSSalesOrderIntegrationInstalled);
    end;

    local procedure IsPTEPrintVisSalesOrderIntegrationinstalled(): Boolean
    var
        ModuleInfo: ModuleInfo;
    begin
        if not NavApp.GetModuleInfo('073c8eda-9ed2-48c9-8cee-9d3d96af20f7', ModuleInfo) then
            exit(IsPTEPVSSalesOrderIntegrationinstalled);
        if ModuleInfo.Name <> 'PTE SalesOrder Integration' then
            exit(IsPTEPVSSalesOrderIntegrationinstalled);
        if ModuleInfo.Publisher <> 'NovaVision Software A/S' then
            exit(IsPTEPVSSalesOrderIntegrationinstalled);

        IsPTEPVSSalesOrderIntegrationinstalled := true;
        exit(IsPTEPVSSalesOrderIntegrationinstalled);
    end;

    var
        IsPVSSalesOrderIntegrationInstalled: Boolean;
        IsPTEPVSSalesOrderIntegrationinstalled: Boolean;

    local procedure MoveTableDataSalesLineArchive()
    var
        SalesLineArchive: Record "Sales Line Archive";
        recRef: RecordRef;
        fieldref: FieldRef;
    begin
        SalesLineArchive.Reset();
        if SalesLineArchive.IsEmpty then
            exit;
        if SalesLineArchive.FindSet() then
            repeat
                recref.GetTable(SalesLineArchive);
                if IsPVSSalesOrderIntegrationInstalled then begin
                    if recref.FieldExist(6010323) then begin
                        fieldref := recref.Field(6010323);
                        SalesLineArchive."PTE UBG  Colors Front" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010322) then begin
                        fieldref := recref.Field(6010322);
                        SalesLineArchive."PTE UBG  Format Code" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010320) then begin
                        fieldref := recref.Field(6010320);
                        SalesLineArchive."PTE UBG  Page Unit" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010321) then begin
                        fieldref := recref.Field(6010321);
                        SalesLineArchive."PTE UBG  Pages" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010325) then begin
                        fieldref := recref.Field(6010325);
                        SalesLineArchive."PTE UBG  Paper" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010318) then begin
                        fieldref := recref.Field(6010318);
                        SalesLineArchive."PTE UBG  Production Order" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010334) then begin
                        fieldref := recref.Field(6010334);
                        SalesLineArchive."PTE UBG  Production Qty." := fieldref.Value();
                    end;
                    if recref.FieldExist(6010317) then begin
                        fieldref := recref.Field(6010317);
                        SalesLineArchive."PTE UBG  Sales Price" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010326) then begin
                        fieldref := recref.Field(6010326);
                        SalesLineArchive."PTE UBG  Unchanged Reprint" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010324) then begin
                        fieldref := recref.Field(6010324);
                        SalesLineArchive."PTE UBG  Colors Back" := fieldref.Value();
                    end;
                end
                else if IsPTEPVSSalesOrderIntegrationinstalled then begin
                    if recref.FieldExist(75323) then begin
                        fieldref := recref.Field(75323);
                        SalesLineArchive."PTE UBG  Colors Front" := fieldref.Value();
                    end;
                    if recref.FieldExist(75322) then begin
                        fieldref := recref.Field(75322);
                        SalesLineArchive."PTE UBG  Format Code" := fieldref.Value();
                    end;
                    if recref.FieldExist(75320) then begin
                        fieldref := recref.Field(75320);
                        SalesLineArchive."PTE UBG  Page Unit" := fieldref.Value();
                    end;
                    if recref.FieldExist(75321) then begin
                        fieldref := recref.Field(75321);
                        SalesLineArchive."PTE UBG  Pages" := fieldref.Value();
                    end;
                    if recref.FieldExist(75325) then begin
                        fieldref := recref.Field(75325);
                        SalesLineArchive."PTE UBG  Paper" := fieldref.Value();
                    end;
                    if recref.FieldExist(75318) then begin
                        fieldref := recref.Field(75318);
                        SalesLineArchive."PTE UBG  Production Order" := fieldref.Value();
                    end;
                    if recref.FieldExist(75334) then begin
                        fieldref := recref.Field(75334);
                        SalesLineArchive."PTE UBG  Production Qty." := fieldref.Value();
                    end;
                    if recref.FieldExist(75317) then begin
                        fieldref := recref.Field(75317);
                        SalesLineArchive."PTE UBG  Sales Price" := fieldref.Value();
                    end;
                    if recref.FieldExist(75326) then begin
                        fieldref := recref.Field(75326);
                        SalesLineArchive."PTE UBG  Unchanged Reprint" := fieldref.Value();
                    end;
                    if recref.FieldExist(75324) then begin
                        fieldref := recref.Field(75324);
                        SalesLineArchive."PTE UBG  Colors Back" := fieldref.Value();
                    end;
                end;

                SalesLineArchive.Modify(false);
            until SalesLineArchive.Next() = 0;

    end;

    local procedure MoveTableDataPurchaseHeader()
    var
        PurchaseHeader: Record "Purchase Header";
        recRef: RecordRef;
        fieldref: FieldRef;
    begin
        PurchaseHeader.Reset();
        if PurchaseHeader.IsEmpty() then
            exit;
        if PurchaseHeader.FindSet() then
            repeat
                recref.GetTable(PurchaseHeader);

                if IsPVSSalesOrderIntegrationInstalled then begin
                    if recref.FieldExist(6010308) then begin
                        fieldref := recref.Field(6010308);
                        PurchaseHeader."PTE UBG  Coordinator" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010053) then begin
                        fieldref := recref.Field(6010053);
                        PurchaseHeader."PTE UBG  Cont Amount Incl. VAT" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010303) then begin
                        fieldref := recref.Field(6010303);
                        PurchaseHeader."PTE UBG  Deadline" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010312) then begin
                        fieldref := recref.Field(6010312);
                        PurchaseHeader."PTE UBG  Expected Receipt Time" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010306) then begin
                        fieldref := recref.Field(6010306);
                        PurchaseHeader."PTE UBG  Manual Responsible" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010300) then begin
                        fieldref := recref.Field(6010300);
                        PurchaseHeader."PTE UBG  P-Order Type" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010304) then begin
                        fieldref := recref.Field(6010304);
                        PurchaseHeader."PTE UBG  Person Responsible" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010054) then begin
                        fieldref := recref.Field(6010054);
                        PurchaseHeader."PTE UBG  Status" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010301) then begin
                        fieldref := recref.Field(6010301);
                        PurchaseHeader."PTE UBG  Status Code" := fieldref.Value();
                    end;
                end
                else if IsPTEPVSSalesOrderIntegrationinstalled then begin
                    if recref.FieldExist(75308) then begin
                        fieldref := recref.Field(75308);
                        PurchaseHeader."PTE UBG  Coordinator" := fieldref.Value();
                    end;
                    if recref.FieldExist(75053) then begin
                        fieldref := recref.Field(75053);
                        PurchaseHeader."PTE UBG  Cont Amount Incl. VAT" := fieldref.Value();
                    end;
                    if recref.FieldExist(75303) then begin
                        fieldref := recref.Field(75303);
                        PurchaseHeader."PTE UBG  Deadline" := fieldref.Value();
                    end;
                    if recref.FieldExist(75312) then begin
                        fieldref := recref.Field(75312);
                        PurchaseHeader."PTE UBG  Expected Receipt Time" := fieldref.Value();
                    end;
                    if recref.FieldExist(75306) then begin
                        fieldref := recref.Field(75306);
                        PurchaseHeader."PTE UBG  Manual Responsible" := fieldref.Value();
                    end;
                    if recref.FieldExist(75300) then begin
                        fieldref := recref.Field(75300);
                        PurchaseHeader."PTE UBG  P-Order Type" := fieldref.Value();
                    end;
                    if recref.FieldExist(75304) then begin
                        fieldref := recref.Field(75304);
                        PurchaseHeader."PTE UBG  Person Responsible" := fieldref.Value();
                    end;
                    if recref.FieldExist(75054) then begin
                        fieldref := recref.Field(75054);
                        PurchaseHeader."PTE UBG  Status" := fieldref.Value();
                    end;
                    if recref.FieldExist(75301) then begin
                        fieldref := recref.Field(75301);
                        PurchaseHeader."PTE UBG  Status Code" := fieldref.Value();
                    end;
                end;
                PurchaseHeader.Modify(false);
            until PurchaseHeader.Next() = 0;

    end;

    local procedure MoveTableDataPurchaseLine()
    var
        PurchaseLine: Record "Purchase Line";
        recRef: RecordRef;
        fieldref: FieldRef;
    begin
        PurchaseLine.Reset();
        if PurchaseLine.IsEmpty() then
            exit;
        if PurchaseLine.FindSet() then
            repeat
                recref.GetTable(PurchaseLine);
                if IsPVSSalesOrderIntegrationInstalled then begin
                    if recref.FieldExist(6010321) then begin
                        fieldref := recref.Field(6010321);
                        PurchaseLine."PTE UBG  Colors Front" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010320) then begin
                        fieldref := recref.Field(6010320);
                        PurchaseLine."PTE UBG  Format Code" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010318) then begin
                        fieldref := recref.Field(6010318);
                        PurchaseLine."PTE UBG  Page Unit" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010319) then begin
                        fieldref := recref.Field(6010319);
                        PurchaseLine."PTE UBG  Pages" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010323) then begin
                        fieldref := recref.Field(6010323);
                        PurchaseLine."PTE UBG  Paper" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010316) then begin
                        fieldref := recref.Field(6010316);
                        PurchaseLine."PTE UBG  Production Order" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010324) then begin
                        fieldref := recref.Field(6010324);
                        PurchaseLine."PTE UBG  Unchanged Reprint" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010322) then begin
                        fieldref := recref.Field(6010322);
                        PurchaseLine."PTE UBG  Colors Back" := fieldref.Value();
                    end;
                end
                else if IsPTEPVSSalesOrderIntegrationinstalled then begin
                    if recref.FieldExist(75321) then begin
                        fieldref := recref.Field(75321);
                        PurchaseLine."PTE UBG  Colors Front" := fieldref.Value();
                    end;
                    if recref.FieldExist(75320) then begin
                        fieldref := recref.Field(75320);
                        PurchaseLine."PTE UBG  Format Code" := fieldref.Value();
                    end;
                    if recref.FieldExist(75318) then begin
                        fieldref := recref.Field(75318);
                        PurchaseLine."PTE UBG  Page Unit" := fieldref.Value();
                    end;
                    if recref.FieldExist(75319) then begin
                        fieldref := recref.Field(75319);
                        PurchaseLine."PTE UBG  Pages" := fieldref.Value();
                    end;
                    if recref.FieldExist(75323) then begin
                        fieldref := recref.Field(75323);
                        PurchaseLine."PTE UBG  Paper" := fieldref.Value();
                    end;
                    if recref.FieldExist(75316) then begin
                        fieldref := recref.Field(75316);
                        PurchaseLine."PTE UBG  Production Order" := fieldref.Value();
                    end;
                    if recref.FieldExist(75324) then begin
                        fieldref := recref.Field(75324);
                        PurchaseLine."PTE UBG  Unchanged Reprint" := fieldref.Value();
                    end;
                    if recref.FieldExist(75322) then begin
                        fieldref := recref.Field(75322);
                        PurchaseLine."PTE UBG  Colors Back" := fieldref.Value();
                    end;
                end;
                PurchaseLine.Modify(false);
            until PurchaseLine.Next() = 0;

    end;

    local procedure MoveTableDataPurchaseHeaderArchive()
    var
        PurchaseHeaderArchive: Record "Purchase Header Archive";
        recRef: RecordRef;
        fieldref: FieldRef;
    begin
        PurchaseHeaderArchive.Reset();
        if PurchaseHeaderArchive.IsEmpty() then
            exit;
        if PurchaseHeaderArchive.FindSet() then
            repeat
                recref.GetTable(PurchaseHeaderArchive);
                if IsPVSSalesOrderIntegrationInstalled then begin

                    if recref.FieldExist(6010052) then begin
                        fieldref := recref.Field(6010052);
                        PurchaseHeaderArchive."PTE UBG  Archived" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010053) then begin
                        fieldref := recref.Field(6010053);
                        PurchaseHeaderArchive."PTE UBG  Cont Amount Incl. VAT" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010308) then begin
                        fieldref := recref.Field(6010308);
                        PurchaseHeaderArchive."PTE UBG  Coordinator" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010303) then begin
                        fieldref := recref.Field(6010303);
                        PurchaseHeaderArchive."PTE UBG  Deadline" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010312) then begin
                        fieldref := recref.Field(6010312);
                        PurchaseHeaderArchive."PTE UBG  Expected Receipt Time" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010306) then begin
                        fieldref := recref.Field(6010306);
                        PurchaseHeaderArchive."PTE UBG  Manual Responsible" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010300) then begin
                        fieldref := recref.Field(6010300);
                        PurchaseHeaderArchive."PTE UBG  Order Type Code" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010304) then begin
                        fieldref := recref.Field(6010304);
                        PurchaseHeaderArchive."PTE UBG  Person Responsible" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010054) then begin
                        fieldref := recref.Field(6010054);
                        PurchaseHeaderArchive."PTE UBG  Status" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010301) then begin
                        fieldref := recref.Field(6010301);
                        PurchaseHeaderArchive."PTE UBG  Status Code" := fieldref.Value();
                    end;
                end
                else if IsPTEPVSSalesOrderIntegrationinstalled then begin

                    if recref.FieldExist(75052) then begin
                        fieldref := recref.Field(75052);
                        PurchaseHeaderArchive."PTE UBG  Archived" := fieldref.Value();
                    end;
                    if recref.FieldExist(75053) then begin
                        fieldref := recref.Field(75053);
                        PurchaseHeaderArchive."PTE UBG  Cont Amount Incl. VAT" := fieldref.Value();
                    end;
                    if recref.FieldExist(75308) then begin
                        fieldref := recref.Field(75308);
                        PurchaseHeaderArchive."PTE UBG  Coordinator" := fieldref.Value();
                    end;
                    if recref.FieldExist(75303) then begin
                        fieldref := recref.Field(75303);
                        PurchaseHeaderArchive."PTE UBG  Deadline" := fieldref.Value();
                    end;
                    if recref.FieldExist(75312) then begin
                        fieldref := recref.Field(75312);
                        PurchaseHeaderArchive."PTE UBG  Expected Receipt Time" := fieldref.Value();
                    end;
                    if recref.FieldExist(75306) then begin
                        fieldref := recref.Field(75306);
                        PurchaseHeaderArchive."PTE UBG  Manual Responsible" := fieldref.Value();
                    end;
                    if recref.FieldExist(75300) then begin
                        fieldref := recref.Field(75300);
                        PurchaseHeaderArchive."PTE UBG  Order Type Code" := fieldref.Value();
                    end;
                    if recref.FieldExist(75304) then begin
                        fieldref := recref.Field(75304);
                        PurchaseHeaderArchive."PTE UBG  Person Responsible" := fieldref.Value();
                    end;
                    if recref.FieldExist(75054) then begin
                        fieldref := recref.Field(75054);
                        PurchaseHeaderArchive."PTE UBG  Status" := fieldref.Value();
                    end;
                    if recref.FieldExist(75301) then begin
                        fieldref := recref.Field(75301);
                        PurchaseHeaderArchive."PTE UBG  Status Code" := fieldref.Value();
                    end;
                end;
                PurchaseHeaderArchive.Modify(false);
            until PurchaseHeaderArchive.Next() = 0;

    end;

    local procedure MoveTableDataPurchaseLineArchive()
    var
        PurchaseLineArchive: Record "Purchase Line Archive";
        recRef: RecordRef;
        fieldref: FieldRef;
    begin
        PurchaseLineArchive.Reset();
        if PurchaseLineArchive.IsEmpty() then
            exit;
        if PurchaseLineArchive.FindSet() then
            repeat
                if IsPVSSalesOrderIntegrationInstalled then begin
                    recref.GetTable(PurchaseLineArchive);
                    if recref.FieldExist(6010321) then begin
                        fieldref := recref.Field(6010321);
                        PurchaseLineArchive."PTE UBG  Colors Front" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010320) then begin
                        fieldref := recref.Field(6010320);
                        PurchaseLineArchive."PTE UBG  Format Code" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010318) then begin
                        fieldref := recref.Field(6010318);
                        PurchaseLineArchive."PTE UBG  Page Unit" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010319) then begin
                        fieldref := recref.Field(6010319);
                        PurchaseLineArchive."PTE UBG  Pages" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010323) then begin
                        fieldref := recref.Field(6010323);
                        PurchaseLineArchive."PTE UBG  Paper" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010316) then begin
                        fieldref := recref.Field(6010316);
                        PurchaseLineArchive."PTE UBG  Production Order" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010324) then begin
                        fieldref := recref.Field(6010324);
                        PurchaseLineArchive."PTE UBG  Unchanged Reprint" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010322) then begin
                        fieldref := recref.Field(6010322);
                        PurchaseLineArchive."PTE UBG  Colors Back" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010328) then begin
                        fieldref := recref.Field(6010328);
                        PurchaseLineArchive."PTE UBG  Expected Receipt Time" := fieldref.Value();
                    end;
                end
                else if IsPTEPVSSalesOrderIntegrationinstalled then begin
                    recref.GetTable(PurchaseLineArchive);
                    if recref.FieldExist(75321) then begin
                        fieldref := recref.Field(75321);
                        PurchaseLineArchive."PTE UBG  Colors Front" := fieldref.Value();
                    end;
                    if recref.FieldExist(75320) then begin
                        fieldref := recref.Field(75320);
                        PurchaseLineArchive."PTE UBG  Format Code" := fieldref.Value();
                    end;
                    if recref.FieldExist(75318) then begin
                        fieldref := recref.Field(75318);
                        PurchaseLineArchive."PTE UBG  Page Unit" := fieldref.Value();
                    end;
                    if recref.FieldExist(75319) then begin
                        fieldref := recref.Field(75319);
                        PurchaseLineArchive."PTE UBG  Pages" := fieldref.Value();
                    end;
                    if recref.FieldExist(75323) then begin
                        fieldref := recref.Field(75323);
                        PurchaseLineArchive."PTE UBG  Paper" := fieldref.Value();
                    end;
                    if recref.FieldExist(75316) then begin
                        fieldref := recref.Field(75316);
                        PurchaseLineArchive."PTE UBG  Production Order" := fieldref.Value();
                    end;
                    if recref.FieldExist(75324) then begin
                        fieldref := recref.Field(75324);
                        PurchaseLineArchive."PTE UBG  Unchanged Reprint" := fieldref.Value();
                    end;
                    if recref.FieldExist(75322) then begin
                        fieldref := recref.Field(75322);
                        PurchaseLineArchive."PTE UBG  Colors Back" := fieldref.Value();
                    end;
                    if recref.FieldExist(75328) then begin
                        fieldref := recref.Field(75328);
                        PurchaseLineArchive."PTE UBG  Expected Receipt Time" := fieldref.Value();
                    end;
                end;
                PurchaseLineArchive.Modify(false);
            until PurchaseLineArchive.Next() = 0;

    end;

    local procedure MoveTableDataSalesHeader()
    var
        SalesHeader: Record "Sales Header";
        recRef: RecordRef;
        fieldref: FieldRef;
    begin
        SalesHeader.Reset();
        if SalesHeader.IsEmpty() then
            exit;

        if SalesHeader.FindSet() then
            repeat
                recref.GetTable(SalesHeader);
                if IsPVSSalesOrderIntegrationInstalled then begin

                    if recref.FieldExist(6010054) then begin
                        fieldref := recref.Field(6010054);
                        SalesHeader."PTE UBG  Calc. Status" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010312) then begin
                        fieldref := recref.Field(6010312);
                        SalesHeader."PTE UBG  Coordinator" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010307) then begin
                        fieldref := recref.Field(6010307);
                        SalesHeader."PTE UBG  Deadline" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010310) then begin
                        fieldref := recref.Field(6010310);
                        SalesHeader."PTE UBG  Manual Responsible" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010304) then begin
                        fieldref := recref.Field(6010304);
                        SalesHeader."PTE UBG  Order Type Code" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010308) then begin
                        fieldref := recref.Field(6010308);
                        SalesHeader."PTE UBG  Person Responsible" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010302) then begin
                        fieldref := recref.Field(6010302);
                        SalesHeader."PTE UBG  Price Method" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010305) then begin
                        fieldref := recref.Field(6010305);
                        SalesHeader."PTE UBG  Status Code" := fieldref.Value();
                    end;
                end
                else if IsPTEPVSSalesOrderIntegrationinstalled then begin

                    if recref.FieldExist(75054) then begin
                        fieldref := recref.Field(75054);
                        SalesHeader."PTE UBG  Calc. Status" := fieldref.Value();
                    end;
                    if recref.FieldExist(75312) then begin
                        fieldref := recref.Field(75312);
                        SalesHeader."PTE UBG  Coordinator" := fieldref.Value();
                    end;
                    if recref.FieldExist(75307) then begin
                        fieldref := recref.Field(75307);
                        SalesHeader."PTE UBG  Deadline" := fieldref.Value();
                    end;
                    if recref.FieldExist(75310) then begin
                        fieldref := recref.Field(75310);
                        SalesHeader."PTE UBG  Manual Responsible" := fieldref.Value();
                    end;
                    if recref.FieldExist(75304) then begin
                        fieldref := recref.Field(75304);
                        SalesHeader."PTE UBG  Order Type Code" := fieldref.Value();
                    end;
                    if recref.FieldExist(75308) then begin
                        fieldref := recref.Field(75308);
                        SalesHeader."PTE UBG  Person Responsible" := fieldref.Value();
                    end;
                    if recref.FieldExist(75302) then begin
                        fieldref := recref.Field(75302);
                        SalesHeader."PTE UBG  Price Method" := fieldref.Value();
                    end;
                    if recref.FieldExist(75305) then begin
                        fieldref := recref.Field(75305);
                        SalesHeader."PTE UBG  Status Code" := fieldref.Value();
                    end;
                end;
                SalesHeader.Modify(false);
            until SalesHeader.Next() = 0;

    end;

    local procedure MoveTableDataSalesLine()
    var
        SalesLine: Record "Sales Line";
        recRef: RecordRef;
        fieldref: FieldRef;
    begin
        SalesLine.Reset();
        if SalesLine.IsEmpty() then
            exit;
        if SalesLine.FindSet() then
            repeat
                recref.GetTable(SalesLine);
                if IsPVSSalesOrderIntegrationInstalled then begin

                    if recref.FieldExist(6010323) then begin
                        fieldref := recref.Field(6010323);
                        SalesLine."PTE UBG  Colors Front" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010322) then begin
                        fieldref := recref.Field(6010322);
                        SalesLine."PTE UBG  Format Code" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010320) then begin
                        fieldref := recref.Field(6010320);
                        SalesLine."PTE UBG  Page Unit" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010321) then begin
                        fieldref := recref.Field(6010321);
                        SalesLine."PTE UBG  Pages" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010325) then begin
                        fieldref := recref.Field(6010325);
                        SalesLine."PTE UBG  Paper" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010318) then begin
                        fieldref := recref.Field(6010318);
                        SalesLine."PTE UBG  Production Order" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010334) then begin
                        fieldref := recref.Field(6010334);
                        SalesLine."PTE UBG  Production Qty." := fieldref.Value();
                    end;
                    if recref.FieldExist(6010317) then begin
                        fieldref := recref.Field(6010317);
                        SalesLine."PTE UBG  Sales Price" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010326) then begin
                        fieldref := recref.Field(6010326);
                        SalesLine."PTE UBG  Unchanged Reprint" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010324) then begin
                        fieldref := recref.Field(6010324);
                        SalesLine."PTE UBG  Colors Back" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010315) then begin
                        fieldref := recref.Field(6010315);
                        SalesLine."PTE UBG  Qty. Order" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010316) then begin
                        fieldref := recref.Field(6010316);
                        SalesLine."PTE UBG  Unit" := fieldref.Value();
                    end;
                end
                else if IsPTEPVSSalesOrderIntegrationinstalled then begin

                    if recref.FieldExist(75323) then begin
                        fieldref := recref.Field(75323);
                        SalesLine."PTE UBG  Colors Front" := fieldref.Value();
                    end;
                    if recref.FieldExist(75322) then begin
                        fieldref := recref.Field(75322);
                        SalesLine."PTE UBG  Format Code" := fieldref.Value();
                    end;
                    if recref.FieldExist(75320) then begin
                        fieldref := recref.Field(75320);
                        SalesLine."PTE UBG  Page Unit" := fieldref.Value();
                    end;
                    if recref.FieldExist(75321) then begin
                        fieldref := recref.Field(75321);
                        SalesLine."PTE UBG  Pages" := fieldref.Value();
                    end;
                    if recref.FieldExist(75325) then begin
                        fieldref := recref.Field(75325);
                        SalesLine."PTE UBG  Paper" := fieldref.Value();
                    end;
                    if recref.FieldExist(75318) then begin
                        fieldref := recref.Field(75318);
                        SalesLine."PTE UBG  Production Order" := fieldref.Value();
                    end;
                    if recref.FieldExist(75334) then begin
                        fieldref := recref.Field(75334);
                        SalesLine."PTE UBG  Production Qty." := fieldref.Value();
                    end;
                    if recref.FieldExist(75317) then begin
                        fieldref := recref.Field(75317);
                        SalesLine."PTE UBG  Sales Price" := fieldref.Value();
                    end;
                    if recref.FieldExist(75326) then begin
                        fieldref := recref.Field(75326);
                        SalesLine."PTE UBG  Unchanged Reprint" := fieldref.Value();
                    end;
                    if recref.FieldExist(75324) then begin
                        fieldref := recref.Field(75324);
                        SalesLine."PTE UBG  Colors Back" := fieldref.Value();
                    end;
                    if recref.FieldExist(75315) then begin
                        fieldref := recref.Field(75315);
                        SalesLine."PTE UBG  Qty. Order" := fieldref.Value();
                    end;
                    if recref.FieldExist(75316) then begin
                        fieldref := recref.Field(75316);
                        SalesLine."PTE UBG  Unit" := fieldref.Value();
                    end;
                end;
                SalesLine.Modify(false);
            until SalesLine.Next() = 0;

    end;

    local procedure MoveTableDataSalesHeaderArchive()
    var
        SalesHeaderArchive: Record "Sales Header Archive";
        recRef: RecordRef;
        fieldref: FieldRef;
    begin
        SalesHeaderArchive.Reset();
        if SalesHeaderArchive.IsEmpty() then
            exit;

        if SalesHeaderArchive.FindSet() then
            repeat
                recref.GetTable(SalesHeaderArchive);
                if IsPVSSalesOrderIntegrationInstalled then begin

                    if recref.FieldExist(6010054) then begin
                        fieldref := recref.Field(6010054);
                        SalesHeaderArchive."PTE UBG  Calc. Status" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010312) then begin
                        fieldref := recref.Field(6010312);
                        SalesHeaderArchive."PTE UBG  Coordinator" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010307) then begin
                        fieldref := recref.Field(6010307);
                        SalesHeaderArchive."PTE UBG  Deadline" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010310) then begin
                        fieldref := recref.Field(6010310);
                        SalesHeaderArchive."PTE UBG  Manual Responsible" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010304) then begin
                        fieldref := recref.Field(6010304);
                        SalesHeaderArchive."PTE UBG  Order Type Code" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010308) then begin
                        fieldref := recref.Field(6010308);
                        SalesHeaderArchive."PTE UBG  Person Responsible" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010302) then begin
                        fieldref := recref.Field(6010302);
                        SalesHeaderArchive."PTE UBG  Price Method" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010305) then begin
                        fieldref := recref.Field(6010305);
                        SalesHeaderArchive."PTE UBG  Status Code" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010332) then begin
                        fieldref := recref.Field(6010332);
                        SalesHeaderArchive."PTE UBG  End User Contact" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010052) then begin
                        fieldref := recref.Field(6010052);
                        SalesHeaderArchive."PTE UBG  Reception" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010316) then begin
                        fieldref := recref.Field(6010316);
                        SalesHeaderArchive."PTE UBG  Rejection Code" := fieldref.Value();
                    end;
                    if recref.FieldExist(6010315) then begin
                        fieldref := recref.Field(6010315);
                        SalesHeaderArchive."PTE UBG  Customer Group Code" := fieldref.Value();
                    end;
                end
                else if IsPTEPVSSalesOrderIntegrationinstalled then begin

                    if recref.FieldExist(75054) then begin
                        fieldref := recref.Field(75054);
                        SalesHeaderArchive."PTE UBG  Calc. Status" := fieldref.Value();
                    end;
                    if recref.FieldExist(75312) then begin
                        fieldref := recref.Field(75312);
                        SalesHeaderArchive."PTE UBG  Coordinator" := fieldref.Value();
                    end;
                    if recref.FieldExist(75307) then begin
                        fieldref := recref.Field(75307);
                        SalesHeaderArchive."PTE UBG  Deadline" := fieldref.Value();
                    end;
                    if recref.FieldExist(75310) then begin
                        fieldref := recref.Field(75310);
                        SalesHeaderArchive."PTE UBG  Manual Responsible" := fieldref.Value();
                    end;
                    if recref.FieldExist(75304) then begin
                        fieldref := recref.Field(75304);
                        SalesHeaderArchive."PTE UBG  Order Type Code" := fieldref.Value();
                    end;
                    if recref.FieldExist(75308) then begin
                        fieldref := recref.Field(75308);
                        SalesHeaderArchive."PTE UBG  Person Responsible" := fieldref.Value();
                    end;
                    if recref.FieldExist(75302) then begin
                        fieldref := recref.Field(75302);
                        SalesHeaderArchive."PTE UBG  Price Method" := fieldref.Value();
                    end;
                    if recref.FieldExist(75305) then begin
                        fieldref := recref.Field(75305);
                        SalesHeaderArchive."PTE UBG  Status Code" := fieldref.Value();
                    end;
                    if recref.FieldExist(75332) then begin
                        fieldref := recref.Field(75332);
                        SalesHeaderArchive."PTE UBG  End User Contact" := fieldref.Value();
                    end;
                    if recref.FieldExist(75052) then begin
                        fieldref := recref.Field(75052);
                        SalesHeaderArchive."PTE UBG  Reception" := fieldref.Value();
                    end;
                    if recref.FieldExist(75316) then begin
                        fieldref := recref.Field(75316);
                        SalesHeaderArchive."PTE UBG  Rejection Code" := fieldref.Value();
                    end;
                    if recref.FieldExist(75315) then begin
                        fieldref := recref.Field(75315);
                        SalesHeaderArchive."PTE UBG  Customer Group Code" := fieldref.Value();
                    end;
                end;
                SalesHeaderArchive.Modify(false);
            until SalesHeaderArchive.Next() = 0;

    end;
}