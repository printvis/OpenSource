namespace PrintVis.SpencerMetrics.CounterManagement;

query 80290 "PVS SM Counts Sum By UOM"
{
    elements
    {
        dataitem(CounterEntry; "PVS SM Counter Entry")
        {
            filter(CostCenter; "Cost Center Code") { }
            filter(CaseID; "Case ID") { }
            filter(PlanID; "Plan ID") { }
            column(UOM; UOM) { }
            column(DifferenceCountSum; "Difference Count") { Method = Sum; }
        }
    }
}