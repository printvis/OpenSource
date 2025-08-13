Codeunit 80281 "Split bind Merge Planning"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Planning Units Generate ", OnBefore_FindExistingPlanUnit, '', false, false)]
    local procedure OnBefore_FindExistingPlanUnit(var out_PlanUnitTmp: Record "PVS Job Planning Unit" temporary; in_SetupRec: Record "PVS Calculation Unit Setup"; in_CapacityCode: Code[20]; SheetID: Integer; ProcessID: Integer; var in_CalcUnitTMP: Record "PVS Job Calculation Unit" temporary; var in_JobItemRec_Tmp: Record "PVS Job Item" temporary; var IsFound: Boolean; var IsHandled: Boolean);
    var
        CalcUnitRec: Record "PVS Job Calculation Unit";
        Sheet_Filter: Text[250];
        Stop: Boolean;
    begin

        // Split bind – merge schedule based on new job item field (Common Text = true)

        CalcUnitRec := in_CalcUnitTMP;

        in_JobItemRec_Tmp.SetRange(ID, CalcUnitRec.ID);
        in_JobItemRec_Tmp.SetRange(Job, CalcUnitRec.Job);
        in_JobItemRec_Tmp.SetRange(Version, CalcUnitRec.Version);


        // Check if the actual calculation unit has a value in the new job item field
        if CalcUnitRec."Job Item No." <> 0 then
            Stop := (not in_JobItemRec_Tmp.Get(CalcUnitRec.ID, CalcUnitRec.Job, CalcUnitRec.Version, CalcUnitRec."Job Item No.", 1))
        else
            if CalcUnitRec."Sheet ID" <> 0 then begin
                in_JobItemRec_Tmp.setrange("Sheet ID", CalcUnitRec."Sheet ID");
                Stop := (not in_JobItemRec_Tmp.FindFirst());
            end else
                Stop := true;

        if not stop then
            stop := (not in_JobItemRec_Tmp."Common Text");

        if stop then begin
            in_JobItemRec_Tmp.Reset();
            exit;
        end;

        // make a filtertxt for the other sheets belonging to the common text
        Sheet_Filter := '';

        in_JobItemRec_Tmp.SetRange("Sheet ID", SheetID);
        in_JobItemRec_Tmp.setfilter("Sheet ID", '<>0&<>%1', CalcUnitRec."Sheet ID");
        in_JobItemRec_Tmp.setrange("Common Text", true);

        if in_JobItemRec_Tmp.FindSet(false) then
            repeat
                if Sheet_Filter <> '' then
                    Sheet_Filter += '|';
                Sheet_Filter += Format(in_JobItemRec_Tmp."Sheet ID");
            until in_JobItemRec_Tmp.Next() = 0;

        in_JobItemRec_Tmp.reset;

        if Sheet_Filter = '' then begin
            // This is the only JobItem Marked as common text -> no merge
            IsFound := false;
            IsHandled := true;
            exit;
        end;

        out_PlanUnitTmp.SetCurrentkey("Simulation Version", "Capacity Unit", Unit, ID, Job, "Planning Status");
        out_PlanUnitTmp.SetRange("Simulation Version", 0);
        out_PlanUnitTmp.SetRange(ID, CalcUnitRec.ID);
        out_PlanUnitTmp.SetRange(Job, CalcUnitRec.Job);
        out_PlanUnitTmp.SetRange(Unit, in_SetupRec.Code);
        out_PlanUnitTmp.SetRange("Sheet No. 2", 0, 1);
        out_PlanUnitTmp.SetRange("Capacity Unit", in_CapacityCode);

        in_CalcUnitTMP.SetRange(ID, CalcUnitRec.ID);
        in_CalcUnitTMP.SetRange(Job, CalcUnitRec.Job);
        in_CalcUnitTMP.SetRange(Version, CalcUnitRec.Version);
        in_CalcUnitTMP.SetRange("Cost Center Code", CalcUnitRec."Cost Center Code"); // I assume cost centers need to be identical
        in_CalcUnitTMP.SetFilter("Sheet ID", Sheet_Filter);

        if out_PlanUnitTmp.FindSet() then
            repeat
                // Potential merge candidate found
                IsFound := false;
                in_CalcUnitTMP.SetRange("Plan ID", out_PlanUnitTmp."Plan ID");
                if not in_CalcUnitTMP.IsEmpty then
                    IsFound := true
                else
                    Stop := out_PlanUnitTmp.Next() = 0;
            until IsFound or Stop;

        in_CalcUnitTMP.Reset;
        // if IsFound then
        IsHandled := true;
    end;


}