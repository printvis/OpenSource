page 80309 "PVS BS Document Workflow Card"
{
    ApplicationArea = All;
    Caption = 'Document Workflow Card';
    PageType = Card;
    SourceTable = "PVS BS Document Workflow";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec."Code") { }
            }
            group(Status)
            {
                Caption = 'Status';
                field("Update Status"; Rec."Update Status") { }
                field("Next Status Code"; Rec."Next Status Code") { }
                field("Rejection Reason"; Rec."Rejection Code") { }
            }

            group(Milestone)
            {
                Caption = 'Milestone';

                field("Update Milestone"; Rec."Update Milestone") { }
                field("Milestone to complete"; Rec."Milestone to Complete") { }
                field("Milestone Comment"; Rec."Milestone Comment")
                {
                    MultiLine = true;
                }
            }
            group(EmailConfiguration)
            {
                Caption = 'Email Configuration';
                field("Email Subject"; Rec."Email Subject") { }
                field("Email Body"; Rec."Email Body")
                {
                    MultiLine = true;
                }
            }
        }
    }
}
