pageextension 80136 "SIEP Shipment Card" extends "PVS Shipment Card"
{
    layout
    {
        addafter("Sender Code")
        {
            field("SIEP Sender Address Id"; Rec."SIEP Sender Address Id")
            {
                ApplicationArea = all;
                Caption = 'Address Id';
                Editable = false;
                Visible = EasyPostEnabled;
            }
        }

        addafter("AddressType")
        {
            field("SIEP Ship-to Address Verified"; Rec."SIEP Ship-to Address Verified")
            {
                ApplicationArea = all;
                Caption = 'Address Verified';
                Editable = false;
                Visible = EasyPostEnabled;
            }
            field("SIEP Address Id"; Rec."SIEP Ship-to Address Id")
            {
                ApplicationArea = all;
                Caption = 'Address Id';
                Editable = false;
                Visible = EasyPostEnabled;
            }
        }

        addbefore("Package Length")
        {
            field("SIEP Predefined Packages"; Rec."SIEP Predefined Package")
            {
                ApplicationArea = All;
                Lookup = true;
                LookupPageId = "SIEP Options";

                trigger OnLookup(var Text: Text): Boolean
                var
                    EasyPostOption: Record "SIEP Option";
                begin
                    EasyPostOption.SetRange(Type, EasyPostOption.Type::"Predefined Package");
                    if Rec."Shipping Agent Code" <> '' then
                        EasyPostOption.SetRange("Shipping Agent Code", Rec."Shipping Agent Code");
                    if Page.RunModal(Page::"SIEP Options", EasyPostOption) = Action::LookupOK then begin
                        Text := EasyPostOption.Code;
                        exit(true);
                    end;
                    exit(false);
                end;
            }
        }

        addafter(Customs)
        {
            group("SIEP EP")
            {
                Caption = 'EasyPost';
                Visible = EasyPostEnabled;

                field("SIEP Contents Type"; Rec."SIEP Non Delivery Option")
                {
                    // Visible = false;
                    ApplicationArea = All;
                }
                field("SIEP Contents Explanation"; Rec."SIEP Restriction Comments")
                {
                    // Visible = false;
                    ApplicationArea = All;
                }
                field("SIEP Customs Certify"; Rec."SIEP Customs Certify")
                {
                    // Visible = false;
                    ApplicationArea = All;
                }
                field("SIEP Customs Signer"; Rec."SIEP Customs Signer")
                {
                    // Visible = false;
                    ApplicationArea = All;
                }
                field("SIEP Non Delivery Option"; Rec."SIEP Non Delivery Option")
                {
                    // Visible = false;
                    ApplicationArea = All;
                }
                field("SIEP Restriction Type"; Rec."SIEP Restriction Type")
                {
                    // Visible = false;
                    ApplicationArea = All;
                }
                field("SIEP Restriction Comments"; Rec."SIEP Restriction Comments")
                {
                    // Visible = false;
                    ApplicationArea = All;
                }
            }
            part("SIEP Customs Items"; "SIEP Customs Items")
            {
                ApplicationArea = All;
                Caption = 'EasyPost Customs Items';
                Visible = EasyPostEnabled;
            }
        }
    }

    actions
    {
        addbefore("SI Create Shipment")
        {
            action("SIEP Verify Address")
            {
                ApplicationArea = All;
                Caption = 'Verify Address';
                Image = ShipAddress;
                Visible = EasyPostEnabled;

                trigger OnAction()
                var
                    ShippingIntegration: Codeunit "PVS Shipping Integration";
                begin
                    ShippingIntegration.ExecuteShippingAction(Enum::"PVS Shipping Action"::"SIEP Verify Address", Rec);
                end;
            }
        }
        addafter("SI Create Shipment")
        {
            action("SIEP Buy Shipment")
            {
                ApplicationArea = All;
                Caption = 'Buy Shipment';
                Image = NewTransferOrder;
                Visible = EasyPostEnabled;

                trigger OnAction()
                var
                    ShippingIntegration: Codeunit "PVS Shipping Integration";
                begin
                    ShippingIntegration.ExecuteShippingAction(Enum::"PVS Shipping Action"::"SIEP Buy Shipment", Rec);
                end;
            }
        }
        addbefore("SI Create Shipment Promoted")
        {
            actionref("SIEP Verify Address Promoted"; "SIEP Verify Address") { }
        }
        addafter("SI Create Shipment Promoted")
        {
            actionref("SIEP Buy Shipment Promoted"; "SIEP Buy Shipment") { }
        }
    }

    trigger OnOpenPage()
    begin
        EasyPostEnabled := EasyPostMgt.IsEnabled();
    end;

    trigger OnAfterGetRecord()
    var
        CustomItemFilters: Record "SIEP Customs Item";
    begin
        if EasyPostMgt.IsEnabled() and EasyPostMgt.IsEasyPost(Rec."Shipping Agent Code") then begin
            this.CreateShipmentEnabled := true;
            this.CancelShipmentEnabled := true;
            this.TrackShipmentEnabled := true;
            this.FetchRatesEnabled := false;
            this.ViewRatesEnabled := true;
            this.RetrieveLabelsEnabled := false;
            this.ViewLabelsEnabled := true;
        end;

        CustomItemFilters.SetRange("Source Record ID", Rec.RecordId);
        CurrPage."SIEP Customs Items".Page.SetRecord(CustomItemFilters);
    end;

    var
        EasyPostMgt: Codeunit "SIEP Mgt.";
        EasyPostEnabled: Boolean;
}