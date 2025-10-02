namespace PrintVis.OpenSource.EasyPost;

using PrintVis.OpenSource.EasyPost.API;
using System.Utilities;
using Microsoft.Inventory.Location;
using Microsoft.Foundation.Shipping;
using PrintVis.OpenSource.EasyPost.Setup;

codeunit 80135 "SIEP Mgt."
{
    var
        ErrorHelper: Codeunit "PVS Error Logging Management";
        Tracing: Codeunit "PVS Shipping Integration Trc.";
        EasyPostAPIClient: codeunit "SIEP API Client";
        RequestBuilder: codeunit "SIEP Request Builder";
        ResponseHandler: codeunit "SIEP Resp. Handler";
        Validator: Codeunit "SIEP Validator";

    procedure VerifyAddress(in_Action: enum "PVS Shipping Action";
        var out_ShippingSetup: Record "PVS Shipping Setup";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    var
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        RequestJson,
        ResponseJson : Text;
    begin
        this.RequestBuilder.CreateVerifyAddressObject(out_ShippingSetup).WriteTo(RequestJson);

        this.Tracing.StartTrace();

        IsRequestSuccessful := this.EasyPostAPIClient.RequestVerifyAddress(RequestJson, HttpResponseMessage);

        this.Tracing.Log('', in_Action, RequestJson, IsRequestSuccessful);

        if IsRequestSuccessful then begin
            HttpResponseMessage.Content().ReadAs(ResponseJson);
            this.Tracing.Log('', in_Action, ResponseJson, HttpResponseMessage.IsSuccessStatusCode());
            if HttpResponseMessage.IsSuccessStatusCode() then
                this.ResponseHandler.ProcessVerifyAddress(out_ShippingSetup, ResponseJson, out_ErrorMessageMgt)
            else
                this.ErrorHelper.LogResponseError(ResponseJson, out_ErrorMessageMgt);
        end else
            this.ErrorHelper.LogHttpClientError(HttpResponseMessage, out_ErrorMessageMgt);

        this.Tracing.EndTrace();

        exit(not this.ErrorHelper.HasErrors(out_ErrorMessageMgt));
    end;

    procedure VerifyAddress(in_Action: enum "PVS Shipping Action";
        var out_SenderAddress: Record "PVS Sender Address";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    var
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        RequestJson,
        ResponseJson : Text;
    begin
        this.RequestBuilder.CreateVerifyAddressObject(out_SenderAddress).WriteTo(RequestJson);

        this.Tracing.StartTrace();

        IsRequestSuccessful := EasyPostAPIClient.RequestVerifyAddress(RequestJson, HttpResponseMessage);

        this.Tracing.Log('', in_Action, RequestJson, IsRequestSuccessful);

        if IsRequestSuccessful then begin
            HttpResponseMessage.Content().ReadAs(ResponseJson);
            this.Tracing.Log('', in_Action, ResponseJson, HttpResponseMessage.IsSuccessStatusCode());
            if HttpResponseMessage.IsSuccessStatusCode() then
                this.ResponseHandler.ProcessVerifyAddress(out_SenderAddress, ResponseJson, out_ErrorMessageMgt)
            else
                this.ErrorHelper.LogResponseError(ResponseJson, out_ErrorMessageMgt);
        end else
            this.ErrorHelper.LogHttpClientError(HttpResponseMessage, out_ErrorMessageMgt);

        this.Tracing.EndTrace();

        exit(not this.ErrorHelper.HasErrors(out_ErrorMessageMgt));
    end;

    procedure VerifyAddress(in_Action: enum "PVS Shipping Action";
        var out_Location: Record "Location";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    var
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        RequestJson,
        ResponseJson : Text;
    begin
        this.RequestBuilder.CreateVerifyAddressObject(out_Location).WriteTo(RequestJson);

        this.Tracing.StartTrace();

        IsRequestSuccessful := this.EasyPostAPIClient.RequestVerifyAddress(RequestJson, HttpResponseMessage);

        this.Tracing.Log('', in_Action, RequestJson, IsRequestSuccessful);

        if IsRequestSuccessful then begin
            HttpResponseMessage.Content().ReadAs(ResponseJson);
            this.Tracing.Log('', in_Action, ResponseJson, HttpResponseMessage.IsSuccessStatusCode());
            if HttpResponseMessage.IsSuccessStatusCode() then
                this.ResponseHandler.ProcessVerifyAddress(out_Location, ResponseJson, out_ErrorMessageMgt)
            else
                this.ErrorHelper.LogResponseError(ResponseJson, out_ErrorMessageMgt);
        end else
            this.ErrorHelper.LogHttpClientError(HttpResponseMessage, out_ErrorMessageMgt);

        this.Tracing.EndTrace();

        exit(not this.ErrorHelper.HasErrors(out_ErrorMessageMgt));
    end;

    procedure VerifyAddress(in_Action: enum "PVS Shipping Action";
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    var
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        RequestJson,
        ResponseJson : Text;
    begin
        this.RequestBuilder.CreateVerifyAddressObject(out_Shipment).WriteTo(RequestJson);

        this.Tracing.StartTrace();

        IsRequestSuccessful := this.EasyPostAPIClient.RequestVerifyAddress(RequestJson, HttpResponseMessage);

        this.Tracing.Log('', in_Action, RequestJson, IsRequestSuccessful);

        if IsRequestSuccessful then begin
            HttpResponseMessage.Content().ReadAs(ResponseJson);
            this.Tracing.Log('', in_Action, ResponseJson, HttpResponseMessage.IsSuccessStatusCode());
            if HttpResponseMessage.IsSuccessStatusCode() then
                this.ResponseHandler.ProcessVerifyAddress(out_Shipment, ResponseJson, out_ErrorMessageMgt)
            else
                this.ErrorHelper.LogResponseError(ResponseJson, out_ErrorMessageMgt);
        end else
            this.ErrorHelper.LogHttpClientError(HttpResponseMessage, out_ErrorMessageMgt);

        this.Tracing.EndTrace();

        exit(not this.ErrorHelper.HasErrors(out_ErrorMessageMgt));
    end;

    procedure CreateOrder(in_Action: enum "PVS Shipping Action";
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    var
        EasyPostSetup: Record "SIEP Setup";
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        RequestJson,
        ResponseJson : Text;
    begin
        EasyPostSetup.Get();

        this.Validator.CreateOrderValidate(out_Shipment);

        if this.ErrorHelper.HasErrors(out_ErrorMessageMgt) then
            exit(false);

        this.RequestBuilder.CreateCreateOrderObject(out_Shipment,
            EasyPostSetup."Label Size",
            EasyPostSetup."Label Type").WriteTo(RequestJson);

        this.Tracing.StartTrace();

        IsRequestSuccessful := this.EasyPostAPIClient.RequestCreateOrder(RequestJson, HttpResponseMessage);

        this.Tracing.Log('', in_Action, RequestJson, IsRequestSuccessful);

        if IsRequestSuccessful then begin
            HttpResponseMessage.Content().ReadAs(ResponseJson);
            this.Tracing.Log('', in_Action, ResponseJson, HttpResponseMessage.IsSuccessStatusCode());
            if HttpResponseMessage.IsSuccessStatusCode() then
                this.ResponseHandler.ProcessCreateOrderResponse(out_Shipment,
                    EasyPostSetup."Label Type",
                    ResponseJson,
                    out_ErrorMessageMgt)
            else
                this.ErrorHelper.LogResponseError(ResponseJson, out_ErrorMessageMgt);
        end else
            this.ErrorHelper.LogHttpClientError(HttpResponseMessage, out_ErrorMessageMgt);

        this.Tracing.EndTrace();

        exit(not this.ErrorHelper.HasErrors(out_ErrorMessageMgt));
    end;

    procedure BuyOrder(in_Action: enum "PVS Shipping Action";
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    var
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        RequestJson,
        ResponseJson : Text;
    begin
        this.RequestBuilder.CreateBuyOrderBody(out_Shipment).WriteTo(RequestJson);

        this.Tracing.StartTrace();

        IsRequestSuccessful := this.EasyPostAPIClient.RequestBuyOrder(out_Shipment."Shipment Reference No.", RequestJson, HttpResponseMessage);

        this.Tracing.Log('', in_Action, RequestJson, IsRequestSuccessful);

        if IsRequestSuccessful then begin
            HttpResponseMessage.Content().ReadAs(ResponseJson);
            this.Tracing.Log('', in_Action, ResponseJson, HttpResponseMessage.IsSuccessStatusCode());
            if HttpResponseMessage.IsSuccessStatusCode() then
                this.ResponseHandler.ProcessBuyOrderResponse(out_Shipment, ResponseJson, out_ErrorMessageMgt)
            else
                this.ResponseHandler.ProcessBuyOrderFailedResponse(out_Shipment, ResponseJson, out_ErrorMessageMgt);
        end else
            this.ErrorHelper.LogHttpClientError(HttpResponseMessage, out_ErrorMessageMgt);

        this.Tracing.EndTrace();

        exit(not this.ErrorHelper.HasErrors(out_ErrorMessageMgt));
    end;

    procedure RefundShipment(in_Action: enum "PVS Shipping Action";
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    var
        EasyPostSetup: Record "SIEP Setup";
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        RequestJson,
        ResponseJson : Text;
    begin
        EasyPostSetup.Get();

        this.Tracing.StartTrace();

        IsRequestSuccessful := this.EasyPostAPIClient.RequestCancelOrder(out_Shipment."Shipment Reference No.", HttpResponseMessage);

        this.Tracing.Log('', in_Action, RequestJson, IsRequestSuccessful);

        if IsRequestSuccessful then begin
            HttpResponseMessage.Content().ReadAs(ResponseJson);
            this.Tracing.Log('', in_Action, ResponseJson, HttpResponseMessage.IsSuccessStatusCode());
            if HttpResponseMessage.IsSuccessStatusCode() then
                this.ResponseHandler.ProcessCancelShipmentResponse(out_Shipment, ResponseJson, out_ErrorMessageMgt)
            else
                this.ErrorHelper.LogResponseError(ResponseJson, out_ErrorMessageMgt);
        end else
            this.ErrorHelper.LogHttpClientError(HttpResponseMessage, out_ErrorMessageMgt);

        this.Tracing.EndTrace();

        exit(not this.ErrorHelper.HasErrors(out_ErrorMessageMgt));
    end;

    procedure RetrieveShipmentStatus(in_Action: enum "PVS Shipping Action";
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    var
        NoTrackingUrlErr: Label 'No tracking URL found for shipment';
    begin
        out_Shipment.TestField("Shipment Status", Enum::"PVS Shipment Status"::"SIEP Courier Booked");
        if (out_Shipment."Tracking Url" <> '') then begin
            Hyperlink(out_Shipment."Tracking URL");
            exit(true);
        end;

        out_ErrorMessageMgt.LogSimpleErrorMessage(NoTrackingUrlErr);
        exit(false);
    end;

    procedure ActivateErrorHandlingFor(var out_ErrorMessageMgt: codeunit "Error Message Management";
        var out_ErrorMessageHandler: Codeunit "Error Message Handler";
        var out_ErrorContextElement: Codeunit "Error Context Element";
        in_SourceRecordId: RecordId)
    begin
        out_ErrorMessageMgt.Activate(out_ErrorMessageHandler);
        out_ErrorMessageMgt.PushContext(out_ErrorContextElement, in_SourceRecordId, 0, '');
    end;

    procedure IsEasyPost(in_ShippingAgentCode: Code[10]): Boolean
    var
        ShippingAgent: Record "Shipping Agent";
    begin
        if ShippingAgent.Get(in_ShippingAgentCode) then
            exit(ShippingAgent."PVS Shipping Integration" = Enum::"PVS Shipping Integration"::"SIEP ");

        exit(false);
    end;

    procedure OpenShipmentRates(var out_Shipment: Record "PVS Job Shipment"; in_ApplyServiceCodeFilter: Boolean)
    var
        JobShipmentRate: Record "PVS Job Shipment Rate";
        JobShipmentRates: Page "PVS Job Shipment Rates";
    begin
        if (out_Shipment."Shipping Agent Code" <> '') then
            JobShipmentRate.SetRange("Shipping Agent Code", out_Shipment."Shipping Agent Code");
        if in_ApplyServiceCodeFilter and (out_Shipment."Shipping Agent Service Code" <> '') then
            JobShipmentRate.SetRange("Shipping Agent Service Code", out_Shipment."Shipping Agent Service Code");

        JobShipmentRate.SetRange("Source Record ID", out_Shipment.RecordId);

        Clear(JobShipmentRates);
        JobShipmentRates.SetTableView(JobShipmentRate);
        JobShipmentRates.LookupMode(true);
        if JobShipmentRates.RunModal() = Action::LookupOK then begin
            JobShipmentRates.GetRecord(JobShipmentRate);

            if (out_Shipment."Shipping Agent Code" <> JobShipmentRate."Shipping Agent Code") then
                out_Shipment.Validate("Shipping Agent Code", JobShipmentRate."Shipping Agent Code");
            if (out_Shipment."Shipping Agent Service Code" <> JobShipmentRate."Shipping Agent Service Code") then
                out_Shipment.Validate("Shipping Agent Service Code", JobShipmentRate."Shipping Agent Service Code");
            out_Shipment."SIEP Rate Id" := JobShipmentRate."SIEP Rate Id";
            out_Shipment."Cost Amount" := JobShipmentRate.Rate;
            out_Shipment.Modify();
        end;
    end;

    procedure IsEnabled(): Boolean
    var
        EasyPostSetup: Record "SIEP Setup";
    begin
        exit(EasyPostSetup.IsEnabled());
    end;
}