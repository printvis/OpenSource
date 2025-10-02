namespace PrintVis.OpenSource.NShift.Delivery.Setup;

page 80155 "SINS Delivery Setup"
{
    ApplicationArea = All;
    Caption = 'nShift Delivery Setup';
    InsertAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "SINS Delivery Setup";
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
            group(Authentication)
            {
                Caption = 'Authentication';
                Editable = not Rec.Enabled;

                field("User Name"; Rec."User Name")
                {
                    Caption = 'User Name';
                }
                group(ApiKeyAuth)
                {
                    ShowCaption = false;

                    field("Api Key"; ApiKey)
                    {
                        Caption = 'API Key';

                        trigger OnValidate()
                        begin
                            Rec.SaveApiKey(ApiKey);
                        end;
                    }
                }
            }

            group(TrackAndTrace)
            {
                Caption = 'Track and Trace';
                Editable = not Rec.Enabled;

                field("Shipment Tracking Url"; Rec."Shipment Tracking Url")
                {
                    ShowMandatory = true;
                }
                field("Language Code"; Rec."Language Code")
                {
                    ShowMandatory = true;
                }
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
            ApiKey := '********';
    end;

    var
        ApiKey: Text;
}