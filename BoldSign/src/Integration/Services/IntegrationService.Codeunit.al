namespace PrintVis.BoldSign.Integration.Services;

using Microsoft.Foundation.Reporting;
using PrintVis.BoldSign.Configuration;
using PrintVis.BoldSign.Documents;

codeunit 80305 "PVS BS Integration Service"
{
    Access = Internal;

    var
        ActivityLogMgt: Codeunit "PVS BS Activity Log Mgt.";

    /// <summary>
    /// Downloads a document from the BoldSign service.
    /// </summary>
    /// <param name="Document">The document record to download.</param>
    /// <param name="SaveToFolder">If true, saves the document to a folder. If false, opens the document.</param>
    /// <param name="ShowDownloadDialog">If true, shows a download dialog. If false, uses default download location.</param>
    /// <returns>True if the download was successful, false otherwise.</returns>
    procedure DownloadDocument(var Document: Record "PVS BS Document"; SaveToFolder: Boolean; ShowDownloadDialog: Boolean): Boolean
    var
        DocumentDownloadService: Codeunit "PVS BS Doc. Download Service";
        Result: Boolean;
        DocumentDownloadActivityDescriptionLbl: Label 'Document Download', Locked = true;
        DocumentDownloadFailedLbl: Label 'Failed to download document from BoldSign service. Error: %1', Comment = '%1 = Error Message';
        DocumentDownloadSuccessLbl: Label 'Successfully downloaded document from BoldSign service.';
    begin
        ClearLastError();
        Result := DocumentDownloadService.DownloadDocument(Document, SaveToFolder, ShowDownloadDialog);
        if Result then
            this.ActivityLogMgt.LogSuccess(Document, DocumentDownloadActivityDescriptionLbl, DocumentDownloadSuccessLbl)
        else
            this.ActivityLogMgt.LogFailure(Document, DocumentDownloadActivityDescriptionLbl, StrSubstNo(DocumentDownloadFailedLbl, GetLastErrorText()));

        exit(Result);
    end;


    procedure RevokeDocument(var Document: Record "PVS BS Document"): Boolean
    var
        DocumentRevokeService: Codeunit "PVS BS Signature Service";
        Result: Boolean;
        DocumentRevokeActivityDescriptionLbl: Label 'Document Revoke', Locked = true;
        DocumentRevokeFailedLbl: Label 'Failed to revoke document in BoldSign. Error: %1', Comment = '%1 = Error Message';
        DocumentRevokeSuccessLbl: Label 'Successfully revoked document in BoldSign.';
    begin
        ClearLastError();
        Result := DocumentRevokeService.RevokeDocument(Document);
        if Result then
            this.ActivityLogMgt.LogSuccess(Document, DocumentRevokeActivityDescriptionLbl, DocumentRevokeSuccessLbl)
        else
            this.ActivityLogMgt.LogFailure(Document, DocumentRevokeActivityDescriptionLbl, StrSubstNo(DocumentRevokeFailedLbl, GetLastErrorText()));

        exit(Result);
    end;


    /// <summary>
    /// Starts the signature process for a document.
    /// </summary>
    /// <param name="Document">The document record to start the signature process for.</param>
    /// <param name="EmailSubject">The subject of the email to send to the signers.</param>
    /// <param name="EmailBody">The body of the email to send to the signers.</param>
    /// <param name="Signers">A dictionary containing signer names as keys and their email addresses as values.</param>
    /// <param name="ReportSelection">The report selection holding the signature field position.</param>
    /// <param name="ReportPageCount">The page count of the report PDF, used when the signature is placed on the last page.</param>
    /// <returns>True if the signature process was started successfully, false otherwise.</returns>
    procedure StartSignaturesProcess(var Document: Record "PVS BS Document";
        var DocumentInStream: InStream;
        EmailSubject: Text;
        EmailBody: Text;
        Signers: Dictionary of [Text, Text];
        ReportSelection: Record "Report Selections";
        ReportPageCount: Integer;
        posX: Integer; posY: integer; inUseCustomPos: Boolean): Boolean
    var
        SignatureService: Codeunit "PVS BS Signature Service";
        Result: Boolean;
        SignatureProcessActivityDescriptionLbl: Label 'Signature Process', Locked = true;
        SignatureProcessFailedLbl: Label 'Failed to start signature process for document. Error: %1', Comment = '%1 = Error Message';
        SignatureProcessSuccessLbl: Label 'Successfully started signature process for document.';
    begin
        ClearLastError();

        if inUseCustomPos then
            SignatureService.setSignaturePositionParam(posX, posY, true);

        Result := SignatureService.StartSignaturesProcess(Document, DocumentInStream, EmailSubject, EmailBody, Signers, ReportSelection, ReportPageCount);

        if Result then
            this.ActivityLogMgt.LogSuccess(Document, SignatureProcessActivityDescriptionLbl, SignatureProcessSuccessLbl)
        else
            this.ActivityLogMgt.LogFailure(Document, SignatureProcessActivityDescriptionLbl, StrSubstNo(SignatureProcessFailedLbl, GetLastErrorText()));

        exit(Result);
    end;

    /// <summary>
    /// Gets the current status of a signature process.
    /// </summary>
    /// <param name="Document">The document record to get the signature status for.</param>
    /// <returns>True if the status was retrieved successfully, false otherwise.</returns>
    procedure GetSignatureProcessStatus(var Document: Record "PVS BS Document"): Boolean
    var
        SignatureService: Codeunit "PVS BS Signature Service";
        Result: Boolean;
        OldStatus: Enum "PVS BS Document Status";
        SignatureStatusActivityDescriptionLbl: Label 'Signature Process', Locked = true;
        SignatureStatusChangedLbl: Label 'Status changed from %1 to %2', Comment = '%1 = Old Status, %2 = New Status';
        SignatureStatusFailedLbl: Label 'Failed to retrieve signature process status. Error: %1', Comment = '%1 = Error Message';
        SignatureStatusSuccessLbl: Label 'Successfully retrieved signature process status.';
    begin
        ClearLastError();
        OldStatus := Document.Status;
        Result := SignatureService.GetSignatureProcessStatus(Document);
        if Result then begin
            this.ActivityLogMgt.LogSuccess(Document, SignatureStatusActivityDescriptionLbl, SignatureStatusSuccessLbl);
            if OldStatus <> Document.Status then
                this.ActivityLogMgt.LogSuccess(Document, SignatureStatusActivityDescriptionLbl, StrSubstNo(SignatureStatusChangedLbl, OldStatus, Document.Status));
        end else
            this.ActivityLogMgt.LogFailure(Document, SignatureStatusActivityDescriptionLbl, StrSubstNo(SignatureStatusFailedLbl, GetLastErrorText()));

        exit(Result);
    end;




}