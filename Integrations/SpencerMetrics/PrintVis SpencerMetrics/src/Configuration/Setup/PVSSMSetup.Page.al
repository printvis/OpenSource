page 80293 "PVS SM Setup"
{
    ApplicationArea = All;
    Caption = 'SpencerMetrics Setup';
    InsertAllowed = false;
    PageType = List;
    SourceTable = "PVS SM Setup";
    UsageCategory = Administration;
    layout
    {
        area(Content)
        {
            group(API)
            {
                Caption = 'API';
                field("Base URL"; Rec."Base URL") { }
            }
            group(Session)
            {
                Caption = 'Session';
                field("Max Session Duration (min)"; Rec."Max Session Duration (min)")
                {
                    ToolTip = 'Maximum session duration in minutes. 0 means no limit. Default is 8 hours (480 min).';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Initialize();
    end;
}