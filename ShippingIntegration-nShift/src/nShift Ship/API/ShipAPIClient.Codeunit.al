namespace PrintVis.OpenSource.NShift.Ship.API;

using PrintVis.OpenSource.NShift.Ship.Setup;
using System.Text;

codeunit 80160 "SINS Ship API Client"
{
    procedure RequestCreateShipment(in_Json: Text; var out_HttpResponseMessage: HttpResponseMessage): Boolean
    begin
        exit(this.SendRequest('POST', 'shipments', in_Json, out_HttpResponseMessage));
    end;

    procedure RequestCancelShipment(in_ShipmentTag: Text; var out_HttpResponseMessage: HttpResponseMessage): Boolean
    begin
        exit(this.SendRequest('DELETE', StrSubstNo('shipments/%1', in_ShipmentTag), '', out_HttpResponseMessage));
    end;

    procedure RequestTrackShipment(in_ShipmentTag: Text; var out_HttpResponseMessage: HttpResponseMessage): Boolean
    begin
        exit(this.SendRequest('GET', StrSubstNo('shipments/%1/trackingURL', in_ShipmentTag), '', out_HttpResponseMessage));
    end;

    procedure RequestShipmentPrices(in_Json: Text; var out_HttpResponseMessage: HttpResponseMessage): Boolean
    begin
        exit(this.SendRequest('POST', 'ShipmentPrices', in_Json, out_HttpResponseMessage));
    end;

    procedure RequestAccessToken(var out_HttpResponseMessage: HttpResponseMessage): Boolean
    var
        Setup: Record "SINS Ship Setup";
        Client: HttpClient;
        Content: HttpContent;
        Headers: HttpHeaders;
        HttpRequestMessage: HttpRequestMessage;
        Data: SecretText;
    begin
        Setup.Get();
        Setup.TestField("Authentication Server Url");
        Setup.TestField("Client ID");

        Data := SecretText.SecretStrSubstNo('grant_type=client_credentials&client_id=%1&client_secret=%2',
            Setup."Client ID",
            Setup.GetClientSecret());

        Content.WriteFrom(Data);
        Content.GetHeaders(Headers);
        Headers.Clear();
        Headers.Add('Content-Type', 'application/x-www-form-urlencoded');

        HttpRequestMessage.SetRequestUri(Setup."Authentication Server Url");
        HttpRequestMessage.Method := 'POST';
        HttpRequestMessage.Content := Content;

        exit(Client.Send(HttpRequestMessage, out_HttpResponseMessage));
    end;

    local procedure SendRequest(
        in_Method: Text;
        in_Resource: Text;
        in_Body: Text;
        var out_HttpResponseMessage: HttpResponseMessage): Boolean
    var
        Setup: Record "SINS Ship Setup";
        Client: HttpClient;
        Content: HttpContent;
        ContentHeader: HttpHeaders;
        HttpRequestMessage: HttpRequestMessage;
        RequestUrl: Text;
    begin
        Setup.Get();
        Setup.TestField("Server Url");
        Setup.TestField("Actor ID");

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

    local procedure GetRequestUrl(in_Setup: Record "SINS Ship Setup"; in_Resource: Text): Text
    begin
        exit(StrSubstNo('%1/ShipServer/%2/%3', in_Setup."Server Url", in_Setup."Actor ID", in_Resource));
    end;

    procedure AddAuthHeader(var out_HttpClient: HttpClient)
    begin
        this.AddBearerTokenHeader(out_HttpClient);
    end;

    local procedure AddBearerTokenHeader(var out_HttpClient: HttpClient)
    var
        Setup: Record "SINS Ship Setup";
        JsonMgt: Codeunit "JSON Management";
        APIClient: Codeunit "SINS Ship API Client";
        AccessTokenDueDateTime: DateTime;
        HttpResponseMessage: HttpResponseMessage;
        ExpiresIn: Integer;
        AccessToken, AuthString : SecretText;
        ExpiresInText, ResponseJson : Text;
    begin
        Setup.Get();
        if not Setup.AccessTokenIsValid() then begin
            APIClient.RequestAccessToken(HttpResponseMessage);

            if not HttpResponseMessage.IsSuccessStatusCode then
                Error('Error getting access token');

            HttpResponseMessage.Content.ReadAs(ResponseJson);

            JsonMgt.InitializeFromString(ResponseJson);

            ExpiresInText := JsonMgt.GetValue('expires_in');
            if Evaluate(ExpiresIn, ExpiresInText) then;

            AccessToken := JsonMgt.GetValue('access_token');
            AccessTokenDueDateTime := CurrentDateTime + (ExpiresIn * 1000);

            Setup.SaveAccessToken(AccessToken, AccessTokenDueDateTime);
        end;

        AuthString := SecretText.SecretStrSubstNo('Bearer %1', Setup.GetAccessToken());
        out_HttpClient.DefaultRequestHeaders().Add('Authorization', AuthString);
    end;
}