namespace PrintVis.SpencerMetrics.Integration;

using PrintVis.SpencerMetrics.Configuration;
using PrintVis.SpencerMetrics.CounterManagement;

pageextension 80290 "PVS SM Electronic Ticket" extends "PVS SF Electronic Ticket"
{
    layout
    {
        addbefore(QtyPart)
        {
            part("PVS SM Count Summary"; "PVS SM Count FactBox")
            {
                ApplicationArea = All;
                Caption = 'SpencerMetrics Count Summary';
                Visible = ShowCountsFactBox;
            }
        }
    }

    var
        ShowCountsFactBox: Boolean;

    trigger OnOpenPage()
    var
        SMCostCenterSetup: Record "PVS SM Cost Center Setup";
        ShopFloorManagement: Codeunit "PVS Shop Floor Management";
    begin
        SMCostCenterSetup.SetRange("Cost Center", ShopFloorManagement.User_Get_Current_CostCenter());
        ShowCountsFactBox := not SMCostCenterSetup.IsEmpty;
    end;
}