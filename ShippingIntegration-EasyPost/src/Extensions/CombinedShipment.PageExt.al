pageextension 80139 "SIEP Combined Shipment" extends "PVS Combined Shipment"
{
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
                    TempCombinedShipmentLine: Record "PVS Combined Shipment Line" temporary;
                    ShippingIntegration: Codeunit "PVS Shipping Integration";
                begin
                    CurrPage.Lines.Page.GetShpmntLines(TempCombinedShipmentLine);
                    ShippingIntegration.ExecuteShippingAction(Enum::"PVS Shipping Action"::"SIEP Verify Address", Rec, TempCombinedShipmentLine);
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
                    TempCombinedShipmentLine: Record "PVS Combined Shipment Line" temporary;
                    ShippingIntegration: Codeunit "PVS Shipping Integration";
                begin
                    CurrPage.Lines.Page.GetShpmntLines(TempCombinedShipmentLine);
                    ShippingIntegration.ExecuteShippingAction(Enum::"PVS Shipping Action"::"SIEP Buy Shipment", Rec, TempCombinedShipmentLine);
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