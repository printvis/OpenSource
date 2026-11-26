namespace PrintVis.BoldSign.Configuration;

using Microsoft.Foundation.Reporting;
using System.Reflection;

page 80307 "PVS BS Report Selection Setup"
{
    ApplicationArea = All;
    Caption = 'PrintVis BoldSign Report Selection Setup';
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Report Selections";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            field(ReportUsage; SelectedReportType)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Report Type';
                OptionCaption = 'Artwork Approval';
                ToolTip = 'Specifies which type of document the report is used for.';

                trigger OnValidate()
                begin
                    this.SetReportTypeFilter();
                end;
            }
            repeater(Control1)
            {
                FreezeColumn = ReportCaption;
                ShowCaption = false;

                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sequence';
                    ToolTip = 'Specifies a number that indicates where this report is in the printing order.';
                }
                field(ReportID; Rec."Report ID")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Report ID';
                    LookupPageId = Objects;
                    ToolTip = 'Specifies the object ID of the report.';
                }
                field(ReportCaption; Rec."Report Caption")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Report Name';
                    DrillDown = false;
                    LookupPageId = Objects;
                    ToolTip = 'Specifies the display name of the report.';
                }
                field("PVS BS Use for BoldSign Sign."; Rec."PVS BS Use for BoldSign Sign.") { }
                field("PVS BS Sent Doc. Workflow"; Rec."PVS BS Sent Doc. Workflow") { }
                field("PVS BS Signed Workflow"; Rec."PVS BS Signed Doc. Workflow") { }
                field("PVS BS Declined Doc. Workflow"; Rec."PVS BS Declined Doc. Workflow") { }
                field("PVS BS Expired Document Workflow"; Rec."PVS BS Expired Doc. Workflow") { }
                field("PVS BS Add Decline Button"; Rec."PVS BS Add Decline Button") { }
                field("PVS BS Allow Delegate"; Rec."PVS BS Allow Delegate") { }
                field("PVS BS Sign. On Last Page"; Rec."PVS BS Sign. On Last Page") { }
                field("PVS BS Sign. Page No."; Rec."PVS BS Sign. Page No.") { }
                field("PVS BS Sign. X"; Rec."PVS BS Sign. X") { }
                field("PVS BS Sign. Y"; Rec."PVS BS Sign. Y") { }
                field("PVS BS Sign. Width"; Rec."PVS BS Sign. Width") { }
                field("PVS BS Sign. Height"; Rec."PVS BS Sign. Height") { }
            }
        }
    }

    trigger OnOpenPage()
    begin
        this.SetReportTypeFilter();
    end;

    var
        SelectedReportType: Option "Artwork Approval";

    procedure SetReportTypeFilter()
    begin
        Rec.FilterGroup(2);
        case this.SelectedReportType of
            this.SelectedReportType::"Artwork Approval":
                Rec.SetRange(Usage, Rec.Usage::"PVS BS Artwork Approval");
        end;
        Rec.FilterGroup(0);
        CurrPage.Update(false);
    end;
}