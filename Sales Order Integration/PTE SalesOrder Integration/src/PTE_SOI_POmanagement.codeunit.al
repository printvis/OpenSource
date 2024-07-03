Codeunit 80101 "PTE SOI Purchase Order Mgt"
{
    var
        NV: Codeunit "PVS Global";
        SingleInstance: Codeunit "PVS SingleInstance";
        CacheMgt: Codeunit "PVS Cache Management";
        NTR: Codeunit "PVS ML Text Resource";

    procedure PurchHead_Insert(var in_PH_Rec: Record "Purchase Header")
    var
        UserRec: Record "PVS User Setup";
    begin
        if not NV.Use_PrintVis() then
            exit;

        if (in_PH_Rec."PTE SOI Coordinator" = '') or (in_PH_Rec."Purchaser Code" = '') or (in_PH_Rec."PTE SOI Status Code" = '') then
            if SingleInstance.Get_UserSetupRec(UserRec) then begin
                in_PH_Rec."PTE SOI Coordinator" := UserRec."Case Default Coordinator";
                in_PH_Rec."Purchaser Code" := UserRec."Case Default Salesperson";
                // Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order
                case in_PH_Rec."Document Type" of
                    in_PH_Rec."Document Type"::Order, in_PH_Rec."Document Type"::"Blanket Order", in_PH_Rec."Document Type"::"Return Order":
                        in_PH_Rec.Validate("PTE SOI Status Code", UserRec."PTE SOI Status Code New P.");
                end;
            end;
    end;

    procedure PurchHead_Recieve_ReturnStatus(var in_PH_Rec: Record "Purchase Header")
    var
        SH: Record "Sales Header";
        PL_Temp: Record "Purchase Line" temporary;
        UserSetupRec: Record "PVS User Setup";
        StatusRec: Record "PVS Status Code";
        SOIntProdOrderMgt: Codeunit "PTE SOI SOint Prod Order Mgt";
    begin
        SingleInstance.Get_UserSetupRec(UserSetupRec);
        StatusRec.Get(UserSetupRec."User ID", UserSetupRec."Status Code Goods Received");

        SOIntProdOrderMgt.READ_Tmp_Purchaselines(PL_Temp, in_PH_Rec."Document Type", in_PH_Rec."No.");
        PL_Temp.SetRange(Type, 2);
        PL_Temp.SetFilter("Sales Order No.", '<>%1', '');

        if PL_Temp.FindSet(false) then
            repeat
                if SH.Get(1, PL_Temp."Sales Order No.") then
                    if SH."PTE SOI Status Code" <> StatusRec.Code then
                        SH.Validate("PTE SOI Status Code", StatusRec.Code);
            until PL_Temp.Next() = 0;

        in_PH_Rec.Validate("PTE SOI Status Code", StatusRec.Code);
        in_PH_Rec.Modify(true);

        NTR.Message3(1034, StatusRec.Text, '', '');
    end;

    procedure PurchHead_Validate_StatusCode(var in_PH_Rec: Record "Purchase Header"; var in_xPH_Rec: Record "Purchase Header")
    var
        PH2: Record "Purchase Header";
        PL_Temp: Record "Purchase Line" temporary;
        StatusRec: Record "PVS Status Code";
        SOIntProdOrderMgt: Codeunit "PTE SOI SOint Prod Order Mgt";
        Is_Quote_to_Order: Boolean;
        ok: Boolean;
    begin
        Is_Quote_to_Order := false;

        if in_PH_Rec."PTE SOI Status Code" <> '' then begin
            StatusRec.Get('', in_PH_Rec."PTE SOI Status Code");
            if StatusRec."Deadline Date Expression" <> '' then
                in_PH_Rec."PTE SOI Deadline" := NV.xCALCDATE(StatusRec."Deadline Date Expression", Today());

            if (StatusRec.Status > 1) and (in_PH_Rec."Document Type" = in_PH_Rec."Document Type"::Quote) then
                Is_Quote_to_Order := true;
        end;

        PurchHead_Get_Responsible(in_PH_Rec);

        SOIntProdOrderMgt.READ_Tmp_Purchaselines(PL_Temp, in_PH_Rec."Document Type", in_PH_Rec."No.");
        PL_Temp.SetFilter("PVS ID 1", '<>0');

        // Log
        if in_xPH_Rec."No." = '' then
            if PH2.Get(in_PH_Rec."Document Type", in_PH_Rec."No.") then
                in_xPH_Rec."PTE SOI Status Code" := PH2."PTE SOI Status Code";

        ok := in_PH_Rec.Modify();
        Commit();
    end;

    procedure PurchHead_Validate_OrderType(var in_PH_Rec: Record "Purchase Header")
    var
        OrderTypeRec: Record "PVS Order Type";
    begin
        if OrderTypeRec.Get(in_PH_Rec."PTE SOI P-Order Type") then
            if OrderTypeRec."Status Code" <> '' then
                in_PH_Rec.Validate("PTE SOI Status Code", OrderTypeRec."Status Code");
    end;

    procedure PurchHead_Get_Responsible(var in_PH_Rec: Record "Purchase Header")
    var
        CustomerRec: Record Customer;
        ResponsibleRec: Record "PVS Status Responsiblity Area";
        New_Responsible: Code[100];
        ok: Boolean;
    begin
        New_Responsible := '';
        Clear(CustomerRec);
        ok := CustomerRec.Get(in_PH_Rec."Sell-to Customer No.");

        ResponsibleRec.SetFilter(Status, '%1|%2', in_PH_Rec."PTE SOI Status Code", '');
        ResponsibleRec.SetFilter("Order Type", '%1|%2', in_PH_Rec."PTE SOI P-Order Type", '');
        ResponsibleRec.SetFilter("Customer Group", '%1|%2', CustomerRec."PVS Customer Group Code", '');
        ResponsibleRec.SetFilter("Sell-To No.", '%1|%2', in_PH_Rec."Sell-to Customer No.", '');
        ResponsibleRec.SetFilter("From Date", '..%1', Today());
        ResponsibleRec.SetFilter("To Date", '%1..|%2', Today(), 0D);

        if ResponsibleRec.FindLast() then
            case ResponsibleRec.Responsible of
                0:
                    New_Responsible := ResponsibleRec."Responsible Code";
                1:
                    New_Responsible := SingleInstance.Get_Current_Logical_Login_User();
                2:
                    New_Responsible := in_PH_Rec."Purchaser Code";
                3:
                    New_Responsible := in_PH_Rec."PTE SOI Coordinator";
            end;

        if New_Responsible = '' then
            if in_PH_Rec."PTE SOI Coordinator" <> '' then
                New_Responsible := in_PH_Rec."PTE SOI Coordinator"
            else
                if in_PH_Rec."Purchaser Code" <> '' then
                    New_Responsible := in_PH_Rec."Purchaser Code"
                else
                    New_Responsible := SingleInstance.Get_Current_Logical_Login_User();

        case in_PH_Rec."PTE SOI Manual Responsible" of
            true:
                begin
                    if New_Responsible <> in_PH_Rec."PTE SOI Person Responsible" then
                        NTR.Message3(1030, in_PH_Rec."PTE SOI Person Responsible", New_Responsible, '');
                    in_PH_Rec."PTE SOI Manual Responsible" := false;
                end;
        end;
        in_PH_Rec."PTE SOI Person Responsible" := New_Responsible;
        in_PH_Rec.CalcFields("PTE SOI Person Respon. Name");
    end;

    procedure PurchHead_Get_Recieve_Date(var in_PH_Rec: Record "Purchase Header")
    var
        PL_Temp: Record "Purchase Line" temporary;
        SOIntProdOrderMgt: Codeunit "PTE SOI SOint Prod Order Mgt";
        First_Date: Date;
        ok: Boolean;
    begin
        if not NV.Use_PrintVis() then
            exit;

        First_Date := 0D;

        SOIntProdOrderMgt.READ_Tmp_Purchaselines(PL_Temp, in_PH_Rec."Document Type", in_PH_Rec."No.");
        PL_Temp.SetFilter("Outstanding Qty. (Base)", '<>0');

        if PL_Temp.FindSet(false) then
            repeat
                if (PL_Temp."Expected Receipt Date" < First_Date) or (First_Date = 0D) then
                    First_Date := PL_Temp."Expected Receipt Date";
            until PL_Temp.Next() = 0;

        if (First_Date <> 0D) and (First_Date <> in_PH_Rec."Expected Receipt Date") then begin
            in_PH_Rec."Expected Receipt Date" := First_Date;
            ok := in_PH_Rec.Modify();
        end;
    end;

    procedure PurchHead_Change_Next_Status(in_PH_Rec: Record "Purchase Header"; in_Is_Confirm: Boolean)
    var
        StatusRec: Record "PVS Status Code";
        New_Status: Code[20];
    begin
        New_Status := StatusRec.Get_Next_Status(0, in_PH_Rec."PTE SOI Status Code", in_PH_Rec."PTE SOI P-Order Type", '', in_PH_Rec."Buy-from Vendor No.");

        if New_Status = '' then
            exit;

        if in_Is_Confirm then
            if not NTR.Confirm3(1036, New_Status, '', '') then
                exit;

        in_PH_Rec.Validate("PTE SOI Status Code", New_Status);
    end;

    procedure PurchHead_Get_Next_StatusTxt(in_Rec: Record "Purchase Header"): Text[250]
    var
        StatusRec: Record "PVS Status Code";
    begin
        exit(
          StatusRec.Get_Next_Status(in_Rec."PVS ID",
          in_Rec."PTE SOI Status Code",
          in_Rec."PTE SOI P-Order Type",
          '',
          ''));
    end;

    procedure PurchHead_OnLookUp_Contact(var in_Rec: Record "Purchase Header"; in_Type: Option Buy,Pay,Ship)
    var
        ContactRec: Record Contact;
    begin
        case in_Type of
            In_type::Buy:
                ContactRec."Company No." := NV.Get_Contact2Vendor(in_Rec."Buy-from Vendor No.");
            In_type::Pay:
                ContactRec."Company No." := NV.Get_Contact2Vendor(in_Rec."Pay-to Vendor No.");
            In_type::Ship:
                ContactRec."Company No." := NV.Get_Contact2Vendor(in_Rec."Buy-from Vendor No.");
        end;
        if ContactRec."Company No." = '' then
            exit;

        ContactRec.SetCurrentkey("Company No.");
        ContactRec.SetRange("Company No.", ContactRec."Company No.");
        if Page.RunModal(0, ContactRec) <> Action::LookupOK then
            exit;

        ContactRec.Get(ContactRec."No.");
        case in_Type of
            In_type::Buy:
                in_Rec."Buy-from Contact" := ContactRec.Name;
            In_type::Pay:
                in_Rec."Pay-to Contact" := ContactRec.Name;
            In_type::Ship:
                in_Rec."Buy-from Contact" := ContactRec.Name;
        end;
    end;



    procedure PurchHead_Has_PrintVisCaseLink(in_Rec: Record "Purchase Header"): Boolean
    var
        PL: Record "Purchase Line";
    begin
        PL.Reset();
        PL.SetRange("Document Type", in_Rec."Document Type");
        PL.SetRange("Document No.", in_Rec."No.");

        if not PL.FindSet(false) then
            exit(false)
        else
            repeat
                if PL."PTE SOI Production Order" then
                    exit(true);
            until PL.Next() = 0;
    end;

    procedure PurchLine_Validate_Color(var in_PL_Rec: Record "Purchase Line")
    var
        Text003: label 'You cannot place print on the back when an even number of pages has been entered';
    begin
        if (in_PL_Rec."PTE SOI Colors Front" <> 0) and (in_PL_Rec."PTE SOI Colors Back" <> 0) then
            if in_PL_Rec."PTE SOI Pages" MOD 2 <> 0 then
                Error(Text003);
    end;

    procedure PurchLine_Validate_ProdOrder(var in_Rec: Record "Purchase Line")
    var
        PVmgt: Codeunit "PTE SOI SOint Prod Order Mgt";
    begin
        if in_Rec."PTE SOI Production Order" then
            PVMgt.Insert_P_Order_PurchaseLine(in_Rec)
        else
            if in_Rec."PVS ID 1" <> 0 then
                PVMgt.Delete_P_Order_PurchaseLine(in_Rec);
    end;

    procedure PurchLine_OrderNo_OnAfterInput(var in_Rec: Record "Purchase Line"; var in_Text: Text[1024])
    var
        OrderRec: Record "PVS Case";
    begin
        if not in_Rec."PTE SOI Production Order" then
            if in_Text = '' then
                in_Rec.Validate("PVS ID 1", 0)
            else begin
                OrderRec.Reset();
                OrderRec.SetCurrentkey("Order No.");
                OrderRec.SetRange("Order No.", in_Text);
                if OrderRec.FindFirst() then
                    in_Rec.Validate("PVS ID 1", OrderRec.ID);
            end;
    end;

    procedure Post_Recieve(var in_Rec: Record "Purchase Header")
    var
        PurchPost: Codeunit "Purch.-Post";
    begin
        in_Rec.Validate("Posting Date", Today());
        in_Rec.Receive := true;
        in_Rec.Invoice := false;
        PurchPost.Run(in_Rec);
    end;

}
