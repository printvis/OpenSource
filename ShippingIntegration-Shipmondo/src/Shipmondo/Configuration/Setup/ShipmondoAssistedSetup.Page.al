namespace PrintVis.OpenSource.Shipmondo.Configuration;

page 80185 "SISM Assisted Setup"
{
    ApplicationArea = All;
    Caption = 'Shipmondo Setup';
    PageType = NavigatePage;
    SourceTable = "SISM Setup";

    layout
    {
        area(Content)
        {
            group(Welcome)
            {
                Visible = Step = Step::Welcome;
                group(WelcomeGroup)
                {
                    InstructionalText = 'Configure Shipmondo integration for shipping management.';
                    ShowCaption = false;
                }
            }

            group(Connection)
            {
                Visible = Step = Step::Connection;
                group(ConnectionGroup)
                {
                    InstructionalText = 'Enter your Shipmondo API credentials.';
                    ShowCaption = false;

                    field(ServerUrl; Rec."Server Url")
                    {
                        ShowMandatory = true;
                    }
                    field(Username; Rec.Username)
                    {
                        ShowMandatory = true;
                    }
                    field(Password; PasswordText)
                    {
                        Caption = 'Password';
                        ExtendedDatatype = Masked;
                        ShowMandatory = true;

                        trigger OnValidate()
                        begin
                            Rec.SavePassword(PasswordText);
                        end;
                    }
                    field(TestMode; Rec."Test Mode") { }
                }
            }

            group(Labels)
            {
                Visible = Step = Step::Labels;
                group(LabelsGroup)
                {
                    InstructionalText = 'Configure label printing settings.';
                    ShowCaption = false;

                    field(LabelFormat; Rec."Label Format") { }
                    field(ScaleBy; Rec."Scale By") { }
                    field(ScaleSize; Rec."Scale Size") { }
                }
            }

            group(Finish)
            {
                Visible = Step = Step::Finish;
                group(FinishGroup)
                {
                    InstructionalText = 'Click Finish to save the setup and enable Shipmondo integration.';
                    ShowCaption = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionBack)
            {
                Caption = 'Back';
                Enabled = BackEnabled;
                Image = PreviousRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    NextStep(true);
                end;
            }
            action(ActionNext)
            {
                Caption = 'Next';
                Enabled = NextEnabled;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    NextStep(false);
                end;
            }
            action(ActionFinish)
            {
                Caption = 'Finish';
                Enabled = FinishEnabled;
                Image = Approve;
                InFooterBar = true;

                trigger OnAction()
                begin
                    FinishAction();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then
            Rec.Initialize();

        if Rec.PasswordIsSet() then
            PasswordText := '********';

        Step := Step::Welcome;
        EnableControls();
    end;

    var
        BackEnabled: Boolean;
        FinishEnabled: Boolean;
        NextEnabled: Boolean;
        Step: Option Welcome,Connection,Labels,Finish;
        PasswordText: Text;

    local procedure EnableControls()
    begin
        BackEnabled := Step > Step::Welcome;
        NextEnabled := Step < Step::Finish;
        FinishEnabled := Step = Step::Finish;
    end;

    local procedure NextStep(Backwards: Boolean)
    begin
        if Backwards then
            Step -= 1
        else
            Step += 1;

        EnableControls();
    end;

    local procedure FinishAction()
    begin
        Rec.Validate(Enabled, true);
        Rec.Modify(true);
        CurrPage.Close();
    end;
}