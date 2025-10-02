pageextension 80157 "SINS Shipment Card" extends "PVS Shipment Card"
{
    layout
    {
        addlast(Sender)
        {
            field("SINS Quick ID"; Rec."SINS Sender Quick ID")
            {
                ApplicationArea = All;
                Caption = 'Quick ID';
                Editable = false;
                Visible = DeliveryEnabled;
            }
        }
    }

    trigger OnOpenPage()
    begin
        DeliveryEnabled := DeliveryShptMgt.IsEnabled();
    end;

    trigger OnAfterGetRecord()
    begin
        if ShipShptMgt.IsEnabled() and ShipShptMgt.IsShip(Rec."Shipping Agent Code") then begin
            this.CreateShipmentEnabled := true;
            this.CancelShipmentEnabled := true;
            this.TrackShipmentEnabled := true;
            this.FetchRatesEnabled := true;
            this.ViewRatesEnabled := true;
            this.RetrieveLabelsEnabled := false;
            this.ViewLabelsEnabled := true;
        end;

        if DeliveryShptMgt.IsEnabled() and DeliveryShptMgt.IsDelivery(Rec."Shipping Agent Code") then begin
            this.CreateShipmentEnabled := true;
            this.CancelShipmentEnabled := true;
            this.TrackShipmentEnabled := true;
            this.FetchRatesEnabled := true;
            this.ViewRatesEnabled := true;
            this.RetrieveLabelsEnabled := false;
            this.ViewLabelsEnabled := true;
        end;
    end;

    var
        DeliveryShptMgt: Codeunit "SINS Delivery Shpt. Mgt.";
        ShipShptMgt: Codeunit "SINS Ship Shpt. Mgt.";
        DeliveryEnabled: Boolean;
}