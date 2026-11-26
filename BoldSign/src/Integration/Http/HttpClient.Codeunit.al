namespace PrintVis.BoldSign.Integration.Http;

using PrintVis.BoldSign.Configuration;

codeunit 80304 "PVS BS Http Client"
{
    Access = Internal;

    procedure SendHttpGetRequest(Resource: Text; var ResponseMessage: HttpResponseMessage): Boolean
    var
        ServiceSetup: Record "PVS BS Service Setup";
        Client: HttpClient;
        Content: HttpContent;
        RequestMessage: HttpRequestMessage;
        RequestUri: Text;
    begin
        ServiceSetup.Get();

        RequestUri := StrSubstNo('%1/%2', ServiceSetup.GetServiceEndpoint(), Resource);

        this.PrepareHttpClient(Client, RequestMessage, 'GET', RequestUri, Content, ServiceSetup.GetApiKey());

        exit(this.SendWithRetry(Client, RequestMessage, ResponseMessage));
    end;

    procedure SendHttpPostRequest(Resource: Text; BodyContent: Text; var ResponseMessage: HttpResponseMessage): Boolean
    var
        ServiceSetup: Record "PVS BS Service Setup";
        Client: HttpClient;
        Content: HttpContent;
        RequestMessage: HttpRequestMessage;
        RequestUri: Text;
    begin
        ServiceSetup.Get();

        RequestUri := StrSubstNo('%1/%2', ServiceSetup.GetServiceEndpoint(), Resource);

        this.PrepareHttpContent(Content, BodyContent);
        this.PrepareHttpClient(Client, RequestMessage, 'POST', RequestUri, Content, ServiceSetup.GetApiKey());

        exit(this.SendWithRetry(Client, RequestMessage, ResponseMessage));
    end;

    procedure SendHttpPostMultipartRequest(Resource: Text; Boundary: Text; var BodyInStream: InStream; var ResponseMessage: HttpResponseMessage): Boolean
    var
        ServiceSetup: Record "PVS BS Service Setup";
        Client: HttpClient;
        Content: HttpContent;
        RequestMessage: HttpRequestMessage;
        RequestUri: Text;
    begin
        ServiceSetup.Get();

        RequestUri := StrSubstNo('%1/%2', ServiceSetup.GetServiceEndpoint(), Resource);

        this.PrepareMultipartContent(Content, Boundary, BodyInStream);
        this.PrepareHttpClient(Client, RequestMessage, 'POST', RequestUri, Content, ServiceSetup.GetApiKey());

        exit(this.SendWithRetry(Client, RequestMessage, ResponseMessage));
    end;

    local procedure PrepareMultipartContent(var Content: HttpContent; Boundary: Text; var BodyInStream: InStream)
    var
        ContentHeaders: HttpHeaders;
    begin
        Content.Clear();
        Content.WriteFrom(BodyInStream);
        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'multipart/form-data; boundary=' + Boundary);
    end;

    local procedure PrepareHttpContent(var Content: HttpContent; Body: Text)
    var
        ContentHeaders: HttpHeaders;
    begin
        Content.Clear();
        Content.WriteFrom(Body);
        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');
    end;

    local procedure PrepareHttpClient(var Client: HttpClient;
        var RequestMessage: HttpRequestMessage;
        Method: Text;
        RequestUri: Text;
        Content: HttpContent;
        ApiKey: SecretText)
    var
        HttpHeaders: HttpHeaders;
    begin
        RequestMessage.Method(Method);
        RequestMessage.SetRequestUri(RequestUri);
        RequestMessage.Content := Content;

        Client.Clear();
        HttpHeaders := Client.DefaultRequestHeaders();
        HttpHeaders.Add('Accept', 'application/json');
        HttpHeaders.Add('X-API-KEY', ApiKey);
    end;

    local procedure SendWithRetry(var Client: HttpClient; var RequestMessage: HttpRequestMessage; var ResponseMessage: HttpResponseMessage): Boolean
    var
        AttemptNo: Integer;
        MaxAttempts: Integer;
    begin
        MaxAttempts := this.GetMaxAttempts();
        repeat
            AttemptNo += 1;
            Clear(ResponseMessage);

            if not Client.Send(RequestMessage, ResponseMessage) then
                exit(false);

            if ResponseMessage.HttpStatusCode <> 429 then
                exit(true);

            if AttemptNo < MaxAttempts then
                Sleep(this.GetRetryAfter(ResponseMessage));
        until AttemptNo >= MaxAttempts;

        exit(true);
    end;

    local procedure GetMaxAttempts(): Integer
    begin
        exit(3);
    end;

    local procedure GetRetryAfter(ResponseMessage: HttpResponseMessage): Integer
    var
        ResponseHeaders: HttpHeaders;
        HeaderValues: array[10] of Text;
        Seconds: Integer;
        DefaultDelayMs: Integer;
    begin
        DefaultDelayMs := 1000;
        ResponseHeaders := ResponseMessage.Headers;

        if not ResponseHeaders.GetValues('Retry-After', HeaderValues) then
            exit(DefaultDelayMs);

        if HeaderValues[1] = '' then
            exit(DefaultDelayMs);

        if not Evaluate(Seconds, HeaderValues[1]) then
            exit(DefaultDelayMs);

        if Seconds <= 0 then
            exit(DefaultDelayMs);

        exit(Seconds * 1000);
    end;

}