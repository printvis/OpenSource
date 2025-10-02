namespace PrintVis.OpenSource.NShift.Ship.Setup;

page 80154 "SINS Ship Setup"
{
    ApplicationArea = All;
    Caption = 'nShift Ship Setup';
    InsertAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "SINS Ship Setup";
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
                field("Authentication Server Url"; Rec."Authentication Server Url")
                {
                    Caption = 'Authentication Server Url';
                    ShowMandatory = true;
                }
            }
            group(Authentication)
            {
                Caption = 'Authentication';
                Editable = not Rec.Enabled;

                field("Actor ID"; Rec."Actor ID")
                {
                    Caption = 'Actor ID';
                }
                group(BearerTokenAuth)
                {
                    ShowCaption = false;
                    field("Client ID"; Rec."Client ID")
                    {
                        Caption = 'Client ID';
                    }
                    field("Client Secret"; ClientSecret)
                    {
                        Caption = 'Client Secret';

                        trigger OnValidate()
                        begin
                            Rec.SaveClientSecret(ClientSecret);
                        end;
                    }
                }
            }
            group(Tracking)
            {
                Caption = 'Tracking';
                Editable = not Rec.Enabled;

                field("Shipment Tracking Url"; Rec."Shipment Tracking Url")
                {
                    Caption = 'Tracking Url';
                }
                field("Package Tracking Url"; Rec."Package Tracking Url")
                {
                    Caption = 'Package Tracking Url';
                }
            }
            group(labels)
            {
                Caption = 'Labels';
                Editable = not Rec.Enabled;

                field("Label Type"; Rec."Label Type")
                {
                    Caption = 'Label Type';
                }
            }
            group(Prices)
            {
                Caption = 'Prices';
                Editable = not Rec.Enabled;

                field("Enable Price Calculation"; Rec."Enable Price Calculation")
                {
                    Caption = 'Price Calculation';
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
        if Rec.ClientSecretIsSet() then
            ClientSecret := '********';
    end;

    var
        ClientSecret: Text;
}