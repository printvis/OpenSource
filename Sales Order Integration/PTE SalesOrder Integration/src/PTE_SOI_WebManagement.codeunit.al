Codeunit 80107 "PTE SOI Web2PV Management"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Web2PVS Backend WEB", 'OnAfterInsertSalesHeader', '', true, false)]
    local procedure PVS_CU6010937_OnAfterInsertSalesHeader(var WebshopHeader: Record "PVS Web2PVS Header"; var SalesHeader: Record "Sales Header")
    begin
        SalesHeader.Validate("PTE SOI Status Code", WebshopHeader."Status Code");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Web2PVS Backend WEB", 'OnAfterCalculateHead', '', true, false)]
    local procedure OnAfterCalculateHead(var in_HeaderNo: Code[20])
    var
        WebRequestHeadRec: Record "PVS Web2PVS Header";
        WebRequestLineRec: Record "PVS Web2PVS Line";
    begin
        if not WebRequestHeadRec.get(in_HeaderNo) then
            exit;
        if WebRequestHeadRec."Sales Order No." = '' then
            exit;
        UpdateSalesOrderFromWebOrder(WebRequestHeadRec, WebRequestLineRec);


    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Web2PVS Backend NAV", 'OnAfterCreateNewOrder', '', true, false)]
    local procedure OnAfterCreateNewOrder(var HeaderRec: Record "PVS Web2PVS Header"; var LineRec: Record "PVS Web2PVS Line"; var HasSalesOrder: Boolean; var IsHandled: Boolean);
    begin
        if not HasSalesOrder then exit;
        UpdateSalesOrderFromWebOrder(HeaderRec, LineRec);
    end;


    local procedure UpdateSalesOrderFromWebOrder(var in_WebRequestHeadRec: Record "PVS Web2PVS Header"; in_WebRequestLineRec: Record "PVS Web2PVS Line")
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesLineTMP: Record "Sales Line" temporary;
        JobRec: Record "PVS Job";
        Global_SetupRec: Record "PVS Web2PVS Frontend Setup";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        ReleaseAfterChange: Boolean;
    begin
        IF in_WebRequestHeadRec."Sales Order No." = '' then
            exit;

        if not SalesHeader.Get(SalesHeader."Document Type"::Order, in_WebRequestHeadRec."Sales Order No.") then
            exit;

        Global_SetupRec.Get(in_WebRequestHeadRec."Frontend ID");

        // Update saleslines with P-order info
        in_WebRequestLineRec.Reset();
        in_WebRequestLineRec.SetRange("Header No.", in_WebRequestHeadRec."No.");
        in_WebRequestLineRec.SetRange("Production Order", true);
        in_WebRequestLineRec.setfilter("Case ID", '<>0');
        in_WebRequestLineRec.setfilter("Job ID", '<>0');
        if in_WebRequestLineRec.findset then
            repeat
                // Find matching Sales line
                SalesLine.setrange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.setrange("PVS ID", in_WebRequestLineRec."Case ID");
                SalesLine.setrange("PVS Job", in_WebRequestLineRec."Job ID");
                if SalesLine.findset(false) then
                    repeat
                        if not SalesLine."PTE SOI Production Order" then begin
                            SalesLineTMP := SalesLine;
                            SalesLineTMP."PTE SOI Production Order" := true;
                            // find Job
                            JobRec.setrange(ID, in_WebRequestLineRec."Case ID");
                            JobRec.SetRange(Job, in_WebRequestLineRec."Job ID");
                            if JobRec.FindFirst() then begin

                                SalesLineTMP."PTE SOI Pages" := JobRec.Pages;
                                SalesLineTMP."PTE SOI Format Code" := JobRec."Format Code";
                                SalesLineTMP."PTE SOI Colors Front" := JobRec."Colors Front";
                                SalesLineTMP."PTE SOI Colors Back" := JobRec."Colors Back";
                            end;
                            if SalesLineTMP.insert then;
                        end;
                    until SalesLine.next = 0;
            until in_WebRequestLineRec.next = 0;


        // write required change
        if (not SalesLineTMP.IsEmpty) then begin
            //  Release Sales Order if needed
            if SalesHeader.Status <> SalesHeader.Status::Open then begin
                ReleaseAfterChange := true;
                ReleaseSalesDoc.Reopen(SalesHeader);
                SalesHeader.get(SalesHeader."Document Type", SalesHeader."No.");
            end;

            if SalesLineTMP.findset(false) then
                repeat
                    SalesLine.get(SalesLineTMP."Document Type", SalesLineTMP."Document No.", SalesLineTMP."Line No.");
                    SalesLine."PTE SOI Production Order" := SalesLineTMP."PTE SOI Production Order";
                    SalesLine."PTE SOI Pages" := SalesLineTMP."PTE SOI Pages";
                    SalesLine."PTE SOI Format Code" := SalesLineTMP."PTE SOI Format Code";
                    SalesLine."PTE SOI Colors Front" := SalesLineTMP."PTE SOI Colors Front";
                    SalesLine."PTE SOI Colors Back" := SalesLineTMP."PTE SOI Colors Back";
                    if SalesLine.modify then;
                until SalesLineTMP.next = 0;

            if (SalesHeader."PTE SOI Status Code" <> Global_SetupRec."Status Code") and (SalesHeader."PTE SOI Status Code" = '') then begin
                SalesHeader.Validate("PTE SOI Status Code", Global_SetupRec."Status Code");
                SalesHeader.Modify(true);
            end;

            if ReleaseAfterChange then begin
                SalesHeader.get(SalesHeader."Document Type", SalesHeader."No.");
                ReleaseSalesDoc.ReleaseSalesHeader(SalesHeader, false);
            end;
        end;

        // --- Release Sales Order ---
        if Global_SetupRec."Release Sales Order" then begin
            if SalesHeader.Get(SalesHeader."Document Type"::Order, in_WebRequestHeadRec."Sales Order No.") then begin
                ReleaseSalesDoc.PerformManualRelease(SalesHeader);

                SalesHeader.Get(SalesHeader."Document Type"::Order, in_WebRequestHeadRec."Sales Order No.");
                if (SalesHeader."PTE SOI Status Code" <> Global_SetupRec."Status Code") and (Global_SetupRec."Status Code" <> '') then begin
                    SalesHeader.Validate("PTE SOI Status Code", Global_SetupRec."Status Code");
                    SalesHeader.Modify(true);
                end;
            end;
        end;
    end;
}

