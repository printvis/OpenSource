namespace PrintVis.BoldSign.Integration.Services;

using System.Text;
using System.Utilities;
using Microsoft.Foundation.Reporting;
using PrintVis.BoldSign.Configuration;
using PrintVis.BoldSign.Documents;
using PrintVis.BoldSign.Integration.Http;
using PrintVis.BoldSign.Utilities;

codeunit 80317 "PVS BS Signature Service"
{
    Access = Internal;

    var
        Utilities: Codeunit "PVS BS Utility";
        SignerOrder: Integer;
        DeliveryMode: Text;
        FieldType: Text;
        FieldName: Text;
        FieldPageNumber: Integer;
        FieldX: Integer;
        FieldY: Integer;
        FieldWidth: Integer;
        FieldHeight: Integer;
        UseCustomFieldPosition: Boolean;
        FieldIsRequired: Boolean;

    procedure setSignaturePositionParam(inX: Integer; inY: Integer; inUseCustom: Boolean)
    begin
        FieldX := inX;
        FieldY := inY;
        UseCustomFieldPosition := inUseCustom;
    end;

    procedure StartSignaturesProcess(var Document: Record "PVS BS Document";
        var DocumentInStream: InStream;
        EmailSubject: Text;
        EmailBody: Text;
        Signers: Dictionary of [Text, Text];
        ReportSelection: Record "Report Selections";
        ReportPageCount: Integer): Boolean
    var
        BoldSignSetup: Record "PVS BS Service Setup";
        PrintVisCase: Record "PVS Case";
        HttpClient: Codeunit "PVS BS Http Client";
        Utility: Codeunit "PVS BS Utility";
        JsonMgt: Codeunit "JSON Management";
        TempBlob: Codeunit "Temp Blob";
        ResponseMessage: HttpResponseMessage;
        BodyInStream: InStream;
        JsonRequest, DocumentTitle, DocumentFileName, DocumentIdText, Boundary : Text;
        DocumentId: Guid;
        ExpiryDays: Integer;
        StartSignaturesProcessErr: Label 'Failed to start signature request: %1 %2', Comment = '%1 = HTTP Status Code, %2 = HTTP Reason Phrase';
        NoSignersErr: Label 'No signers provided';
    begin
        BoldSignSetup.Get();
        if not BoldSignSetup.HasApiKey() then
            Error('Enter the BoldSign API key in BoldSign Setup before sending documents.');
        if Signers.Count() = 0 then
            Error(NoSignersErr);

        if not PrintVisCase.Get(Document."Case ID") then
            Clear(PrintVisCase);

        if EmailSubject <> '' then
            EmailSubject := Utility.ReplaceTextPlaceholders(PrintVisCase, EmailSubject);
        if EmailBody <> '' then
            EmailBody := Utility.ReplaceTextPlaceholders(PrintVisCase, EmailBody);

        DocumentFileName := Utility.GetFileName(Document."Report Type", PrintVisCase) + '.pdf';

        DocumentTitle := EmailSubject;
        if DocumentTitle = '' then
            DocumentTitle := Utility.GetReportFileName(Document."Report Type", Document."Case ID");

        if Document."Expires On" <> 0DT then begin
            ExpiryDays := Document."Expires On".Date - Today;
            if ExpiryDays < 1 then
                ExpiryDays := 1;
        end;

        this.InitSignatureFieldDefaults(ReportSelection, ReportPageCount);
        Boundary := 'BoldSign' + DelChr(Format(CreateGuid()), '=', '{}-');
        this.BuildSendMultipartBody(TempBlob, Boundary, DocumentInStream, DocumentFileName, DocumentTitle, EmailBody,
            Document."Allow Delegate", ExpiryDays, Signers);
        TempBlob.CreateInStream(BodyInStream);

        if not HttpClient.SendHttpPostMultipartRequest('document/send', Boundary, BodyInStream, ResponseMessage) then
            Error(StartSignaturesProcessErr, ResponseMessage.HttpStatusCode, ResponseMessage.ReasonPhrase);

        ResponseMessage.Content().ReadAs(JsonRequest);
        if not ResponseMessage.IsSuccessStatusCode() then begin
            Message(JsonRequest);
            exit(false);
        end;

        JsonMgt.InitializeFromString(JsonRequest);
        DocumentIdText := JsonMgt.GetValue('documentId');
        if not Evaluate(DocumentId, DocumentIdText) then
            Error('BoldSign did not return a valid document ID.');

        Document."Document ID" := DocumentId;
        Document.Validate(Status, Enum::"PVS BS Document Status"::"Awaiting Signature");
        Document.Modify();
        Commit();
        exit(true);
    end;

    procedure GetSignatureProcessStatus(var Document: Record "PVS BS Document"): Boolean
    var
        HttpClient: Codeunit "PVS BS Http Client";
        IsSuccess: Boolean;
        ResponseMessage: HttpResponseMessage;
        GetSignatureProcessStatusErr: Label 'Failed to get signature process status: %1 %2', Comment = '%1 = HTTP Status Code, %2 = HTTP Reason Phrase';
        Resource: Text;
    begin
        Clear(ResponseMessage);

        Document.TestField(Status, Enum::"PVS BS Document Status"::"Awaiting Signature");
        Document.TestField("Document ID");

        Resource := StrSubstNo('document/properties?documentId=%1', Utilities.FormatGuid(Document."Document ID"));

        if not HttpClient.SendHttpGetRequest(Resource, ResponseMessage) then
            Error(GetSignatureProcessStatusErr,
                ResponseMessage.HttpStatusCode,
                ResponseMessage.ReasonPhrase);

        IsSuccess := this.HandleGetSignatureProcessStatusResponse(Document, ResponseMessage);
        if IsSuccess then
            if Document.Status in [Enum::"PVS BS Document Status"::Signed, Enum::"PVS BS Document Status"::Canceled] then
                this.DownloadDocument(Document);

        exit(IsSuccess);
    end;

    local procedure HandleGetSignatureProcessStatusResponse(var Document: Record "PVS BS Document"; var ResponseMessage: HttpResponseMessage): Boolean
    var
        JsonMgt: Codeunit "JSON Management";
        JsonResponse, StatusText : Text;
    begin
        ResponseMessage.Content().ReadAs(JsonResponse);

        if not ResponseMessage.IsSuccessStatusCode() then begin
            Message(JsonResponse);
            exit(false);
        end;

        JsonMgt.InitializeFromString(JsonResponse);
        StatusText := JsonMgt.GetValue('status');

        Document.Validate(Status, this.Utilities.TextToDocumentStatus(StatusText));
        if Document.Status in [Enum::"PVS BS Document Status"::Signed, Enum::"PVS BS Document Status"::Canceled] then
            Document."Processed Document ID" := Document."Document ID";
        Document.Modify();
        Commit();

        exit(true);
    end;

    local procedure InitSignatureFieldDefaults(ReportSelection: Record "Report Selections"; ReportPageCount: Integer)
    begin
        SignerOrder := 1;
        DeliveryMode := 'Email';
        FieldType := 'Signature';
        FieldName := 'sign_field';
        FieldIsRequired := true;

        this.GetSignatureBounds(ReportSelection, ReportPageCount, FieldPageNumber, FieldX, FieldY, FieldWidth, FieldHeight);
    end;

    internal procedure GetSignatureBounds(ReportSelection: Record "Report Selections"; ReportPageCount: Integer;
        var PageNumber: Integer; var X: Integer; var Y: Integer; var Width: Integer; var Height: Integer)
    var
        LastPageUnknownErr: Label 'The number of pages in the report could not be determined, so the signature cannot be placed on the last page.';
    begin
        if ReportSelection."PVS BS Sign. On Last Page" then begin
            if ReportPageCount < 1 then
                Error(LastPageUnknownErr);
            PageNumber := ReportPageCount;
        end else
            PageNumber := ReportSelection."PVS BS Sign. Page No.";
        if PageNumber < 1 then
            PageNumber := 1;

        if not UseCustomFieldPosition then
            X := ReportSelection."PVS BS Sign. X";
        if X < 0 then
            X := 50;
        if not UseCustomFieldPosition then
            Y := ReportSelection."PVS BS Sign. Y";
        if Y < 0 then
            Y := 50;
        Width := ReportSelection."PVS BS Sign. Width";
        if Width < 1 then
            Width := 200;
        Height := ReportSelection."PVS BS Sign. Height";
        if Height < 1 then
            Height := 30;
    end;

    local procedure BuildSendMultipartBody(var TempBlob: Codeunit "Temp Blob"; Boundary: Text; var DocumentInStream: InStream;
        FileName: Text; Title: Text; Message: Text; EnableReassign: Boolean; ExpiryDays: Integer; Signers: Dictionary of [Text, Text])
    var
        BodyOutStream: OutStream;
        Brand: Record "PVS BS Brand";
        BrandId: Guid;
        SignerName: Text;
        Prefix: Text;
        CRLF: Text[2];
        i: Integer;
    begin
        CRLF[1] := 13;
        CRLF[2] := 10;
        TempBlob.CreateOutStream(BodyOutStream, TextEncoding::UTF8);

        this.AddTextPart(BodyOutStream, Boundary, 'Title', Title);
        this.AddTextPart(BodyOutStream, Boundary, 'EnableReassign', Format(EnableReassign, 0, 9));
        if Brand.GetActiveBrandId(BrandId) then
            this.AddTextPart(BodyOutStream, Boundary, 'BrandId', this.Utilities.FormatGuid(BrandId));
        if Message <> '' then
            this.AddTextPart(BodyOutStream, Boundary, 'Message', Message);
        if ExpiryDays > 0 then
            this.AddTextPart(BodyOutStream, Boundary, 'ExpiryDays', Format(ExpiryDays, 0, 9));

        foreach SignerName in Signers.Keys do begin
            Prefix := StrSubstNo('Signers[%1]', i);
            this.AddTextPart(BodyOutStream, Boundary, Prefix + '[Name]', SignerName);
            this.AddTextPart(BodyOutStream, Boundary, Prefix + '[EmailAddress]', Signers.Get(SignerName));
            this.AddTextPart(BodyOutStream, Boundary, Prefix + '[SignerOrder]', Format(SignerOrder + i, 0, 9));
            this.AddTextPart(BodyOutStream, Boundary, Prefix + '[DeliveryMode]', DeliveryMode);
            this.AddTextPart(BodyOutStream, Boundary, Prefix + '[FormFields][0][FieldType]', FieldType);
            this.AddTextPart(BodyOutStream, Boundary, Prefix + '[FormFields][0][Name]', FieldName);
            this.AddTextPart(BodyOutStream, Boundary, Prefix + '[FormFields][0][PageNumber]', Format(FieldPageNumber, 0, 9));
            this.AddTextPart(BodyOutStream, Boundary, Prefix + '[FormFields][0][Bounds][X]', Format(FieldX, 0, 9));
            this.AddTextPart(BodyOutStream, Boundary, Prefix + '[FormFields][0][Bounds][Y]', Format(FieldY, 0, 9));
            this.AddTextPart(BodyOutStream, Boundary, Prefix + '[FormFields][0][Bounds][Width]', Format(FieldWidth, 0, 9));
            this.AddTextPart(BodyOutStream, Boundary, Prefix + '[FormFields][0][Bounds][Height]', Format(FieldHeight, 0, 9));
            this.AddTextPart(BodyOutStream, Boundary, Prefix + '[FormFields][0][IsRequired]', Format(FieldIsRequired, 0, 9));
            i += 1;
        end;

        BodyOutStream.WriteText('--' + Boundary + CRLF);
        BodyOutStream.WriteText(StrSubstNo('Content-Disposition: form-data; name="Files"; filename="%1"', FileName) + CRLF);
        BodyOutStream.WriteText('Content-Type: application/pdf' + CRLF + CRLF);
        CopyStream(BodyOutStream, DocumentInStream);
        BodyOutStream.WriteText(CRLF + '--' + Boundary + '--' + CRLF);
    end;

    local procedure AddTextPart(var BodyOutStream: OutStream; Boundary: Text; PartName: Text; PartValue: Text)
    var
        CRLF: Text[2];
    begin
        CRLF[1] := 13;
        CRLF[2] := 10;
        BodyOutStream.WriteText('--' + Boundary + CRLF);
        BodyOutStream.WriteText(StrSubstNo('Content-Disposition: form-data; name="%1"', PartName) + CRLF + CRLF);
        BodyOutStream.WriteText(PartValue + CRLF);
    end;

    local procedure DownloadDocument(var Document: Record "PVS BS Document")
    var
        DownloadService: Codeunit "PVS BS Doc. Download Service";
    begin
        DownloadService.DownloadDocument(Document, true, GuiAllowed());
    end;

    procedure RevokeDocument(var Document: Record "PVS BS Document"): Boolean
    var
        HttpClient: Codeunit "PVS BS Http Client";
        ResponseMessage: HttpResponseMessage;
        RequestBody: JsonObject;
        JsonRequest: Text;
        RevokeDocumentErr: Label 'Document must be awaiting signature to be revoked';
        RevokeReasonLbl: Label 'Revoked from PrintVis.';
        Resource: Text;
    begin
        Document.TestField("Document ID");

        if Document.Status <> Enum::"PVS BS Document Status"::"Awaiting Signature" then
            Error(RevokeDocumentErr);

        Resource := StrSubstNo('document/revoke?documentId=%1', Utilities.FormatGuid(Document."Document ID"));
        RequestBody.Add('Message', RevokeReasonLbl);
        RequestBody.WriteTo(JsonRequest);

        if not HttpClient.SendHttpPostRequest(Resource, JsonRequest, ResponseMessage) then
            Error(RevokeDocumentErr);

        if not ResponseMessage.IsSuccessStatusCode then
            exit(false);

        Document.Validate(Status, Enum::"PVS BS Document Status"::Canceled);
        Document.Modify();
        Commit();

        exit(true);
    end;

    procedure DeleteDocument(var Document: Record "PVS BS Document"): Boolean
    var
        HttpClient: Codeunit "PVS BS Http Client";
        ResponseMessage: HttpResponseMessage;
        RequestBody: JsonObject;
        JsonRequest: Text;
        RevokeDocumentErr: Label 'Document must be awaiting signature to be revoked';
        RevokeReasonLbl: Label 'Revoked from PrintVis.';
        Resource: Text;
    begin
        Document.TestField("Document ID");

        if Document.Status <> Enum::"PVS BS Document Status"::"Awaiting Signature" then
            Error(RevokeDocumentErr);

        Resource := StrSubstNo('document/revoke?documentId=%1', Utilities.FormatGuid(Document."Document ID"));
        RequestBody.Add('Message', RevokeReasonLbl);
        RequestBody.WriteTo(JsonRequest);

        if not HttpClient.SendHttpPostRequest(Resource, JsonRequest, ResponseMessage) then
            Error(RevokeDocumentErr);

        if not ResponseMessage.IsSuccessStatusCode then
            exit(false);

        Document.Validate(Status, Enum::"PVS BS Document Status"::Canceled);
        Document.Modify();
        Commit();

        exit(true);
    end;

    /// <summary>
    /// Retrieves the brands from BoldSign and creates or updates the local brands.
    /// </summary>
    procedure RefreshBrands()
    var
        HttpClient: Codeunit "PVS BS Http Client";
        ResponseMessage: HttpResponseMessage;
        ResponseJson: JsonObject;
        BrandsToken, BrandToken : JsonToken;
        ResponseText: Text;
        RefreshBrandsErr: Label 'Failed to retrieve the brands: %1 %2', Comment = '%1 = HTTP Status Code, %2 = HTTP Reason Phrase';
    begin
        if not HttpClient.SendHttpGetRequest('brand/list', ResponseMessage) then
            Error(RefreshBrandsErr, ResponseMessage.HttpStatusCode, ResponseMessage.ReasonPhrase);

        ResponseMessage.Content().ReadAs(ResponseText);
        if not ResponseMessage.IsSuccessStatusCode() then
            Error(RefreshBrandsErr, ResponseMessage.HttpStatusCode, ResponseText);

        if not ResponseJson.ReadFrom(ResponseText) then
            exit;
        if not ResponseJson.Get('result', BrandsToken) then
            exit;

        foreach BrandToken in BrandsToken.AsArray() do
            this.UpsertBrand(BrandToken.AsObject());
    end;

    /// <summary>
    /// Creates the brand in BoldSign and stores the returned brand ID on the local brand.
    /// </summary>
    procedure CreateBrand(var Brand: Record "PVS BS Brand"; var LogoInStream: InStream; LogoFileName: Text)
    var
        HttpClient: Codeunit "PVS BS Http Client";
        TempBlob: Codeunit "Temp Blob";
        ResponseMessage: HttpResponseMessage;
        ResponseJson: JsonObject;
        BrandIdToken: JsonToken;
        BodyOutStream: OutStream;
        BodyInStream: InStream;
        Boundary, ResponseText : Text;
        BrandId: Guid;
        AlreadyCreatedErr: Label 'Brand %1 already exists in BoldSign.', Comment = '%1 = Brand Code';
        CreateBrandErr: Label 'Failed to create the brand: %1 %2', Comment = '%1 = HTTP Status Code, %2 = HTTP Reason Phrase';
        InvalidResponseErr: Label 'BoldSign did not return a valid brand ID.';
    begin
        if not IsNullGuid(Brand."BoldSign Brand ID") then
            Error(AlreadyCreatedErr, Brand."Code");
        Brand.TestField(Name);

        Boundary := 'BoldSign' + DelChr(Format(CreateGuid()), '=', '{}-');
        TempBlob.CreateOutStream(BodyOutStream, TextEncoding::UTF8);
        this.AddOptionalTextPart(BodyOutStream, Boundary, 'BrandName', Brand.Name);
        this.AddOptionalTextPart(BodyOutStream, Boundary, 'BackgroundColor', Brand.BackgroundColor);
        this.AddOptionalTextPart(BodyOutStream, Boundary, 'ButtonColor', Brand.ButtonColor);
        this.AddOptionalTextPart(BodyOutStream, Boundary, 'ButtonTextColor', Brand.ButtonTextColor);
        this.AddOptionalTextPart(BodyOutStream, Boundary, 'EmailDisplayName', Brand.EmailDisplayName);
        BodyOutStream.WriteText('--' + Boundary + this.GetCRLF());
        BodyOutStream.WriteText(StrSubstNo('Content-Disposition: form-data; name="BrandLogo"; filename="%1"', LogoFileName) + this.GetCRLF());
        BodyOutStream.WriteText('Content-Type: ' + this.GetLogoContentType(LogoFileName) + this.GetCRLF() + this.GetCRLF());
        CopyStream(BodyOutStream, LogoInStream);
        BodyOutStream.WriteText(this.GetCRLF() + '--' + Boundary + '--' + this.GetCRLF());
        TempBlob.CreateInStream(BodyInStream);

        if not HttpClient.SendHttpPostMultipartRequest('brand/create', Boundary, BodyInStream, ResponseMessage) then
            Error(CreateBrandErr, ResponseMessage.HttpStatusCode, ResponseMessage.ReasonPhrase);

        ResponseMessage.Content().ReadAs(ResponseText);
        if not ResponseMessage.IsSuccessStatusCode() then
            Error(CreateBrandErr, ResponseMessage.HttpStatusCode, ResponseText);

        if not ResponseJson.ReadFrom(ResponseText) then
            Error(InvalidResponseErr);
        if not ResponseJson.Get('brandId', BrandIdToken) then
            Error(InvalidResponseErr);
        if not Evaluate(BrandId, BrandIdToken.AsValue().AsText()) then
            Error(InvalidResponseErr);

        Brand."BoldSign Brand ID" := BrandId;
        Brand.Modify();
    end;

    local procedure UpsertBrand(BrandJson: JsonObject)
    var
        Brand: Record "PVS BS Brand";
        BrandId: Guid;
    begin
        if not Evaluate(BrandId, this.GetJsonText(BrandJson, 'brandId')) then
            exit;

        Brand.SetRange("BoldSign Brand ID", BrandId);
        if not Brand.FindFirst() then begin
            Brand.Reset();
            Brand.Init();
            Brand."Code" := this.GetNewCode(this.GetJsonText(BrandJson, 'brandName'));
            Brand."BoldSign Brand ID" := BrandId;
            Brand.Insert();
        end;

        Brand.Name := CopyStr(this.GetJsonText(BrandJson, 'brandName'), 1, MaxStrLen(Brand.Name));
        Brand.BackgroundColor := CopyStr(this.GetJsonText(BrandJson, 'backgroundColor'), 1, MaxStrLen(Brand.BackgroundColor));
        Brand.ButtonColor := CopyStr(this.GetJsonText(BrandJson, 'buttonColor'), 1, MaxStrLen(Brand.ButtonColor));
        Brand.ButtonTextColor := CopyStr(this.GetJsonText(BrandJson, 'buttonTextColor'), 1, MaxStrLen(Brand.ButtonTextColor));
        Brand.EmailDisplayName := CopyStr(this.GetJsonText(BrandJson, 'emailDisplayName'), 1, MaxStrLen(Brand.EmailDisplayName));
        Brand.Modify();
    end;

    local procedure GetNewCode(BrandName: Text): Code[20]
    var
        Brand: Record "PVS BS Brand";
        BaseCode: Code[20];
        NewCode: Code[20];
        Suffix: Integer;
    begin
        BaseCode := CopyStr(UpperCase(DelChr(BrandName, '=', ' ')), 1, 16);
        if BaseCode = '' then
            BaseCode := 'BRAND';

        NewCode := BaseCode;
        while Brand.Get(NewCode) do begin
            Suffix += 1;
            NewCode := CopyStr(BaseCode + Format(Suffix), 1, MaxStrLen(NewCode));
        end;
        exit(NewCode);
    end;

    local procedure GetJsonText(JsonObj: JsonObject; PropertyName: Text): Text
    var
        JsonToken: JsonToken;
    begin
        if not JsonObj.Get(PropertyName, JsonToken) then
            exit('');
        if not JsonToken.IsValue() then
            exit('');
        if JsonToken.AsValue().IsNull() then
            exit('');
        exit(JsonToken.AsValue().AsText());
    end;

    local procedure GetLogoContentType(FileName: Text): Text
    var
        UnsupportedLogoErr: Label 'The logo must be a PNG, JPEG or SVG file.';
    begin
        FileName := FileName.ToLower();
        case true of
            FileName.EndsWith('.png'):
                exit('image/png');
            FileName.EndsWith('.jpg'), FileName.EndsWith('.jpeg'):
                exit('image/jpeg');
            FileName.EndsWith('.svg'):
                exit('image/svg+xml');
            else
                Error(UnsupportedLogoErr);
        end;
    end;

    local procedure AddOptionalTextPart(var BodyOutStream: OutStream; Boundary: Text; PartName: Text; PartValue: Text)
    begin
        if PartValue = '' then
            exit;

        BodyOutStream.WriteText('--' + Boundary + this.GetCRLF());
        BodyOutStream.WriteText(StrSubstNo('Content-Disposition: form-data; name="%1"', PartName) + this.GetCRLF() + this.GetCRLF());
        BodyOutStream.WriteText(PartValue + this.GetCRLF());
    end;

    local procedure GetCRLF() Result: Text[2]
    begin
        Result[1] := 13;
        Result[2] := 10;
    end;
}