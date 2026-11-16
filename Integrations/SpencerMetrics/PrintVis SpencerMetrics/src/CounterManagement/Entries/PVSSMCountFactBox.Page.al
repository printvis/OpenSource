namespace PrintVis.SpencerMetrics.CounterManagement;

using PrintVis.SpencerMetrics.Utilities;

page 80295 "PVS SM Count FactBox"
{
    ApplicationArea = All;
    Caption = 'SpencerMetrics Count Summary';
    Editable = false;
    PageType = ListPart;
    SourceTable = "PVS SM Count Summary Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            usercontrol(Timer; "PVS SM Timer AddIn")
            {
                trigger Ready()
                begin
                    CurrPage.Timer.Start(5000);
                end;

                trigger OnTick()
                begin
                    this.RefreshLoop();
                end;
            }

            repeater(repeater)
            {
                field(UOM; Rec."UOM") { }
                field("Total Difference Count"; Rec."Total Difference Count") { }
            }
        }
    }

    local procedure ResolveContext(): Boolean
    var
        ShopFloorMgmt: Codeunit "PVS Shop Floor Management";
    begin
        CurrentCostCenter := ShopFloorMgmt.User_Get_Current_CostCenter();
        if (CurrentCostCenter = '') then
            exit(false);

        exit(ShopFloorMgmt.Find_ActivePlanJournalEntry(CurrentPlan, 0, 0, 0, CurrentCostCenter));
    end;

    local procedure RefreshLoop()
    var
        SumByUOM: Query "PVS SM Counts Sum By UOM";
    begin
        If not this.ResolveContext() then
            exit;

        Rec.DeleteAll();

        SumByUOM.SetFilter(CostCenter, CurrentCostCenter);
        SumByUOM.SetRange(CaseID, CurrentPlan.ID);
        SumByUOM.SetRange(PlanID, CurrentPlan."Plan ID");
        if not SumByUOM.Open() then
            Error('Error opening Query');

        while SumByUOM.Read() do begin
            Clear(Rec);
            Rec."Case ID" := CurrentPlan.ID;
            Rec."Plan ID" := CurrentPlan."Plan ID";
            Rec."UOM" := SumByUOM.UOM;
            Rec."Total Difference Count" := SumByUOM.DifferenceCountSum;
            Rec."Cost Center Code" := CurrentCostCenter;
            Rec.Insert();
        end;

        SumByUOM.Close();

        CurrPage.Update(false);
    end;

    var
        CurrentPlan: Record "PVS Shop Floor Journal Entry";
        CurrentCostCenter: Code[20];
}