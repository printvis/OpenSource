namespace PrintVis.OpenSource.EasyPost.API;

using PrintVis.OpenSource.EasyPost.Setup;

codeunit 80137 "SIEP API Client"
{
    procedure RequestVerifyAddress(in_Json: Text; var out_HttpResponseMessage: HttpResponseMessage): Boolean
    begin
        exit(this.SendRequest('POST', 'addresses', in_Json, out_HttpResponseMessage));
    end;

    procedure RequestCreateOrder(in_Json: Text; var out_HttpResponseMessage: HttpResponseMessage): Boolean
    begin
        exit(this.SendRequest('POST', 'orders', in_Json, out_HttpResponseMessage));
    end;

    procedure RequestCancelOrder(in_OrderId: Text; var out_HttpResponseMessage: HttpResponseMessage): Boolean
    begin
        exit(this.SendRequest('DELETE', StrSubstNo('orders/%1', in_OrderId), '', out_HttpResponseMessage));
    end;

    procedure RequestBuyOrder(in_OrderId: Text; in_Json: Text; var out_HttpResponseMessage: HttpResponseMessage): Boolean
    begin
        exit(this.SendRequest('POST', StrSubstNo('orders/%1/buy', in_OrderId), in_Json, out_HttpResponseMessage));
    end;

    procedure RequestRefundShipment(in_Json: Text; var out_HttpResponseMessage: HttpResponseMessage): Boolean
    begin
    end;

    local procedure SendRequest(in_Method: Text; in_Resource: Text; in_Body: Text; var out_HttpResponseMessage: HttpResponseMessage): Boolean
    var
        Setup: Record "SIEP Setup";
        Client: HttpClient;
        Content: HttpContent;
        ContentHeader: HttpHeaders;
        HttpRequestMessage: HttpRequestMessage;
        RequestUrl: Text;
    begin
        Setup.Get();
        Setup.TestField("Server Url");

        RequestUrl := this.GetRequestUrl(Setup, in_Resource);

        if in_Body <> '' then begin
            Content.WriteFrom(in_Body);
            Content.GetHeaders(ContentHeader);
            ContentHeader.Clear();
            ContentHeader.Add('Content-Type', 'application/json');
            HttpRequestMessage.Content := Content;
        end;

        HttpRequestMessage.Method(in_Method);
        HttpRequestMessage.SetRequestUri(RequestUrl);

        this.AddAuthHeader(Client);

        exit(Client.Send(HttpRequestMessage, out_HttpResponseMessage));
    end;

    procedure AddAuthHeader(var out_HttpClient: HttpClient)
    begin
        this.AddApiKeyHeader(out_HttpClient);
    end;

    local procedure AddApiKeyHeader(var out_HttpClient: HttpClient)
    var
        Setup: Record "SIEP Setup";
        AuthString: SecretText;
    begin
        Setup.Get();

        AuthString := SecretText.SecretStrSubstNo('Bearer %1', Setup.GetApiKey());

        out_HttpClient.DefaultRequestHeaders().Add('Authorization', AuthString);
    end;

    local procedure GetRequestUrl(in_Setup: Record "SIEP Setup"; in_Resource: Text): Text
    begin
        exit(StrSubstNo('%1/%2', in_Setup."Server Url", in_Resource));
    end;
}