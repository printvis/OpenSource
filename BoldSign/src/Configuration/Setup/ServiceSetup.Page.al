namespace PrintVis.BoldSign.Configuration;

using System.Threading;
using PrintVis.BoldSign.Processing;
using PrintVis.BoldSign.Workflows;

page 80301 "PVS BS Service Setup"
{
    ApplicationArea = All;
    Caption = 'BoldSign Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "PVS BS Service Setup";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Connection';

                field("Service Endpoint"; Rec."Service Endpoint")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the BoldSign API base URL, including its version path.';
                }
                field(ApiKey; ApiKey)
                {
                    ApplicationArea = All;
                    Caption = 'API Key';
                    ExtendedDatatype = Masked;
                    ToolTip = 'Enter the BoldSign API key. It is stored as a secret and is not shown again.';

                    trigger OnValidate()
                    begin
                        if ApiKey <> '' then begin
                            Rec.SaveApiKey(ApiKey);
                            Clear(ApiKey);
                            CurrPage.Update(false);
                        end;
                    end;
                }
                field(ApiKeyConfigured; ApiKeyConfigured)
                {
                    ApplicationArea = All;
                    Caption = 'API Key Configured';
                    Editable = false;
                    ToolTip = 'Specifies whether an API key has been stored.';
                }
                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether BoldSign sending and status refresh are enabled.';
                }
            }
            group(Documents)
            {
                Caption = 'Documents';

                field("Document Expiration Date"; Rec."Document Exp. DateFormula")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default expiration period for signature requests.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(DocumentWorkflows)
            {
                ApplicationArea = All;
                Caption = 'Document Workflows';
                Image = Workflow;
                RunObject = page "PVS BS Document Workflows";
            }
            action(SelectRegion)
            {
                ApplicationArea = All;
                Caption = 'Select Region';
                Image = Setup;
                ToolTip = 'Select the BoldSign region of your account. The service endpoint is set accordingly.';

                trigger OnAction()
                begin
                    SetRegionEndpoint();
                end;
            }
            action(Brands)
            {
                ApplicationArea = All;
                Caption = 'Brands';
                Image = Setup;
                RunObject = page "PVS BS Brands";
                ToolTip = 'Set up the BoldSign brands and choose the active one.';
            }
            action(CreateJobQueue)
            {
                ApplicationArea = All;
                Caption = 'Create/Check Status Job';
                Image = Timeline;
                ToolTip = 'Create or check the recurring job that refreshes BoldSign document statuses.';

                trigger OnAction()
                begin
                    CreateCheckJobQueueEntry();
                end;
            }
        }
        area(Promoted)
        {
            actionref(DocumentWorkflowsPromoted; DocumentWorkflows) { }
            actionref(SelectRegionPromoted; SelectRegion) { }
            actionref(BrandsPromoted; Brands) { }
            actionref(CreateJobQueuePromoted; CreateJobQueue) { }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec.Initialize() then begin
            Commit();
            SetRegionEndpoint();
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        Clear(ApiKey);
        ApiKeyConfigured := Rec.HasApiKey();
    end;

    local procedure CreateCheckJobQueueEntry()
    var
        JobQueueEntry: Record "Job Queue Entry";
        JobQueueDescLbl: Label 'BoldSign Document Check';
    begin
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Object ID to Run", Codeunit::"PVS BS BoldSign Document Check");
        if JobQueueEntry.IsEmpty() then begin
            JobQueueEntry.Init();
            JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
            JobQueueEntry."Object ID to Run" := Codeunit::"PVS BS BoldSign Document Check";
            JobQueueEntry.Description := CopyStr(JobQueueDescLbl, 1, MaxStrLen(JobQueueEntry.Description));
            JobQueueEntry."Maximum No. of Attempts to Run" := 3;
            JobQueueEntry.Status := JobQueueEntry.Status::Ready;
            JobQueueEntry."Rerun Delay (sec.)" := 30;
            JobQueueEntry."Recurring Job" := true;
            JobQueueEntry."Run on Mondays" := true;
            JobQueueEntry."Run on Tuesdays" := true;
            JobQueueEntry."Run on Wednesdays" := true;
            JobQueueEntry."Run on Thursdays" := true;
            JobQueueEntry."Run on Fridays" := true;
            JobQueueEntry."Run on Saturdays" := true;
            JobQueueEntry."Run on Sundays" := true;
            JobQueueEntry."No. of Minutes between Runs" := 5;
            JobQueueEntry."Starting Time" := Time;
            Codeunit.Run(Codeunit::"Job Queue - Enqueue", JobQueueEntry);
        end;

        JobQueueEntry.FindFirst();
        Page.Run(Page::"Job Queue Entry Card", JobQueueEntry);
    end;

    local procedure SetRegionEndpoint()
    var
        Selection: Integer;
        RegionOptionsLbl: Label 'US,EU,CA,AU', Locked = true;
        SelectRegionLbl: Label 'Select your BoldSign region:';
    begin
        Selection := StrMenu(RegionOptionsLbl, 1, SelectRegionLbl);
        if Selection = 0 then
            exit;

        case Selection of
            1:
                Rec.Validate("Service Endpoint", 'https://api.boldsign.com/v1');
            2:
                Rec.Validate("Service Endpoint", 'https://api-eu.boldsign.com/v1');
            3:
                Rec.Validate("Service Endpoint", 'https://api-ca.boldsign.com/v1');
            4:
                Rec.Validate("Service Endpoint", 'https://api-au.boldsign.com/v1');
        end;
        Rec.Modify(true);
        CurrPage.Update(false);
    end;

    var
        ApiKey: Text;
        ApiKeyConfigured: Boolean;
}