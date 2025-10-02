pageextension 80141 "SIEP Shipment Management" extends "PVS Shipment Management"
{
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

    var
        EasyPostMgt: Codeunit "SIEP Mgt.";
        EasyPostEnabled: Boolean;
}