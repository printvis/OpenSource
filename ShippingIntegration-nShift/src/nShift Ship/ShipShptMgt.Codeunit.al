namespace PrintVis.OpenSource.NShift.Ship;
using PrintVis.OpenSource.NShift.Ship.API;

using PrintVis.OpenSource.NShift.Ship.Setup;
using System.Utilities;
using Microsoft.Foundation.Shipping;

codeunit 80163 "SINS Ship Shpt. Mgt."
{
    var
        ErrorHelper: Codeunit "PVS Error Logging Management";
        ApiClient: Codeunit "SINS Ship API Client";
        RequestBuilder: Codeunit "SINS Ship Req. Builder";
        ResponseHandler: Codeunit "SINS Ship Resp. Handler";
        Validation: Codeunit "SINS Ship Validation";

    procedure CreateShipment(
        in_Action: Enum "PVS Shipping Action";
        in_IsBatch: Boolean;
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    var
        ShipSetup: Record "SINS Ship Setup";
        Tracing: Codeunit "PVS Shipping Integration Trc.";
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        RequestJson,
        ResponseJson : Text;
        HasAnyErrors: Boolean;
    begin
        HasAnyErrors := false;

        ShipSetup.Get();

        this.Validation.ValidateShipmentCreation(out_Shipment);

        if this.ErrorHelper.HasErrors(out_ErrorMessageMgt) then
            HasAnyErrors := true
        else begin
            RequestJson := this.RequestBuilder.CreateRequestBody(
                this.RequestBuilder.CreateShipmentObject(out_Shipment),
                this.RequestBuilder.CreateOptionsObject(ShipSetup));

            Tracing.StartTrace();

            IsRequestSuccessful := this.ApiClient.RequestCreateShipment(RequestJson, HttpResponseMessage);

            Tracing.Log('', in_Action, RequestJson, IsRequestSuccessful);

            if IsRequestSuccessful then begin
                HttpResponseMessage.Content().ReadAs(ResponseJson);
                Tracing.Log('', in_Action, ResponseJson, HttpResponseMessage.IsSuccessStatusCode());
                if HttpResponseMessage.IsSuccessStatusCode() then
                    this.ResponseHandler.ProcessCreateShipmentResponse(out_Shipment, ResponseJson, out_ErrorMessageMgt)
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
        in_IsBatch: Boolean;
        var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    var
        ShipSetup: Record "SINS Ship Setup";
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
                ShipSetup.Get();

                this.Validation.ValidateShipmentCreation(out_CombinedShipment);

                if this.ErrorHelper.HasErrors(out_ErrorMessageMgt) then
                    HasAnyErrors := true
                else begin
                    RequestJson := this.RequestBuilder.CreateRequestBody(
                        this.RequestBuilder.CreateShipmentObject(out_CombinedShipment),
                        this.RequestBuilder.CreateOptionsObject(ShipSetup));

                    Tracing.StartTrace();

                    IsRequestSuccessful := this.ApiClient.RequestCreateShipment(RequestJson, HttpResponseMessage);

                    Tracing.Log('', in_Action, RequestJson, IsRequestSuccessful);

                    if IsRequestSuccessful then begin
                        HttpResponseMessage.Content().ReadAs(ResponseJson);
                        Tracing.Log('', in_Action, ResponseJson, HttpResponseMessage.IsSuccessStatusCode());
                        if HttpResponseMessage.IsSuccessStatusCode() then
                            this.ResponseHandler.ProcessCreateShipmentResponse(out_CombinedShipment, out_CombinedShipmentLine, ResponseJson, out_ErrorMessageMgt)
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

    procedure CancelShipment(
        in_Action: Enum "PVS Shipping Action";
        in_IsBatch: Boolean;
        var out_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    var
        ShipSetup: Record "SINS Ship Setup";
        Tracing: Codeunit "PVS Shipping Integration Trc.";
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        ResponseJson: Text;
        HasAnyErrors: Boolean;
    begin
        HasAnyErrors := false;

        if out_Shipment.FindSet() then
            repeat
                ShipSetup.Get();

                Tracing.StartTrace();

                IsRequestSuccessful := this.ApiClient.RequestCancelShipment(out_Shipment."SINS Shipment Tag", HttpResponseMessage);

                Tracing.Log('', in_Action, StrSubstNo('%1: %2', out_Shipment.FieldCaption("SINS Shipment Tag"), out_Shipment."SINS Shipment Tag"), IsRequestSuccessful);

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
            until out_Shipment.Next() = 0;

        exit(not HasAnyErrors);
    end;

    procedure CancelShipment(
        in_Action: Enum "PVS Shipping Action";
        in_IsBatch: Boolean;
        var out_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_CombinedShipmentLine: Record "PVS Combined Shipment Line";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    var
        ShipSetup: Record "SINS Ship Setup";
        Tracing: Codeunit "PVS Shipping Integration Trc.";
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        ResponseJson: Text;
        HasAnyErrors: Boolean;
    begin
        HasAnyErrors := false;

        if out_CombinedShipment.FindSet() then
            repeat
                ShipSetup.Get();

                Tracing.StartTrace();

                IsRequestSuccessful := this.ApiClient.RequestCancelShipment(out_CombinedShipment."SINS Shipment Tag", HttpResponseMessage);

                Tracing.Log('', in_Action, StrSubstNo('%1: %2', out_CombinedShipment.FieldCaption("SINS Shipment Tag"), out_CombinedShipment."SINS Shipment Tag"), IsRequestSuccessful);

                if IsRequestSuccessful then begin
                    HttpResponseMessage.Content().ReadAs(ResponseJson);
                    Tracing.Log('', in_Action, ResponseJson, HttpResponseMessage.IsSuccessStatusCode());
                    if HttpResponseMessage.IsSuccessStatusCode then
                        this.ResponseHandler.ProcessCancelShipmentResponse(out_CombinedShipment, out_CombinedShipmentLine)
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

    procedure RetrieveShipmentStatus(in_Shipment: Record "PVS Job Shipment"): Boolean
    begin
        if (in_Shipment."Tracking Url" <> '') then begin
            Hyperlink(in_Shipment."Tracking Url");
            exit(true);
        end;

        exit(false);
    end;

    procedure RetrieveShipmentStatus(in_CombinedShipment: Record "PVS Combined Shipment Header"): Boolean
    begin
        if (in_CombinedShipment."Tracking Url" <> '') then begin
            Hyperlink(in_CombinedShipment."Tracking Url");
            exit(true);
        end;

        exit(false);
    end;

    procedure FetchShippingRates(
        in_Action: Enum "PVS Shipping Action";
        in_IsBatch: Boolean;
        var in_Shipment: Record "PVS Job Shipment";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    var
        ShipSetup: Record "SINS Ship Setup";
        Tracing: Codeunit "PVS Shipping Integration Trc.";
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        RequestJson,
        ResponseJson : Text;
        HasAnyErrors: Boolean;
    begin
        HasAnyErrors := false;

        ShipSetup.Get();

        this.Validation.ValidateShipmentCreation(in_Shipment);

        if this.ErrorHelper.HasErrors(out_ErrorMessageMgt) then
            HasAnyErrors := true
        else begin
            RequestJson := this.RequestBuilder.CreateRequestBody(this.RequestBuilder.CreateShipmentObject(in_Shipment),
                this.RequestBuilder.CreateOptionsObject(ShipSetup));

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
        in_IsBatch: Boolean;
        var in_CombinedShipment: Record "PVS Combined Shipment Header";
        var out_ErrorMessageMgt: Codeunit "Error Message Management"): Boolean
    var
        ShipSetup: Record "SINS Ship Setup";
        Tracing: Codeunit "PVS Shipping Integration Trc.";
        IsRequestSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        RequestJson,
        ResponseJson : Text;
        HasAnyErrors: Boolean;
    begin
        HasAnyErrors := false;

        if in_CombinedShipment.FindSet() then
            repeat
                ShipSetup.Get();

                // this.Validation.ValidateShipmentCreation(in_CombinedShipment);

                if this.ErrorHelper.HasErrors(out_ErrorMessageMgt) then
                    HasAnyErrors := true
                else begin
                    RequestJson := this.RequestBuilder.CreateRequestBody(this.RequestBuilder.CreateShipmentObject(in_CombinedShipment),
                        this.RequestBuilder.CreateOptionsObject(ShipSetup));

                    Tracing.StartTrace();

                    IsRequestSuccessful := this.ApiClient.RequestShipmentPrices(RequestJson, HttpResponseMessage);

                    Tracing.Log('', in_Action, RequestJson, IsRequestSuccessful);

                    if IsRequestSuccessful then begin
                        HttpResponseMessage.Content().ReadAs(ResponseJson);
                        Tracing.Log('', in_Action, ResponseJson, HttpResponseMessage.IsSuccessStatusCode());
                        if HttpResponseMessage.IsSuccessStatusCode() then
                            this.ResponseHandler.ProcessFetchShippingRatesResponse(in_CombinedShipment, ResponseJson)
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
            until in_CombinedShipment.Next() = 0;

        exit(not HasAnyErrors);
    end;

    procedure IsEnabled(): Boolean
    var
        ShipSetup: Record "SINS Ship Setup";
    begin
        ShipSetup.Get();
        exit(ShipSetup.Enabled);
    end;

    procedure IsShip(in_ShippingAgentCode: Code[10]): Boolean
    var
        ShippingAgent: Record "Shipping Agent";
    begin
        if ShippingAgent.Get(in_ShippingAgentCode) then
            exit(ShippingAgent."PVS Shipping Integration" = Enum::"PVS Shipping Integration"::"SINS nShift Ship");
    end;
}
