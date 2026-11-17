namespace PrintVis.BoldSign.Configuration;

using Microsoft.Foundation.Reporting;

page 80308 "PVS BS Select Report to Send"
{
    ApplicationArea = All;
    Caption = 'Select Report to Send';
    PageType = List;
    SourceTable = "Report Selections";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(reports)
            {
                ShowCaption = false;

                field(Usage; Rec.Usage)
                {
                    ToolTip = 'Specifies the usage of the report selection';
                }
                field("Report ID"; Rec."Report ID")
                {
                    ToolTip = 'Specifies the ID of the report';
                }
                field("Report Caption"; Rec."Report Caption")
                {
                    ToolTip = 'Specifies the caption of the report';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("PVS BS Use for BoldSign Sign.", true);
        Rec.FilterGroup(0);
    end;
}
