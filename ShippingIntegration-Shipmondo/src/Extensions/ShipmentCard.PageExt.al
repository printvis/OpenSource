namespace PrintVis.OpenSource.Shipmondo;
using Microsoft.Foundation.Shipping;

pageextension 80184 "SISM Shipment Card" extends "PVS Shipment Card"
{
    layout
    {
        modify(ShippingAgentServiceCode)
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }

        addlast(ShipTo)
        {
            field("SISM Service Point ID"; Rec."SISM Service Point ID")
            {
                ApplicationArea = All;
                Enabled = ServicePointEnabled;

                trigger OnDrillDown()
                var
                    ShippingAgent: Record "Shipping Agent";
                    PickupPoint: Record "SISM Pickup Point";
                    PickupPoints: Page "SISM Pickup Points";
                begin
                    ShippingAgent.Get(Rec."Shipping Agent Code");
                    ShippingAgent.TestField("SISM External Service Id");

                    Clear(PickupPoints);
                    PickupPoints.Load(ShippingAgent."SISM External Service Id", Rec."Country/Region Code", Rec."Post Code", Rec."Address");
                    PickupPoints.LookupMode(true);
                    Commit();
                    if PickupPoints.RunModal() = Action::LookupOK then begin
                        PickupPoints.GetRecord(PickupPoint);
                        if (PickupPoint.ID <> '') then
                            Rec."SISM Service Point ID" := PickupPoint."ID";
                    end;
                end;
            }
        }
        addafter(Info)
        {
            group("SISM")
            {
                Caption = 'Shipmondo';

                field("SISM Printer Name"; Rec."SISM Printer Name")
                {
                    ApplicationArea = All;
                }
                field("SISM Printer Label Format"; Rec."SISM Printer Label Format")
                {
                    ApplicationArea = All;
                }
                field("SISM Printer Hostname"; Rec."SISM Printer Hostname")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        addlast("SI Shipping")
        {
            action("SISM Print Job")
            {
                ApplicationArea = All;
                Caption = 'Print Job';
                Enabled = ShipmondoEnabled;
                Image = Print;

                trigger OnAction()
                var
                    ShippingIntegration: Codeunit "PVS Shipping Integration";
                begin
                    ShippingIntegration.ExecuteShippingAction(Enum::"PVS Shipping Action"::"SISM Print Job", Rec);
                end;

                // trigger OnAction()
                // var
                //     ShipmondoImplementation: Codeunit "SISM Implementation";
                //     JobPrintedMsg: Label 'Job printed successfully';
                // begin
                //     Clear(ErrorMessageMgt);
                //     Clear(ErrorMessageHandler);
                //     Clear(ErrorContextElement);

                //     ShipmondoMgt.ActivateErrorHandlingFor(ErrorMessageMgt, ErrorMessageHandler, ErrorContextElement, Rec.RecordId);

                //     if not ShipmondoImplementation.PrintJob(Enum::"PVS Shipping Action"::"SISM Print Job", Rec, ErrorMessageMgt) then
                //         ErrorMessageHandler.ShowErrors()
                //     else
                //         Message(JobPrintedMsg);
                // end;
            }
        }
        addlast("SI Shipping Promoted")
        {
            actionref("SISM Print Job Promoted"; "SISM Print Job") { }
        }
    }

    trigger OnAfterGetRecord()
    var
        ShippingAgentService: Record "Shipping Agent Services";
    begin
        ShipmondoEnabled := ShipmondoMgt.IsEnabled() and ShipmondoMgt.IsShipmondo(Rec."Shipping Agent Code");
        if ShipmondoEnabled then begin
            this.CreateShipmentEnabled := true;
            this.CancelShipmentEnabled := true;
            this.TrackShipmentEnabled := true;
            this.FetchRatesEnabled := true;
            this.ViewRatesEnabled := true;
            this.ViewLabelsEnabled := true;
            this.RetrieveLabelsEnabled := true;
        end;

        ServicePointEnabled := false;
        if (Rec."Shipping Agent Code" <> '') and (Rec."Shipping Agent Service Code" <> '') then
            if ShippingAgentService.Get(Rec."Shipping Agent Code", Rec."Shipping Agent Service Code") then
                ServicePointEnabled := ShippingAgentService."SISM Req. Service Point";
    end;

    var
        ShipmondoMgt: Codeunit "SISM Mgt";
        ServicePointEnabled, ShipmondoEnabled : Boolean;
}