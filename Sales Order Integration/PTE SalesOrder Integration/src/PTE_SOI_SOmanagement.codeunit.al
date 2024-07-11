Codeunit 80104 "PTE SOI S.O. Mgt"
{
    var
        SingleInstance: Codeunit "PVS SingleInstance";
        NAVmgt: Codeunit "PVS NAV API";
        PVmgt: Codeunit "PTE SOI SOint Prod Order Mgt";

    procedure SalesHead_Validate_StatusCode(var in_SH_Rec: Record "Sales Header"; var in_xSH_Rec: Record "Sales Header"; is_GUI_ACTIVE: Boolean)
    var
        SHloc: Record "Sales Header";
        StatusRec: Record "PVS Status Code";
        ok: Boolean;
        SalesQuote_To_Order: Boolean;
    begin
        SalesQuote_To_Order := false;
        if in_SH_Rec."PTE SOI Status Code" <> '' then begin
            // Manage New Status
            StatusRec.Get('', in_SH_Rec."PTE SOI Status Code");
            if StatusRec."Deadline Date Expression" <> '' then
                in_SH_Rec."PTE SOI Deadline" := CalcDate(StatusRec."Deadline Date Expression", Today());

            SalesHead_Get_Reponsible(in_SH_Rec);

            if (StatusRec.Status > 1) and (in_SH_Rec."Document Type" = in_SH_Rec."Document Type"::Quote) then begin
                SalesQuote_To_Order := true;
                SalesHead_Change_QuoteToOrder(in_SH_Rec);
            end;
        end;

        SalesHead_Change_Prod_Status(in_SH_Rec, is_GUI_ACTIVE);

        // Log
        if in_xSH_Rec."No." = '' then
            if SHloc.Get(in_SH_Rec."Document Type", in_SH_Rec."No.") then
                in_xSH_Rec."PTE SOI Status Code" := in_SH_Rec."PTE SOI Status Code";

        ok := in_SH_Rec.Modify();

        Commit();
        SalesHead_Force_Log(in_SH_Rec, in_xSH_Rec, 1);

        // Perform Custom Check Report - After Status Change
        if StatusRec."SH Check Report After" <> 0 then begin
            SHloc := in_SH_Rec;
            SHloc.SetRange("Document Type", in_SH_Rec."Document Type");
            SHloc.SetRange("No.", in_SH_Rec."No.");
            SHloc.SetRecfilter();
            Report.RunModal(StatusRec."SH Check Report After", false, false, SHloc);
            in_SH_Rec.Get(in_SH_Rec."Document Type", in_SH_Rec."No.");
        end;
    end;

    procedure SalesHead_OnLookUp_StatusCode(var in_Rec: Record "Sales Header")
    var
        StatusRec: Record "PVS Status Code";
    begin
        // Take the table relations in consideration
        if in_Rec."Document Type" = in_Rec."document type"::Quote then
            StatusRec.SetFilter(Status, '%1..', StatusRec.Status::Quote);
        if in_Rec."Document Type" = in_Rec."document type"::Order then
            StatusRec.SetFilter(Status, '%1..', StatusRec.Status::Order);
        StatusRec.SetRange(User, SingleInstance.Get_Current_Logical_Login_User());    // Show only statuscodes for this user
        if StatusRec.IsEmpty then begin
            StatusRec.SetRange(User, '');    // Show general statuscodes
            if StatusRec.Get('', in_Rec."PTE SOI Status Code") then;
        end else
            if StatusRec.Get(SingleInstance.Get_Current_Logical_Login_User(), in_Rec."PTE SOI Status Code") then;

        StatusRec.SetRange(Blocked, false);  // Show only not blocked

        if Page.RunModal(Page::"PVS Status Code List", StatusRec) = Action::LookupOK then
            in_Rec.Validate("PTE SOI Status Code", StatusRec.Code);
    end;

    procedure SalesHead_Change_QuoteToOrder(var in_SH_Rec: Record "Sales Header")
    var
        SH_OLD: Record "Sales Header";
        SalesQuotetoOrderYesNo: Codeunit "Sales-Quote to Order (Yes/No)";
        Sales_Quote_to_Order: Codeunit "Sales-Quote to Order";
        ok: Boolean;
    begin
        in_SH_Rec."Order Date" := Today();
        ok := in_SH_Rec.Modify();
        SH_OLD := in_SH_Rec;

        Commit();

        SalesQuotetoOrderYesNo.Run(in_SH_Rec);

        SingleInstance.Get_Global_SalesHeader(in_SH_Rec);
    end;

    procedure SalesHead_Change_Prod_Status(var in_SH_Rec: Record "Sales Header"; is_GUI_ACTIVE: Boolean)
    var
        SL: Record "Sales Line";
        P_OrderRec: Record "PVS Case";
        StatusRec: Record "PVS Status Code";
    begin
        if not StatusRec.Get('', in_SH_Rec."PTE SOI Status Code") then
            exit;

        SL.Reset();
        SL.SetRange("Document Type", in_SH_Rec."Document Type");
        SL.SetRange("Document No.", in_SH_Rec."No.");

        if SL.FindSet(false) then
            repeat
                if SL."PVS ID" <> 0 then
                    if P_OrderRec.Get(SL."PVS ID") then
                        if not P_OrderRec.Archived then begin
                            P_OrderRec."Sales Order Type" := in_SH_Rec."Document Type".AsInteger();
                            P_OrderRec."Sales Order No." := in_SH_Rec."No.";

                            if StatusRec."Prod eq. Sale" then begin
                                P_OrderRec.Status_Change(StatusRec.code, false, is_GUI_ACTIVE, true);
                                if in_SH_Rec.Get(in_SH_Rec."Document Type", in_SH_Rec."No.") then;
                            end;

                            P_OrderRec.Modify(true);
                        end;
            until SL.Next() = 0;
    end;

    procedure SalesHead_Validate_OrderType(var in_SH_Rec: Record "Sales Header")
    var
        OrderTypeRec: Record "PVS Order Type";
    begin
        if OrderTypeRec.Get(in_SH_Rec."PTE SOI Order Type Code") then
            if OrderTypeRec."Status Code" <> '' then
                in_SH_Rec.Validate("PTE SOI Status Code", OrderTypeRec."Status Code");
    end;


    procedure SalesHead_Validate_ShipDate(var in_Rec: Record "Sales Header"; in_xRec: Record "Sales Header")
    var
        SL: Record "Sales Line";
    begin
        SL.Reset();
        SL.SetRange("Document Type", in_Rec."Document Type");
        SL.SetRange("Document No.", in_Rec."No.");

        if SL.FindSet(false) then
            repeat
                if SL."PTE SOI Production Order" then
                    PVmgt.SalesLine_Insert_PrintVis(SL);
            until SL.Next() = 0;
    end;

    procedure SalesHead_Get_Reponsible(var in_SH_Rec: Record "Sales Header")
    var
        NTR: Codeunit "PVS ML Text Resource";
        CustomerRec: Record Customer;
        ResponsibityRec: Record "PVS Status Responsiblity Area";
        New_Responsible: Code[100];
        ok: Boolean;
    begin
        New_Responsible := '';
        Clear(CustomerRec);
        ok := CustomerRec.Get(in_SH_Rec."Sell-to Customer No.");

        ResponsibityRec.SetFilter(Status, '%1|%2', in_SH_Rec."PTE SOI Status Code", '');
        ResponsibityRec.SetFilter("Order Type", '%1|%2', in_SH_Rec."PTE SOI Order Type Code", '');
        ResponsibityRec.SetFilter("Customer Group", '%1|%2', CustomerRec."PVS Customer Group Code", '');
        ResponsibityRec.SetFilter("Sell-To No.", '%1|%2', in_SH_Rec."Sell-to Customer No.", '');
        ResponsibityRec.SetFilter("From Date", '..%1', Today());
        ResponsibityRec.SetFilter("To Date", '%1..|%2', Today(), 0D);

        if ResponsibityRec.FindLast() then
            case ResponsibityRec.Responsible of
                0:
                    New_Responsible := ResponsibityRec."Responsible Code";
                1:
                    New_Responsible := SingleInstance.Get_Current_Logical_Login_User();
                2:
                    New_Responsible := in_SH_Rec."Salesperson Code";
                3:
                    New_Responsible := in_SH_Rec."PTE SOI Coordinator";
            end;

        if New_Responsible = '' then
            if in_SH_Rec."PTE SOI Coordinator" <> '' then
                New_Responsible := in_SH_Rec."PTE SOI Coordinator"
            else
                if in_SH_Rec."Salesperson Code" <> '' then
                    New_Responsible := in_SH_Rec."Salesperson Code"
                else
                    New_Responsible := SingleInstance.Get_Current_Logical_Login_User();

        case in_SH_Rec."PTE SOI Manual Responsible" of
            true:
                begin
                    if New_Responsible <> in_SH_Rec."PTE SOI Person Responsible" then
                        NTR.Message3(1030, in_SH_Rec."PTE SOI Person Responsible", New_Responsible, '');
                    in_SH_Rec."PTE SOI Manual Responsible" := false;
                end;
        end;
        in_SH_Rec."PTE SOI Person Responsible" := New_Responsible;
        in_SH_Rec.CalcFields("PTE SOI Person Respon. Name");
    end;

    procedure SalesHead_Change_Next_Status(in_SH_Rec: Record "Sales Header"; in_Is_Confirm: Boolean)
    var
        NTR: Codeunit "PVS ML Text Resource";
        StatusRec: Record "PVS Status Code";
        New_Status: Code[20];
    begin
        New_Status :=
          StatusRec.Get_Next_Status(0,
            in_SH_Rec."PTE SOI Status Code",
            in_SH_Rec."PTE SOI Order Type Code",
            in_SH_Rec."PVS Customer Group Code",
            in_SH_Rec."Sell-to Customer No.");
        if New_Status = '' then
            exit;

        if in_Is_Confirm then begin
            if NTR.Confirm3(1036, New_Status, '', '') then
                in_SH_Rec.Validate("PTE SOI Status Code", New_Status);
        end else
            in_SH_Rec.Validate("PTE SOI Status Code", New_Status);
    end;

    procedure SalesHead_Force_Log(var in_Rec: Record "Sales Header"; var in_xRec: Record "Sales Header"; in_Action: Option Insert,Modify,Delete)
    var
        LogManagement: Codeunit "PVS Change Log Management";
        RecRef: RecordRef;
        xRecRef: RecordRef;
    begin
        RecRef.GetTable(in_Rec);
        xRecRef.GetTable(in_xRec);
        LogManagement.Force_Log(RecRef, xRecRef, in_Action);
    end;

    procedure SalesHead_Get_Next_StatusTxt(in_Rec: Record "Sales Header"): Text[250]
    var
        StatusRec: Record "PVS Status Code";
    begin
        exit(
          StatusRec.Get_Next_Status(in_Rec."PVS Order ID",
          in_Rec."PTE SOI Status Code",
          in_Rec."PTE SOI Order Type Code",
          in_Rec."PVS Customer Group Code",
          in_Rec."Sell-to Customer No."));
    end;


    procedure SalesHead_Has_PurchaseOrdreNo(in_SH: Record "Sales Header"): Boolean
    var
        SL: Record "Sales Line";
        PL: Record "Purchase Line";
    begin
        SL.Reset();
        SL.SetRange("Document Type", in_SH."Document Type");
        SL.SetRange("Document No.", in_SH."No.");

        if SL.FindSet(false) then
            repeat
                if SL.Type = sl.Type::Item then begin // Item
                    PL.SetCurrentkey("Sales Order No.", "Sales Order Line No.");
                    PL.SetRange("Sales Order No.", SL."Document No.");
                    PL.SetRange("Sales Order Line No.", SL."Line No.");
                    if PL.FindFirst() then
                        exit(true);
                end;
            until SL.Next() = 0;

        exit(false);
    end;

    procedure SalesHead_Get_ProductionOrderN(in_SH: Record "Sales Header"): Text[1024]
    var
        SaleslineRec: Record "Sales Line";
        OrderRec: Record "PVS Case";
        OrderRec_Temp: Record "PVS Case" temporary;
        Txt: Text[1024];
    begin
        SaleslineRec.SetRange("Document Type", in_SH."Document Type");
        SaleslineRec.SetRange("Document No.", in_SH."No.");

        if not SaleslineRec.FindSet(false) then
            exit('');

        repeat
            if SaleslineRec."PVS ID" <> 0 then
                if OrderRec.Get(SaleslineRec."PVS ID") then begin
                    OrderRec_Temp := OrderRec;
                    if OrderRec_Temp.Insert() then
                        Txt := CopyStr(Txt + ' ' + OrderRec."Order No.", 1, MaxStrLen(Txt));
                end;
        until SaleslineRec.Next() = 0;

        exit(Txt);
    end;

    procedure SalesLine_OnModify(var In_Rec: Record "Sales Line"; var In_xRec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        PVSCase: Record "PVS Case";
    begin
        if not SalesHeader.Get(In_Rec."Document Type", In_Rec."Document No.") then
            exit;

        if In_Rec."PVS ID" = 0 then
            In_Rec."PVS ID" := SalesHeader."PVS Order ID";

        if (In_Rec."PVS ID" <> 0) and (In_Rec."PVS ID" <> In_xRec."PVS ID") then
            if PVSCase.Get(In_Rec."PVS ID") then
                In_Rec."PVS Product Group Code" := PVSCase."Product Group";

        if In_Rec."PVS ID" <> 0 then
            PVmgt.Update_PrintVis_Description(In_Rec);

        if (In_Rec."PVS ID" = 0) and (In_Rec."Sell-to Customer No." <> '') then
            exit;

        if In_Rec."Sell-to Customer No." = '' then
            In_Rec."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";

        if SalesHeader."Document Type" in [SalesHeader."document type"::Invoice, SalesHeader."document type"::"Credit Memo"] then
            if (SalesHeader."PVS Order ID" = 0) and (In_Rec."PVS ID" <> 0) then begin
                SalesHeader."PVS Order ID" := In_Rec."PVS ID";
                SalesHeader.Modify();
            end;
    end;

    procedure SalesLine_OnDelete(var in_SL_Rec: Record "Sales Line")
    begin
        if (in_SL_Rec.Type = in_SL_Rec.Type::" ") and (in_SL_Rec."PTE SOI Sales Price" <> 0) then
            in_SL_Rec."PTE SOI Sales Price" := 0;
    end;

    procedure SalesLine_Validate_ProductGrp(var in_Rec: Record "Sales Line"; in_xRec: Record "Sales Line")
    begin
        PVmgt.SalesLine_Insert_PrintVis(in_Rec);
    end;

    procedure SalesLine_Validate_Unchanged(var in_Rec: Record "Sales Line"; in_xRec: Record "Sales Line")
    begin
        PVmgt.SalesLine_Insert_PrintVis(in_Rec);
    end;

    procedure SalesLine_Validate_Quantity(var in_SL_Rec: Record "Sales Line"; in_xRec: Record "Sales Line")
    var
        ItemRec: Record Item;
        BeforeRec: Record "Sales Line";
        CustomerInventoryRec: Record "Sales Line";
        SetupRec: Record "PVS General Setup";
        ItemMgt: Codeunit "PVS Item Management";
        Dec1: Decimal;
        Dec2: Decimal;
        Dec3: Decimal;
        Dec4: Decimal;
    begin
        if in_SL_Rec."Shipment Line No." <> 0 then
            exit;

        SingleInstance.Get_SetupRec(SetupRec);

        if not SetupRec.is_PrintingCompany() then
            exit;

        BeforeRec := in_SL_Rec;

        // Perform PrintVis Pricelist LookUp
        if in_SL_Rec.Type = in_SL_Rec.Type::Item then
            if ItemRec.Get(in_SL_Rec."No.") then
                if ItemMgt.Find_PrintVis_Pricelist_Price(ItemRec,
                     in_SL_Rec."Sell-to Customer No.",
                     '',
                     in_SL_Rec."PVS Product Group Code",
                     Abs(in_SL_Rec.Quantity * in_SL_Rec."Qty. per Unit of Measure"),
                     Dec1, Dec2, Dec3, Dec4)
                then begin

                    if in_SL_Rec."Qty. per Unit of Measure" <> 0 then
                        Dec2 := Dec2 * in_SL_Rec."Qty. per Unit of Measure";

                    if Dec2 <> 0 then
                        in_SL_Rec.Validate("Unit Price", Dec2);
                end;

        if in_SL_Rec."PTE SOI Production Order" then
            if in_SL_Rec."PTE SOI Production Qty." = 0 then
                in_SL_Rec."PTE SOI Production Qty." := Round(in_SL_Rec."Quantity (Base)", 1);

        if in_SL_Rec."PTE SOI Production Order" and
           (in_SL_Rec."PVS ID" <> 0) and
           (in_SL_Rec."PVS Job" <> 0)
        then
            PVmgt.SalesLine_Insert_PrintVis(in_SL_Rec); // moved from form

        if in_SL_Rec."Line No." = 0 then
            exit;
    end;

    procedure SalesLine_Validate_Unit_Price(var in_Rec: Record "Sales Line"; var in_xRec: Record "Sales Line")
    begin
        case in_Rec."PTE SOI Unit" of // Pcs,1000 Pcs
            0:
                in_Rec."PTE SOI Sales Price" := in_Rec."Unit Price";
            1:
                in_Rec."PTE SOI Sales Price" := in_Rec."Unit Price" * 1000;
        end;

    end;

    procedure SalesLine_Validate_Colors(var in_SL_Rec: Record "Sales Line")
    var
        Text029: label 'You cannot place print on the back when an even number of pages has been entered';
    begin
        if (in_SL_Rec."PTE SOI Colors Front" <> 0) and (in_SL_Rec."PTE SOI Colors Back" <> 0) then
            if in_SL_Rec."PTE SOI Pages" MOD 2 <> 0 then
                Error(Text029);
    end;

    procedure SalesLine_Validate_Format(var in_Rec: Record "Sales Line")
    begin
        PVmgt.SalesLine_Insert_PrintVis(in_Rec);
    end;

    procedure SalesLine_Validate_Pages(var in_Rec: Record "Sales Line")
    begin
        PVmgt.SalesLine_Insert_PrintVis(in_Rec);
    end;

    procedure SalesLine_Validate_Paper(var in_Rec: Record "Sales Line")
    begin
        PVmgt.SalesLine_Insert_PrintVis(in_Rec);
    end;

    procedure SalesLine_Validate_PVS_Quantity(var in_SL_Rec: Record "Sales Line")
    begin
        if in_SL_Rec.Type <> in_SL_Rec.Type::" " then
            in_SL_Rec.Validate(Quantity, in_SL_Rec."PTE SOI Qty. Order");
    end;


    procedure SalesLine_Validate_PVS_Price(var in_SL_Rec: Record "Sales Line")
    var
        GB: Decimal;
    begin
        if in_SL_Rec.Type <> in_SL_Rec.Type::" " then begin

            if in_SL_Rec."No." <> '' then
                case in_SL_Rec."PTE SOI Unit" of // pcs,1000 pcs
                    0:
                        in_SL_Rec.Validate("Unit Price", in_SL_Rec."PTE SOI Sales Price");
                    1:
                        in_SL_Rec.Validate("Unit Price", in_SL_Rec."PTE SOI Sales Price" / 1000);
                end;
        end;
    end;

    procedure SalesLine_Validate_ProdOrder(var in_SL_Rec: Record "Sales Line"; var in_xSL_Rec: Record "Sales Line")
    var
        ItemRec: Record Item;
        SalesHeaderRec: Record "Sales Header";
        SetupRec: Record "PVS General Setup";
        CurrentGUINotAllowed: Boolean;
    begin
        if in_SL_Rec."PTE SOI Production Order" then begin
            if in_SL_Rec."PTE SOI Production Qty." = 0 then
                in_SL_Rec."PTE SOI Production Qty." := Round(in_SL_Rec."Quantity (Base)", 1);
        end else
            in_SL_Rec."PTE SOI Production Qty." := 0;

        if in_SL_Rec."PTE SOI Production Order" then begin
            CurrentGUINotAllowed := SingleInstance.Get_GUINOTALLOWED();
            SingleInstance.Set_GUINOTALLOWED(true);
            PVmgt.SalesLine_Insert_PrintVis(in_SL_Rec);
            SingleInstance.Set_GUINOTALLOWED(CurrentGUINotAllowed);
        end else
            if in_SL_Rec."PVS ID" <> 0 then
                PVmgt.Delete_PrintVis_SalesLine(in_SL_Rec);

        if in_SL_Rec."PTE SOI Production Order" then begin
            if SalesHeaderRec.Get(in_SL_Rec."Document Type", in_SL_Rec."Document No.") then;

            SingleInstance.Get_SetupRec(SetupRec);
            OnBeforePopupPageFromSalesline(in_SL_Rec);

            case SetupRec."Popup Page From Sales Line" of
                SetupRec."popup page from sales line"::Always:
                    begin
                        Commit();
                        Salesline_Call_Form_Order(in_SL_Rec);
                    end;
                SetupRec."popup page from sales line"::"If no template":
                    if ItemRec.Get(in_SL_Rec."No.") then
                        if ItemRec."PVS Template Job" = 0 then begin
                            Commit();
                            Salesline_Call_Form_Order(in_SL_Rec);
                        end;
            end;
        end;
    end;

    procedure Salesline_Call_Form_Order(var in_Rec: Record "Sales Line")
    var
        SetupRec: Record "PVS General Setup";
        OrderRec: Record "PVS Case";
        JobRec: Record "PVS Job";
    begin
        if in_Rec."PVS ID" = 0 then
            exit;

        if not in_Rec."PTE SOI Production Order" then
            exit;

        OrderRec.Get(in_Rec."PVS ID");

        OrderRec.SetRange(ID, in_Rec."PVS ID");
        if OrderRec.FindSet() then;

        SingleInstance.Get_SetupRec(SetupRec);

        case SetupRec."Production Page" of
            SetupRec."production page"::"Case Card":
                Page.RunModal(Page::"PVS Case Card", OrderRec);
            SetupRec."production page"::"Job Card":
                begin
                    if not JobRec.Get(in_Rec."PVS ID", in_Rec."PVS Job", NAVmgt.Current_JobVersion(in_Rec."PVS ID", in_Rec."PVS Job")) then
                        exit;
                    Page.RunModal(Page::"PVS Job Card", JobRec);
                end;
            SetupRec."production page"::"Quick Quote":
                Page.RunModal(Page::"PVS Quick Case Card", OrderRec);
        end;

        if not JobRec.Get(in_Rec."PVS ID", in_Rec."PVS Job", NAVmgt.Current_JobVersion(in_Rec."PVS ID", in_Rec."PVS Job")) then
            exit;

        PVmgt.Calculate_UnitPrices(in_Rec, JobRec);
        in_Rec.Get(in_Rec."Document Type", in_Rec."Document No.", in_Rec."Line No.");
    end;

    procedure Salesline_Call_Form_Job(var in_Rec: Record "Sales Line")
    var
        JobRec: Record "PVS Job";
    begin
        if in_Rec."PVS ID" = 0 then
            exit;

        if not in_Rec."PTE SOI Production Order" then
            exit;

        if not JobRec.Get(in_Rec."PVS ID", in_Rec."PVS Job", NAVmgt.Current_JobVersion(in_Rec."PVS ID", in_Rec."PVS Job")) then
            exit;

        JobRec.SetRange(ID, JobRec.ID);
        JobRec.SetRange(Job, JobRec.Job);

        Page.RunModal(Page::"PVS Job Card", JobRec);

        if not JobRec.Get(in_Rec."PVS ID", in_Rec."PVS Job", NAVmgt.Current_JobVersion(in_Rec."PVS ID", in_Rec."PVS Job")) then
            exit;

        PVmgt.Calculate_UnitPrices(in_Rec, JobRec);
        in_Rec.Get(in_Rec."Document Type", in_Rec."Document No.", in_Rec."Line No.");
    end;

    procedure Salesline_Call_Form_Est(var in_Rec: Record "Sales Line")
    var
        JobRec: Record "PVS Job";
        Job_CalcUnit_Rec: Record "PVS Job Calculation Unit";
    begin
        if in_Rec."PVS ID" = 0 then
            exit;

        if not in_Rec."PTE SOI Production Order" then
            exit;

        if not JobRec.Get(in_Rec."PVS ID", in_Rec."PVS Job", NAVmgt.Current_JobVersion(in_Rec."PVS ID", in_Rec."PVS Job")) then
            exit;

        Job_CalcUnit_Rec.Reset();
        Job_CalcUnit_Rec.SetRange(ID, JobRec.ID);
        Job_CalcUnit_Rec.SetRange(Job, JobRec.Job);
        Job_CalcUnit_Rec.SetRange(Version, JobRec.Version);

        Page.RunModal(Page::"PVS Job Calculation Unit 1", Job_CalcUnit_Rec);

        if not JobRec.Get(in_Rec."PVS ID", in_Rec."PVS Job", NAVmgt.Current_JobVersion(in_Rec."PVS ID", in_Rec."PVS Job")) then
            exit;

        PVmgt.Calculate_UnitPrices(in_Rec, JobRec);
        in_Rec.Get(in_Rec."Document Type", in_Rec."Document No.", in_Rec."Line No.");
    end;

    procedure Salesline_Call_Form_Milestones(in_Rec: Record "Sales Line")
    var
        JobRec: Record "PVS Job";
        PlanUnitRec: Record "PVS Job Planning Unit";
    begin
        if in_Rec."PVS ID" = 0 then
            exit;

        if not JobRec.Get(in_Rec."PVS ID", in_Rec."PVS Job", in_Rec."PVS ID 3") then
            exit;

        PlanUnitRec.SetRange(ID, in_Rec."PVS ID");
        PlanUnitRec.SetRange(Job, in_Rec."PVS Job");

        Page.RunModal(Page::"PVS Job Milestones", PlanUnitRec);
    end;

    procedure Salesline_Call_Form_Planning(in_Rec: Record "Sales Line")
    var
        JobRec: Record "PVS Job";
        PlanUnitRec: Record "PVS Job Planning Unit";
    begin
        if in_Rec."PVS ID" = 0 then
            exit;

        if not JobRec.Get(in_Rec."PVS ID", in_Rec."PVS Job", in_Rec."PVS ID 3") then
            exit;

        PlanUnitRec.SetRange(ID, in_Rec."PVS ID");
        PlanUnitRec.SetRange(Job, in_Rec."PVS Job");

        Page.RunModal(Page::"PVS Job Planning", PlanUnitRec);
    end;

    procedure Salesline_Get_JobCosting_Total(var in_Rec: Record "Sales Line"): Decimal
    begin
        if in_Rec."PVS ID" = 0 then
            exit(0);

        in_Rec.CalcFields("PTE SOI Job Cost. Dir. C. H.",
          "PTE SOI Job Cost. Dir. C. Mat.",
          "PTE SOI Job Cost. Dir. C. P.",
          "PTE SOI Job Cost. Mat. C. P.",
          "PTE SOI Job Cost. External P.");

        exit(in_Rec."PTE SOI Job Cost. Dir. C. H." +
          in_Rec."PTE SOI Job Cost. Dir. C. Mat." +
          in_Rec."PTE SOI Job Cost. Mat. C. P." +
          in_Rec."PTE SOI Job Cost. External P.");
    end;

    procedure Salesline_LookUp_Comments(var in_Rec: Record "Sales Line")
    var
        PageMgt: Codeunit "PVS Page Management";
        JobRec: Record "PVS Job";
    begin
        if in_Rec."PVS ID" = 0 then
            exit;

        if not JobRec.Get(in_Rec."PVS ID", 1, NAVmgt.Current_JobVersion(in_Rec."PVS ID", in_Rec."PVS Job")) then
            exit;

        PageMgt.Call_Page_Job_Comments(in_Rec."PVS ID", 1, JobRec.Version);
    end;

    procedure Salesline_CopyProductionOrder(var in_SL: Record "Sales Line")
    var
        SH: Record "Sales Header";
        OrderRec: Record "PVS Case";
        From_JobRec: Record "PVS Job";
        JobCopyRec: Record "PVS Job";
        JobRec: Record "PVS Job";
        JobRecTMP: Record "PVS Job" temporary;
        ProductRec: Record "PVS Intent Product";
        CopyMgt: Codeunit "PVS Copy Management";
    begin
        if not SH.Get(in_SL."Document Type", in_SL."Document No.") then
            exit;

        if in_SL."Line No." = 0 then begin
            in_SL.Init();
            in_SL."Line No." := 10000;
            in_SL.Validate(Type, 2);
            if not in_SL.Insert(true) then
                exit;
            Commit();
        end;

        if SH."Sell-to Customer No." <> '' then
            JobCopyRec.SetRange("Sell-To No.", SH."Sell-to Customer No.");

        if Page.RunModal(Page::"PVS Search Customer/Job", JobCopyRec) <> Action::LookupOK then
            exit;

        SingleInstance.Get_Current_JobRecTMP(JobRecTMP);

        if JobRecTMP.FindFirst() then
            if From_JobRec.Get(JobRecTMP.ID, JobRecTMP.Job, JobRecTMP.Version) then begin
                if in_SL."PTE SOI Production Order" and (in_SL."PVS ID" <> 0) then begin
                    if in_SL."PVS Job" <> 0 then begin
                        // Bliver den automatisk deaktiveret
                    end;

                    OrderRec.Get(in_SL."PVS ID");

                end else begin
                    in_SL."PTE SOI Production Order" := true;
                    in_SL."PVS Product Group Code" := From_JobRec."Product Group";
                    PVmgt."Find/Insert_P-Order"(in_SL, SH, OrderRec);
                end;

                CopyMgt.Main_Copy_Job_To_Order(OrderRec, From_JobRec, true, false);
                JobRec.Reset();
                JobRec.SetRange(ID, OrderRec.ID);
                if not JobRec.FindLast() then
                    exit;

                // Item No.
                if in_SL.Type = in_SL.Type::Item then
                    if in_SL."No." = '' then begin
                        if JobRec."Item No." <> '' then
                            in_SL.Validate("No.", JobRec."Item No.");
                    end else
                        JobRec."Item No." := in_SL."No.";
                if in_SL."Item Reference No." <> '' then
                    JobRec."Cross Reference No." := in_SL."Item Reference No.";

                // Quantity
                if (in_SL.Quantity <= 1) and (From_JobRec.Quantity <> 0) then begin
                    if in_SL."Qty. per Unit of Measure" = 0 then
                        in_SL."Qty. per Unit of Measure" := 1;

                    in_SL.Validate(Quantity, From_JobRec.Quantity / in_SL."Qty. per Unit of Measure");
                end;

                // Shipment
                if Dt2Date(JobRec."Requested Delivery DateTime") <> in_SL."Shipment Date" then
                    JobRec.Validate("Requested Delivery DateTime", CreateDatetime(in_SL."Shipment Date", 120000T));

                JobRec."Job Name" := From_JobRec."Job Name";

                // ID - production order
                in_SL."PVS ID" := JobRec.ID;
                in_SL."PVS Job" := JobRec.Job;
                in_SL."PTE SOI Production Order" := true;

                // Redundant
                in_SL."Item Reference No." := JobRec."Cross Reference No.";
                in_SL."PVS Product Group Code" := JobRec."Product Group";
                in_SL.Description := CopyStr(JobRec."Job Name", 1, MaxStrLen(in_SL.Description));
                in_SL."PTE SOI Pages" := JobRec.Pages;
                in_SL."PTE SOI Format Code" := JobRec."Format Code";
                in_SL."PTE SOI Colors Front" := JobRec."Colors Front";
                in_SL."PTE SOI Colors Back" := JobRec."Colors Back";
                in_SL."PTE SOI Paper" := JobRec.Paper;
                in_SL."PTE SOI Unchanged Reprint" := JobRec."Unchanged Rerun";
                in_SL."PTE SOI Production Qty." := JobRec.Quantity;

                // Update() intent
                ProductRec.SetCurrentkey(ID, Job, Version);
                ProductRec.SetRange(ID, JobRec.ID);
                ProductRec.SetRange(Job, JobRec.Job);
                ProductRec.SetRange(Version, JobRec.Version);
                if ProductRec.FindFirst() then begin
                    ProductRec."Finished Goods Item No." := JobRec."Item No.";
                    ProductRec.Quantity := in_SL."Quantity (Base)";
                    ProductRec.Modify();
                end;

                in_SL.Modify(true);

                if in_SL."Quantity (Base)" <> JobRec.Quantity then begin
                    JobRec.Validate(Quantity, in_SL."Quantity (Base)");
                    JobRec.Validate(Quantity, in_SL."Quantity (Base)");
                end;
                JobRec.Modify(true);
                PVmgt.Calculate_UnitPrices(in_SL, JobRec);
            end;
    end;

    procedure Get_Page_Comments_Salesorder(var SH: Record "Sales Header"): Text[250]
    var
        BrugerRec: Record "PVS User Setup";
        TextRec: Record "PVS Job Text Description";
    begin
        if not BrugerRec.Get(SingleInstance.Get_Current_Logical_Login_User()) then
            exit('');
        TextRec.SetRange(Type, 7); // Bemærkning til ansvarsområde
        TextRec.SetRange("Table ID", 36);
        TextRec.SetRange(Code, SH."No.");
        TextRec.SetRange(ID, SH."Document Type");
        TextRec.SetRange(Job, 0);
        TextRec.SetRange(Version, 0);
        TextRec.SetRange("No.", 0);
        TextRec.SetFilter(Text, '<>%1', '');
        TextRec.SetFilter(Department, CopyStr(BrugerRec."Responsibility Areas", 1, 20));

        if TextRec.FindFirst() then
            exit(TextRec.Text);

        exit('');
    end;

    procedure Job_Redundant_To_SalesLines(var in_Rec: Record "PVS Job")
    var
        SL_Rec: Record "Sales Line";
        SL_Temp: Record "Sales Line" temporary;
        PVSCase: Record "PVS Case";
    begin
        if not in_Rec.Active then
            exit;
        if not in_Rec."Production Calculation" then
            exit;

        if not PVSCase.Get(in_Rec.ID) then
            exit;

        SL_Rec.Reset();
        if PVSCase."Sales Order No." <> '' then
            SL_Rec.SetFilter("No.", PVSCase."Sales Order No.");
        SL_Rec.SetRange("PVS ID", in_Rec.ID);
        SL_Rec.SetRange("PVS Job", in_Rec.Job);
        if SL_Rec.FindSet(false) then
            repeat
                if SL_Rec."PTE SOI Production Order" then
                    if (SL_Rec."PVS Product Group Code" <> in_Rec."Product Group") or
                       (SL_Rec."PTE SOI Page Unit" <> in_Rec.Unit) or
                       (SL_Rec."PTE SOI Pages" <> in_Rec.Pages) or
                       (SL_Rec."PTE SOI Format Code" <> in_Rec."Format Code") or
                       (SL_Rec."PTE SOI Colors Front" <> in_Rec."Colors Front") or
                       (SL_Rec."PTE SOI Colors Back" <> in_Rec."Colors Back") or
                       (SL_Rec."PTE SOI Paper" <> in_Rec.Paper) or
                       (SL_Rec."PTE SOI Unchanged Reprint" <> in_Rec."Unchanged Rerun") or
                       (SL_Rec."PTE SOI Production Qty." <> in_Rec.Quantity)
                    then begin
                        SL_Temp := SL_Rec;
                        SL_Temp.Insert();
                    end;
            until SL_Rec.Next() = 0;

        SL_Temp.Reset();
        if SL_Temp.FindSet(false) then
            repeat
                SL_Rec.Get(SL_Temp."Document Type", SL_Temp."Document No.", SL_Temp."Line No.");
                SL_Rec."PVS Product Group Code" := in_Rec."Product Group";
                SL_Rec."PTE SOI Page Unit" := in_Rec.Unit;
                SL_Rec."PTE SOI Pages" := in_Rec.Pages;
                SL_Rec."PTE SOI Format Code" := in_Rec."Format Code";
                SL_Rec."PTE SOI Colors Front" := in_Rec."Colors Front";
                SL_Rec."PTE SOI Colors Back" := in_Rec."Colors Back";
                SL_Rec."PTE SOI Paper" := in_Rec.Paper;
                SL_Rec."PTE SOI Unchanged Reprint" := in_Rec."Unchanged Rerun";
                SL_Rec."PTE SOI Production Qty." := in_Rec.Quantity;
                SL_Rec.Modify();
            until SL_Temp.Next() = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePopupPageFromSalesline(SalesLine: Record "Sales Line")
    begin
    end;
}
