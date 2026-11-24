namespace PrintVis.BoldSign.Documents;

using PrintVis.BoldSign.Integration.Services;
using Microsoft.Utilities;
using PrintVis.BoldSign.Processing;

page 80302 "PVS BS Document List"
{
    ApplicationArea = All;
    Caption = 'BoldSign Documents';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "PVS BS Document";
    SourceTableView = order(descending);
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(repeater)
            {
                ShowCaption = false;

                field("Report Type"; Rec."Report Type") { }
                field(Status; Rec.Status)
                {
                    StyleExpr = this.StatusStyleText;
                }
                field("Started By User Name"; Rec."Started By User Name") { }
                field("Started On"; Rec."Started On") { }
                field("Expires On"; Rec."Expires On")
                {
                    StyleExpr = this.ExpiresOnStyleText;
                }
                field("Allow Decline"; Rec."Allow Decline") { }
                field("Allow Delegate"; Rec."Allow Delegate") { }
                field("Document ID"; Rec."Document ID")
                {
                    Visible = false;
                }
                field("Sent Doc. Workflow"; Rec."Sent Doc. Workflow")
                {
                    Visible = false;
                }
                field("Sent Doc. Workflow Status"; Rec."Sent Doc. Workflow Status")
                {
                    Visible = false;
                }
                field("Signed Doc. Workflow"; Rec."Signed Doc. Workflow")
                {
                    Visible = false;
                }
                field("Signed Doc. Workflow Status"; Rec."Signed Doc. Workflow Status")
                {
                    Visible = false;
                }
                field("Expired Doc. Workflow"; Rec."Expired Doc. Workflow")
                {
                    Visible = false;
                }
                field("Expired Doc. Workflow Status"; Rec."Expired Doc. Workflow Status")
                {
                    Visible = false;
                }
                field("Declined Doc. Workflow"; Rec."Declined Doc. Workflow")
                {
                    Visible = false;
                }
                field("Declined Doc. Workflow Status"; Rec."Declined Doc. Workflow Status")
                {
                    Visible = false;
                }
                field(ID; Rec.ID) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RefreshAllStatuses)
            {
                Caption = 'Refresh All Statuses';
                Image = RefreshLines;
                ToolTip = 'Checks BoldSign for the current status of all documents that are awaiting signature.';

                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"PVS BS BoldSign Document Check");
                end;
            }
            action(RefreshStatus)
            {
                Caption = 'Refresh Status';
                Enabled = Rec.Status = Enum::"PVS BS Document Status"::"Awaiting Signature";
                Image = Refresh;

                trigger OnAction()
                var
                    PrevStatus: Enum "PVS BS Document Status";
                    RefreshStatusFailedLbl: Label 'Failed to refresh document status. Error: %1', Comment = '%1 = Error Message';
                    RefreshStatusSuccessLbl: Label 'Document status refreshed successfully';
                    SignatureStatusChangedLbl: Label 'Status changed from %1 to %2', Comment = '%1 = Old Status, %2 = New Status';
                begin
                    PrevStatus := Rec.Status;
                    if not Codeunit.Run(Codeunit::"PVS BS Refresh Document Status", Rec) then
                        Message(RefreshStatusFailedLbl, GetLastErrorText())
                    else
                        if PrevStatus <> Rec.Status then
                            Message(StrSubstNo(SignatureStatusChangedLbl, PrevStatus, Rec.Status))
                        else
                            Message(RefreshStatusSuccessLbl);
                end;
            }

            action(RevokeDocument)
            {
                Caption = 'Revoke Document';
                Enabled = Rec.Status = Enum::"PVS BS Document Status"::"Awaiting Signature";
                Image = Delete;

                trigger OnAction()
                var
                    BoldSignService: Codeunit "PVS BS Integration Service";
                    RevokeMsg: Label 'Document revoked successfully';
                begin
                    if BoldSignService.RevokeDocument(Rec) then
                        Message(RevokeMsg);
                end;
            }

            action(ActivityLog)
            {
                Caption = 'Activity Log';
                Image = Log;
                ToolTip = 'View the activity log for this document.';

                trigger OnAction()
                var
                    ActivityLog: Record "Activity Log";
                begin
                    ActivityLog.ShowEntries(Rec.RecordId());
                end;
            }
        }
        area(Navigation)
        {
            action(DownloadDocument)
            {
                Caption = 'Download Document';
                Enabled = DownloadDocumentEnabled;
                Image = Download;

                trigger OnAction()
                var
                    BoldSignService: Codeunit "PVS BS Integration Service";
                begin
                    BoldSignService.DownloadDocument(Rec, false, true);
                end;
            }
            action(ErrorDetails)
            {
                Caption = 'Error Details';
                Enabled = Rec."Signed Doc. Workflow Status" = Enum::"PVS BS Doc. Workflow Status"::Failed;
                Image = ErrorLog;

                trigger OnAction()
                begin
                    Message(Rec.GetErrorDetailsText());
                end;
            }
        }
        area(Promoted)
        {
            actionref(RefreshStatusPromoted; RefreshStatus) { }
            actionref(DownloadDocumentPromoted; DownloadDocument) { }
            actionref(RevokeDocumentPromoted; RevokeDocument) { }
            actionref(ErrorDetailsPromoted; ErrorDetails) { }
            actionref(ActivityLogPromoted; ActivityLog) { }
        }
    }

    views
    {
        view(NewDocuments)
        {
            Caption = 'New';
            Filters = where(Status = const(New));
            OrderBy = descending(ID);
        }
        view(UploadedDocuments)
        {
            Caption = 'Uploaded';
            Filters = where(Status = const(Uploaded));
            OrderBy = descending(ID);
        }
        view(AwaitingSignature)
        {
            Caption = 'Awaiting Signature';
            Filters = where(Status = const("Awaiting Signature"));
            OrderBy = descending(ID);
        }
        view(SignedDocuments)
        {
            Caption = 'Signed';
            Filters = where(Status = const(Signed));
            OrderBy = descending(ID);
        }
        view(CanceledDocuments)
        {
            Caption = 'Canceled';
            Filters = where(Status = const(Canceled));
            OrderBy = descending(ID);
        }
        view(RemovedDocuments)
        {
            Caption = 'Removed';
            Filters = where(Status = const(Removed));
            OrderBy = descending(ID);
        }
        view(ErrorDocuments)
        {
            Caption = 'Error';
            Filters = where(Status = const(Error));
            OrderBy = descending(ID);
        }
        view(ExpiredDocuments)
        {
            Caption = 'Expired';
            Filters = where(Status = const(Expired));
            OrderBy = descending(ID);
        }
    }

    trigger OnAfterGetRecord()
    begin
        this.SetStatusStyleText();
        this.SetExpiresOnStyleText();
        this.SetDownloadDocumentEnabled();
    end;

    local procedure SetDownloadDocumentEnabled()
    begin
        this.DownloadDocumentEnabled := Rec.Status in [Enum::"PVS BS Document Status"::Signed, Enum::"PVS BS Document Status"::Canceled];
    end;

    local procedure SetStatusStyleText()
    begin
        this.StatusStyleText := '';

        case Rec.Status of
            Enum::"PVS BS Document Status"::New:
                this.StatusStyleText := Format(PageStyle::None);
            Enum::"PVS BS Document Status"::Uploaded:
                this.StatusStyleText := Format(PageStyle::Ambiguous);
            Enum::"PVS BS Document Status"::"Awaiting Signature":
                this.StatusStyleText := Format(PageStyle::AttentionAccent);
            Enum::"PVS BS Document Status"::Signed:
                this.StatusStyleText := Format(PageStyle::Favorable);
            Enum::"PVS BS Document Status"::Canceled:
                this.StatusStyleText := Format(PageStyle::Subordinate);
            Enum::"PVS BS Document Status"::Removed:
                this.StatusStyleText := Format(PageStyle::Subordinate);
            Enum::"PVS BS Document Status"::Error:
                this.StatusStyleText := Format(PageStyle::Unfavorable);
        end;
    end;

    local procedure SetExpiresOnStyleText()
    begin
        if Rec."Expires On" <= CurrentDateTime() then
            this.ExpiresOnStyleText := Format(PageStyle::Unfavorable);
    end;

    var
        DownloadDocumentEnabled: Boolean;
        ExpiresOnStyleText, StatusStyleText : Text;
}