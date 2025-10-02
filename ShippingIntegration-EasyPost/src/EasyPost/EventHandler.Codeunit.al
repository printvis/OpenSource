namespace PrintVis.OpenSource.EasyPost;

using System.Utilities;
using PrintVis.OpenSource.EasyPost.Setup;
using Microsoft.Inventory.Location;

codeunit 80140 "SIEP Event Handler"
{
    SingleInstance = true;

    var
        VerifyAddressQst: Label 'You have changed the address. Do you want to verify the address now?';

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Shipping Integration Evts.", 'OnExecuteShippingAction', '', false, false)]
    local procedure ShippingIntegrationOnExecuteShippingAction(in_ShippingAction: Enum "PVS Shipping Action";
        in_Integration: Interface "PVS Shipping Integration";
        var out_ErrorMessageMgt: Codeunit "Error Message Management";
        in_IsCombinedShipment: Boolean;
        var out_Shipment: Record "PVS Job Shipment";
        var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
        var out_Result: Boolean;
        var out_IsHandled: Boolean)
    var
        EasyPostIntegration: Interface "SIEP Integration";
    begin
        case in_ShippingAction of
            Enum::"PVS Shipping Action"::"SIEP Verify Address":
                begin
                    EasyPostIntegration := in_Integration as "SIEP Integration";
                    out_Result := this.VerifyAddress(in_ShippingAction,
                        EasyPostIntegration,
                        out_ErrorMessageMgt,
                        in_IsCombinedShipment,
                        out_Shipment,
                        out_CombinedShipment,
                        out_CombinedShipmentLine);
                    out_IsHandled := true;
                end;
            Enum::"PVS Shipping Action"::"SIEP Buy Shipment":
                begin
                    EasyPostIntegration := in_Integration as "SIEP Integration";
                    out_Result := this.BuyShipment(in_ShippingAction,
                        EasyPostIntegration,
                        out_ErrorMessageMgt,
                        in_IsCombinedShipment,
                        out_Shipment,
                        out_CombinedShipment,
                        out_CombinedShipmentLine);
                    out_IsHandled := true;
                end;
        end;
    end;

    local procedure VerifyAddress(in_ShippingAction: Enum "PVS Shipping Action";
        in_Integration: Interface "SIEP Integration";
        var out_ErrorMessageMgt: Codeunit "Error Message Management";
        in_IsCombinedShipment: Boolean;
        var out_Shipment: Record "PVS Job Shipment";
        var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line"): Boolean
    begin
        if in_IsCombinedShipment then
            exit(in_Integration.VerifyAddress(in_ShippingAction, out_CombinedShipment, out_CombinedShipmentLine, out_ErrorMessageMgt))
        else
            exit(in_Integration.VerifyAddress(in_ShippingAction, out_Shipment, out_ErrorMessageMgt));
    end;

    local procedure BuyShipment(in_ShippingAction: Enum "PVS Shipping Action";
        in_Integration: Interface "SIEP Integration";
        var out_ErrorMessageMgt: Codeunit "Error Message Management";
        in_IsCombinedShipment: Boolean;
        var out_Shipment: Record "PVS Job Shipment";
        var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line"): Boolean
    begin
        if in_IsCombinedShipment then
            exit(in_Integration.BuyShipment(in_ShippingAction, out_CombinedShipment, out_CombinedShipmentLine, out_ErrorMessageMgt))
        else
            exit(in_Integration.BuyShipment(in_ShippingAction, out_Shipment, out_ErrorMessageMgt));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Shipping Integration Evts.", 'OnRegisterShippingApps', '', true, false)]
    local procedure RegisterEasyPostShippingApp(var out_ShippingApps: Record "PVS Shipping Apps")
    var
        EasyPostSetup: Record "SIEP Setup";
        ShippingIntegrationLbl: Label 'PrintVis Open Source - EasyPost';
    begin
        EasyPostSetup.Initialize();

        if EasyPostSetup.Enabled then
            out_ShippingApps.Status := out_ShippingApps.Status::Enabled
        else
            out_ShippingApps.Status := out_ShippingApps.Status::Disabled;

        out_ShippingApps.InsertShippingApp(out_ShippingApps, ShippingIntegrationLbl, EasyPostSetup.RecordId(), Page::"SIEP Setup");
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Shipment", 'OnAfterValidateEvent', 'Sender Code', false, false)]
    local procedure OnAfterValidateJobShipmentSenderCode(var Rec: Record "PVS Job Shipment"; var xRec: Record "PVS Job Shipment")
    var
        SenderAddress: Record "PVS Sender Address";
    begin
        if not SenderAddress.Get(Rec."Sender Code") then
            Clear(SenderAddress);

        Rec."SIEP Sender Address Id" := SenderAddress."SIEP Address Id";
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Shipment", 'OnAfterSetSenderAddressFromDefaultAddress', '', false, false)]
    local procedure OnAfterSetSenderAddressFromDefaultAddress(var JobShipment: Record "PVS Job Shipment"; ShippingSetup: Record "PVS Shipping Setup")
    begin
        JobShipment."SIEP Sender Address Id" := ShippingSetup."SIEP Address Id";
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Shipment", 'OnAfterSetSenderAddressFromLocation', '', false, false)]
    local procedure OnAfterSetShipToAddressFromLocation(var JobShipment: Record "PVS Job Shipment"; Location: Record Location)
    begin
        JobShipment."SIEP Ship-to Address Id" := Location."SIEP Address Id";
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Shipment", 'OnAfterSetSenderAddressFromSenderAddress', '', false, false)]
    local procedure OnAfterSetShipToAddressFromSenderAddress(var JobShipment: Record "PVS Job Shipment"; SenderAddress: Record "PVS Sender Address")
    begin
        JobShipment."SIEP Ship-to Address Id" := SenderAddress."SIEP Address Id";
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Shipping Setup", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyShippingSetup(var Rec: Record "PVS Shipping Setup"; var xRec: Record "PVS Shipping Setup"; RunTrigger: Boolean)
    var
        ConfirmMgt: Codeunit "Confirm Management";
        ErrorContextElement: Codeunit "Error Context Element";
        ErrorMessageHandler: Codeunit "Error Message Handler";
        ErrorMessageMgt: Codeunit "Error Message Management";
        EasyPostImpl: Codeunit "SIEP Implementation";
        EasyPostMgt: Codeunit "SIEP Mgt.";
    begin
        if not RunTrigger then
            exit;

        if not EasyPostMgt.IsEnabled() then
            exit;

        if (Rec.Name <> xRec.Name) or
            (Rec."Name 2" <> xRec."Name 2") or
            (Rec.Address <> xRec.Address) or
            (Rec."Address 2" <> xRec."Address 2") or
            (Rec."Post Code" <> xRec."Post Code") or
            (Rec.City <> xRec.City) or
            (Rec.County <> xRec.County) or
            (Rec."Country/Region Code" <> xRec."Country/Region Code")
        then begin
            Rec."SIEP Address Id" := '';
            Rec."SIEP Address Verified" := false;

            if ConfirmMgt.GetResponseOrDefault(VerifyAddressQst, true) then begin
                EasyPostMgt.ActivateErrorHandlingFor(ErrorMessageMgt, ErrorMessageHandler, ErrorContextElement, Rec.RecordId());
                EasyPostImpl.VerifyAddress(Enum::"PVS Shipping Action"::"SIEP Verify Address", Rec, ErrorMessageMgt);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Shipment", 'OnAfterValidateEvent', 'Name', false, false)]
    local procedure OnAfterValidateJobShipmentName(var Rec: Record "PVS Job Shipment"; var xRec: Record "PVS Job Shipment")
    begin
        if xRec.Name <> Rec.Name then begin
            Rec."SIEP Ship-to Address Id" := '';
            Rec."SIEP Ship-to Address Verified" := false;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Shipment", 'OnAfterValidateEvent', 'Name 2', false, false)]
    local procedure OnAfterValidateJobShipmentName2(var Rec: Record "PVS Job Shipment"; var xRec: Record "PVS Job Shipment")
    begin
        if xRec."Name 2" <> Rec."Name 2" then begin
            Rec."SIEP Ship-to Address Id" := '';
            Rec."SIEP Ship-to Address Verified" := false;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Shipment", 'OnAfterValidateEvent', 'Address', false, false)]
    local procedure OnAfterValidateJobShipmentAddress(var Rec: Record "PVS Job Shipment"; var xRec: Record "PVS Job Shipment")
    begin
        if xRec.Address <> Rec.Address then begin
            Rec."SIEP Ship-to Address Id" := '';
            Rec."SIEP Ship-to Address Verified" := false;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Shipment", 'OnAfterValidateEvent', 'Address 2', false, false)]
    local procedure OnAfterValidateJobShipmentAddress2(var Rec: Record "PVS Job Shipment"; var xRec: Record "PVS Job Shipment")
    begin
        if xRec."Address 2" <> Rec."Address 2" then begin
            Rec."SIEP Ship-to Address Id" := '';
            Rec."SIEP Ship-to Address Verified" := false;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Shipment", 'OnAfterValidateEvent', 'Post Code', false, false)]
    local procedure OnAfterValidateJobShipmentPostCode(var Rec: Record "PVS Job Shipment"; var xRec: Record "PVS Job Shipment")
    begin
        if xRec."Post Code" <> Rec."Post Code" then begin
            Rec."SIEP Ship-to Address Id" := '';
            Rec."SIEP Ship-to Address Verified" := false;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Shipment", 'OnAfterValidateEvent', 'City', false, false)]
    local procedure OnAfterValidateJobShipmentCity(var Rec: Record "PVS Job Shipment"; var xRec: Record "PVS Job Shipment")
    begin
        if xRec.City <> Rec.City then begin
            Rec."SIEP Ship-to Address Id" := '';
            Rec."SIEP Ship-to Address Verified" := false;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Shipment", 'OnAfterValidateEvent', 'County', false, false)]
    local procedure OnAfterValidateJobShipmentCounty(var Rec: Record "PVS Job Shipment"; var xRec: Record "PVS Job Shipment")
    begin
        if xRec.County <> Rec.County then begin
            Rec."SIEP Ship-to Address Id" := '';
            Rec."SIEP Ship-to Address Verified" := false;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Shipment", 'OnAfterValidateEvent', 'Country/Region Code', false, false)]
    local procedure OnAfterValidateJobShipmentCountryRegionCode(var Rec: Record "PVS Job Shipment"; var xRec: Record "PVS Job Shipment")
    begin
        if xRec."Country/Region Code" <> Rec."Country/Region Code" then begin
            Rec."SIEP Ship-to Address Id" := '';
            Rec."SIEP Ship-to Address Verified" := false;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Shipment", 'OnAfterValidateEvent', 'Ship-to EMail', false, false)]
    local procedure OnAfterValidateJobShipmentShipToEmail(var Rec: Record "PVS Job Shipment"; var xRec: Record "PVS Job Shipment")
    begin
        if xRec."Ship-to EMail" <> Rec."Ship-to EMail" then begin
            Rec."SIEP Ship-to Address Id" := '';
            Rec."SIEP Ship-to Address Verified" := false;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Shipment", 'OnAfterValidateEvent', 'Ship-to PhoneNo.', false, false)]
    local procedure OnAfterValidateJobShipmentShipToPhoneNo(var Rec: Record "PVS Job Shipment"; var xRec: Record "PVS Job Shipment")
    begin
        if xRec."Ship-to PhoneNo." <> Rec."Ship-to PhoneNo." then begin
            Rec."SIEP Ship-to Address Id" := '';
            Rec."SIEP Ship-to Address Verified" := false;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job Shipment", 'OnAfterValidateEvent', 'Contact', false, false)]
    local procedure OnAfterValidateJobShipmentContact(var Rec: Record "PVS Job Shipment"; var xRec: Record "PVS Job Shipment")
    begin
        if xRec.Contact <> Rec.Contact then begin
            Rec."SIEP Ship-to Address Id" := '';
            Rec."SIEP Ship-to Address Verified" := false;
        end;
    end;

    // [EventSubscriber(ObjectType::Table, Database::"PVS Job Shipment", 'OnAfterModifyEvent', '', false, false)]
    // local procedure OnAfterModifyJobShipment(var Rec: Record "PVS Job Shipment"; var xRec: Record "PVS Job Shipment")
    // var
    //     //EasyPostImpl: Codeunit "SIEP Implementation";
    //     EasyPostMgt: Codeunit "SIEP Mgt.";
    // // ConfirmMgt: Codeunit "Confirm Management";
    // // ErrorMessageMgt: Codeunit "Error Message Management";
    // // ErrorMessageHandler: Codeunit "Error Message Handler";
    // // ErrorContextElement: Codeunit "Error Context Element";
    // begin
    //     if not (EasyPostMgt.IsEnabled() and EasyPostMgt.IsEasyPost(Rec."Shipping Agent Code")) then
    //         exit;

    //     if (Rec.Name <> xRec.Name) or
    //         (Rec."Name 2" <> xRec."Name 2") or
    //         (Rec.Address <> xRec.Address) or
    //         (Rec."Address 2" <> xRec."Address 2") or
    //         (Rec."Post Code" <> xRec."Post Code") or
    //         (Rec.City <> xRec.City) or
    //         (Rec.County <> xRec.County) or
    //         (Rec."Country/Region Code" <> xRec."Country/Region Code")
    //     then begin
    //         Rec."SIEP Ship-to Address Id" := '';
    //         Rec."SIEP Ship-to Address Verified" := false;

    //         // if ConfirmMgt.GetResponseOrDefault(VerifyAddressQst, true) then begin
    //         //     EasyPostMgt.ActivateErrorHandlingFor(ErrorMessageMgt, ErrorMessageHandler, ErrorContextElement, Rec.RecordId());
    //         //     EasyPostImpl.VerifyAddress(Enum::"PVS Shipping Action"::"Verify Address", Rec, ErrorMessageMgt);
    //         // end;
    //     end;
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Shipping Integration Evts.", 'OnBeforeExecuteShippingAction', '', false, false)]
    local procedure ShippingIntegrationOnBeforeExecuteShippingAction(in_ShippingAction: Enum "PVS Shipping Action";
        in_Integration: Interface "PVS Shipping Integration";
        var out_ErrorMessageMgt: Codeunit "Error Message Management";
        var out_Shipment: Record "PVS Job Shipment";
        var out_Result: Boolean;
        var out_IsHandled: Boolean)
    var
        EasyPostMgt: Codeunit "SIEP Mgt.";
    begin
        if (in_ShippingAction <> Enum::"PVS Shipping Action"::"View Shipping Rates") then
            exit;

        if not (EasyPostMgt.IsEnabled() and EasyPostMgt.IsEasyPost(out_Shipment."Shipping Agent Code")) then
            exit;

        EasyPostMgt.OpenShipmentRates(out_Shipment, true);

        out_Result := true;
        out_IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Shipping Integration Evts.", 'OnAfterExecuteShippingAction', '', false, false)]
    local procedure ShippingIntegrationOnAfterExecuteShippingAction(
        in_ShippingAction: Enum "PVS Shipping Action";
        in_Integration: Interface "PVS Shipping Integration";
        in_IsCombinedShipment: Boolean;
        in_IsBatchMode: Boolean;
       var out_ErrorMessageMgt: Codeunit "Error Message Management";
       var out_Shipment: Record "PVS Job Shipment";
       var out_CombinedShipment: Record "PVS Combined Shipment Header";
       var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
       var out_Result: Boolean)
    var
        JobShipmentRate: Record "PVS Job Shipment Rate";
        EasyPostMgt: Codeunit "SIEP Mgt.";
    begin
        if EasyPostMgt.IsEnabled() and EasyPostMgt.IsEasyPost(out_Shipment."Shipping Agent Code") then
            if in_ShippingAction = Enum::"PVS Shipping Action"::"Create Shipment" then begin
                JobShipmentRate.SetRange("Source Record ID", out_Shipment.RecordId);
                if JobShipmentRate.Count() > 0 then begin
                    Commit();
                    EasyPostMgt.OpenShipmentRates(out_Shipment, false);
                end;
            end;
    end;
}