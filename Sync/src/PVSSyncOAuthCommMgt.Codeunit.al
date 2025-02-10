Codeunit 80202 "PVS Sync OAuth Comm. Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        BusinessGroupTemp: Record "PVS Business Group" temporary;
        CompanyTemp: Record Company temporary;
        SyncJsonExchange: Codeunit "PVS Sync Json Exchange.";
        OAuth2: Codeunit Oauth2;
        SyncHttpClient: HttpClient;
        SyncHttpRequestMessage: HttpRequestMessage;
        SyncHttpResponseMessage: HttpResponseMessage;
        SyncHttpContent: HttpContent;
        SyncHttpHeaders: HttpHeaders;
        ApiCompanyId: Guid;
        ResponseData: Text;

    procedure GetAccessToken(var BusinessGroup: Record "PVS Business Group"): Boolean
    var
        PromptInteraction: Enum "Prompt Interaction";
        Scopes: List of [Text];
        AuthError: Text;
        AccessToken, SecretText : SecretText;
    begin
        Scopes.Add('https://api.businesscentral.dynamics.com/user_impersonation');
        SecretText := BusinessGroup.GetClientSecret();
        OAuth2.AcquireTokenByAuthorizationCode(BusinessGroup."PVS Client Id", SecretText,
        BusinessGroup."PVS Authorization Endpoint", BusinessGroup."PVS Redirect Url", Scopes, PromptInteraction::"Select Account", AccessToken, AuthError);

        if AccessToken.IsEmpty() then
            DisplayErrorMessage(BusinessGroup, AuthError)
        else begin
            SetAccessToken(BusinessGroup, AccessToken);
            BusinessGroup."PVS OAuth Error Message" := '';
            BusinessGroup."PVS Token Acquired" := true;
            BusinessGroup."API Connection Verified" := true;
        end;
    end;

    procedure AcquireTokenFromCache(BusinessGroup: Record "PVS Business Group")
    var
        PromptInteraction: Enum "Prompt Interaction";
        Scopes: List of [Text];
        AuthError: Text;
        AccessToken: SecretText;
    begin
        Scopes.Add('https://api.businesscentral.dynamics.com/user_impersonation');

        OAuth2.AcquireAuthorizationCodeTokenFromCache(BusinessGroup."PVS Client Id", BusinessGroup.GetClientSecret(),
            BusinessGroup."PVS Redirect Url", BusinessGroup."PVS Authorization Endpoint" + 'authorize', Scopes, AccessToken);

        if AccessToken.IsEmpty() <> false then begin
            SetAccessToken(BusinessGroup, AccessToken);
            exit;
        end;

        OAuth2.AcquireTokenByAuthorizationCode(BusinessGroup."PVS Client Id", BusinessGroup.GetClientSecret(),
            BusinessGroup."PVS Authorization Endpoint" + 'authorize', BusinessGroup."PVS Redirect Url", Scopes,
                Enum::"Prompt Interaction"::"Select Account", AccessToken, AuthError);

        if AccessToken.IsEmpty() <> false then
            SetAccessToken(BusinessGroup, AccessToken);
    end;

    procedure SetAccessToken(var BusinessGroup: Record "PVS Business Group"; AccessToken: SecretText)
    begin
        BusinessGroup.SetAccessToken(AccessToken);
        BusinessGroup.Modify();
    end;

    local procedure DisplayErrorMessage(var BusinessGroup: Record "PVS Business Group"; AuthError: Text)
    begin
        BusinessGroup."PVS Token Acquired" := false;
        if AuthError = '' then
            BusinessGroup."PVS OAuth Error Message" := 'Authorization has failed.'
        else
            BusinessGroup."PVS OAuth Error Message" := StrSubstNo('Authorization has failed with the error: %1.', AuthError);
    end;

    procedure SetApiMethod(Method: Option Get,POST; JsonBody: Text)
    begin
        SyncHttpRequestMessage.Method(Format(Method));

        case Method of
            Method::POST:
                SyncHttpContent.WriteFrom(JsonBody);
        end;
    end;

    procedure InitializeApi(FunctionUrl: Text)
    begin
        Clear(SyncHttpClient);
        Clear(SyncHttpContent);
        Clear(SyncHttpHeaders);
        Clear(SyncHttpRequestMessage);
        Clear(SyncHttpResponseMessage);
        Clear(ApiCompanyId);

        SyncHttpContent.GetHeaders(SyncHttpHeaders);
        SyncHttpHeaders.Remove('Content-Type');
        SyncHttpHeaders.Add('Content-Type', 'application/json');
        SyncHttpClient.DefaultRequestHeaders.Remove('Accept');
        SyncHttpClient.DefaultRequestHeaders.Add('Accept', 'application/json');
        SyncHttpRequestMessage.SetRequestUri(FunctionUrl);
    end;

    procedure SetApiTargetCompany(var BusinessGroup: Record "PVS Business Group")
    var
        Company: Record Company;
        JsonCompany: Codeunit "PVS Sync Json Exchange.";
        CompanyJsonProperty: Text;
        QueryString: Text;
    begin
        BusinessGroupTemp := BusinessGroup;
        if Company.Get(BusinessGroup.Company) then begin
            CompanyTemp := Company;
            ApiCompanyId := CompanyTemp.Id;
            exit;
        end;

        if NOT CompanyTemp.Get(BusinessGroup.Company) then begin
            CompanyTemp.Init();
            CompanyTemp.Name := BusinessGroup.Company;

            QueryString := GetApiBaseAddress(BusinessGroup) + StrSubstNo('companies?$filter=name eq ''%1''', BusinessGroup.Company);
            InitializeApi(QueryString);
            SetApiAuthentication(BusinessGroup);

            ClearLastError();
            if TryCallApi() then
                SyncJsonExchange.LoadResponseJsonArray(ResponseData)
            else
                Error(GetLastErrorText());

            JsonCompany.LoadResponseJson(SyncJsonExchange.GetJsonObjectFromArray(0));
            CompanyJsonProperty := JsonCompany.GetJsonPropertyValueByName('id');
            Evaluate(CompanyTemp.Id, CompanyJsonProperty);
            CompanyTemp.Insert();
        end;

        ApiCompanyId := CompanyTemp.Id;
    end;

    [TryFunction]
    procedure TryCallApi()
    var
        TempBlobResponse: Record "PVS TempBlob" temporary;
        PVSBlobStorage: Codeunit "PVS Blob Storage";
        ResponseInStream: InStream;
        Success: Boolean;
    begin
        Clear(ResponseData);
        TempBlobResponse.Init();
        TempBlobResponse.Blob.CreateInstream(ResponseInStream);

        if SyncHttpRequestMessage.Method.ToLower() = 'post' then begin
            SyncHttpContent.GetHeaders(SyncHttpHeaders);
            SyncHttpHeaders.Remove('Content-Type');
            SyncHttpHeaders.Add('Content-Type', 'application/json');
            SyncHttpClient.DefaultRequestHeaders.Add('ContentType', 'application/json');
            if SyncHttpClient.Post(SyncHttpRequestMessage.GetRequestUri(), SyncHttpContent, SyncHttpResponseMessage) then
                Success := true;
        end else begin
            if SyncHttpClient.send(SyncHttpRequestMessage, SyncHttpResponseMessage) then
                Success := true;
        end;
        SyncHttpResponseMessage.Content().ReadAs(ResponseData);
        if not (SyncHttpResponseMessage.HttpStatusCode in [200, 201, 202, 203, 204, 205, 206, 400]) then
            Error(SyncHttpResponseMessage.ReasonPhrase + ResponseData);
        if not Success then
            Error(ResponseData);
    end;

    procedure GetApiBaseAddress(var BusinessGroup: Record "PVS Business Group") BaseURL: Text
    begin
        BaseURL := 'http';
        if BusinessGroup."API Server Uses SSL" then
            BaseURL += 's';
        BaseURL += '://' + BusinessGroup."API Server FQDN" + '/v2.0';
        BaseURL += '/' + BusinessGroup."API Server Instance" + '/';
        BaseURL += StrSubstNo('api/%1/%2/%3/', ApiPublisher(), ApiGroup(), ApiVersion());
    end;

    procedure GetFQApiUrl(ApiServiceName: Text): Text
    begin
        if ApiServiceName = '' then
            ApiServiceName := BusinessGroupTemp."API Service Name";
        if not IsNullGuid(ApiCompanyId) then
            exit(StrSubstNo('%1companies(%2)/%3', GetApiBaseAddress(BusinessGroupTemp), GetIdWithoutBrackets(ApiCompanyId), ApiServiceName))
        else
            exit(StrSubstNo('%1companies', GetApiBaseAddress(BusinessGroupTemp)));
    end;

    procedure SetApiAuthentication(BusinessGroup: Record "PVS Business Group")
    var
        AccessToken: Text;
        ReadString: Text;
        InStr: InStream;
    begin
        SyncHttpClient.DefaultRequestHeaders().Add('Authorization', SecretText.SecretStrSubstNo('Bearer %1', BusinessGroup.GetAccessToken()));
    end;

    local procedure GetIdWithoutBrackets(Id: Guid): Text
    begin
        exit(CopyStr(Format(Id), 2, StrLen(Format(Id)) - 2));
    end;

    local procedure ApiPublisher(): Text
    begin
        exit('printvis');
    end;

    local procedure ApiGroup(): Text
    begin
        exit('multicompany');
    end;

    local procedure ApiVersion(): Text
    begin
        exit('v2.0');
    end;
}

