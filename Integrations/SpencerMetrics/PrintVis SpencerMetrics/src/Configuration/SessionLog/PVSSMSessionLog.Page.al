namespace PrintVis.SpencerMetrics.Configuration;

page 80292 "PVS SM Session Log"
{
    ApplicationArea = All;
    Caption = 'SpencerMetrics Session Log';
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "PVS SM Session Log";
    SourceTableView = sorting("Entry No.") order(descending);
    UsageCategory = None;
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(repeater)
            {
                field("Entry No."; Rec."Entry No.") { }
                field("Cost Center"; Rec."Cost Center") { }
                field("Job Queue Entry ID"; Rec."Job Queue Entry ID") { }
                field("Event Type"; Rec."Event Type") { }
                field("Event DateTime"; Rec."Event DateTime") { }
                field("Expected End DateTime"; Rec."Expected End DateTime") { }
                field("User ID"; Rec."User ID") { }
                field(Success; Rec.Success)
                {
                    StyleExpr = SuccessStyle;
                }
                field("Error Message"; Rec."Error Message")
                {
                    Visible = false;
                }
            }
        }
    }

    var
        SuccessStyle: Text;

    trigger OnAfterGetRecord()
    begin
        if Rec.Success then
            SuccessStyle := 'Favorable'
        else
            SuccessStyle := 'Unfavorable';
    end;
}
