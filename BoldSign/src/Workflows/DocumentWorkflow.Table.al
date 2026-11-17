namespace PrintVis.BoldSign.Workflows;

table 80302 "PVS BS Document Workflow"
{
    Caption = 'Document Workflow';
    DataClassification = CustomerContent;
    DrillDownPageId = "PVS BS Document Workflows";
    LookupPageId = "PVS BS Document Workflows";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            ToolTip = 'Specifies the code of the document workflow';
        }
        field(10; "Update Status"; Boolean)
        {
            Caption = 'Update Status';
            ToolTip = 'Specifies if the status should be updated';

            trigger OnValidate()
            begin
                if not Rec."Update Status" then
                    Rec.Validate("Next Status Code", '');
            end;
        }
        field(12; "Next Status Code"; Code[20])
        {
            Caption = 'Next Status Code';
            TableRelation = "PVS Status Code".Code where(User = const(''));
            ToolTip = 'Specifies the next status code';

            trigger OnValidate()
            begin
                if (Rec."Next Status Code" <> '') then
                    Rec.TestField("Update Status", true);
            end;
        }
        field(20; "Email Salesperson"; Boolean)
        {
            Caption = 'Email Salesperson';
            ToolTip = 'Specifies if the salesperson should be notified';
            trigger OnValidate()
            begin
                this.ValidateExclusiveEmailFields();
            end;
        }
        field(21; "Email Coordinator"; Boolean)
        {
            Caption = 'Email Coordinator';
            ToolTip = 'Specifies if the coordinator should be notified';
            trigger OnValidate()
            begin
                this.ValidateExclusiveEmailFields();
            end;
        }
        field(30; "Update Milestone"; Boolean)
        {
            Caption = 'Update Milestone';
            ToolTip = 'Specifies if the milestone should be updated';
        }
        field(40; "Milestone to Complete"; Code[20])
        {
            Caption = 'Milestone to complete';
            TableRelation = "PVS Calculation Unit Setup".Code where(
                Type = const("Planning Unit"),
                Milestone = const(true)
            );
            ToolTip = 'Specifies the milestone to complete';
        }
        field(41; "Milestone Comment"; Text[250])
        {
            Caption = 'Milestone Comment';
            ToolTip = 'This comment will be added to the milestone when BoldSign marks the milestone complete. If empty, then ''BoldSign Signed'' will be used.';
        }
        field(50; "Rejection Code"; Code[20])
        {
            Caption = 'Rejection Reason';
            TableRelation = "PVS Rejection Cause";
            ToolTip = 'Specifies the rejection reason';
        }
        field(100; "Email Subject"; Text[100])
        {
            Caption = 'Email Subject';
            ToolTip = 'Specifies the subject of the email. You can use the following placeholders: %1 = Quote Number, %2 = Order Number, %3 = Contact Name, %4 = Job Name, %5 = Salesperson name, %6 = Coordinator name.';
        }
        field(101; "Email Body"; Text[250])
        {
            Caption = 'Email Body';
            ToolTip = 'Specifies the body content of the notification email. You can use the following placeholders: %1 = Quote Number, %2 = Order Number, %3 = Contact Name, %4 = Job Name, %5 = Salesperson name, %6 = Coordinator name.';
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    var
        ExclusiveEmailFieldsErr: Label 'Only one of "Email Salesperson" or "Email Coordinator" can be selected.';

    local procedure ValidateExclusiveEmailFields()
    begin
        if (Rec."Email Salesperson") and (Rec."Email Coordinator") then
            Error(this.ExclusiveEmailFieldsErr);
    end;
}