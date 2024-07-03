Codeunit 80106 "PTE SOI Status Management"
{
    procedure Set_State_Quote_Default(var in_OrderRec: Record "Sales Header")
    var
        StatusRec: Record "PVS Status Code";
    begin
        StatusRec.Reset();
        StatusRec.SetRange(User, '');
        StatusRec.SetRange("Default Quote", true);
        if not StatusRec.FindFirst() then
            exit;

        if in_OrderRec."PTE SOI Status Code" = StatusRec.Code then
            exit;

        in_OrderRec.Validate("PTE SOI Status Code", StatusRec.Code);
        in_OrderRec.Modify(true);
        in_OrderRec.get(in_OrderRec."Document Type", in_OrderRec."No.");
    end;

    procedure Set_State_QuoteOffered_Default(var in_OrderRec: Record "Sales Header")
    var
        StatusRec: Record "PVS Status Code";
    begin
        StatusRec.Reset();
        StatusRec.SetRange(User, '');
        StatusRec.SetRange("Default Quoted", true);
        if not StatusRec.FindFirst() then
            exit;

        if in_OrderRec."PTE SOI Status Code" = StatusRec.Code then
            exit;

        in_OrderRec.Validate("PTE SOI Status Code", StatusRec.Code);
        in_OrderRec.Modify(true);
        in_OrderRec.get(in_OrderRec."Document Type", in_OrderRec."No.");
    end;

    procedure Set_State_Order_Default(var in_OrderRec: Record "Sales Header")
    var
        StatusRec: Record "PVS Status Code";
    begin
        StatusRec.Reset();
        StatusRec.SetRange(User, '');
        if not StatusRec.FindFirst() then
            exit;

        if in_OrderRec."PTE SOI Status Code" = StatusRec.Code then
            exit;

        in_OrderRec.Validate("PTE SOI Status Code", StatusRec.Code);
        in_OrderRec.Modify(true);
        in_OrderRec.get(in_OrderRec."Document Type", in_OrderRec."No.");
    end;

    procedure Set_State_Prod_Ready_Default(var in_OrderRec: Record "Sales Header")
    var
        StatusRec: Record "PVS Status Code";
    begin
        StatusRec.Reset();
        StatusRec.SetRange(User, '');
        if not StatusRec.FindFirst() then
            exit;

        if in_OrderRec."PTE SOI Status Code" = StatusRec.Code then
            exit;

        in_OrderRec.Validate("PTE SOI Status Code", StatusRec.Code);
        in_OrderRec.Modify(true);
        in_OrderRec.get(in_OrderRec."Document Type", in_OrderRec."No.");
    end;

    procedure Set_SOstatus_Shipped_Part(var in_OrderRec: Record "Sales Header")
    var
        StatusRec: Record "PVS Status Code";
    begin
        StatusRec.Reset();
        StatusRec.SetRange(User, '');
        StatusRec.SetRange("Std. Sales Order Part. Shipped", true);
        if not StatusRec.FindFirst() then
            exit;

        if in_OrderRec."PTE SOI Status Code" = StatusRec.Code then
            exit;

        if not StatusRec.Is_Higher_Status(in_OrderRec."PTE SOI Status Code", StatusRec.Code) then
            exit;

        in_OrderRec.Validate("PTE SOI Status Code", StatusRec.Code);
        in_OrderRec.Modify(true);
        in_OrderRec.get(in_OrderRec."Document Type", in_OrderRec."No.");
    end;

    procedure Set_SOstatus_Shipped_Full(var in_OrderRec: Record "Sales Header")
    var
        StatusRec: Record "PVS Status Code";
    begin
        StatusRec.Reset();
        StatusRec.SetRange(User, '');
        StatusRec.SetRange("Std. Sales Order Fully Shipped", true);
        if not StatusRec.FindFirst() then
            exit;

        if in_OrderRec."PTE SOI Status Code" = StatusRec.Code then
            exit;

        if not StatusRec.Is_Higher_Status(in_OrderRec."PTE SOI Status Code", StatusRec.Code) then
            exit;

        in_OrderRec.Validate("PTE SOI Status Code", StatusRec.Code);
        in_OrderRec.Modify(true);
        in_OrderRec.get(in_OrderRec."Document Type", in_OrderRec."No.");
    end;

    procedure Set_State_Invoiced_Default(var in_OrderRec: Record "Sales Header")
    var
        StatusRec: Record "PVS Status Code";
    begin
        StatusRec.Reset();
        StatusRec.SetRange(User, '');
        StatusRec.SetRange("Default Invoiced", true);
        if not StatusRec.FindFirst() then
            exit;

        if in_OrderRec."PTE SOI Status Code" = StatusRec.Code then
            exit;

        if not StatusRec.Is_Higher_Status(in_OrderRec."PTE SOI Status Code", StatusRec.Code) then
            exit;

        in_OrderRec.Validate("PTE SOI Status Code", StatusRec.Code);
        in_OrderRec.Modify(true);
        in_OrderRec.get(in_OrderRec."Document Type", in_OrderRec."No.");
    end;

}