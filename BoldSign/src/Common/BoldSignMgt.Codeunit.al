namespace PrintVis.BoldSign.Common;

using Microsoft.Foundation.Reporting;
using Microsoft.Shared.Report;
using System.Reflection;
using System.Utilities;
using PrintVis.BoldSign.Configuration;
using PrintVis.BoldSign.Documents;
using PrintVis.BoldSign.Processing;

codeunit 80302 "PVS BS BoldSign Mgt."
{
    Access = Internal;
    Permissions = tabledata "PVS BS Service Setup" = RIMD;

    /// <summary>
    /// Checks if the BoldSign service is enabled in the setup.
    /// </summary>
    /// <returns>True if the service is enabled, false otherwise.</returns>
    procedure IsEnabled(): Boolean
    var
        BoldSignSetup: Record "PVS BS Service Setup";
    begin
        exit(BoldSignSetup.Get() and BoldSignSetup.Enabled);
    end;

    /// <summary>
    /// Prints the artwork approval report for a specific case.
    /// </summary>
    /// <param name="CaseID">The ID of the case to print the report for.</param>
    /// <error>Throws an error if the case is not found.</error>
    procedure PrintArtworkApprovalReport(CaseID: Integer)
    var
        CaseRec: Record "PVS Case";
        ReportSelection: Record "Report Selections";
        ReportMgt: Codeunit "PVS Report Mgt";
        CaseNotFoundErr: Label 'Case %1 not found.', Comment = '%1 = Case ID';
    begin
        if not CaseRec.Get(CaseID) then
            Error(CaseNotFoundErr, CaseID);

        ReportMgt.SetGlobalReportCode('');
        ReportMgt.SetGlobalID(CaseID);

        if not this.GetArtworkApprovalReport(ReportSelection) then
            exit;

        CaseRec.SetRecFilter();
        Report.RunModal(ReportSelection."Report ID", true, false, CaseRec);
    end;

    local procedure GetArtworkApprovalReport(var ReportSelection: Record "Report Selections"): Boolean
    var
        ReportSelectionPage: Page "PVS BS Report Selection Setup";
    begin
        ReportSelection.Reset();
        ReportSelection.SetRange(Usage, Enum::"Report Selection Usage"::"PVS BS Artwork Approval");

        if ReportSelection.Count() = 1 then
            exit(ReportSelection.FindFirst());

        ReportSelectionPage.LookupMode(true);
        if ReportSelectionPage.RunModal() = Action::LookupOK then begin
            ReportSelectionPage.GetRecord(ReportSelection);
            exit(true);
        end;

        exit(false);
    end;

    /// <summary>
    /// Sends a report for signature for a specific case.
    /// </summary>
    /// <param name="CaseID">The ID of the case to send the report for.</param>
    procedure SendReportForSignature(CaseID: Integer)
    var
        CurrPrintVisCase: Record "PVS Case";
        SelectedLayout: Record "Report Layout List";
        ReportLayoutSelection: Record "Report Layout Selection";
        ReportSelection: Record "Report Selections";
        CaseNotFoundMsg: Label 'Case %1 not found.', Comment = '%1 = Case ID';
    begin
        if not this.GetReportSelection(ReportSelection) then
            exit;

        if not this.ValidateReportSelection(ReportSelection) then
            exit;

        if not CurrPrintVisCase.Get(CaseID) then
            Error(CaseNotFoundMsg, CaseID);

        CurrPrintVisCase.SetRecFilter();

        if not this.SelectReportLayout(ReportSelection."Report ID", SelectedLayout, ReportLayoutSelection) then
            exit;

        Commit();

        this.ShowSendForSignaturePage(CurrPrintVisCase, ReportSelection);
    end;

    local procedure GetReportSelection(var ReportSelection: Record "Report Selections"): Boolean
    var
        SelectReportToSend: Page "PVS BS Select Report to Send";
    begin
        Clear(SelectReportToSend);
        SelectReportToSend.LookupMode(true);
        if SelectReportToSend.RunModal() <> Action::LookupOK then
            exit(false);

        SelectReportToSend.GetRecord(ReportSelection);

        exit(true);
    end;

    local procedure ValidateReportSelection(ReportSelection: Record "Report Selections"): Boolean
    var
        ReportSelectionErr: Label 'No report was selected.';
    begin
        if ReportSelection."Report ID" = 0 then begin
            Message(ReportSelectionErr);
            exit(false);
        end;

        exit(true);
    end;

    local procedure SelectReportLayout(ReportID: Integer; var SelectedLayout: Record "Report Layout List"; var ReportLayoutSelection: Record "Report Layout Selection"): Boolean
    var
        ReportLayoutList: Record "Report Layout List";
        ReportLayouts: Page "Report Layouts";
        ReportLayoutsErr: Label 'You must select a layout to continue.';
    begin
        ReportLayoutList.Reset();
        ReportLayoutList.SetRange("Report ID", ReportID);
        if ReportLayoutList.Count() <= 1 then
            exit(true);

        ReportLayouts.SetTableView(ReportLayoutList);
        ReportLayouts.LookupMode(true);
        if ReportLayouts.RunModal() <> Action::LookupOK then
            Error(ReportLayoutsErr);

        ReportLayouts.GetRecord(SelectedLayout);
        ReportLayoutSelection.SetTempLayoutSelectedName(SelectedLayout.Name);

        exit(true);
    end;

    local procedure ShowSendForSignaturePage(CurrPrintVisCase: Record "PVS Case"; ReportSelection: Record "Report Selections")
    var
        SendForSignature: Page "PVS BS Send for Signature";
    begin
        Clear(SendForSignature);
        SendForSignature.SetParameters(CurrPrintVisCase,
            ReportSelection.Usage,
            ReportSelection."Report ID",
            ReportSelection."PVS BS Sent Doc. Workflow",
            ReportSelection."PVS BS Signed Doc. Workflow",
            ReportSelection."PVS BS Expired Doc. Workflow",
            ReportSelection."PVS BS Declined Doc. Workflow",
            ReportSelection."PVS BS Add Decline Button",
            ReportSelection."PVS BS Allow Delegate");
        SendForSignature.SetReportSelection(ReportSelection);
        SendForSignature.RunModal();
    end;

    procedure CreateDocument(PrintVisCase: Record "PVS Case";
        ReportType: Enum "Report Selection Usage";
        ReportID: Integer;
        DocumentExpirationDateFormula: DateFormula;
        SentDocumentWorkflow: Code[20];
        PostSigningWorkflow: Code[20];
        ExpiredDocumentWorkflow: Code[20];
        DeclinedDocumentWorkflow: Code[20];
        AddDeclineButton: Boolean;
        AllowDelegate: Boolean;
        ReportCode: Code[50]): BigInteger
    var
        Document: Record "PVS BS Document";
    begin
        exit(Document.CreateNew(
            PrintVisCase.ID,
            ReportType,
            ReportID,
            DocumentExpirationDateFormula,
            SentDocumentWorkflow,
            PostSigningWorkflow,
            ExpiredDocumentWorkflow,
            DeclinedDocumentWorkflow,
            ReportCode,
            AddDeclineButton,
            AllowDelegate));
    end;

    procedure SaveReport(ReportID: Integer; RecordRef: RecordRef; var TempBlob: Codeunit "Temp Blob"): Boolean
    var
        ReportOutStream: OutStream;
        ReportParameters: Text;
    begin
        Clear(TempBlob);
        TempBlob.CreateOutStream(ReportOutStream);
        exit(Report.SaveAs(ReportID, ReportParameters, ReportFormat::Pdf, ReportOutStream, RecordRef))
    end;

}