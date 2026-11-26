namespace PrintVis.BoldSign.Processing;

using System.Email;
using System.Text;
using System.Utilities;
using Microsoft.CRM.Contact;
using Microsoft.EServices.EDocument;
using Microsoft.Foundation.Reporting;
using PrintVis.BoldSign.CloudDrive;
using PrintVis.BoldSign.Configuration;
using PrintVis.BoldSign.Documents;
using PrintVis.BoldSign.Integration.Services;
using PrintVis.BoldSign.Utilities;
using PrintVis.BoldSign.Common;
using PrintVis.BoldSign.Workflows;

page 80304 "PVS BS Send for Signature"
{
    ApplicationArea = All;
    Caption = 'Send for Signature';
    PageType = NavigatePage;
    SourceTable = "PVS BS Document";
    SourceTableTemporary = true;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(SignerStep)
            {
                ShowCaption = false;
                Visible = this.SignerStepVisible;

                group(SignerWelcome)
                {
                    Caption = 'Enter Signer Information';
                    InstructionalText = 'Please enter the name and email of the person who should sign this document.';
                    field("Signer Name"; this.SignerName)
                    {
                        Caption = 'Name';
                        ShowMandatory = true;
                    }
                    field("Signer Email"; this.SignerEmail)
                    {
                        Caption = 'Email';
                        ShowMandatory = true;

                        trigger OnValidate()
                        begin
                            this.ValidateEmail(this.SignerEmail);
                        end;
                    }
                    group(SigPosition)
                    {
                        Caption = 'Signature Position';
                        field(sigX; sigX)
                        {
                            Caption = 'Signature Pos. X';
                            ToolTip = 'Specifies the horizontal position of the signature field, measured from the left edge of the page.';

                            trigger OnValidate()
                            begin

                            end;
                        }
                        field(sigY; sigY)
                        {
                            Caption = 'Signature Pos. Y';
                            ToolTip = 'Specifies the vertical position of the signature field, measured from the top edge of the page.';

                            trigger OnValidate()
                            begin

                            end;
                        }

                    }
                    usercontrol(PDFUtility; "PVS BS PDF Utility")
                    {
                        trigger ControlAddinReady()
                        var
                            ReportPdfToken: JsonToken;
                        begin
                            if not this.ReportSelection."PVS BS Sign. On Last Page" then
                                exit;

                            if this.PDFArray.Get(0, ReportPdfToken) then
                                CurrPage.PDFUtility.GetPageCount(ReportPdfToken.AsValue().AsText());
                        end;

                        trigger PageCountReady(PageCount: Integer)
                        begin
                            this.ReportPageCount := PageCount;
                        end;

                        trigger MergeComplete(MergedPdfContent: Text)
                        var
                            Base64Convert: Codeunit "Base64 Convert";
                            FinalOutStream: OutStream;
                        begin
                            this.FinalBlob.CreateOutStream(FinalOutStream);
                            Base64Convert.FromBase64(MergedPdfContent, FinalOutStream);

                            this.ShowDocumentPreviewEnabled := true;
                            CurrPage.Update();
                        end;

                        trigger MergeError(ErrorMessage: Text)
                        begin
                            Message(ErrorMessage);
                        end;

                        trigger SignatureBoxReady(PdfContent: Text)
                        begin
                            this.ShowMarkedPreview(PdfContent);
                        end;
                    }
                }
            }

            group(FinishStep)
            {
                ShowCaption = false;
                Visible = this.FinishStepVisible;

                group(Summary)
                {
                    Caption = 'Summary';
                    InstructionalText = 'Review the information below and click Finish to send the document for signature.';
                    field(SummarySignerName; this.SignerName)
                    {
                        Caption = 'Signer Name';
                        Editable = false;
                    }
                    field(SummarySignerEmail; this.SignerEmail)
                    {
                        Caption = 'Signer Email';
                        Editable = false;
                    }
                    field(SummaryEmailSubject; this.EmailSubject)
                    {
                        Caption = 'Email Subject';
                        ToolTip = 'Specifies the subject of the email. You can use the following placeholders: %1 = Quote Number, %2 = Order Number, %3 = Contact Name, %4 = Job Name, %5 = Salesperson name, %6 = Coordinator name.';

                        trigger OnValidate()
                        begin
                            this.EmailSubject := this.Utility.ReplaceTextPlaceholders(this.PrintVisCase, this.EmailSubject);
                        end;
                    }
                    field(SummaryEmailBody; this.EmailBody)
                    {
                        Caption = 'Email Body';
                        ToolTip = 'Specifies the body content of the notification email. You can use the following placeholders: %1 = Quote Number, %2 = Order Number, %3 = Contact Name, %4 = Job Name, %5 = Salesperson name, %6 = Coordinator name.';
                        MultiLine = true;

                        trigger OnValidate()
                        begin
                            this.EmailBody := this.Utility.ReplaceTextPlaceholders(this.PrintVisCase, this.EmailBody);
                        end;
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Cancel)
            {
                Caption = 'Cancel';
                Image = Cancel;
                InFooterBar = true;
                ToolTip = 'Closes the wizard without sending the document.';
                Visible = this.SignerStepVisible;

                trigger OnAction()
                begin
                    CurrPage.Close();
                end;
            }
            action(Back)
            {
                Caption = 'Back';
                Enabled = this.BackEnabled;
                Visible = this.FinishStepVisible;
                Image = PreviousRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    this.NextStep(true);
                end;
            }
            action("Next")
            {
                Caption = 'Next';
                Enabled = this.NextEnabled;
                Image = NextRecord;
                InFooterBar = true;
                Visible = not this.FinishEnabled;

                trigger OnAction()
                begin
                    this.NextStep(false);
                end;
            }
            action(Finish)
            {
                Caption = 'Finish';
                Enabled = this.FinishEnabled;
                Image = Approve;
                InFooterBar = true;
                Visible = this.FinishEnabled;

                trigger OnAction()
                begin
                    this.SendDocument();
                end;
            }
            fileuploadaction(FileUpload)
            {
                AllowMultipleFiles = true;
                AllowedFileExtensions = '.pdf';
                Caption = 'Add additional PDF';
                Image = Import;
                InFooterBar = true;
                ToolTip = 'This action allows you to choose the PDF files that will be included in the document for signature.';
                Visible = not this.FinishEnabled;

                trigger OnAction(files: List of [FileUpload])
                var
                    Base64Convert: Codeunit "Base64 Convert";
                    CurrentFile: FileUpload;
                    FileInStream: InStream;
                begin
                    this.ShowDocumentPreviewEnabled := false;

                    foreach CurrentFile in files do begin
                        CurrentFile.CreateInStream(FileInStream, TextEncoding::UTF8);
                        this.PDFArray.Add(Base64Convert.ToBase64(FileInStream));
                    end;

                    CurrPage.PDFUtility.MergePDFs(PDFArray);
                end;
            }
            action(ShowPreview)
            {
                Caption = 'Show Preview';
                Enabled = this.ShowDocumentPreviewEnabled;
                Image = View;
                InFooterBar = true;

                trigger OnAction()
                begin
                    this.ShowDocumentPreview();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        Base64Convert: Codeunit "Base64 Convert";
        RecordRef: RecordRef;
        MissingApiKeyErr: Label 'Enter the BoldSign API key in BoldSign Setup before sending documents.';
        BoldSignIsNotEnabledErr: Label 'BoldSign is not enabled';
        ReportInStream: InStream;
    begin
        this.ShowDocumentPreviewEnabled := true;

        if not this.BoldSignSetup.Get() then
            Clear(this.BoldSignSetup);

        if not this.BoldSignSetup.Enabled then
            Error(BoldSignIsNotEnabledErr);

        if not this.BoldSignSetup.HasApiKey() then
            Error(MissingApiKeyErr);

        RecordRef.GetTable(this.PrintVisCase);
        RecordRef.SetRecFilter();
        if not this.BoldSignManager.SaveReport(this.ReportID, RecordRef, this.ReportBlob) then
            Error(GetLastErrorText());

        this.ReportBlob.CreateInStream(ReportInStream);
        this.PDFArray.Add(Base64Convert.ToBase64(ReportInStream));

        this.StepNumber := 1;
        this.UpdateWizardState();
    end;

    local procedure NextStep(Backwards: Boolean)
    begin
        if Backwards then
            this.StepNumber -= 1
        else
            if this.ValidateCurrentStep() then
                this.StepNumber += 1;

        this.UpdateWizardState();
    end;

    local procedure ValidateCurrentStep(): Boolean
    begin
        case this.StepNumber of
            1:
                exit(this.ValidateSignerStep());
            2:
                exit(true);
            3:
                exit(true);
        end;
    end;

    local procedure ValidateSignerStep(): Boolean
    var
        EnterSignerNameMsg: Label 'Please enter the signer name.';
        EnterSignerEmailMsg: Label 'Please enter the signer email.';
    begin
        if this.SignerName = '' then begin
            Message(EnterSignerNameMsg);
            exit(false);
        end;
        if this.SignerEmail = '' then begin
            Message(EnterSignerEmailMsg);
            exit(false);
        end;

        if not this.ValidateEmail(this.SignerEmail) then
            exit(false);

        exit(true);
    end;

    local procedure ValidateEmail(Email: Text): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(MailManagement.CheckValidEmailAddress(Email))
    end;

    local procedure UpdateWizardState()
    begin
        this.SignerStepVisible := this.StepNumber = 1;
        this.FinishStepVisible := this.StepNumber = 2;

        this.BackEnabled := this.StepNumber > 1;
        this.NextEnabled := this.StepNumber < 2;
        this.FinishEnabled := this.StepNumber = 2;

        this.StepStyle := 'Strong';
    end;

    local procedure SendDocument()
    var
        NewDocument: Record "PVS BS Document";
        Dialog: Dialog;
        DialogMsg: Label 'Creating Document...#1####\\Sending to BoldSign...#2####';
        DocumentInStream: InStream;
        ErrorText: Text;
    begin
        this.InitializeSigners();
        Dialog.Open(DialogMsg);
        Commit();

        if not this.TryCreateDocument(NewDocument, Dialog, ErrorText) then begin
            Message(ErrorText);
            exit;
        end;

        DocumentInStream := this.GetDocumentInStream();
        if not this.TryStartSignatureProcess(NewDocument, DocumentInStream, Dialog, ErrorText) then begin
            Message(ErrorText);
            exit;
        end;

        Dialog.Close();

        if ErrorText <> '' then
            Message(ErrorText)
        else
            this.HandleSuccessfulSending(NewDocument);

        CurrPage.Close();
    end;

    local procedure InitializeSigners()
    begin
        Clear(this.Signers);
        this.Signers.Add(this.SignerName, this.SignerEmail);
    end;

    local procedure TryCreateDocument(var NewDocument: Record "PVS BS Document"; var Dialog: Dialog; var ErrorText: Text): Boolean
    var
        ReportManagement: Codeunit "PVS Report Mgt";
        NewDocumentId: BigInteger;
        FailedToCreateDocumentErr: Label 'Failed to create document';
    begin
        NewDocumentId := this.BoldSignManager.CreateDocument(
            this.PrintVisCase,
            this.ReportType,
            this.ReportID,
            this.BoldSignSetup."Document Exp. DateFormula",
            this.SentDocumentWorkflow,
            this.PostSigningWorkflow,
            this.ExpiredDocumentWorkflow,
            this.DeclinedDocumentWorkflow,
            this.AddDeclineButton,
            this.AllowDelegate,
            ReportManagement.GetGlobalReportCode());

        if not NewDocument.Get(NewDocumentId) then begin
            ErrorText := FailedToCreateDocumentErr;
            this.UpdateDialogError(Dialog, 1);
            exit(false);
        end;

        this.UpdateDialogSuccess(Dialog, 1);
        exit(true);
    end;

    local procedure TryStartSignatureProcess(var NewDocument: Record "PVS BS Document"; var DocumentInStream: InStream; var Dialog: Dialog; var ErrorText: Text): Boolean
    var
        BoldSignService: Codeunit "PVS BS Integration Service";
        FailedToStartSignaturesProcessErr: Label 'Failed to start signature process';
        useCustomPosSig: Boolean;
    begin
        useCustomPosSig := (this.ReportSelection."PVS BS Sign. X" <> sigX) or (this.ReportSelection."PVS BS Sign. Y" <> sigY);

        if not BoldSignService.StartSignaturesProcess(NewDocument, DocumentInStream, this.EmailSubject, this.EmailBody, this.Signers, this.ReportSelection, this.ReportPageCount,
        sigX, sigY, useCustomPosSig) then begin
            ErrorText := FailedToStartSignaturesProcessErr;
            this.UpdateDialogError(Dialog, 2);
            exit(false);
        end;

        this.UpdateDialogSuccess(Dialog, 2);
        exit(true);
    end;

    local procedure HandleSuccessfulSending(var NewDocument: Record "PVS BS Document")
    var
        FolderSetup: Record "PVS Folder Setup";
        ReportSetup: Record "PVS Report Setup";
        CloudDriveMgt: Codeunit "PVS BS Cloud Drive Mgt.";
        Utility: Codeunit "PVS BS Utility";
        DocumentInStream: InStream;
        ReportFileName: Text;
    begin
        if (NewDocument."Report Setup Code" = '') then
            exit;

        if ReportSetup.Get(NewDocument."Report Setup Code") then
            if ReportSetup."Folder Group Code" <> '' then begin
                FolderSetup.Reset();
                FolderSetup.SetRange(Type, FolderSetup.Type::Folders);
                FolderSetup.SetRange(Group, ReportSetup."Folder Group Code");
                FolderSetup.SetRange("PVS BS Sent Documents", NewDocument."Report Type");
                if FolderSetup.FindFirst() then begin
                    ReportFileName := Utility.GetFileName(NewDocument."Report Type", this.PrintVisCase);
                    this.ReportBlob.CreateInStream(DocumentInStream);
                    CloudDriveMgt.SaveDocumentToFolder(this.PrintVisCase.ID,
                        ReportSetup."Folder Group Code",
                        FolderSetup."Folder ID",
                        ReportFileName,
                        DocumentInStream);
                    Commit();
                end;
            end;
    end;

    local procedure UpdateDialogError(var Dialog: Dialog; StepNo: Integer)
    var
        ErrorLbl: Label 'Error';
        SkippedLbl: Label 'Skipped';
    begin
        Dialog.Update(StepNo, ErrorLbl);
        for StepNo := StepNo + 1 to 2 do
            Dialog.Update(StepNo, SkippedLbl);
    end;

    local procedure UpdateDialogSuccess(var Dialog: Dialog; StepNo: Integer)
    var
        DoneLbl: Label 'Done';
    begin
        Dialog.Update(StepNo, DoneLbl);
    end;

    local procedure GetDocumentInStream(): InStream
    var
        DocumentInStream: InStream;
    begin
        this.FinalBlob.CreateInStream(DocumentInStream);
        if DocumentInStream.Length() = 0 then
            this.ReportBlob.CreateInStream(DocumentInStream);

        exit(DocumentInStream);
    end;

    local procedure ShowDocumentPreview()
    var
        Base64Convert: Codeunit "Base64 Convert";
        SignatureService: Codeunit "PVS BS Signature Service";
        DocumentInStream: InStream;
        PageNumber, X, Y, Width, Height : Integer;
    begin
        DocumentInStream := this.GetDocumentInStream();
        SignatureService.setSignaturePositionParam(sigX, sigY, true);
        SignatureService.GetSignatureBounds(this.ReportSelection, this.ReportPageCount, PageNumber, sigX, sigY, Width, Height);
        CurrPage.PDFUtility.DrawSignatureBox(Base64Convert.ToBase64(DocumentInStream), PageNumber, sigX, sigY, Width, Height);
    end;

    local procedure ShowMarkedPreview(PdfContent: Text)
    var
        Base64Convert: Codeunit "Base64 Convert";
        PreviewBlob: Codeunit "Temp Blob";
        DocumentPreviewPage: Page "PVS BS Document Preview";
        PreviewOutStream: OutStream;
        PreviewInStream: InStream;
    begin
        PreviewBlob.CreateOutStream(PreviewOutStream);
        Base64Convert.FromBase64(PdfContent, PreviewOutStream);
        PreviewBlob.CreateInStream(PreviewInStream);

        Clear(DocumentPreviewPage);
        DocumentPreviewPage.SetDocumentContent(PreviewInStream);
        DocumentPreviewPage.Run();
    end;

    internal procedure SetParameters(PrintVisCase2: Record "PVS Case";
        ReportType2: Enum "Report Selection Usage";
        ReportID2: Integer;
        SentDocumentWorkflow2: Code[20];
        PostSigningWorkflow2: Code[20];
        ExpiredDocumentWorkflow2: Code[20];
        DeclinedDocumentWorkflow2: Code[20];
        AddDeclineButton2: Boolean;
        AllowDelegate2: Boolean)
    var
        SentDocumentWF: Record "PVS BS Document Workflow";
        Contact: Record Contact;
        EmailSubjectLbl: Label '%1 is awaiting your signature', Comment = '%1 = Report Type';
        EmailBodyLbl: Label 'Please sign the document';
    begin
        this.PrintVisCase := PrintVisCase2;
        this.ReportType := ReportType2;
        this.ReportID := ReportID2;
        this.SentDocumentWorkflow := SentDocumentWorkflow2;
        this.PostSigningWorkflow := PostSigningWorkflow2;
        this.ExpiredDocumentWorkflow := ExpiredDocumentWorkflow2;
        this.DeclinedDocumentWorkflow := DeclinedDocumentWorkflow2;
        this.AddDeclineButton := AddDeclineButton2;
        this.AllowDelegate := AllowDelegate2;

        if not Contact.Get(this.PrintVisCase."Sell-To Contact No.") then
            Clear(Contact);

        this.SignerName := Contact."First Name" + ' ' + Contact.Surname;
        this.SignerEmail := Contact."E-Mail";

        if this.SentDocumentWorkflow <> '' then
            if SentDocumentWF.Get(this.SentDocumentWorkflow) then begin
                if (SentDocumentWF."Email Subject" <> '') then
                    this.EmailSubject := SentDocumentWF."Email Subject";
                if (SentDocumentWF."Email Body" <> '') then
                    this.EmailBody := SentDocumentWF."Email Body";
            end;

        if (this.EmailSubject = '') then
            this.EmailSubject := StrSubstNo(EmailSubjectLbl, Utility.GetReportFileName(this.ReportType, this.PrintVisCase.ID));

        if (this.EmailBody = '') then
            this.EmailBody := EmailBodyLbl;

        this.EmailSubject := this.Utility.ReplaceTextPlaceholders(this.PrintVisCase, this.EmailSubject);
        this.EmailBody := this.Utility.ReplaceTextPlaceholders(this.PrintVisCase, this.EmailBody);
    end;

    internal procedure SetReportSelection(ReportSelection2: Record "Report Selections")
    begin
        this.ReportSelection := ReportSelection2;
        this.sigX := ReportSelection."PVS BS Sign. X";
        this.sigY := ReportSelection."PVS BS Sign. Y";
    end;

    var
        PrintVisCase: Record "PVS Case";
        ReportSelection: Record "Report Selections";
        BoldSignSetup: Record "PVS BS Service Setup";
        BoldSignManager: Codeunit "PVS BS BoldSign Mgt.";
        AdditionalArtworkBlob, FinalBlob, ReportBlob : Codeunit "Temp Blob";
        Utility: Codeunit "PVS BS Utility";
        PDFArray: JsonArray;
        AddDeclineButton,
        AllowDelegate,
        ArtworkFileStepVisible, BackEnabled, FinishEnabled, FinishStepVisible, NextEnabled, ShowDocumentPreviewEnabled, SignerStepVisible : Boolean;
        DeclinedDocumentWorkflow, ExpiredDocumentWorkflow, PostSigningWorkflow, SentDocumentWorkflow : Code[20];
        EmailSubject, EmailBody : Text;
        Signers: Dictionary of [Text, Text];
        ReportType: Enum "Report Selection Usage";
        ReportID,
        ReportPageCount,
        StepNumber : Integer;
        MergedPdfContentBase64, SignerEmail, SignerName, StepStyle : Text;
        sigX, sigY : Integer;
}