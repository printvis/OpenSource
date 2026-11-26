namespace PrintVis.BoldSign.Extensions;

using PrintVis.BoldSign.Documents;
using PrintVis.BoldSign.Common;

pageextension 80304 "PVS BS Case Card" extends "PVS Case Card"
{
    ContextSensitiveHelpPage = 'BoldSign/BoldSignUsage/';

    actions
    {
        addlast(processing)
        {
            group("PVS BS PVS BS")
            {
                Caption = 'BoldSign';
                ShowAs = SplitButton;
                Visible = BoldSignEnabled;

                action("PVS BS Send for Signature")
                {
                    ApplicationArea = All;
                    Caption = 'Send for Signature';
                    Image = Document;
                    Visible = BoldSignEnabled;

                    trigger OnAction()
                    var
                        BoldSignManager: Codeunit "PVS BS BoldSign Mgt.";
                    begin
                        BoldSignManager.SendReportForSignature(Rec.ID);
                    end;
                }
                action("PVS BS Documents")
                {
                    ApplicationArea = All;
                    Caption = 'BoldSign Documents';
                    Image = Documents;
                    RunObject = page "PVS BS Document List";
                    RunPageLink = "Case ID" = field(ID);
                    Visible = BoldSignEnabled;
                }
            }
        }
        addlast(PrintSend)
        {
            action("PVS BS Artwork Approval")
            {
                ApplicationArea = All;
                Caption = 'Artwork Approval';
                Image = Confirm;
                Visible = BoldSignEnabled;

                trigger OnAction()
                var
                    BoldSignManager: Codeunit "PVS BS BoldSign Mgt.";
                begin
                    BoldSignManager.PrintArtworkApprovalReport(Rec.ID);
                end;
            }
        }
        addfirst(DocumentsGroup)
        {
            actionref("PVS BS Send for Signature Promoted"; "PVS BS Send for Signature") { }
            actionref("PVS BS Documents Promoted"; "PVS BS Documents") { }
        }
        addlast(DocumentsGroup)
        {
            actionref("PVS BS Artwork Approval Promoted"; "PVS BS Artwork Approval") { }
        }
    }

    trigger OnOpenPage()
    var
        BoldSignManager: Codeunit "PVS BS BoldSign Mgt.";
    begin
        BoldSignEnabled := BoldSignManager.IsEnabled();
    end;

    var
        BoldSignEnabled: Boolean;
}