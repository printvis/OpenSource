Codeunit 80103 "PTE SOI SOint Prod Order Mgt"
{
    var
        Global_SetupRec: record "PVS General Setup";
        Global_OrderRec: record "PVS Case";
        Global_JobRec: record "PVS Job";
        Global_SubjectRec: record "PVS Job Item";
        SingleInstance: Codeunit "PVS SingleInstance";
        CacheMgt: Codeunit "PVS Cache Management";
        GAF: Codeunit "PVS Table Filters";

    procedure SalesHead_Insert_New(var in_SH_Rec: Record "Sales Header")
    var
        UserRec: Record "PVS User Setup";
        StatusRec: Record "PVS Status Code";
    begin
        if SingleInstance.Get_SetupRec(Global_SetupRec) then
            if Global_SetupRec."PTE Sales Order Calc. Wait" then
                in_SH_Rec."PTE SOI Calc. Status" := 1;

        if SingleInstance.Get_UserSetupRec(UserRec) then begin
            in_SH_Rec."PTE SOI Coordinator" := UserRec."Case Default Coordinator";
            in_SH_Rec."Salesperson Code" := UserRec."Case Default Salesperson";

            case in_SH_Rec."Document Type".AsInteger() of
                0:
                    if UserRec."Status Code New Request" <> '' then
                        if StatusRec.Get(UserRec."User ID", UserRec."Status Code New Request") then
                            if StatusRec.Status = 1 then
                                in_SH_Rec.Validate("PTE SOI Status Code", UserRec."Status Code New Request");

                1:
                    if UserRec."Status Code New Request" <> '' then
                        if StatusRec.Get(UserRec."User ID", UserRec."Status Code New Request") then
                            if StatusRec.Status > 1 then
                                in_SH_Rec.Validate("PTE SOI Status Code", StatusRec.Code)
                            else
                                if UserRec."Status Code New Quote" <> '' then
                                    if StatusRec.Get(UserRec."User ID", UserRec."Status Code New Quote") then
                                        if StatusRec.Status > 1 then
                                            in_SH_Rec.Validate("PTE SOI Status Code", StatusRec.Code);
            end;
        end;
    end;

    procedure SalesLine_Insert_PrintVis(var in_SL_Rec: Record "Sales Line")
    var
        CalcMgt: Codeunit "PVS Calculation Management";
        SH: Record "Sales Header";
        SL: Record "Sales Line";
        SL_Tmp: Record "Sales Line" temporary;
        Item: Record Item;
        TemplateRec: Record "PVS Job";
        ProductGroupRec: Record "PVS Product Group";
        QuantityVariationsRec: Record "PVS Quantity Variations";
        IntentMgt: Codeunit "PVS Intent Management";
        NAVmgt: Codeunit "PVS NAV API";
        Combined_Quantity: Decimal;
        OLD_ID1: Integer;
        OLD_ID2: Integer;
        OLD_ID3: Integer;
        AddSubjects: Boolean;
        NewJob: Boolean;
        IsHandled: Boolean;
        ok: Boolean;
        Text005: label 'It is not possible to create an extra Job Item';

    begin
        if not (in_SL_Rec."Document Type".AsInteger() in [in_SL_Rec."Document Type"::Quote.AsInteger(), in_SL_Rec."Document Type"::Order.AsInteger(), in_SL_Rec."Document Type"::"Blanket Order".AsInteger()]) then
            exit;

        if not SH.Get(in_SL_Rec."Document Type", in_SL_Rec."Document No.") then
            exit;

        NAVmgt.OnBeforeUpdatingPOrderOnSalesLine(in_SL_Rec, IsHandled);
        if IsHandled then
            exit;

        if Copy_Previous_P_Order(in_SL_Rec, OLD_ID1, OLD_ID2, OLD_ID3) then
            in_SL_Rec.Validate(Quantity);

        if not in_SL_Rec."PTE SOI Production Order" then
            exit;

        "Find/Insert_P-Order"(in_SL_Rec, SH, Global_OrderRec);

        if ok then
            in_SL_Rec.Get(in_SL_Rec."Document Type", in_SL_Rec."Document No.", in_SL_Rec."Line No.");

        // Maintain Job / JobItem
        if not ProductGroupRec.Get(in_SL_Rec."PVS Product Group Code") then begin
            ProductGroupRec.Init();
            // Find template
            TemplateRec.Reset();
            TemplateRec.SetCurrentkey(Template, "Item No.");
            TemplateRec.SetRange(Template, true);
            TemplateRec.SetRange("Item No.", in_SL_Rec."No.");

            if TemplateRec.FindLast() then
                ok := ProductGroupRec.Get(TemplateRec."Product Group");
        end;

        NewJob := false;
        if in_SL_Rec."PVS Job" = 0 then begin
            case ProductGroupRec."Sales Order Production Method" of
                ProductGroupRec."sales order production method"::"One job item per. line":
                    if not Make_Extra_JobItem(in_SL_Rec, ok) then
                        if ok then
                            ProductGroupRec."Sales Order Production Method" := ProductGroupRec."sales order production method"::"One job per line"
                        else begin
                            in_SL_Rec."PTE SOI Production Order" := false;
                            if GuiAllowed then
                                Message(Text005);
                            exit;
                        end;
            end;

            if ProductGroupRec."Sales Order Production Method" = ProductGroupRec."sales order production method"::"One job per line" then begin
                // Create a new job
                Clear(Global_JobRec);
                Global_JobRec.Init();
                Global_JobRec.ID := Global_OrderRec.ID;

                Global_JobRec."Sales Order" := true;
                if in_SL_Rec."Shipment Date" <> 0D then
                    Global_JobRec.Validate("Requested Delivery DateTime", CreateDatetime(in_SL_Rec."Shipment Date", 120000T));

                Global_JobRec."Skip Calc." := true;

                IsHandled := false;
                OnBeforeOneJobPerLineGlobal_JobRecInsert(Global_JobRec, in_SL_Rec, IsHandled);
                if IsHandled = true then exit;

                Global_JobRec.Insert(true);

                in_SL_Rec."PVS Job" := Global_JobRec.Job;
                in_SL_Rec."PVS ID 3" := 1; // Auto Shipment

                // IF Copy_Re_Order_ItemRef_Sale(in_SL_Rec,Global_JobRec,OLD_ID1,OLD_ID2,OLD_ID3) THEN
                //   Global_JobRec.Modify();

                NewJob := true;

            end;
        end else
            // Read Job
            Global_JobRec.Get(in_SL_Rec."PVS ID", in_SL_Rec."PVS Job", NAVmgt.Current_JobVersion(in_SL_Rec."PVS ID", in_SL_Rec."PVS Job"));

        // Maintain Job
        ok := in_SL_Rec.Modify();

        // Find the combined Quantity for all Jobs + Customer Inventory
        Combined_Quantity := 0;
        AddSubjects := false;
        READ_Tmp_Saleslines(SL_Tmp, in_SL_Rec."Document Type", in_SL_Rec."Document No.");

        if in_SL_Rec."Line No." = 0 then
            Combined_Quantity := in_SL_Rec."Quantity (Base)"
        else
            if SL_Tmp.FindSet(false) then
                repeat
                    if (SL_Tmp."PVS ID" = in_SL_Rec."PVS ID") and (SL_Tmp."PVS Job" = in_SL_Rec."PVS Job") and SL_Tmp."PTE SOI Production Order" then
                        if SL_Tmp."PVS Job Item No." = in_SL_Rec."PVS Job Item No." then begin
                            if SL.Get(SL_Tmp."Document Type", SL_Tmp."Document No.", SL_Tmp."Line No.") then begin
                                Combined_Quantity := Combined_Quantity + SL_Tmp."Quantity (Base)";
                            end;
                        end else
                            AddSubjects := true;
                until SL_Tmp.Next() = 0;

        if not QuantityVariationsRec.Get(Global_JobRec."Qty. Variation Code") then
            QuantityVariationsRec.Init();

        if in_SL_Rec."PVS Job Item No." = 0 then begin // Primary line

            if (Global_JobRec."Item No." <> in_SL_Rec."No.") or
               (Global_JobRec."Product Group" <> in_SL_Rec."PVS Product Group Code")
            then begin

                if Global_JobRec."Item No." <> in_SL_Rec."No." then
                    Global_JobRec.Validate("Item No.", in_SL_Rec."No.");

                if Global_JobRec."Product Group" <> in_SL_Rec."PVS Product Group Code" then
                    Global_JobRec.Validate("Product Group", in_SL_Rec."PVS Product Group Code")
                else
                    if (ProductGroupRec.Code = in_SL_Rec."PVS Product Group Code") and
                       (ProductGroupRec."Template Job" <> 0) and
                       (Global_JobRec."Template Job" = 0)
                    then
                        Global_JobRec.Validate("Product Group", in_SL_Rec."PVS Product Group Code");

                //  - 84045 - CM
                if in_SL_Rec.Find('=') then;
                // #2235 - 84045 - CM
                if Item.get(in_SL_Rec."No.") then begin
                    if (Item."PVS Colors Back" <> 0) or (Item."PVS Colors Front" <> 0) then begin
                        Global_JobRec.validate("Colors Back", item."PVS Colors Back");
                        Global_JobRec.validate("Colors Front", item."PVS Colors Front");
                    end;
                    if (Item."PVS Format Code" <> '') then
                        Global_JobRec.validate("Format Code", item."PVS Format Code");
                end;
                in_SL_Rec."PTE SOI Pages" := Global_JobRec.Pages;
                in_SL_Rec."PTE SOI Format Code" := Global_JobRec."Format Code";
                in_SL_Rec."PTE SOI Colors Front" := Global_JobRec."Colors Front";
                in_SL_Rec."PTE SOI Colors Back" := Global_JobRec."Colors Back";
                in_SL_Rec."PTE SOI Paper" := Global_JobRec.Paper;
                ok := in_SL_Rec.Modify();
            end;

            if Global_JobRec."Unchanged Rerun" <> in_SL_Rec."PTE SOI Unchanged Reprint" then
                Global_JobRec.Validate("Unchanged Rerun", in_SL_Rec."PTE SOI Unchanged Reprint");

            if (not AddSubjects) and (Global_JobRec.Quantity <> Combined_Quantity) then
                Global_JobRec.Validate("Ordered Qty.", Combined_Quantity);

            if Global_JobRec.Pages <> in_SL_Rec."PTE SOI Pages" then
                Global_JobRec.Validate(Pages, in_SL_Rec."PTE SOI Pages");

            if Global_JobRec."Format Code" <> in_SL_Rec."PTE SOI Format Code" then
                Global_JobRec.Validate("Format Code", in_SL_Rec."PTE SOI Format Code");

            if Global_JobRec."Colors Front" <> in_SL_Rec."PTE SOI Colors Front" then
                Global_JobRec.Validate("Colors Front", in_SL_Rec."PTE SOI Colors Front");

            if Global_JobRec."Colors Back" <> in_SL_Rec."PTE SOI Colors Back" then
                Global_JobRec.Validate("Colors Back", in_SL_Rec."PTE SOI Colors Back");

            if Global_JobRec.Paper <> in_SL_Rec."PTE SOI Paper" then
                Global_JobRec.Validate(Paper, in_SL_Rec."PTE SOI Paper");

            if Global_JobRec."Job Name" <> in_SL_Rec.Description then
                Global_JobRec.Validate("Job Name", in_SL_Rec.Description);

            if in_SL_Rec."Shipment Date" <> Global_JobRec."Requested Delivery Date" then
                Global_JobRec.Validate("Requested Delivery DateTime", CreateDatetime(in_SL_Rec."Shipment Date", 120000T));

            Global_JobRec."Cross Reference No." := in_SL_Rec."Item Reference No.";

            NAVmgt.Copy_Re_Order_ItemRef(Global_JobRec, OLD_ID1, OLD_ID2, OLD_ID3);
            Global_JobRec."Skip Calc." := false;
            Global_JobRec.Modify(true);

            CalcMgt.Main_Calculate_Job(Global_JobRec.ID, Global_JobRec.Job, Global_JobRec.Version);
            CalcMgt.Main_Price_Calculate_Job(Global_JobRec.ID, Global_JobRec.Job, Global_JobRec.Version);

            Global_JobRec.Get(Global_JobRec.ID, Global_JobRec.Job, Global_JobRec.Version);

            Global_JobRec.Default_Description;
            Global_JobRec.CalcFields(Description);
            if ok then
                in_SL_Rec.Get(in_SL_Rec."Document Type", in_SL_Rec."Document No.", in_SL_Rec."Line No."); // MC 14/5-2001

            in_SL_Rec."PVS ID" := Global_JobRec.ID;
            in_SL_Rec."PVS Job" := Global_JobRec.Job;

            in_SL_Rec."PVS Product Group Code" := Global_JobRec."Product Group";
            in_SL_Rec."PTE SOI Pages" := Global_JobRec.Pages;
            in_SL_Rec."PTE SOI Format Code" := Global_JobRec."Format Code";
            in_SL_Rec."PTE SOI Colors Front" := Global_JobRec."Colors Front";
            in_SL_Rec."PTE SOI Colors Back" := Global_JobRec."Colors Back";
            in_SL_Rec."PTE SOI Paper" := Global_JobRec.Paper;
            in_SL_Rec."PTE SOI Unchanged Reprint" := Global_JobRec."Unchanged Rerun";
            in_SL_Rec."PTE SOI Production Qty." := Global_JobRec.Quantity;

            if AddSubjects then
                Global_SubjectRec.Get(Global_JobRec.ID, Global_JobRec.Job, Global_JobRec.Version, 1, 1);

        end else begin // extra subject
            Global_SubjectRec.Get(Global_JobRec.ID, Global_JobRec.Job, Global_JobRec.Version, in_SL_Rec."PVS Job Item No.", 1);

            if Global_SubjectRec."Item No." <> in_SL_Rec."No." then begin
                Global_SubjectRec.Validate("Item No.", in_SL_Rec."No.");

                in_SL_Rec."PTE SOI Pages" := Global_SubjectRec."Pages With Print";
                in_SL_Rec."PTE SOI Format Code" := Global_SubjectRec."Final Format Code";
                in_SL_Rec."PTE SOI Colors Front" := Global_SubjectRec."Colors Front";
                in_SL_Rec."PTE SOI Colors Back" := Global_SubjectRec."Colors Back";
                ok := in_SL_Rec.Modify();
            end;

            if Global_SubjectRec."Pages With Print" <> in_SL_Rec."PTE SOI Pages" then
                Global_SubjectRec.Validate("Pages With Print", in_SL_Rec."PTE SOI Pages");

            if (Global_SubjectRec."Final Format Code" <> in_SL_Rec."PTE SOI Format Code") and (in_SL_Rec."PTE SOI Format Code" <> '') then
                Global_SubjectRec.Validate("Final Format Code", in_SL_Rec."PTE SOI Format Code");

            if Global_SubjectRec."Colors Front" <> in_SL_Rec."PTE SOI Colors Front" then
                Global_SubjectRec.Validate("Colors Front", in_SL_Rec."PTE SOI Colors Front");

            if Global_SubjectRec."Colors Back" <> in_SL_Rec."PTE SOI Colors Back" then
                Global_SubjectRec.Validate("Colors Back", in_SL_Rec."PTE SOI Colors Back");

            Global_SubjectRec.Modify();

            in_SL_Rec."PVS Product Group Code" := Global_JobRec."Product Group";
            in_SL_Rec."PTE SOI Paper" := Global_JobRec.Paper;
            in_SL_Rec."PTE SOI Unchanged Reprint" := Global_JobRec."Unchanged Rerun";
        end;

        if AddSubjects then begin
            if Global_SubjectRec.Quantity <> Combined_Quantity then
                Global_SubjectRec.Validate(Quantity, Combined_Quantity);
            Global_SubjectRec."Manual Qty." := true;
            Global_SubjectRec.Modify(true);

            Update_JobItems(Global_JobRec);

        end;

        in_SL_Rec."PVS Order No." := Global_OrderRec."Order No.";
        ok := in_SL_Rec.Modify();

        Calculate_UnitPrices(in_SL_Rec, Global_JobRec);

        OnAfter_SalesLine_Insert_PrintVis(in_SL_Rec, Global_JobRec, isHandled);

        if isHandled then exit;

        Update_PrintVis_Description(in_SL_Rec);
    end;

    procedure "Find/Insert_P-Order"(var in_SL_Rec: Record "Sales Line"; var in_SH_Rec: Record "Sales Header"; var out_OrderRec: Record "PVS Case")
    var
        NAVmgt: Codeunit "PVS NAV API";
        ContactRec: Record Contact;
        IsHandled: Boolean;
        ok: Boolean;
    begin
        if not in_SL_Rec."PTE SOI Production Order" then
            exit;

        NAVmgt.OnBeforeUpdatingPOrderOnSalesLine(in_SL_Rec, IsHandled);
        if IsHandled then
            exit;

        if not out_OrderRec.Get(in_SL_Rec."PVS ID") then begin
            Clear(in_SL_Rec."PVS ID");
            Clear(in_SL_Rec."PVS Job");
            Clear(in_SL_Rec."PVS ID 3");
        end;

        // Maintain CaseHead Rec
        if in_SL_Rec."PVS ID" = 0 then begin
            // Create new Case Head
            Clear(out_OrderRec);
            out_OrderRec.Init();
            out_OrderRec."Sales Order Type" := in_SH_Rec."Document Type".AsInteger();
            out_OrderRec."Sales Order No." := in_SH_Rec."No.";
            out_OrderRec."Status Code" := in_SH_Rec."PTE SOI Status Code";
            out_OrderRec.Insert(true);

            // #3312
            if in_SH_Rec."Sell-to Customer No." <> '' then
                if out_OrderRec."Sell-To No." <> in_SH_Rec."Sell-to Customer No." then
                    out_OrderRec.Validate("Sell-To No.", in_SH_Rec."Sell-to Customer No.");
            // #3312

            out_OrderRec.Validate("Order Type", in_SH_Rec."PTE SOI Order Type Code");
            out_OrderRec.Validate(Salesperson, in_SH_Rec."Salesperson Code");
            if in_SH_Rec."PTE SOI Coordinator" <> '' then
                out_OrderRec.Validate(Coordinator, in_SH_Rec."PTE SOI Coordinator");

            out_OrderRec."Cross Reference No." := in_SL_Rec."Item Reference No.";

            out_OrderRec."Sales Order Type" := in_SL_Rec."Document Type".AsInteger();
            out_OrderRec."Sales Order No." := in_SL_Rec."Document No.";
            out_OrderRec."Product Group" := in_SL_Rec."PVS Product Group Code";

            out_OrderRec.Validate("Status Code", in_SH_Rec."PTE SOI Status Code");

            out_OrderRec.Modify();
            case in_SH_Rec."Document Type".AsInteger() of
                0:
                    out_OrderRec.Type := 1; // Quote
                1:
                    out_OrderRec.Type := 2; // Order
            end;

            in_SL_Rec."PVS ID" := out_OrderRec.ID;
        end else
            // Maintain Case Head
            out_OrderRec.Get(in_SL_Rec."PVS ID");

        ok := in_SL_Rec.Modify();

        out_OrderRec."Order Date" := in_SH_Rec."Order Date";

        if in_SH_Rec."Sell-to Customer No." = '' then begin
            if ContactRec.Get(in_SH_Rec."Sell-to Contact No.") then
                if ContactRec.Type = ContactRec.Type::Company then begin
                    if out_OrderRec."Sell-To Contact No." <> in_SH_Rec."Sell-to Contact No." then
                        out_OrderRec.Validate("Sell-To Contact No.", in_SH_Rec."Sell-to Contact No.");
                end else begin
                    if out_OrderRec."Sell-To No." <> ContactRec."Company No." then
                        out_OrderRec.Validate("Sell-To No.", ContactRec."Company No.");
                    if out_OrderRec."Sell-To Contact No." <> in_SH_Rec."Sell-to Contact No." then
                        out_OrderRec.Validate("Sell-To Contact No.", in_SH_Rec."Sell-to Contact No.");
                end
            else
                if out_OrderRec."Sell-To No." <> in_SH_Rec."Sell-to Contact No." then
                    out_OrderRec.Validate("Sell-To No.", in_SH_Rec."Sell-to Contact No.");
        end else
            if out_OrderRec."Sell-To No." <> in_SH_Rec."Sell-to Customer No." then
                out_OrderRec.Validate("Sell-To No.", in_SH_Rec."Sell-to Customer No.");

        if out_OrderRec."Bill-To No." <> in_SH_Rec."Bill-to Customer No." then
            out_OrderRec.Validate("Bill-To No.", in_SH_Rec."Bill-to Customer No.");

        if out_OrderRec.Salesperson <> in_SH_Rec."Salesperson Code" then
            out_OrderRec.Validate(Salesperson, in_SH_Rec."Salesperson Code");

        if out_OrderRec.Coordinator <> in_SH_Rec."PTE SOI Coordinator" then
            out_OrderRec.Validate(Coordinator, in_SH_Rec."PTE SOI Coordinator");

        if out_OrderRec.Responsible <> in_SH_Rec."PTE SOI Person Responsible" then
            out_OrderRec.Validate(Responsible, in_SH_Rec."PTE SOI Person Responsible");

        out_OrderRec."Job Name" := in_SL_Rec.Description;
        out_OrderRec."Created By Sales Order" := in_SL_Rec."Document No.";
        out_OrderRec."Cross Reference No." := in_SL_Rec."Item Reference No.";

        out_OrderRec."Global Dimension 1 Code" := in_SH_Rec."Shortcut Dimension 1 Code";
        out_OrderRec."Global Dimension 2 Code" := in_SH_Rec."Shortcut Dimension 2 Code";

        if in_SL_Rec."Shortcut Dimension 1 Code" <> '' then
            out_OrderRec."Global Dimension 1 Code" := in_SL_Rec."Shortcut Dimension 1 Code";

        if in_SL_Rec."Shortcut Dimension 2 Code" <> '' then
            out_OrderRec."Global Dimension 2 Code" := in_SL_Rec."Shortcut Dimension 2 Code";

        if in_SH_Rec."Bill-to Contact No." <> '' then begin
            if out_OrderRec."Bill-To Contact No." <> in_SH_Rec."Bill-to Contact No." then
                out_OrderRec.Validate("Bill-To Contact No.", in_SH_Rec."Bill-to Contact No.");
        end else
            out_OrderRec."Bill-To Contact" := in_SH_Rec."Bill-to Contact";

        if in_SH_Rec."Sell-to Contact No." <> '' then begin
            if out_OrderRec."Sell-To Contact No." <> in_SH_Rec."Sell-to Contact No." then
                out_OrderRec.Validate("Sell-To Contact No.", in_SH_Rec."Sell-to Contact No.");
        end else
            out_OrderRec."Sell-To Contact" := in_SH_Rec."Sell-to Contact";

        out_OrderRec."Your Reference" := in_SH_Rec."Your Reference";

        if in_SH_Rec."Shipment Method Code" <> '' then
            out_OrderRec.Validate("Shipment Code", in_SH_Rec."Shipment Method Code");

        if in_SH_Rec."PVS End User Contact" <> '' then
            out_OrderRec.Validate("End User Contact", in_SH_Rec."PVS End User Contact");
        out_OrderRec.Validate("Can Be Planned");

        out_OrderRec.Modify(true);
    end;

    procedure READ_Tmp_Saleslines(var Out_Rec_Tmp: Record "Sales Line" temporary; in_DocumentType: Enum "Sales Document Type"; in_DocumentNo: Code[20])
    var
        LocalRec: Record "Sales Line";
    begin
        Out_Rec_Tmp.Reset();
        Out_Rec_Tmp.DeleteAll();
        LocalRec.Reset();
        LocalRec.SetRange("Document Type", in_DocumentType);
        LocalRec.SetRange("Document No.", in_DocumentNo);
        if LocalRec.IsEmpty() then
            exit;
        if not LocalRec.FindSet(false) then
            exit;
        repeat
            Out_Rec_Tmp := LocalRec;
            if Out_Rec_Tmp.Insert() then;
        until LocalRec.Next() = 0;
    end;

    procedure READ_Tmp_Purchaselines(var Out_Rec_Tmp: Record "Purchase Line" temporary; in_DocumentType: enum "Purchase Document Type"; in_DocumentNo: Code[20])
    var
        LocalRec: Record "Purchase Line";
    begin
        Out_Rec_Tmp.Reset();
        Out_Rec_Tmp.DeleteAll();
        LocalRec.Reset();
        LocalRec.SetRange("Document Type", in_DocumentType);
        LocalRec.SetRange("Document No.", in_DocumentNo);
        if LocalRec.IsEmpty() then
            exit;
        if not LocalRec.FindSet(false) then
            exit;
        repeat
            Out_Rec_Tmp := LocalRec;
            if Out_Rec_Tmp.Insert() then;
        until LocalRec.Next() = 0;
    end;

    local procedure Make_Extra_JobItem(var in_SL_Rec: Record "Sales Line"; var MakeNewJob: Boolean): Boolean
    var
        NAVmgt: Codeunit "PVS NAV API";
        ItemRec: Record Item;
        SL_Tmp: Record "Sales Line" temporary;
        JobItemRec: Record "PVS Job Item";
        JobItemRec_New: Record "PVS Job Item";
        ok: Boolean;
    begin
        MakeNewJob := false;
        ok := false;

        READ_Tmp_Saleslines(SL_Tmp, in_SL_Rec."Document Type", in_SL_Rec."Document No.");

        SL_Tmp.SetFilter("Line No.", '<>%1', in_SL_Rec."Line No.");
        SL_Tmp.SetRange(Type, 2);
        SL_Tmp.SetRange("PTE SOI Production Order", true);
        SL_Tmp.SetRange("PVS ID", in_SL_Rec."PVS ID");
        SL_Tmp.SetFilter("PVS Job", '<>0');
        SL_Tmp.SetRange("PVS Job Item No.", 0); // Indicates subjectno.

        if not SL_Tmp.FindLast() then begin
            MakeNewJob := true;
            exit(false);
        end;

        if not Global_JobRec.Get(SL_Tmp."PVS ID", SL_Tmp."PVS Job", NAVmgt.Current_JobVersion(SL_Tmp."PVS ID", SL_Tmp."PVS Job")) then
            exit(false);

        GAF.SELECT_JobItems2Job(JobItemRec, Global_JobRec.ID, Global_JobRec.Job, Global_JobRec.Version, true);

        if not JobItemRec.FindLast() then
            exit(false);

        if (JobItemRec.Tool <> '') and ItemRec.Get(in_SL_Rec."No.") then
            if ItemRec."PVS Imposition Code" <> JobItemRec.Tool then
                exit(false);

        JobItemRec_New.Init();
        JobItemRec_New.ID := JobItemRec.ID;
        JobItemRec_New.Job := JobItemRec.Job;
        JobItemRec_New.Version := JobItemRec.Version;
        JobItemRec_New."Job Item No." := JobItemRec."Job Item No." + 1;

        JobItemRec_New."Entry No." := 1;
        JobItemRec_New."Creation Date" := Today();
        JobItemRec_New."Created By User" := UserId;
        JobItemRec_New."Job Item No. 2" := JobItemRec_New."Job Item No.";

        JobItemRec_New."Sheet ID" := JobItemRec."Sheet ID";
        JobItemRec_New."Add. Qty." := JobItemRec."Add. Qty.";

        JobItemRec_New.Insert();

        in_SL_Rec."PVS Job" := SL_Tmp."PVS Job";
        in_SL_Rec."PVS ID 3" := 0; // Generate new shipment
        in_SL_Rec."PVS Job Item No." := JobItemRec_New."Job Item No.";

        exit(true);
    end;

    local procedure Update_JobItems(var Local_JobRec: Record "PVS Job")
    var
        JobItemRec: Record "PVS Job Item";
        Item_Quantity: Integer;
    begin
        Item_Quantity := 0;

        GAF.SELECT_JobItems2Job(JobItemRec, Local_JobRec.ID, Local_JobRec.Job, Local_JobRec.Version, true);

        if JobItemRec.FindSet(true) then
            repeat
                if not JobItemRec."Manual Qty." then begin
                    JobItemRec."Manual Qty." := true;
                    JobItemRec.Modify();
                end;
                Item_Quantity := Item_Quantity + JobItemRec.Quantity;
            until JobItemRec.Next() = 0;

        if Local_JobRec.Quantity <> Item_Quantity then begin
            Local_JobRec.Validate(Quantity, Item_Quantity);
            Local_JobRec.Modify();
        end;
    end;

    procedure Calculate_UnitPrices(var in_SL_Rec: Record "Sales Line"; var Local_JobRec: Record "PVS Job")
    var
        ItemRec: Record Item;
        SH: Record "Sales Header";
        SL: Record "Sales Line";
        SL_Tmp: Record "Sales Line" temporary;
        ProductGroupRec: Record "PVS Product Group";
        TotalSale: Decimal;
        ok: Boolean;
    begin
        if Local_JobRec.Quantity = 0 then
            exit;
        if not ProductGroupRec.Get(Local_JobRec."Product Group") then
            exit;

        if not SH.Get(in_SL_Rec."Document Type", in_SL_Rec."Document No.") then
            exit;

        if ProductGroupRec."Sales Order Price Method" <> 1 then begin
            exit;
            if not ItemRec.Get(in_SL_Rec."No.") then
                exit;
            if ItemRec."Unit Price" <> 0 then
                exit;
        end;

        if SH."Currency Factor" = 0 then
            SH."Currency Factor" := 1;

        Local_JobRec.CalcFields("Total Cost Calc.");

        // 001
        // TotalSale := Local_JobRec."Quoted Price" * SH."Currency Factor";
        TotalSale := Local_JobRec."Quoted Price Currency";
        // 001

        READ_Tmp_Saleslines(SL_Tmp, in_SL_Rec."Document Type", in_SL_Rec."Document No.");
        SL_Tmp.SetRange(Type, in_SL_Rec.Type);
        SL_Tmp.SetRange("PVS ID", Local_JobRec.ID);
        SL_Tmp.SetRange("PVS Job", Local_JobRec.Job);
        SL_Tmp.SetRange("PTE SOI Production Order", true);

        if SL_Tmp.FindSet() then
            repeat
                SL.Get(SL_Tmp."Document Type", SL_Tmp."Document No.", SL_Tmp."Line No.");
                ok := false;

                if SL."Qty. per Unit of Measure" = 0 then
                    SL."Qty. per Unit of Measure" := 1;

                if (SL."Unit Cost (LCY)" <> (Local_JobRec."Total Cost Calc." / Local_JobRec.Quantity * SL."Qty. per Unit of Measure")) or
                   (SL."Line Discount %" <> 0)
                then begin
                    SL.Validate("Unit Cost (LCY)", Local_JobRec."Total Cost Calc." / Local_JobRec.Quantity * SL."Qty. per Unit of Measure");
                    SL.Validate("Line Discount %", 0);
                    ok := true;
                end;

                if SL."Unit Price" <> (TotalSale / Local_JobRec.Quantity * SL."Qty. per Unit of Measure") then begin
                    SL.Validate("Unit Price", (TotalSale / Local_JobRec.Quantity * SL."Qty. per Unit of Measure"));
                    ok := true;
                end;

                if ok then
                    SL.Modify(true);
            until SL_Tmp.Next() = 0;

        ok := in_SL_Rec.Get(in_SL_Rec."Document Type", in_SL_Rec."Document No.", in_SL_Rec."Line No.");
    end;

    procedure Delete_PrintVis_SalesLine(var in_SL_Rec: Record "Sales Line")
    var
        NAVmgt: Codeunit "PVS NAV API";
        SL_Tmp: Record "Sales Line" temporary;
        JobRec: Record "PVS Job";
        JobRec_Tmp: Record "PVS Job" temporary;
        JobItemRec: Record "PVS Job Item";
        JobItemRec2: Record "PVS Job Item";
        ok, IsHandled : Boolean;
    begin
        OnBeforeDelete_PrintVis_SalesLine(in_SL_Rec, IsHandled);
        if IsHandled then
            exit;

        if not (in_SL_Rec."Document Type" in [in_SL_Rec."Document Type"::Quote, in_SL_Rec."Document Type"::Order, in_SL_Rec."Document Type"::"Blanket Order"]) then
            exit;

        if in_SL_Rec."PVS ID" = 0 then
            exit;

        if in_SL_Rec.Type = in_SL_Rec.Type::" " then
            exit;

        if not Global_OrderRec.Get(in_SL_Rec."PVS ID") then
            exit;

        Global_OrderRec.OnDelete_Test;

        // IF NOT in_SL_Rec."Production Order" THEN
        //   EXIT;

        READ_Tmp_Saleslines(SL_Tmp, in_SL_Rec."Document Type", in_SL_Rec."Document No.");
        SL_Tmp.SetFilter("Line No.", '<%1', in_SL_Rec."Line No.");
        SL_Tmp.SetRange(Type, 2);
        SL_Tmp.SetRange("PTE SOI Production Order", true);
        SL_Tmp.SetRange("PVS ID", in_SL_Rec."PVS ID");
        SL_Tmp.SetRange("PVS Job", in_SL_Rec."PVS Job");
        SL_Tmp.SetFilter("PVS Job Item No.", '<>%1', in_SL_Rec."PVS Job Item No.");

        if SL_Tmp.FindFirst() then begin
            if in_SL_Rec."PVS Job Item No." = 0 then begin
                in_SL_Rec."PTE SOI Production Order" := true;
                exit;
            end;

            JobItemRec.Reset();
            JobItemRec.SetRange(ID, in_SL_Rec."PVS ID");
            JobItemRec.SetRange(Job, in_SL_Rec."PVS Job");
            JobItemRec.SetRange(Version, NAVmgt.Current_JobVersion(in_SL_Rec."PVS ID", in_SL_Rec."PVS Job"));
            JobItemRec.SetRange("Job Item No.", in_SL_Rec."PVS Job Item No.");

            if JobItemRec.FindSet(true) then begin
                JobItemRec2 := JobItemRec;
                repeat
                    ok := JobItemRec.Delete(true);
                until JobItemRec.Next() = 0;
            end;

            in_SL_Rec."PVS ID" := 0;
            in_SL_Rec."PVS Job" := 0;
            in_SL_Rec."PVS ID 3" := 0;
            in_SL_Rec."PVS Job Item No." := 0;
            in_SL_Rec."PTE SOI Production Order" := false;
            if in_SL_Rec.Modify() then;

            if JobRec.Get(JobItemRec2.ID, JobItemRec2.Job, JobItemRec2.Version) then begin
                Update_JobItems(JobRec);
                Calculate_UnitPrices(in_SL_Rec, JobRec);
            end;

        end else begin
            CacheMgt.READ_Tmp_Jobs_To_ID(JobRec_Tmp, in_SL_Rec."PVS ID");
            JobRec_Tmp.SetFilter(Job, '<>%1', in_SL_Rec."PVS Job");

            if JobRec_Tmp.FindFirst() then begin // Delete job
                JobRec_Tmp.SetRange(Job, in_SL_Rec."PVS Job");

                if JobRec_Tmp.FindSet(false) then
                    repeat
                        if JobRec.Get(JobRec_Tmp.ID, JobRec_Tmp.Job, JobRec_Tmp.Version) then
                            if JobRec.Delete(true) then;
                    until JobRec_Tmp.Next() = 0;

            end else begin // Delete order
                Global_OrderRec.Delete(true);
            end;
            if in_SL_Rec.Get(in_SL_Rec."Document Type", in_SL_Rec."Document No.", in_SL_Rec."Line No.") then;
            in_SL_Rec."PVS ID" := 0;
            in_SL_Rec."PVS Job" := 0;
            in_SL_Rec."PVS ID 3" := 0;
            in_SL_Rec."PVS Job Item No." := 0;
            in_SL_Rec."PTE SOI Production Order" := false;
            if in_SL_Rec.Modify() then;
        end;
    end;

    procedure Update_PrintVis_Description(var in_SL_Rec: Record "Sales Line")
    var
        NAVmgt: Codeunit "PVS NAV API";
        SalesHeader: Record "Sales Header";
        SL_Tmp: Record "Sales Line" temporary;
        TextRec: Record "PVS Job Text Description";
        GlobalMgt: Codeunit "PVS Global";
        Next_Entry: Integer;
    begin
        // Read Job
        if in_SL_Rec."PVS ID" = 0 then
            exit;
        if in_SL_Rec."Document Type".AsInteger() > 1 then
            exit;


        // check if sales header is open
        if not SalesHeader.get(in_SL_Rec."Document Type", in_SL_Rec."Document No.") then
            exit;

        if SalesHeader.Status <> SalesHeader.Status::Open then
            exit;

        if in_SL_Rec."PVS Job" = 0 then begin
            if in_SL_Rec.Type <> in_SL_Rec.Type::" " then
                exit;

            READ_Tmp_Saleslines(SL_Tmp, in_SL_Rec."Document Type", in_SL_Rec."Document No.");
            SL_Tmp := in_SL_Rec;
            if SL_Tmp.Insert() then; // Last not modifyed salesline
            SL_Tmp.SetRange(Type, 2);
            SL_Tmp.SetRange("PVS ID", in_SL_Rec."PVS ID");
            SL_Tmp.SetRange("PTE SOI Production Order", true);
            SL_Tmp.SetRange("Line No.", 0, in_SL_Rec."Line No.");

            if SL_Tmp.FindLast() then
                in_SL_Rec."PVS Job" := SL_Tmp."PVS Job"
            else
                exit;
        end;

        if not Global_JobRec.Get(in_SL_Rec."PVS ID", in_SL_Rec."PVS Job", NAVmgt.Current_JobVersion(in_SL_Rec."PVS ID", in_SL_Rec."PVS Job")) then
            exit;

        if in_SL_Rec."PTE SOI Production Order" then begin
            Global_JobRec.Validate("Job Name", in_SL_Rec.Description);
            Global_JobRec.Modify();

            if Global_OrderRec.Get(Global_JobRec.ID) then begin
                Global_OrderRec."Job Name" := in_SL_Rec.Description;
                Global_OrderRec.Modify();
            end;
        end;

        // Delete existing Text
        TextRec.Reset(); // Key: Table ID,Code,ID,Job,Version,No.,Type,Department,Entry No.
        TextRec.SetRange("Table ID", 0);
        TextRec.SetRange(Code, '');
        TextRec.SetRange(ID, Global_JobRec.ID);
        TextRec.SetRange(Job, Global_JobRec.Job);
        TextRec.SetRange(Version, Global_JobRec.Version);
        TextRec.SetRange("No.", 0);
        TextRec.SetRange(Type, 0);

        if TextRec.FindSet(true) then
            repeat
                if TextRec."Modified By User" = in_SL_Rec."Document No." then
                    TextRec.Delete();
            until TextRec.Next() = 0;

        TextRec.SetRange("Table ID", 6010312);
        if TextRec.FindSet(true) then
            repeat
                if TextRec."Modified By User" = in_SL_Rec."Document No." then
                    TextRec.Delete();
            until TextRec.Next() = 0;

        TextRec.SetRange("Table ID", 6010313);
        if TextRec.FindSet(true) then
            repeat
                if TextRec."Modified By User" = in_SL_Rec."Document No." then
                    TextRec.Delete();
            until TextRec.Next() = 0;

        TextRec.SetRange("Table ID", 6010313);
        if not TextRec.FindLast() then
            TextRec."Entry No." := 0;

        // Find Last Entry
        TextRec.Reset(); // Key: Table ID,Code,ID,Job,Version,No.,Type,Department,Entry No.
        TextRec.SetRange("Table ID", 0);
        TextRec.SetRange(Code, '');
        TextRec.SetRange(ID, Global_JobRec.ID);
        TextRec.SetRange(Job, Global_JobRec.Job);
        TextRec.SetRange(Version, Global_JobRec.Version);
        TextRec.SetRange("No.", 0);
        TextRec.SetRange(Type, 0);
        TextRec.SetRange(Department, '');
        if TextRec.FindLast() then
            Next_Entry := TextRec."Entry No."
        else
            Next_Entry := 0;

        Clear(TextRec);
        SL_Tmp.Reset();
        SL_Tmp.DeleteAll();

        READ_Tmp_Saleslines(SL_Tmp, in_SL_Rec."Document Type", in_SL_Rec."Document No.");
        SL_Tmp := in_SL_Rec;
        if SL_Tmp.Insert() then; // Last not modifyed salesline

        SL_Tmp.SetRange(Type, 0);
        SL_Tmp.SetRange("PVS ID", in_SL_Rec."PVS ID");
        if in_SL_Rec."PVS Job" <> 0 then
            SL_Tmp.SetRange("PVS Job", in_SL_Rec."PVS Job");

        SL_Tmp.SetFilter(Description, '<>%1', '');
        if SL_Tmp.FindSet() then
            repeat
                if SL_Tmp."Line No." = in_SL_Rec."Line No." then
                    SL_Tmp.Description := in_SL_Rec.Description;

                Next_Entry := Next_Entry + 10000;

                TextRec.ID := Global_JobRec.ID;
                TextRec.Job := Global_JobRec.Job;
                TextRec.Version := Global_JobRec.Version;
                TextRec.Type := 0;
                TextRec."Entry No." := Next_Entry;

                TextRec.Text := SL_Tmp.Description;
                TextRec."Creation Date" := Today();
                TextRec."Created By User" := UserId;
                TextRec."Modified By User" := in_SL_Rec."Document No.";
                TextRec."Last Date Modified" := Today();
                TextRec.Insert();
            until SL_Tmp.Next() = 0;
    end;

    procedure Insert_Purchase_Head(var PurchaseHearder: Record "Purchase Header")
    var
        UserRec: Record "PVS User Setup";
    begin
        if SingleInstance.Get_UserSetupRec(UserRec) then begin
            PurchaseHearder."PTE SOI Coordinator" := UserRec."Case Default Coordinator";
            PurchaseHearder."Purchaser Code" := UserRec."Case Default Salesperson";
            case PurchaseHearder."Document Type".AsInteger() of
                1:
                    PurchaseHearder.Validate("PTE SOI Status Code", UserRec."PTE SOI Status Code New P.");
            end;
        end;
    end;

    procedure Get_Shipped_Quantity(var in_SL_Rec: Record "Sales Line") Quantity_Shipped: Integer
    var
        JobRec_Tmp: Record "PVS Job" temporary;
        ShipmentRec: Record "PVS Job Shipment";
        Dec: Decimal;
    begin
        Quantity_Shipped := 0;
        if (not in_SL_Rec."PTE SOI Production Order") or (in_SL_Rec."PVS ID" = 0) then
            exit(0);

        CacheMgt.READ_Tmp_Jobs_To_ID(JobRec_Tmp, in_SL_Rec."PVS ID");

        JobRec_Tmp.SetRange("Production Calculation", true);
        if not JobRec_Tmp.FindLast() then
            exit(0); // Get Last Production Job

        ShipmentRec.Reset();
        ShipmentRec.SetRange(ID, JobRec_Tmp.ID);
        ShipmentRec.SetRange(Job, JobRec_Tmp.Job);
        if ShipmentRec.FindSet(false) then
            repeat
                Dec += ShipmentRec."Qty. To Ship";
            until ShipmentRec.Next() = 0;

        Quantity_Shipped := ROUND(Dec, 1);
        exit(Quantity_Shipped);
    end;

    // PURCHASE FUNCTIONS 
    procedure Insert_P_Order_PurchaseLine(var in_PL_Rec: Record "Purchase Line")
    var
        NAVmgt: Codeunit "PVS NAV API";
        PurchaseHearder: Record "Purchase Header";
        ProductGroup: Code[20];
        ok: Boolean;
    begin
        if in_PL_Rec."Document Type".AsInteger() > 1 then
            exit;

        if not in_PL_Rec."PTE SOI Production Order" then
            exit;

        if in_PL_Rec."PVS ID 1" <> 0 then  // If Order exist, dont maintain p-order
            exit;

        if not PurchaseHearder.Get(in_PL_Rec."Document Type", in_PL_Rec."Document No.") then
            exit;

        if in_PL_Rec.Type = Enum::"Purchase Line Type"::Item then
            ProductGroup := GetProductGroupFromItemsTemplate(in_PL_Rec."No.");

        // Maintain Case Head
        if in_PL_Rec."PVS ID 1" = 0 then begin
            PurchaseHearder.TestField("Sell-to Customer No.");
            Clear(Global_OrderRec);
            Global_OrderRec.Init();
            Global_OrderRec.Insert(true);
            Global_OrderRec.Validate("Sell-To No.", PurchaseHearder."Sell-to Customer No.");
            Global_OrderRec.Modify(true);
            Global_OrderRec.Validate("Order Type", PurchaseHearder."PTE SOI P-Order Type");

            if ProductGroup <> '' then
                Global_OrderRec.Validate("Product Group", ProductGroup);

            Global_OrderRec.Validate(Salesperson, PurchaseHearder."Purchaser Code");
            Global_OrderRec.Validate("Status Code", PurchaseHearder."PTE SOI Status Code");
            Global_OrderRec."Cross Reference No." := in_PL_Rec."Item Reference No.";

            Global_OrderRec."Purchase Order No." := in_PL_Rec."Document No.";

            Global_OrderRec.Modify();
            case PurchaseHearder."Document Type".AsInteger() of
                0:
                    Global_OrderRec.Type := 1; // Quote
                1:
                    Global_OrderRec.Type := 2; // Order
            end;

            in_PL_Rec."PVS ID 1" := Global_OrderRec.ID;
        end else
            Global_OrderRec.Get(in_PL_Rec."PVS ID 1");

        Global_OrderRec."Order Date" := PurchaseHearder."Order Date";

        if Global_OrderRec.Salesperson <> PurchaseHearder."Purchaser Code" then
            Global_OrderRec.Validate(Salesperson, PurchaseHearder."Purchaser Code");

        if Global_OrderRec.Coordinator <> PurchaseHearder."PTE SOI Coordinator" then
            Global_OrderRec.Validate(Coordinator, PurchaseHearder."PTE SOI Coordinator");

        if Global_OrderRec.Responsible <> PurchaseHearder."PTE SOI Person Responsible" then
            Global_OrderRec.Validate(Responsible, PurchaseHearder."PTE SOI Person Responsible");

        Global_OrderRec."Job Name" := in_PL_Rec.Description;

        Global_OrderRec.Modify(true);

        // Maitain Job
        if in_PL_Rec."PVS ID 2" = 0 then begin
            Clear(Global_JobRec);
            Global_JobRec.Init();
            Global_JobRec.ID := Global_OrderRec.ID;

            Global_JobRec.Insert(true);
            in_PL_Rec."PVS ID 2" := Global_JobRec.Job;

            NAVmgt.Copy_Re_Order_ItemRef_Purchase(in_PL_Rec, Global_JobRec);

            // IF Copy_Re_Order_ItemRef_Purchase(in_PL_Rec,Global_JobRec) THEN
            //    Global_JobRec.Modify();

        end else
            Global_JobRec.Get(in_PL_Rec."PVS ID 1", 1, NAVmgt.Current_JobVersion(in_PL_Rec."PVS ID 1", 1));

        if Global_JobRec."Product Group" <> in_PL_Rec."PVS Product Group Code" then begin
            Global_JobRec.Validate("Product Group", in_PL_Rec."PVS Product Group Code");
            in_PL_Rec."PTE SOI Pages" := Global_JobRec.Pages;
            in_PL_Rec."PTE SOI Format Code" := Global_JobRec."Format Code";
            in_PL_Rec."PTE SOI Colors Front" := Global_JobRec."Colors Front";
            in_PL_Rec."PTE SOI Colors Back" := Global_JobRec."Colors Back";
            in_PL_Rec."PTE SOI Paper" := Global_JobRec.Paper;
        end;

        if Global_JobRec."Unchanged Rerun" <> in_PL_Rec."PTE SOI Unchanged Reprint" then
            Global_JobRec.Validate("Unchanged Rerun", in_PL_Rec."PTE SOI Unchanged Reprint");

        if Global_JobRec.Quantity <> in_PL_Rec.Quantity then
            Global_JobRec.Validate(Quantity, in_PL_Rec.Quantity);

        if Global_JobRec.Pages <> in_PL_Rec."PTE SOI Pages" then
            Global_JobRec.Validate(Pages, in_PL_Rec."PTE SOI Pages");

        if Global_JobRec."Format Code" <> in_PL_Rec."PTE SOI Format Code" then
            Global_JobRec.Validate("Format Code", in_PL_Rec."PTE SOI Format Code");

        if Global_JobRec."Colors Front" <> in_PL_Rec."PTE SOI Colors Front" then
            Global_JobRec.Validate("Colors Front", in_PL_Rec."PTE SOI Colors Front");

        if Global_JobRec."Colors Back" <> in_PL_Rec."PTE SOI Colors Back" then
            Global_JobRec.Validate("Colors Back", in_PL_Rec."PTE SOI Colors Back");

        if Global_JobRec.Paper <> in_PL_Rec."PTE SOI Paper" then
            Global_JobRec.Validate(Paper, in_PL_Rec."PTE SOI Paper");

        if Global_JobRec."Job Name" <> in_PL_Rec.Description then
            Global_JobRec.Validate("Job Name", in_PL_Rec.Description);

        if in_PL_Rec."Expected Receipt Date" <> Global_JobRec."Requested Delivery Date" then
            Global_JobRec.Validate("Requested Delivery DateTime", CreateDatetime(in_PL_Rec."Expected Receipt Date", 120000T));

        if Global_JobRec."Item No." <> in_PL_Rec."No." then
            Global_JobRec.Validate("Item No.", in_PL_Rec."No.");

        Global_JobRec."Cross Reference No." := in_PL_Rec."Item Reference No.";

        Global_JobRec.Modify(true);

        Global_JobRec.Default_Description;
        Global_JobRec.CalcFields(Description);

        Global_OrderRec.get(Global_OrderRec.id);
        Global_OrderRec.Validate("Can Be Planned");
        Global_OrderRec.Modify(true);

        in_PL_Rec."PVS ID 1" := Global_JobRec.ID;
        in_PL_Rec."PVS ID 2" := 1;
        in_PL_Rec."PVS Order No." := Global_OrderRec."Order No.";
        ok := in_PL_Rec.Modify();
    end;

    local procedure GetProductGroupFromItemsTemplate(ItemNo: Code[20]): Code[20]
    var
        ItemRec: Record Item;
        JobRec: Record "PVS Job";
    begin
        if not ItemRec.Get(ItemNo) then
            exit;
        if ItemRec."PVS Template ID" = 0 then
            exit;
        if not JobRec.Get(ItemRec."PVS Template ID", ItemRec."PVS Template Job", ItemRec."PVS Template Version") then
            exit;
        exit(JobRec."Product Group");
    end;

    procedure Delete_P_Order_PurchaseLine(var in_PL_Rec: Record "Purchase Line")
    begin
        if in_PL_Rec."PVS ID 1" = 0 then
            exit;

        if not Global_OrderRec.Get(in_PL_Rec."PVS ID 1") then
            exit;

        Global_OrderRec.Delete(true);

        in_PL_Rec."PVS ID 1" := 0;
        in_PL_Rec."PVS ID 2" := 0;
        in_PL_Rec."PVS ID 3" := 0;
        in_PL_Rec."PTE SOI Production Order" := false;
        in_PL_Rec.Modify();
    end;

    // GEN PROD FUNCTIONS
    procedure Copy_Previous_P_Order(var in_SL_Rec: Record "Sales Line"; var OLD_ID1: Integer; var OLD_ID2: Integer; var OLD_ID3: Integer): Boolean
    var
        InvoiceLineRec: Record "Sales Invoice Line";
        OLD_REC: Record "PVS Job";
        IntentMgt: Codeunit "PVS Intent Management";
        isHandled: Boolean;
    begin
        OLD_ID1 := 0;
        OLD_ID2 := 0;
        OLD_ID3 := 0;

        OnBefore_Copy_Previous_P_Order(in_SL_Rec, OLD_ID1, OLD_ID2, OLD_ID3, isHandled);

        if isHandled then exit(false);

        if (in_SL_Rec."Sell-to Customer No." = '') or (in_SL_Rec."Item Reference No." = '') then
            exit(false);

        if not in_SL_Rec."PTE SOI Production Order" then
            exit(false);

        if in_SL_Rec."PVS ID" <> 0 then
            exit(false);

        // Get last Order with same Cross-Reference No. from Posted Invoices
        InvoiceLineRec.Reset();
        InvoiceLineRec.SetCurrentkey("Sell-to Customer No.");
        InvoiceLineRec.SetRange("Sell-to Customer No.", in_SL_Rec."Sell-to Customer No.");
        InvoiceLineRec.SetRange("Item Reference No.", in_SL_Rec."Item Reference No.");
        InvoiceLineRec.SetRange(Type, 2); // Item
        InvoiceLineRec.SetFilter("PVS ID 1", '<>0');

        if not InvoiceLineRec.FindLast() then
            exit(false);

        OLD_REC.Reset();
        OLD_REC.SetRange(ID, InvoiceLineRec."PVS ID 1");
        OLD_REC.SetRange(Job, InvoiceLineRec."PVS ID 2");
        OLD_REC.SetRange(Active, true);

        if not OLD_REC.FindLast() then
            exit(false);

        OLD_ID1 := OLD_REC.ID;
        OLD_ID2 := OLD_REC.Job;
        OLD_ID3 := OLD_REC.Version;

        in_SL_Rec."PVS Product Group Code" := OLD_REC."Product Group";
        in_SL_Rec.Quantity := OLD_REC.Quantity;
        in_SL_Rec."PTE SOI Pages" := OLD_REC.Pages;
        in_SL_Rec."PTE SOI Format Code" := OLD_REC."Format Code";
        in_SL_Rec."PTE SOI Colors Front" := OLD_REC."Colors Front";
        in_SL_Rec."PTE SOI Colors Back" := OLD_REC."Colors Back";
        in_SL_Rec."PTE SOI Paper" := OLD_REC.Paper;
        in_SL_Rec.Amount := OLD_REC."Quoted Price";

        exit(true);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOneJobPerLineGlobal_JobRecInsert(var Global_JobRec: Record "PVS Job"; var in_SL_Rec: Record "Sales Line"; var isHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBefore_Copy_Previous_P_Order(var in_SL_Rec: Record "Sales Line"; var OLD_ID1: Integer; var OLD_ID2: Integer; var OLD_ID3: Integer; var isHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfter_SalesLine_Insert_PrintVis(var SalesLine: Record "Sales Line"; var PVSJob: Record "PVS Job"; var isHandled: Boolean)
    begin
    end;

    /// <summary>
    /// This event is triggered before function "Delete_PrintVis_SalesLine" is applied in Codeunit "PTE SOI NAV API", The function can be replaced by using the isHandled pattern.
    /// </summary>
    /// <param name="SalesLine_p">The current Record of the Table Sales Line </param>
    /// <param name="IsHandled_p">Parameter of type Boolean to enable the isHandled pattern</param>

    [IntegrationEvent(false, false)]
    procedure OnBeforeDelete_PrintVis_SalesLine(var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
    end;

}