namespace PrintVis.BoldSign.Integration.Services;

using PrintVis.BoldSign.CloudDrive;
using PrintVis.BoldSign.Documents;
using PrintVis.BoldSign.Integration.Http;
using PrintVis.BoldSign.Utilities;

codeunit 80316 "PVS BS Doc. Download Service"
{
    Access = Internal;

    var
        Utilities: Codeunit "PVS BS Utility";

    procedure DownloadDocument(var Document: Record "PVS BS Document"; SaveToFolder: Boolean; ShowDownloadDialog: Boolean): Boolean
    var
        HttpClient: Codeunit "PVS BS Http Client";
        ResponseMessage: HttpResponseMessage;
        InStream: InStream;
        DownloadDocumentErr: Label 'Failed to download document. Status: %1, Reason: %2', Comment = '%1 = HTTP Status Code, %2 = HTTP Reason Phrase';
        DocumentSuffix,
        Resource : Text;
    begin
        if not this.TryGetDocumentSuffix(Document, DocumentSuffix) then
            exit(false);

        Resource := StrSubstNo('document/download?documentId=%1', Utilities.FormatGuid(Document."Processed Document ID"));

        if not HttpClient.SendHttpGetRequest(Resource, ResponseMessage) then
            Error(DownloadDocumentErr, ResponseMessage.HttpStatusCode, ResponseMessage.ReasonPhrase);

        ResponseMessage.Content.ReadAs(InStream);
        if InStream.Length = 0 then
            exit(false);

        if SaveToFolder then
            this.SaveDocumentToCloudFolder(Document, InStream, DocumentSuffix);

        if ShowDownloadDialog then
            this.ShowDocumentDownloadDialog(Document, InStream, DocumentSuffix);

        exit(GetLastErrorText() = '');
    end;

    local procedure TryGetDocumentSuffix(Document: Record "PVS BS Document"; var DocumentSuffix: Text): Boolean
    var
        DeclinedSuffixTok: Label 'declined', Locked = true;
        SignedSuffixTok: Label 'signed', Locked = true;
    begin
        case Document.Status of
            Enum::"PVS BS Document Status"::Signed:
                DocumentSuffix := SignedSuffixTok;
            Enum::"PVS BS Document Status"::Canceled:
                DocumentSuffix := DeclinedSuffixTok;
            else
                exit(false);
        end;

        exit(true);
    end;

    local procedure SaveDocumentToCloudFolder(Document: Record "PVS BS Document"; var InStream: InStream; DocumentSuffix: Text)
    var
        PrintVisCase: Record "PVS Case";
        FolderSetup: Record "PVS Folder Setup";
        ReportSetup: Record "PVS Report Setup";
        CloudDriveMgt: Codeunit "PVS BS Cloud Drive Mgt.";
        Utility: Codeunit "PVS BS Utility";
        ReportFileName: Text;
    begin
        if not (PrintVisCase.Get(Document."Case ID") and
               ReportSetup.Get(Document."Report Setup Code") and
               (ReportSetup."Folder Group Code" <> '')) then
            exit;

        FolderSetup.Reset();
        FolderSetup.SetRange("Storage Type", FolderSetup."Storage Type"::Graph);
        FolderSetup.SetRange(Type, FolderSetup.Type::Folders);
        FolderSetup.SetRange(Group, ReportSetup."Folder Group Code");

        case Document.Status of
            Enum::"PVS BS Document Status"::Signed:
                FolderSetup.SetRange("PVS BS Signed Documents", Document."Report Type");
            Enum::"PVS BS Document Status"::Canceled:
                FolderSetup.SetRange("PVS BS Declined Documents", Document."Report Type");
        end;

        if not FolderSetup.FindFirst() then
            exit;

        ReportFileName := StrSubstNo('%1 %2', Utility.GetFileName(Document."Report Type", PrintVisCase), DocumentSuffix);

        CloudDriveMgt.SaveDocumentToFolder(Document."Case ID",
            ReportSetup."Folder Group Code",
            FolderSetup."Folder ID",
            ReportFileName,
            InStream);
    end;

    local procedure ShowDocumentDownloadDialog(Document: Record "PVS BS Document"; var InStream: InStream; DocumentSuffix: Text)
    var
        FileFilterTok: Label 'PDF (*.pdf)|*.pdf', Locked = true;
        ToFile: Text;
    begin
        ToFile := StrSubstNo('%1 %2 %3.pdf', Document."Case ID", Format(Document."Report Type"), DocumentSuffix);
        DownloadFromStream(InStream, '', '', FileFilterTok, ToFile);
    end;
}