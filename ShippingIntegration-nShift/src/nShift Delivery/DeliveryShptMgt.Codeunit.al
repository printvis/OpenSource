namespace PrintVis.OpenSource.NShift.Delivery;

using PrintVis.OpenSource.NShift.Delivery.API;
using PrintVis.OpenSource.NShift.Delivery.Setup;
using System.Utilities;
using Microsoft.Foundation.Shipping;

codeunit 80169 "SINS Delivery Shpt. Mgt."
{
    var
        ErrorHelper: Codeunit "PVS Error Logging Management";
        ApiClient: Codeunit "SINS Delivery API Client";
        RequestBuilder: Codeunit "SINS Delivery Req. Builder";
        ResponseHandler: Codeunit "SINS Delivery Resp. Handler";
        Validation: Codeunit "SINS Delivery Validation";

    procedure CreateShipment(
        in_Action: Enum "PVS Shipping Action";
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    var
        Tracing: Codeunit "PVS Shipping Integration Trc.";
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        RequestJson,
        ResponseJson : Text;
        HasAnyErrors: Boolean;
    begin
        HasAnyErrors := false;

        this.Validation.ValidateShipmentCreation(out_Shipment);

        if this.ErrorHelper.HasErrors(out_ErrorMessageMgt) then
            HasAnyErrors := true
        else begin
            this.RequestBuilder.CreateShipmentObject(out_Shipment, false).WriteTo(RequestJson);

            Tracing.StartTrace();

            IsRequestSuccessful := this.ApiClient.RequestCreateShipment(RequestJson, HttpResponseMessage);

            Tracing.Log('', in_Action, RequestJson, IsRequestSuccessful);

            if IsRequestSuccessful then begin
                HttpResponseMessage.Content().ReadAs(ResponseJson);
                Tracing.Log('', in_Action, ResponseJson, HttpResponseMessage.IsSuccessStatusCode());
                if HttpResponseMessage.IsSuccessStatusCode() then
                    this.ResponseHandler.ProcessCreateShipmentResponse(out_Shipment, ResponseJson)
                else begin
                    this.ErrorHelper.LogResponseError(ResponseJson, out_ErrorMessageMgt);
                    HasAnyErrors := true;
                end;
            end else begin
                this.ErrorHelper.LogHttpClientError(HttpResponseMessage, out_ErrorMessageMgt);
                HasAnyErrors := true;
            end;

            Tracing.EndTrace();
        end;

        exit(not HasAnyErrors);
    end;

    procedure CreateShipment(
        in_Action: Enum "PVS Shipping Action";
        var out_CombinedShipmentHeader: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    var
        Tracing: Codeunit "PVS Shipping Integration Trc.";
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        RequestJson,
        ResponseJson : Text;
        HasAnyErrors: Boolean;
    begin
        HasAnyErrors := false;

        if out_CombinedShipmentHeader.FindSet() then
            repeat
                this.Validation.ValidateShipmentCreation(out_CombinedShipmentHeader);

                if this.ErrorHelper.HasErrors(out_ErrorMessageMgt) then
                    HasAnyErrors := true
                else begin
                    this.RequestBuilder.CreateShipmentObject(out_CombinedShipmentHeader, false).WriteTo(RequestJson);

                    Tracing.StartTrace();

                    IsRequestSuccessful := this.ApiClient.RequestCreateShipment(RequestJson, HttpResponseMessage);

                    Tracing.Log('', in_Action, RequestJson, IsRequestSuccessful);

                    if IsRequestSuccessful then begin
                        HttpResponseMessage.Content().ReadAs(ResponseJson);
                        Tracing.Log('', in_Action, ResponseJson, HttpResponseMessage.IsSuccessStatusCode());
                        if HttpResponseMessage.IsSuccessStatusCode() then
                            this.ResponseHandler.ProcessCreateShipmentResponse(out_CombinedShipmentHeader, out_CombinedShipmentLine, ResponseJson)
                        else begin
                            this.ErrorHelper.LogResponseError(ResponseJson, out_ErrorMessageMgt);
                            HasAnyErrors := true;
                        end;
                    end else begin
                        this.ErrorHelper.LogHttpClientError(HttpResponseMessage, out_ErrorMessageMgt);
                        HasAnyErrors := true;
                    end;

                    Tracing.EndTrace();
                end;
            until out_CombinedShipmentHeader.Next() = 0;

        exit(not HasAnyErrors);
    end;

    procedure CancelShipment(
        in_Action: Enum "PVS Shipping Action";
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    var
        Tracing: Codeunit "PVS Shipping Integration Trc.";
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        ResponseJson: Text;
        HasAnyErrors: Boolean;
    begin
        HasAnyErrors := false;

        Tracing.StartTrace();

        IsRequestSuccessful := this.ApiClient.RequestCancelShipment(out_Shipment."Shipment Id", HttpResponseMessage);

        Tracing.Log('', in_Action, StrSubstNo('%1: %2', out_Shipment.FieldCaption("Shipment Id"), out_Shipment."Shipment Id"), IsRequestSuccessful);

        if IsRequestSuccessful then begin
            HttpResponseMessage.Content().ReadAs(ResponseJson);
            Tracing.Log('', in_Action, ResponseJson, HttpResponseMessage.IsSuccessStatusCode());
            if HttpResponseMessage.IsSuccessStatusCode then
                this.ResponseHandler.ProcessCancelShipmentResponse(out_Shipment)
            else begin
                this.ErrorHelper.LogResponseError(ResponseJson, out_ErrorMessageMgt);
                HasAnyErrors := true;
            end;
        end else begin
            this.ErrorHelper.LogHttpClientError(HttpResponseMessage, out_ErrorMessageMgt);
            HasAnyErrors := true;
        end;

        Tracing.EndTrace();

        exit(not HasAnyErrors);
    end;

    procedure CancelShipment(
        in_Action: Enum "PVS Shipping Action";
        var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    var
        Tracing: Codeunit "PVS Shipping Integration Trc.";
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        ResponseJson: Text;
        HasAnyErrors: Boolean;
    begin
        HasAnyErrors := false;

        if out_CombinedShipment.FindSet() then
            repeat
                Tracing.StartTrace();

                IsRequestSuccessful := this.ApiClient.RequestCancelShipment(out_CombinedShipment."Shipment Id", HttpResponseMessage);

                Tracing.Log('', in_Action, StrSubstNo('%1: %2', out_CombinedShipment.FieldCaption("Shipment Id"), out_CombinedShipment."Shipment Id"), IsRequestSuccessful);

                if IsRequestSuccessful then begin
                    HttpResponseMessage.Content().ReadAs(ResponseJson);
                    Tracing.Log('', in_Action, ResponseJson, HttpResponseMessage.IsSuccessStatusCode());
                    if HttpResponseMessage.IsSuccessStatusCode then
                        this.ResponseHandler.ProcessCancelShipmentResponse(out_CombinedShipmentLine)
                    else begin
                        this.ErrorHelper.LogResponseError(ResponseJson, out_ErrorMessageMgt);
                        HasAnyErrors := true;
                    end;
                end else begin
                    this.ErrorHelper.LogHttpClientError(HttpResponseMessage, out_ErrorMessageMgt);
                    HasAnyErrors := true;
                end;

                Tracing.EndTrace();
            until out_CombinedShipment.Next() = 0;

        exit(not HasAnyErrors);
    end;

    procedure RetrieveShipmentStatus(
        in_Reference: Text;
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    var
        DeliverySetup: Record "SINS Delivery Setup";
        ShipmentTrackingUrlNotSetErr: Label '%1 is not set in the delivery setup.', Comment = '%1 = Shipment Tracking Url';
    begin
        DeliverySetup.Get();
        if (DeliverySetup."Shipment Tracking Url" = '') then begin
            out_ErrorMessageMgt.LogSimpleErrorMessage(StrSubstNo(ShipmentTrackingUrlNotSetErr, DeliverySetup.FieldCaption("Shipment Tracking Url")));
            exit(false);
        end;

        this.RetrieveShipmentStatus(DeliverySetup."Shipment Tracking Url",
            DeliverySetup."Language Code".Names.Get(DeliverySetup."Language Code".Ordinals.IndexOf(DeliverySetup."Language Code".AsInteger())),
            DeliverySetup."User Name",
            in_Reference);
    end;

    procedure FetchShippingRates(
        in_Action: Enum "PVS Shipping Action";
        var in_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    var
        Tracing: Codeunit "PVS Shipping Integration Trc.";
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        RequestJson,
        ResponseJson : Text;
        HasAnyErrors: Boolean;
    begin
        HasAnyErrors := false;

        this.Validation.ValidateShipmentCreation(in_Shipment);

        if this.ErrorHelper.HasErrors(out_ErrorMessageMgt) then
            HasAnyErrors := true
        else begin
            this.RequestBuilder.CreateShipmentObject(in_Shipment, true).WriteTo(RequestJson);

            Tracing.StartTrace();

            IsRequestSuccessful := this.ApiClient.RequestShipmentPrices(RequestJson, HttpResponseMessage);

            Tracing.Log('', in_Action, RequestJson, IsRequestSuccessful);

            if IsRequestSuccessful then begin
                HttpResponseMessage.Content().ReadAs(ResponseJson);
                Tracing.Log('', in_Action, ResponseJson, HttpResponseMessage.IsSuccessStatusCode());
                if HttpResponseMessage.IsSuccessStatusCode() then
                    this.ResponseHandler.ProcessFetchShippingRatesResponse(in_Shipment, ResponseJson)
                else begin
                    this.ErrorHelper.LogResponseError(ResponseJson, out_ErrorMessageMgt);
                    HasAnyErrors := true;
                end;
            end else begin
                this.ErrorHelper.LogHttpClientError(HttpResponseMessage, out_ErrorMessageMgt);
                HasAnyErrors := true;
            end;

            Tracing.EndTrace();
        end;

        exit(not HasAnyErrors);
    end;

    procedure FetchShippingRates(
        in_Action: Enum "PVS Shipping Action";
        var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    var
        Tracing: Codeunit "PVS Shipping Integration Trc.";
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        RequestJson,
        ResponseJson : Text;
        HasAnyErrors: Boolean;
    begin
        HasAnyErrors := false;

        if out_CombinedShipment.FindSet() then
            repeat
                //this.Validation.ValidateShipmentCreation(out_CombinedShipment);

                if this.ErrorHelper.HasErrors(out_ErrorMessageMgt) then
                    HasAnyErrors := true
                else begin
                    this.RequestBuilder.CreateShipmentObject(out_CombinedShipment, true).WriteTo(RequestJson);

                    Tracing.StartTrace();

                    IsRequestSuccessful := this.ApiClient.RequestShipmentPrices(RequestJson, HttpResponseMessage);

                    Tracing.Log('', in_Action, RequestJson, IsRequestSuccessful);

                    if IsRequestSuccessful then begin
                        HttpResponseMessage.Content().ReadAs(ResponseJson);
                        Tracing.Log('', in_Action, ResponseJson, HttpResponseMessage.IsSuccessStatusCode());
                        if HttpResponseMessage.IsSuccessStatusCode() then
                            this.ResponseHandler.ProcessFetchShippingRatesResponse(out_CombinedShipment, ResponseJson)
                        else begin
                            this.ErrorHelper.LogResponseError(ResponseJson, out_ErrorMessageMgt);
                            HasAnyErrors := true;
                        end;
                    end else begin
                        this.ErrorHelper.LogHttpClientError(HttpResponseMessage, out_ErrorMessageMgt);
                        HasAnyErrors := true;
                    end;

                    Tracing.EndTrace();
                end;
            until out_CombinedShipment.Next() = 0;

        exit(not HasAnyErrors);
    end;

    local procedure RetrieveShipmentStatus(
        in_ShipmentTrackingUrl: Text;
        in_LanguageCode: Text;
        in_UserName: Text;
        in_Reference: Text)
    begin
        Hyperlink(StrSubstNo(in_ShipmentTrackingUrl, in_LanguageCode, in_UserName, in_Reference));
    end;

    procedure IsEnabled(): Boolean
    var
        DeliverySetup: Record "SINS Delivery Setup";
    begin
        exit(DeliverySetup.IsEnabled());
    end;

    procedure IsDelivery(in_ShippingAgentCode: Code[10]): Boolean
    var
        ShippingAgent: Record "Shipping Agent";
    begin
        if ShippingAgent.Get(in_ShippingAgentCode) then
            exit(ShippingAgent."PVS Shipping Integration" = Enum::"PVS Shipping Integration"::"SINS nShift Delivery");
    end;
}