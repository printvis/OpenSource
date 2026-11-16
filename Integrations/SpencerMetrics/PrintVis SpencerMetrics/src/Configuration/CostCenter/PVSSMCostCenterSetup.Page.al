namespace PrintVis.SpencerMetrics.Configuration;

using PrintVis.SpencerMetrics.CounterManagement;

page 80291 "PVS SM Cost Center Setup"
{
    ApplicationArea = All;
    Caption = 'SpencerMetrics Cost Center Setup';
    PageType = List;
    SourceTable = "PVS SM Cost Center Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(repeater)
            {
                field("Cost Center"; Rec."Cost Center") { }
                field("API Key"; Rec."API Key") { }
                field(Enabled; Rec."Enabled") { }
                field("Interval (ms)"; Rec."Interval (ms)") { }
                field("Session ID"; Rec."Session Id")
                {
                    Editable = false;
                }
                field("Job Queue Entry ID"; Rec."Job Queue Entry ID")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Last Heartbeat"; Rec."Last Heartbeat")
                {
                    Editable = false;
                }
                field("Session Error"; Rec."Last Error")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Counts)
            {
                Caption = 'Counts';
                Image = NumberGroup;
                RunObject = page "PVS SM Counter Entries";
                ToolTip = 'Open the counts page for the selected cost center';
            }

            action("Delete All Records")
            {
                Caption = 'Delete All Records';
                Image = Delete;
                ToolTip = 'Delete all count records for the selected cost center';

                trigger OnAction()
                var
                    CounterEntry: Record "PVS SM Counter Entry";
                    Confirmed: Boolean;
                    ConfirmQst: Label 'Are you sure you want to delete all count records for %1?', Comment = '%1 = Cost Center Code';
                begin
                    Confirmed := Dialog.Confirm(ConfirmQst, false, Rec."Cost Center");
                    if Confirmed then begin
                        CounterEntry.Reset();
                        CounterEntry.SetRange("Cost Center Code", Rec."Cost Center");
                        if (CounterEntry.Count() > 0) then
                            CounterEntry.DeleteAll();
                    end;
                end;
            }

            action("Session Log")
            {
                Caption = 'Session Log';
                Image = Log;
                RunObject = page "PVS SM Session Log";
                RunPageLink = "Cost Center" = field("Cost Center");
                ToolTip = 'View session start/stop history for this cost center';
            }
        }
    }
}