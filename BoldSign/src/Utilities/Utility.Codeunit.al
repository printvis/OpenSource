namespace PrintVis.BoldSign.Utilities;

using PrintVis.BoldSign.Documents;
using Microsoft.Foundation.Reporting;
using System;
using System.Utilities;

codeunit 80307 "PVS BS Utility"
{
    Access = Internal;

    procedure GetReportFileName(ReportType: Enum "Report Selection Usage"; PrintVisCaseID: Integer): Text
    var
        PrintVisCase: Record "PVS Case";
        Filename: Text;
    begin
        if not PrintVisCase.Get(PrintVisCaseID) then
            Clear(PrintVisCase);

        case ReportType of
            ReportType::"PVS Quote Report":
                Filename := Format(ReportType) + ' ' + PrintVisCase."Quote No.";
            ReportType::"PVS Order Confirmation Report":
                Filename := Format(ReportType) + ' ' + PrintVisCase."Order No.";
            ReportType::"PVS BS Artwork Approval":
                Filename := Format(ReportType) + ' ' + PrintVisCase."Order No.";
            else
                Filename := Format(ReportType) + ' ' + Format(PrintVisCase.ID);
        end;

        exit(Filename);
    end;

    procedure GetFileName(ReportType: Enum "Report Selection Usage"; PrintVisCase: Record "PVS Case"): Text
    begin
        exit(this.GetReportFileName(ReportType, PrintVisCase.ID));
    end;

    procedure FormatGuid(GuidId: Guid): Text
    begin
        exit(LowerCase(DelChr(Format(GuidId), '=', '{}')));
    end;

    procedure TextToDocumentStatus(StatusText: Text): Enum "PVS BS Document Status"
    var
        UnknownStatusErr: Label 'Unknown status: %1';
    begin
        case StatusText.ToLower() of
            'inprogress', 'in-progress', 'sent', 'waitingforme', 'waitingforothers':
                exit(Enum::"PVS BS Document Status"::"Awaiting Signature");
            'completed', 'complete':
                exit(Enum::"PVS BS Document Status"::Signed);
            'declined', 'revoked', 'canceled', 'cancelled':
                exit(Enum::"PVS BS Document Status"::Canceled);
            'sendfailed', 'failed', 'error':
                exit(Enum::"PVS BS Document Status"::Error);
            'expired':
                exit(Enum::"PVS BS Document Status"::Expired);
            else
                Error(UnknownStatusErr, StatusText);
        end;
    end;

    /// <summary>
    /// Replaces percent placeholders in text with values from a PVS Case record.
    /// </summary>
    /// <param name="PrintVisCase">The PVS Case record containing the data.</param>
    /// <param name="TextWithPlaceholders">The text containing placeholders to be replaced.</param>
    /// <returns>Text with placeholders replaced with actual values.</returns>
    procedure ReplaceTextPlaceholders(PrintVisCase: Record "PVS Case"; TextWithPlaceholders: Text): Text
    var
        ResultText: Text;
    begin
        PrintVisCase.CalcFields("Salesperson Name", "Coordinator Name");
        ResultText := TextWithPlaceholders;

        // Replace %1 with Quote Number
        ResultText := ResultText.Replace('%1', PrintVisCase."Quote No.");

        // Replace %2 with Order Number
        ResultText := ResultText.Replace('%2', PrintVisCase."Order No.");

        // Replace %3 with Contact Name
        ResultText := ResultText.Replace('%3', PrintVisCase."Sell-To Contact");

        // Replace %4 with Job Name
        ResultText := ResultText.Replace('%4', PrintVisCase."Job Name");

        // Replace %5 with Salesperson name
        ResultText := ResultText.Replace('%5', PrintVisCase."Salesperson Name");

        // Replace %6 with Coordinator name
        ResultText := ResultText.Replace('%6', PrintVisCase."Coordinator Name");

        exit(ResultText);
    end;
}