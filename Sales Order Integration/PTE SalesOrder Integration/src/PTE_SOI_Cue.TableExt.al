TableExtension 80101 "PTE SOI SOint Cue" extends "PVS Cue"
{
    fields
    {


        field(80101; "PTE User ID Purchase Approval"; Integer)
        {
            CalcFormula = count("Purchase Header" where("PTE SOI Person Responsible" = field("Responsibility Filter")));
            Caption = 'UserID Purchase Approval';
            Editable = false;
            FieldClass = FlowField;
        }

        field(80102; "PTE Sales Quotes Open"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Type" = filter(Quote),
                                                              Status = filter(Open),
                                                              "Responsibility Center" = field("Responsibility Center Filter"),
                                                              "PTE SOI Person Responsible" = field("Responsibility Filter")));
            Caption = 'Sales Quotes - Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80103; "PTE Sales Orders Open"; Integer)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = count("Sales Header" where("Document Type" = filter(Order),
                                                              Status = filter(Open),
                                                              "Responsibility Center" = field("Responsibility Center Filter"),
                                                              "PTE SOI Person Responsible" = field("Responsibility Filter")));
            Caption = 'Sales Orders - Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80104; "PTE Ready To Ship"; Integer)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = count("Sales Header" where("Document Type" = filter(Order),
                                                              Status = filter(Released),
                                                              "Completely Shipped" = const(false),
                                                              "Shipment Date" = field("Date Filter 2"),
                                                              "Responsibility Center" = field("Responsibility Center Filter"),
                                                              "PTE SOI Person Responsible" = field("Responsibility Filter")));
            Caption = 'Ready to Ship';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80105; "PTE Delayed"; Integer)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = count("Sales Header" where("Document Type" = filter(Order),
                                                              Status = filter(Released),
                                                              "Completely Shipped" = const(false),
                                                              "Shipment Date" = field("Date Filter"),
                                                              "Responsibility Center" = field("Responsibility Center Filter"),
                                                              "Late Order Shipping" = filter(true),
                                                              "PTE SOI Person Responsible" = field("Responsibility Filter")));
            Caption = 'Delayed';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80106; "PTE Sales Return Orders Open"; Integer)
        {
            AccessByPermission = TableData "Return Receipt Header" = R;
            CalcFormula = count("Sales Header" where("Document Type" = filter("Return Order"),
                                                              Status = filter(Open),
                                                              "Responsibility Center" = field("Responsibility Center Filter"),
                                                              "PTE SOI Person Responsible" = field("Responsibility Filter")));
            Caption = 'Sales Return Orders - Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80107; "PTE Sales Credit Memos Open"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Type" = filter("Credit Memo"),
                                                              Status = filter(Open),
                                                              "Responsibility Center" = field("Responsibility Center Filter"),
                                                              "PTE SOI Person Responsible" = field("Responsibility Filter")));
            Caption = 'Sales Credit Memos - Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80108; "PTE Partially Shipped"; Integer)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = count("Sales Header" where("Document Type" = filter(Order),
                                                              Status = filter(Released),
                                                              "Shipping No." = filter('YES'),
                                                              "Completely Shipped" = filter(false),
                                                              "Shipment Date" = field("Date Filter 2"),
                                                              "Responsibility Center" = field("Responsibility Center Filter"),
                                                              "PTE SOI Person Responsible" = field("Responsibility Filter")));
            Caption = 'Partially Shipped';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80109; "PTE Outstanding P. Orders"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = filter(Order),
                                                         Status = filter(Released),
                                                         Receive = filter(true),
                                                         "Completely Received" = filter(false),
                                                         "PTE SOI Person Responsible" = field("Responsibility Filter")));
            Caption = 'Outstanding Purchase Orders';
            Editable = false;
            FieldClass = FlowField;
        }

    }

    procedure PTE_CalculateAverageDaysDelayed() AverageDays: Decimal
    var
        SalesHeader: Record "Sales Header";
        CountDelayedInvoices: Integer;
        SumDelayDays: Integer;
    begin
        PTE_FilterOrders(SalesHeader, FieldNo("PTE Delayed"));
        if SalesHeader.FindSet() then begin
            repeat
                SumDelayDays += PTE_MaximumDelayAmongLines(SalesHeader);
                CountDelayedInvoices += 1;
            until SalesHeader.Next() = 0;
            AverageDays := SumDelayDays / CountDelayedInvoices;
        end;
    end;

    local procedure PTE_MaximumDelayAmongLines(SalesHeader: Record "Sales Header") MaxDelay: Integer
    var
        SalesLine: Record "Sales Line";
    begin
        MaxDelay := 0;
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetFilter("Shipment Date", '<%1&<>%2', WorkDate(), 0D);
        if SalesLine.FindSet() then
            repeat
                if WorkDate() - SalesLine."Shipment Date" > MaxDelay then
                    MaxDelay := WorkDate() - SalesLine."Shipment Date";
            until SalesLine.Next() = 0;
    end;

    procedure PTE_CountOrders(FieldNumber: Integer): Integer
    var
        PVS_UserSetup: Record "PVS User Setup";
        PVS_SingleInstance: Codeunit "PVS SingleInstance";
        PVSCountSalesOrders: Query "PTE SOI Count Sales Orders";
        SalesDocStatus: Enum "Sales Document Status";
    begin
        PVSCountSalesOrders.SetFilter(Status, '%1', SalesDocStatus::Released);
        PVSCountSalesOrders.SetRange(Completely_Shipped, false);

        // PrintVis
        // Responsible Filter
        if PVS_UserSetup.Get(PVS_SingleInstance.Get_Current_Logical_Login_User()) then;

        if PVS_UserSetup."Responsibility Areas" = '' then
            PVS_UserSetup."Responsibility Areas" := PVS_SingleInstance.Get_Current_Logical_Login_User();

        PVS_UserSetup."Responsibility Areas" := ConvertStr(PVS_UserSetup."Responsibility Areas", ',', '|');

        PVSCountSalesOrders.SetFilter(PVS_Person_Responsible, PVS_UserSetup."Responsibility Areas");
        // PrintVis

        FilterGroup(2);
        PVSCountSalesOrders.SetFilter(Responsibility_Center, GetFilter("Responsibility Center Filter"));
        FilterGroup(0);

        case FieldNumber of
            FieldNo("PTE Ready To Ship"):
                begin
                    PVSCountSalesOrders.SetRange(Ship);
                    PVSCountSalesOrders.SetFilter(Shipment_Date, GetFilter("Date Filter 2"));
                end;
            FieldNo("PTE Partially Shipped"):
                begin
                    PVSCountSalesOrders.SetRange(Shipped, true);
                    PVSCountSalesOrders.SetFilter(Shipment_Date, GetFilter("Date Filter 2"));
                end;
            FieldNo("PTE Delayed"):
                begin
                    PVSCountSalesOrders.SetRange(Ship);
                    PVSCountSalesOrders.SetFilter(Date_Filter, GetFilter("Date Filter"));
                    PVSCountSalesOrders.SetRange(Late_Order_Shipping, true);
                end;
        end;
        PVSCountSalesOrders.Open();
        PVSCountSalesOrders.Read();
        exit(PVSCountSalesOrders.Count_Orders);
        exit(0)
    end;

    local procedure PTE_FilterOrders(var SalesHeader: Record "Sales Header"; FieldNumber: Integer)
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."document type"::Order);
        SalesHeader.SetRange(Status, SalesHeader.Status::Released);
        SalesHeader.SetRange("Completely Shipped", false);
        case FieldNumber of
            FieldNo("PTE Ready To Ship"):
                begin
                    SalesHeader.SetRange(Ship);
                    SalesHeader.SetFilter("Shipment Date", GetFilter("Date Filter 2"));
                end;
            FieldNo("PTE Partially Shipped"):
                begin
                    SalesHeader.SetRange(Shipped, true);
                    SalesHeader.SetFilter("Shipment Date", GetFilter("Date Filter 2"));
                end;
            FieldNo("PTE Delayed"):
                begin
                    SalesHeader.SetRange(Ship);
                    SalesHeader.SetFilter("Date Filter", GetFilter("Date Filter"));
                    SalesHeader.SetRange("Late Order Shipping", true);
                end;
        end;
        FilterGroup(2);
        SalesHeader.SetFilter("Responsibility Center", GetFilter("Responsibility Center Filter"));
        FilterGroup(0);
    end;

    procedure PTE_ShowOrders(FieldNumber: Integer)
    var
        SalesHeader: Record "Sales Header";
    begin
        PTE_FilterOrders(SalesHeader, FieldNumber);
        Page.Run(Page::"Sales Order List", SalesHeader);
    end;
}

