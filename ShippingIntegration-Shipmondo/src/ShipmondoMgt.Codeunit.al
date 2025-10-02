namespace PrintVis.OpenSource.Shipmondo;

using PrintVis.OpenSource.Shipmondo.API;
using Microsoft.Foundation.Shipping;
using System.Utilities;
using PrintVis.OpenSource.Shipmondo.Configuration;

codeunit 80186 "SISM Mgt"
{
    var
        ErrorHelper: Codeunit "PVS Error Logging Management";
        Tracing: Codeunit "PVS Shipping Integration Trc.";
        ShippingIntegrationUtil: Codeunit "PVS Shipping Integration Util";
        ApiClient: Codeunit "SISM API Client";
        RequestBuilder: Codeunit "SISM Req. Builder";
        ResponseHandler: Codeunit "SISM Resp. Handler";

    procedure CreateShipmentQuote(
        in_Action: enum "PVS Shipping Action";
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    var
        Validation: Codeunit "SISM Validation";
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        Requests: List of [Text];
        Responses: List of [Text];
        RequestJson,
        ResponseJson : Text;
    begin
        Validation.Set(out_ErrorMessageMgt);
        if not Validation.ValidateShipmentCreation(out_Shipment) then
            exit(false);

        this.RequestBuilder.CreateShipmentQuoteObject(out_Shipment, true, false).WriteTo(RequestJson);
        Requests.Add(RequestJson);

        this.RequestBuilder.CreateShipmentQuoteObject(out_Shipment, false, true).WriteTo(RequestJson);
        Requests.Add(RequestJson);

        this.Tracing.StartTrace();

        foreach RequestJson in Requests do
            if (RequestJson <> '') then begin
                IsRequestSuccessful := this.ApiClient.RequestCreateShipmentQuote(RequestJson, HttpResponseMessage);

                this.Tracing.Log('', in_Action, RequestJson, IsRequestSuccessful);

                if IsRequestSuccessful then begin
                    if HttpResponseMessage.IsSuccessStatusCode() then begin
                        HttpResponseMessage.Content().ReadAs(ResponseJson);
                        Responses.Add(ResponseJson);
                    end else
                        this.ErrorHelper.LogResponseError(ResponseJson, out_ErrorMessageMgt);

                    this.Tracing.Log('', in_Action, ResponseJson, HttpResponseMessage.IsSuccessStatusCode());
                end else
                    this.ErrorHelper.LogHttpClientError(HttpResponseMessage, out_ErrorMessageMgt);
            end;

        this.Tracing.EndTrace();

        if Responses.Count() > 0 then
            this.ResponseHandler.ProcessCreateShipmentQuoteResponse(out_Shipment, Responses, out_ErrorMessageMgt);

        exit(not this.ErrorHelper.HasErrors(out_ErrorMessageMgt));
    end;

    procedure CreateShipment(
        in_Action: enum "PVS Shipping Action";
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: codeunit "Error Message Management"): Boolean
    var
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        RequestJson,
        ResponseJson : Text;
    begin
        this.RequestBuilder.CreateShipmentObject(out_Shipment).WriteTo(RequestJson);

        this.Tracing.StartTrace();

        IsRequestSuccessful := this.ApiClient.RequestCreateShipment(RequestJson, HttpResponseMessage);

        this.Tracing.Log('', in_Action, RequestJson, IsRequestSuccessful);

        if IsRequestSuccessful then begin
            HttpResponseMessage.Content().ReadAs(ResponseJson);
            this.Tracing.Log('', in_Action, ResponseJson, HttpResponseMessage.IsSuccessStatusCode());
            if HttpResponseMessage.IsSuccessStatusCode() then
                this.ResponseHandler.ProcessCreateShipmentResponse(out_Shipment, ResponseJson, out_ErrorMessageMgt)
            else
                this.ErrorHelper.LogResponseError(ResponseJson, out_ErrorMessageMgt);
        end else
            this.ErrorHelper.LogHttpClientError(HttpResponseMessage, out_ErrorMessageMgt);

        this.Tracing.EndTrace();

        exit(not this.ErrorHelper.HasErrors(out_ErrorMessageMgt));
    end;

    procedure CancelShipment(
        in_Action: Enum "PVS Shipping Action";
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    var
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        ResponseJson: Text;
    begin
        out_Shipment.TestField("Shipment Status", enum::"PVS Shipment Status"::"Shipment Created");
        out_Shipment.TestField("Shipment Reference No.");

        this.Tracing.StartTrace();

        IsRequestSuccessful := this.ApiClient.RequestCancelShipment(out_Shipment."Shipment Reference No.", HttpResponseMessage);

        this.Tracing.Log('', in_Action, out_Shipment."Shipment Reference No.", IsRequestSuccessful);

        if IsRequestSuccessful then begin
            HttpResponseMessage.Content().ReadAs(ResponseJson);
            this.Tracing.Log('', in_Action, ResponseJson, HttpResponseMessage.IsSuccessStatusCode());
            if HttpResponseMessage.IsSuccessStatusCode then
                this.ResponseHandler.ProcessCancelShipmentResponse(out_Shipment, ResponseJson, out_ErrorMessageMgt)
            else
                this.ErrorHelper.LogResponseError(ResponseJson, out_ErrorMessageMgt);
        end else
            this.ErrorHelper.LogHttpClientError(HttpResponseMessage, out_ErrorMessageMgt);

        this.Tracing.EndTrace();

        exit(not this.ErrorHelper.HasErrors(out_ErrorMessageMgt));
    end;

    procedure RetrieveLabels(
        in_Action: Enum "PVS Shipping Action";
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    var
        ShipmondoSetup: Record "SISM Setup";
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        ResponseJson: Text;
    begin
        ShipmondoSetup.Get();

        this.Tracing.StartTrace();

        IsRequestSuccessful := this.ApiClient.RequestRetrieveLabels(out_Shipment."Shipment Reference No.",
            ShipmondoSetup."Label Format",
            ShipmondoSetup."Scale By",
            ShipmondoSetup."Scale Size",
            HttpResponseMessage);

        this.Tracing.Log('', in_Action, out_Shipment."Shipment Reference No.", IsRequestSuccessful);

        if IsRequestSuccessful then begin
            HttpResponseMessage.Content().ReadAs(ResponseJson);
            this.Tracing.Log('', in_Action, ResponseJson, HttpResponseMessage.IsSuccessStatusCode());
            if HttpResponseMessage.IsSuccessStatusCode then
                this.ResponseHandler.ProcessRetrieveLabelsResponse(out_Shipment, ResponseJson, out_ErrorMessageMgt)
            else
                this.ErrorHelper.LogResponseError(ResponseJson, out_ErrorMessageMgt);
        end else
            this.ErrorHelper.LogHttpClientError(HttpResponseMessage, out_ErrorMessageMgt);

        this.Tracing.EndTrace();

        exit(not this.ErrorHelper.HasErrors(out_ErrorMessageMgt));
    end;

    procedure RetrieveShipmentStatus(
        in_Action: Enum "PVS Shipping Action";
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    var
        ShippingAgent: Record "Shipping Agent";
        ShipmondoSetup: Record "SISM Setup";
        TrackingUrl: Text;
    begin
        ShipmondoSetup.Get();
        if (ShipmondoSetup."Shipment Tracking Url" = '') then
            exit(false);

        ShippingAgent.Get(out_Shipment."Shipping Agent Code");
        if (ShippingAgent."SISM External Service Id" = '') then
            exit(false);

        TrackingUrl := StrSubstNo('%1/%2/%3',
         ShipmondoSetup."Shipment Tracking Url",
         Format(ShippingAgent."SISM External Service Id").ToLower(),
         out_Shipment."Track and Trace No.");

        Hyperlink(TrackingUrl);

        exit(true);
    end;

    procedure IsEnabled(): Boolean
    var
        ShipmondoSetup: Record "SISM Setup";
    begin
        exit(ShipmondoSetup.Get() and ShipmondoSetup.Enabled);
    end;

    procedure IsShipmondo(in_ShippingAgentCode: Code[10]): Boolean
    var
        ShippingAgent: Record "Shipping Agent";
    begin
        if (in_ShippingAgentCode = '') then
            exit(false);

        ShippingAgent.Get(in_ShippingAgentCode);
        exit(ShippingAgent."PVS Shipping Integration" = Enum::"PVS Shipping Integration"::"SISM");
    end;

    procedure PrintJob(
        in_Action: enum "PVS Shipping Action";
        in_Shipment: Record "PVS Job Shipment";
        in_DocumentType: Text;
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    var
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        RequestJson,
        ResponseJson : Text;
    begin
        this.Tracing.StartTrace();

        this.RequestBuilder.RequestPrintJob(in_Shipment, in_DocumentType).WriteTo(RequestJson);

        IsRequestSuccessful := this.ApiClient.RequestPrintJob(RequestJson, HttpResponseMessage);

        this.Tracing.Log('', in_Action, in_Shipment."Shipment Reference No.", IsRequestSuccessful);

        if IsRequestSuccessful then begin
            HttpResponseMessage.Content().ReadAs(ResponseJson);
            this.Tracing.Log('', in_Action, ResponseJson, HttpResponseMessage.IsSuccessStatusCode());
            if HttpResponseMessage.IsSuccessStatusCode then
                this.ResponseHandler.ProcessPrintJobResponse(in_Shipment, ResponseJson, out_ErrorMessageMgt)
            else
                this.ErrorHelper.LogResponseError(ResponseJson, out_ErrorMessageMgt);
        end else
            this.ErrorHelper.LogHttpClientError(HttpResponseMessage, out_ErrorMessageMgt);

        this.Tracing.EndTrace();

        exit(not this.ErrorHelper.HasErrors(out_ErrorMessageMgt));
    end;

    procedure GetPickupPoints(
        in_ServiceCode: Text;
        in_CountryCode: Code[10];
        in_PostCode: Code[20];
        in_Address: Text;
        var out_PickupPoints: Record "SISM Pickup Point";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    var
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        ResponseJson: Text;
    begin
        out_PickupPoints.Reset();
        out_PickupPoints.DeleteAll();

        this.Tracing.StartTrace();

        IsRequestSuccessful := this.ApiClient.RequestGetPickupPoints(in_ServiceCode, in_CountryCode, in_PostCode, in_Address, HttpResponseMessage);

        this.Tracing.Log('', Enum::"PVS Shipping Action"::"SISM Get Pickup Points", '', IsRequestSuccessful);

        if IsRequestSuccessful then begin
            HttpResponseMessage.Content().ReadAs(ResponseJson);
            this.Tracing.Log('', Enum::"PVS Shipping Action"::"SISM Get Printers", ResponseJson, HttpResponseMessage.IsSuccessStatusCode());
            if HttpResponseMessage.IsSuccessStatusCode then
                this.ResponseHandler.ProcessGetPickupPointsResponse(ResponseJson, out_PickupPoints, out_ErrorMessageMgt)
            else
                this.ErrorHelper.LogResponseError(ResponseJson, out_ErrorMessageMgt);
        end else
            this.ErrorHelper.LogHttpClientError(HttpResponseMessage, out_ErrorMessageMgt);

        this.Tracing.EndTrace();

        exit(not this.ErrorHelper.HasErrors(out_ErrorMessageMgt));
    end;

    procedure GetPrinters(): Boolean
    var
        out_ErrorMessageMgt: Codeunit "Error Message Management";
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        ResponseJson: Text;
    begin
        this.Tracing.StartTrace();

        IsRequestSuccessful := this.ApiClient.RequestGetPrinters(HttpResponseMessage);

        if IsRequestSuccessful then begin
            HttpResponseMessage.Content().ReadAs(ResponseJson);
            this.Tracing.Log('', Enum::"PVS Shipping Action"::"SISM Get Printers", ResponseJson, HttpResponseMessage.IsSuccessStatusCode());
            if HttpResponseMessage.IsSuccessStatusCode then
                this.ResponseHandler.ProcessGetPrintersResponse(ResponseJson, out_ErrorMessageMgt)
            else
                this.ErrorHelper.LogResponseError(ResponseJson, out_ErrorMessageMgt);
        end else
            this.ErrorHelper.LogHttpClientError(HttpResponseMessage, out_ErrorMessageMgt);

        this.Tracing.EndTrace();

        exit(not this.ErrorHelper.HasErrors(out_ErrorMessageMgt));
    end;

    procedure ActivateErrorHandlingFor(
        var out_ErrorMessageMgt: codeunit "Error Message Management";
        var out_ErrorMessageHandler: Codeunit "Error Message Handler";
        var out_ErrorContextElement: Codeunit "Error Context Element";
        in_SourceRecordId: RecordId)
    begin
        out_ErrorMessageMgt.Activate(out_ErrorMessageHandler);
        out_ErrorMessageMgt.PushContext(out_ErrorContextElement, in_SourceRecordId, 0, '');
    end;
}
