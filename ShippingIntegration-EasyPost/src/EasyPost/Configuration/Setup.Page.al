namespace PrintVis.OpenSource.EasyPost.Setup;

page 80134 "SIEP Setup"
{
    ApplicationArea = All;
    Caption = 'EasyPost Setup';
    InsertAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "SIEP Setup";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(Enabled; Rec.Enabled)
                {
                    Caption = 'Enabled';
                }
            }
            group(Server)
            {
                Caption = 'Server';
                Editable = not Rec.Enabled;

                field("Server Url"; Rec."Server Url")
                {
                    Caption = 'Server Url';
                    ShowMandatory = true;
                }
            }

            group(Authorization)
            {
                Caption = 'Authorization';
                Editable = not Rec.Enabled;

                field(ApiKey; this.ApiKey)
                {
                    Caption = 'API Key';

                    trigger OnValidate()
                    begin
                        Rec.SaveApiKey(ApiKey);
                    end;
                }
            }

            group("Label")
            {
                Caption = 'Label';
                Editable = not Rec.Enabled;

                field("Label Type"; Rec."Label Type") { }
                field("Label Size"; Rec."Label Size") { }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Initialize();
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec.ApiKeyIsSet() then
            this.ApiKey := '********';
    end;

    var
        ApiKey: Text;
}