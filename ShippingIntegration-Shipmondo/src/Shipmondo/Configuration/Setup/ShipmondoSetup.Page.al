namespace PrintVis.OpenSource.Shipmondo.Configuration;

page 80184 "SISM Setup"
{
    ApplicationArea = All;
    Caption = 'Shipmondo Setup';
    InsertAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "SISM Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(Enabled; Rec.Enabled) { }
                field("Test Mode"; Rec."Test Mode")
                {
                    Enabled = not Rec.Enabled;
                }
            }
            group(Server)
            {
                Caption = 'Server';
                Enabled = not Rec.Enabled;

                field("Server Url"; Rec."Server Url")
                {
                    ShowMandatory = true;
                }
            }
            group(Authentication)
            {
                Caption = 'Authentication';
                Enabled = not Rec.Enabled;

                field(Username; Rec."Username") { }
                field(Password; this.PasswordAsText)
                {
                    Caption = 'Password';

                    trigger OnValidate()
                    begin
                        Rec.SavePassword(this.PasswordAsText);
                    end;
                }
            }
            group("Label")
            {
                Caption = 'Label';
                Enabled = not Rec.Enabled;

                field("Label Format"; Rec."Label Format") { }
                field("Scale By"; Rec."Scale By") { }
                field("Scale Size"; Rec."Scale Size") { }
            }
            group(Tracking)
            {
                Caption = 'Tracking';
                Enabled = not Rec.Enabled;

                field("Shipment Tracking Url"; Rec."Shipment Tracking Url") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(AssistedSetup)
            {
                Caption = 'Assisted Setup';
                Image = Setup;
                RunObject = Page "SISM Assisted Setup";
                RunPageMode = Edit;
            }
            action(PrintClients)
            {
                Caption = 'Print Clients';
                Image = MachineCenter;
                RunObject = Page "SISM Print Clients";
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(AssistedSetup_Promoted; AssistedSetup) { }
                actionref(PrintClients_Promoted; PrintClients) { }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then
            Rec.Initialize();

        if Rec.PasswordIsSet() then
            this.PasswordAsText := '********';
    end;

    var
        PasswordAsText: Text;
}