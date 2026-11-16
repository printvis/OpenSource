namespace PrintVis.SpencerMetrics.Services;

using PrintVis.SpencerMetrics.CounterManagement;
using PrintVis.SpencerMetrics.Configuration;
using PrintVis.SpencerMetrics;

codeunit 80295 "PVS SM Api Client"
{
    Access = Internal;

    var
        CostCenterSetupNotFoundErr: Label 'Cost Center SpencerMetrics setup not found';
        InvalidJsonResponseErr: Label 'Invalid JSON response';
        InvalidLoginKeyErr: Label 'Unauthorized - invalid login key';
        UnableToProcessRequestErr: Label 'Unable to process request: Error Code = %1', Comment = '%1 = Error Code';

    procedure ProcessSpencerMetricsData(in_CostCenterCode: Code[20])
    var
        SMCostCenterSetup: Record "PVS SM Cost Center Setup";
        CounterEntry: Record "PVS SM Counter Entry";
        SMSetup: Record "PVS SM Setup";
        Prefix, RequestUrl, Response, SubString : Text;
    begin
        if (in_CostCenterCode = '') then
            exit;

        SMSetup.Get();
        SMSetup.TestField("Base URL");

        if SMCostCenterSetup.Get(in_CostCenterCode) then begin
            this.Authenticate(SMSetup."Base URL", SMCostCenterSetup);

            RequestUrl := this.BuildRequestUrl(SMSetup."Base URL", 'getXMLData?ApiSid=' + SMCostCenterSetup."Login Key");
            Response := this.SendGetRequest(RequestUrl, Response);

            if StrLen(Response) >= 5 then
                Prefix := CopyStr(Response, 1, 5)
            else
                Prefix := Response;

            if Prefix = '<?xml' then begin
                SubString := Response;

                Clear(CounterEntry);
                CounterEntry."Cost Center Code" := in_CostCenterCode;
                CounterEntry.SetXMLContent(SubString);

                Clear(CounterEntry);
                CounterEntry."Cost Center Code" := in_CostCenterCode;
                CounterEntry."Entry No." := CounterEntry.GetNextEntryNo(in_CostCenterCode);
                CounterEntry.SetXMLContent(SubString);
                this.ParseXMLResponse(SubString, CounterEntry, SMCostCenterSetup);
                SMCostCenterSetup.SetLastHeartbeat();
                CounterEntry.Insert();
                Commit();
            end else
                SubString := this.ParseApiResponse(Response);

            if SubString = 'Unauthorized' then begin
                SMCostCenterSetup."Last Error" := InvalidLoginKeyErr;
                SMCostCenterSetup.SetLastHeartbeat();
                SMCostCenterSetup.Modify();
                Commit();
            end;

            if SubString = 'Invalid JSON response' then begin
                SMCostCenterSetup."Last Error" := InvalidJsonResponseErr;
                SMCostCenterSetup.SetLastHeartbeat();
                SMCostCenterSetup.Modify();
                Commit();
            end;

        end else begin
            Clear(SMCostCenterSetup);
            SMCostCenterSetup."Cost Center" := in_CostCenterCode;
            SMCostCenterSetup."Last Error" := CostCenterSetupNotFoundErr;
            SMCostCenterSetup.SetLastHeartbeat();
            SMCostCenterSetup.Modify();
            Commit();
        end;
    end;

    local procedure Authenticate(in_BaseUrl: Text; var out_SMCostCenterSetup: Record "PVS SM Cost Center Setup")
    var
        LoginKey, RequestUrl, Response, SubString : Text;
    begin
        RequestUrl := this.BuildRequestUrl(in_BaseUrl, 'login?key=' + out_SMCostCenterSetup."API Key");
        Response := this.SendGetRequest(RequestUrl, LoginKey);
        SubString := this.ParseApiResponse(Response);

        LoginKey := SubString;
        out_SMCostCenterSetup."Login Key" := CopyStr(LoginKey, 1, MaxStrLen(out_SMCostCenterSetup."Login Key"));
    end;

    procedure ParseApiResponse(in_ResponseText: Text): Text
    var
        JsonObj: JsonObject;
        Token: JsonToken;
        DataText, ErrorText : Text;
    begin
        if JsonObj.ReadFrom(in_ResponseText) then begin
            if JsonObj.Get('error', Token) then
                if Token.IsValue then
                    ErrorText := Token.AsValue().AsText();
            if JsonObj.Get('data', Token) then
                if Token.IsValue then
                    DataText := Token.AsValue().AsText();
        end else
            ErrorText := 'Invalid JSON response';

        if DataText <> '' then
            exit(DataText);
        if ErrorText <> '' then
            exit(ErrorText);
    end;

    procedure ParseXMLResponse(
        in_ResponseText: Text;
        var out_CounterEntry: Record "PVS SM Counter Entry";
        var out_SMCostCenterSetup: Record "PVS SM Cost Center Setup")
    var
        PrevCounterEntry: Record "PVS SM Counter Entry";
        Hours: Decimal;
        ElapsedTime: Duration;
        DiffCount,
        TotalProductionCounter : Integer;
        CounterTxt: Text;
        DeviceStatus: Text;
        Attribute: XmlAttribute;
        XmlDoc: XmlDocument;
        Node: XmlNode;
    begin
        // Parse XML into XmlDocument (static call)
        if not XmlDocument.ReadFrom(in_ResponseText, XmlDoc) then begin
            out_SMCostCenterSetup."Last Error" := 'Invalid XML.';
            exit;
        end;

        // TimeStamp on root <JMF>
        out_CounterEntry."Current Time" := CurrentDateTime();

        // DeviceStatus on <DeviceInfo>
        if XmlDoc.SelectSingleNode('/*[local-name()="JMF"]/*[local-name()="Signal"]/*[local-name()="DeviceInfo"]/@DeviceStatus', Node) then begin
            Attribute := Node.AsXmlAttribute();
            DeviceStatus := Attribute.Value;
            out_CounterEntry."Device Status" := CopyStr(DeviceStatus, 1, MaxStrLen(out_CounterEntry."Device Status"));
        end else
            DeviceStatus := '';

        // TotalProductionCounter on <DeviceInfo>
        if XmlDoc.SelectSingleNode('/*[local-name()="JMF"]/*[local-name()="Signal"]/*[local-name()="DeviceInfo"]/@TotalProductionCounter', Node) then begin
            Attribute := Node.AsXmlAttribute();
            CounterTxt := Attribute.Value;
            if not Evaluate(TotalProductionCounter, CounterTxt) then
                TotalProductionCounter := 0;
        end else
            TotalProductionCounter := 0;

        out_CounterEntry."Current Count" := TotalProductionCounter;

        //Compare against previous record
        PrevCounterEntry.Reset();
        PrevCounterEntry.SetRange("Cost Center Code", out_CounterEntry."Cost Center Code");
        if PrevCounterEntry.FindLast() then begin
            out_CounterEntry.UOM := PrevCounterEntry.UOM;
            out_CounterEntry."Case ID" := PrevCounterEntry."Case ID";
            out_CounterEntry."Plan ID" := PrevCounterEntry."Plan ID";
            if PrevCounterEntry."Current Count" <> -1 then
                DiffCount := out_CounterEntry."Current Count" - PrevCounterEntry."Current Count"
            else
                DiffCount := 0;
            out_CounterEntry."Difference Count" := DiffCount;
            if PrevCounterEntry."Current Time" = 0DT then
                ElapsedTime := out_CounterEntry."Current Time" - out_CounterEntry."Current Time"
            else
                ElapsedTime := out_CounterEntry."Current Time" - PrevCounterEntry."Current Time";

            if ElapsedTime = 0 then
                out_CounterEntry.Speed := 0
            else begin
                Hours := ElapsedTime / (1000 * 60 * 60);
                if Hours > 0 then
                    out_CounterEntry.Speed := Round(DiffCount / Hours, 1);
            end;
        end;
    end;

    local procedure BuildRequestUrl(in_BaseUrl: Text; in_Resource: Text): Text
    var
        RequestUrl: Text;
    begin
        RequestUrl := in_BaseUrl;
        if not RequestUrl.EndsWith('/') then
            RequestUrl := RequestUrl + '/';

        RequestUrl := RequestUrl + in_Resource;

        exit(RequestUrl);
    end;

    procedure SendGetRequest(in_Uri: Text; in_ServiceAction: Text): Text
    var
        IsHandled: Boolean;
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Response: Text;
    begin
        IsHandled := false;
        this.MockWebRequest(in_ServiceAction, Response, IsHandled);
        if IsHandled then
            exit(Response);

        Client.DefaultRequestHeaders().Clear();
        RequestMessage.SetRequestUri(in_Uri);
        RequestMessage.Method('GET');
        if Client.Send(RequestMessage, ResponseMessage) then begin
            ResponseMessage.Content().ReadAs(Response);
            exit(Response);
        end else
            Error(UnableToProcessRequestErr, ResponseMessage.HttpStatusCode());
    end;

    local procedure MockWebRequest(in_ServiceAction: Text; var out_Response: Text; var out_IsHandled: Boolean)
    var
        SpencerMetricsEvents: Codeunit "PVS SM Events";
    begin
        if in_ServiceAction = '' then
            exit;

        SpencerMetricsEvents.OnMockWebRequest(in_ServiceAction, out_Response, out_IsHandled);
    end;
}
