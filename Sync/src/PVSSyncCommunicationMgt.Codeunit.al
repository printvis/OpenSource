Codeunit 80204 "PVS Sync Communication Mgt"
{

    trigger OnRun()
    begin
    end;

    var
        BusinessGroupTemp: Record "PVS Business Group" temporary;
        CompanyTemp: Record Company temporary;
        SyncJsonExchange: Codeunit "PVS Sync Json Exchange.";
        ResponseData: Text;
        ApiCompanyId: Guid;
        SyncHttpClient: HttpClient;
        SyncHttpRequestMessage: HttpRequestMessage;
        SyncHttpResponseMessage: HttpResponseMessage;
        SyncHttpContent: HttpContent;
        SyncHttpHeaders: HttpHeaders;

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

    procedure GetFQApiUrl(ApiServiceName: Text): Text
    begin
        if ApiServiceName = '' then
            ApiServiceName := BusinessGroupTemp."API Service Name";
        if not IsNullGuid(ApiCompanyId) then
            exit(StrSubstNo('%1companies(%2)/%3%4', GetApiBaseAddress(BusinessGroupTemp), GetIdWithoutBrackets(ApiCompanyId), ApiServiceName, AddTenant(BusinessGroupTemp)))
        else
            exit(StrSubstNo('%1companies%4', GetApiBaseAddress(BusinessGroupTemp), AddTenant(BusinessGroupTemp)));
    end;

    procedure AddTenant(var BusinessGroup: Record "PVS Business Group"): Text
    begin
        if BusinessGroup."API Tenant" <> '' then
            exit(StrSubstNo('&tenant=%1', BusinessGroupTemp."API Tenant"));
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

    procedure SetApiAuthentication(UserName: Text; Password: Text)
    begin
        SetApiAuthentication(UserName, Password, false);
    end;

    procedure SetApiAuthentication(UserName: Text; Password: Text; UseWindowsAuthentication: Boolean)
    begin
        SyncHttpClient.DefaultRequestHeaders().Add('Authorization', GetAuthString(UserName, Password));
    end;

    procedure SetApiMethod(Method: Option Get,POST; JsonBody: Text)
    begin
        SyncHttpRequestMessage.Method(Format(Method));

        case Method of
            Method::POST:
                SyncHttpContent.WriteFrom(JsonBody);
        end;
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

            QueryString := GetApiBaseAddress(BusinessGroup) + StrSubstNo('companies?$filter=name eq ''%1''%2', BusinessGroup.Company, AddTenant(BusinessGroup));
            InitializeApi(QueryString);
            SetApiAuthentication(BusinessGroup."API User Name", BusinessGroup.GetPassword(), BusinessGroup."API Server uses Windows Auth");

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

    procedure CheckApi(var BusinessGroup: Record "PVS Business Group"): Boolean
    var
        Company: Record Company;
        JsonCompany: Codeunit "PVS Sync Json Exchange.";
        CompanyJsonProperty: Text;
        QueryString: Text;
        Method: Option Get,POST;
    begin
        SetApiTargetCompany(BusinessGroup);
        InitializeApi(GetFQApiUrl(BusinessGroupTemp."API Service Name"));
        SyncHttpClient.Timeout(5000);
        SetApiAuthentication(BusinessGroup."API User Name", BusinessGroup.GetPassword(), BusinessGroup."API Server uses Windows Auth");

        SetApiMethod(Method::Get, '');

        ClearLastError();
        if not TryCallApi() then
            Error(GetLastErrorText());

        BusinessGroup."API Connection Verified" := true;
        BusinessGroup.Modify();

        exit(true);
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

    procedure GetApiResponse(): Text
    begin
        exit(ResponseData);
    end;

    procedure GetApiBaseAddress(var BusinessGroup: Record "PVS Business Group") BaseURL: Text
    begin
        BaseURL := 'http';
        if BusinessGroup."API Server Uses SSL" then
            BaseURL += 's';
        BaseURL += '://' + BusinessGroup."API Server FQDN";
        if BusinessGroup."API Server Port" <> 0 then
            BaseURL += ':' + Format(BusinessGroup."API Server Port");
        BaseURL += '/' + BusinessGroup."API Server Instance" + '/';
        BaseURL += StrSubstNo('api/%1/%2/%3/', ApiPublisher(), ApiGroup(), ApiVersion());
    end;

    local procedure GetIdWithoutBrackets(Id: Guid): Text
    begin
        exit(CopyStr(Format(Id), 2, StrLen(Format(Id)) - 2));
    end;

    local procedure GetAuthString(inUsername: Text; inPassword: Text): Text
    var
        Base64Convert: Codeunit "Base64 Convert";
        AuthenticationString: Text;
    begin
        AuthenticationString := StrSubstNo('%1:%2', inUsername, inPassword);
        AuthenticationString := Base64Convert.ToBase64(AuthenticationString);
        AuthenticationString := StrSubstNo('Basic %1', AuthenticationString);
        Exit(AuthenticationString);
    end;
}

