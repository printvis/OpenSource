namespace PrintVis.BoldSign.Workflows;

page 80303 "PVS BS Document Workflows"
{
    ApplicationArea = All;
    Caption = 'Document Workflow';
    CardPageId = "PVS BS Document Workflow Card";
    Editable = false;
    PageType = List;
    SourceTable = "PVS BS Document Workflow";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(repeater)
            {
                ShowCaption = false;

                field("Code"; Rec."Code") { }
                field("Update Status"; Rec."Update Status") { }
                field("Next Status Code"; Rec."Next Status Code") { }
                field("Email Salesperson"; Rec."Email Salesperson") { }
                field("Email Coordinator"; Rec."Email Coordinator") { }
                field("Update Milestone"; Rec."Update Milestone") { }
                field("Milestone to complete"; Rec."Milestone to Complete") { }
                field("Milestone Comment"; Rec."Milestone Comment") { }
                field("Rejection Reason"; Rec."Rejection Code") { }
            }
        }
    }
}