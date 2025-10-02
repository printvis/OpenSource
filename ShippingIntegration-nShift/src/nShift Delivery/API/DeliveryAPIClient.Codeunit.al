namespace PrintVis.OpenSource.NShift.Delivery.API;

using PrintVis.OpenSource.NShift.Delivery.Setup;

codeunit 80166 "SINS Delivery API Client"
{
    procedure RequestCreateShipment(in_Json: Text; var out_HttpResponseMessage: HttpResponseMessage): Boolean
    begin
        exit(SendRequest('POST', 'shipments?returnFile=true', in_Json, out_HttpResponseMessage));
    end;

    procedure RequestCancelShipment(in_ShipmentNumber: Text; var out_HttpResponseMessage: HttpResponseMessage): Boolean
    begin
        exit(SendRequest('DELETE', StrSubstNo('shipments/%1', in_ShipmentNumber), '', out_HttpResponseMessage));
    end;

    procedure RequestShipmentPrices(in_Json: Text; var out_HttpResponseMessage: HttpResponseMessage): Boolean
    begin
        exit(SendRequest('POST', 'prices', in_Json, out_HttpResponseMessage));
    end;

    local procedure SendRequest(
        in_Method: Text;
        in_Resource: Text;
        in_Body: Text;
        var out_HttpResponseMessage: HttpResponseMessage): Boolean
    var
        Setup: Record "SINS Delivery Setup";
        Client: HttpClient;
        Content: HttpContent;
        ContentHeader: HttpHeaders;
        HttpRequestMessage: HttpRequestMessage;
        RequestUrl: Text;
    begin
        Setup.Get();
        Setup.TestField("Server Url");

        RequestUrl := GetRequestUrl(Setup, in_Resource);

        if in_Body <> '' then begin
            Content.WriteFrom(in_Body);
            Content.GetHeaders(ContentHeader);
            ContentHeader.Clear();
            ContentHeader.Add('Content-Type', 'application/json');
            HttpRequestMessage.Content := Content;
        end;

        HttpRequestMessage.Method(in_Method);
        HttpRequestMessage.SetRequestUri(RequestUrl);

        AddAuthHeader(Client);

        exit(Client.Send(HttpRequestMessage, out_HttpResponseMessage));
    end;

    local procedure GetRequestUrl(in_Setup: Record "SINS Delivery Setup"; in_Resource: Text): Text
    begin
        exit(StrSubstNo('%1/%2', in_Setup."Server Url", in_Resource));
    end;

    procedure AddAuthHeader(var out_HttpClient: HttpClient)
    begin
        AddApiKeyHeader(out_HttpClient);
    end;

    local procedure AddApiKeyHeader(var out_HttpClient: HttpClient)
    var
        Setup: Record "SINS Delivery Setup";
        AuthString: SecretText;
    begin
        Setup.Get();

        AuthString := SecretText.SecretStrSubstNo('Bearer %1', Setup.GetApiKey());

        out_HttpClient.DefaultRequestHeaders().Add('Authorization', AuthString);
    end;
}