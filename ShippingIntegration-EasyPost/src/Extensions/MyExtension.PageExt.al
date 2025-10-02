pageextension 80140 "SIEP MyExtension" extends "PVS Shipment List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addbefore("SI Create Shipment")
        {
            action("SIEP Verify Address")
            {
                ApplicationArea = All;
                Caption = 'Verify Address';
                Enabled = EasyPostEnabled;
                Image = ShipAddress;

                trigger OnAction()
                var
                    ShippingIntegration: Codeunit "PVS Shipping Integration";
                begin
                    ShippingIntegration.ExecuteShippingAction(Enum::"PVS Shipping Action"::"SIEP Verify Address", Rec);
                end;
            }
        }
        addafter("SI Cancel Shipment")
        {
            action("SIEP Buy Shipment")
            {
                ApplicationArea = All;
                Caption = 'Buy Shipment';
                Enabled = EasyPostEnabled;
                Image = NewTransferOrder;

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
        addafter("SI Cancel Shipment Promoted")
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