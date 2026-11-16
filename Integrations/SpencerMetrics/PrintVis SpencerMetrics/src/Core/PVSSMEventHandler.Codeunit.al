namespace PrintVis.SpencerMetrics;

using PrintVis.SpencerMetrics.CounterManagement;
using Microsoft.Projects.TimeSheet;
using PrintVis.SpencerMetrics.Configuration;

codeunit 80290 "PVS SM Event Handler"
{
    Access = Internal;
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Shop Floor Management", 'OnAfterShopFloorUserLogin', '', false, false)]
    local procedure ShopFloorManagement_OnAfterShopFloorUserLogin(
        var UserRegisterRec: Record "User Time Register";
        var LaborEntryRec: Record "PVS Job Costing Labor Entry")
    var
        SMCostCenterSetup: Record "PVS SM Cost Center Setup";
        SessionManager: Codeunit "PVS SM Session Manager";
    begin
        if SMCostCenterSetup.Get(UserRegisterRec."PVS Login Cost Center") then
            SessionManager.Start(SMCostCenterSetup."Cost Center");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Shop Floor Management", 'OnAfterShopFloorUserLogout', '', false, false)]
    local procedure ShopFloorManagement_OnAfterShopFloorUserLogout(
        var in_PrintVisUserRec: Record "PVS User Setup";
        var UserRegisterRec: Record "User Time Register";
        var LaborEntryRec_Start: Record "PVS Job Costing Labor Entry")
    var
        SMCostCenterSetup: Record "PVS SM Cost Center Setup";
        SessionManager: Codeunit "PVS SM Session Manager";
    begin
        if SMCostCenterSetup.Get(UserRegisterRec."PVS Login Cost Center") then
            SessionManager.Stop(SMCostCenterSetup."Cost Center");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Shop Floor Management", 'OnBeforeReadMachineCounter', '', false, false)]
    local procedure ShopFloorManagement_OnBeforeReadMachineCounter(
        var in_Journal_EntryRec: Record "PVS Shop Floor Journal Entry";
        Is_Start: Boolean;
        var Is_Handled: Boolean)
    var
        SMCostCenterSetup: Record "PVS SM Cost Center Setup";
        CounterEntry: Record "PVS SM Counter Entry";
        FirstEntryNo: Integer;
        StartUOMDeviceStatusTok: Label 'Start UOM', Locked = true;
        StopUOMDeviceStatusTok: Label 'Stop UOM', Locked = true;
    begin
        if not SMCostCenterSetup.Get(in_Journal_EntryRec."Cost Center Code") then
            exit;

        if Is_Start then begin
            Clear(CounterEntry);
            CounterEntry."Cost Center Code" := in_Journal_EntryRec."Cost Center Code";
            CounterEntry."Entry No." := CounterEntry.GetNextEntryNo(in_Journal_EntryRec."Cost Center Code");
            CounterEntry."Case ID" := in_Journal_EntryRec.ID;
            CounterEntry."Plan ID" := in_Journal_EntryRec."Plan ID";
            CounterEntry.UOM := in_Journal_EntryRec."UOM";
            CounterEntry."Current Count" := -1;
            CounterEntry."Device Status" := StartUOMDeviceStatusTok;
            CounterEntry."Include In Job Costing" := true;
            CounterEntry.Insert();
        end else begin
            CounterEntry.Reset();
            CounterEntry.SetRange("Cost Center Code", in_Journal_EntryRec."Cost Center Code");
            CounterEntry.SetRange("Case ID", in_Journal_EntryRec.ID);
            CounterEntry.SetRange("Plan ID", in_Journal_EntryRec."Plan ID");
            CounterEntry.SetRange(UOM, in_Journal_EntryRec."UOM");
            if CounterEntry.FindFirst() then begin
                FirstEntryNo := CounterEntry."Entry No.";
                CounterEntry.Reset();
                CounterEntry.SetRange("Cost Center Code", in_Journal_EntryRec."Cost Center Code");
                CounterEntry.SetRange("Include In Job Costing", false);
                CounterEntry.SetFilter("Entry No.", '>%1', FirstEntryNo);
                if CounterEntry.FindSet(true) then
                    repeat
                        CounterEntry."Case ID" := in_Journal_EntryRec.ID;
                        CounterEntry."Plan ID" := in_Journal_EntryRec."Plan ID";
                        CounterEntry.UOM := in_Journal_EntryRec.UOM;
                        in_Journal_EntryRec.Quantity := in_Journal_EntryRec.Quantity + CounterEntry."Difference Count";
                        CounterEntry."Include In Job Costing" := true;
                        CounterEntry.Modify();
                    until CounterEntry.Next() = 0;
                CounterEntry.Reset();
                CounterEntry.Init();
                CounterEntry."Entry No." := CounterEntry.GetNextEntryNo(in_Journal_EntryRec."Cost Center Code");
                CounterEntry."Case ID" := 0;
                CounterEntry."Plan ID" := 0;
                CounterEntry.UOM := '';
                CounterEntry."Current Count" := -1;
                CounterEntry."Device Status" := StopUOMDeviceStatusTok;
                CounterEntry."Include In Job Costing" := true;
                CounterEntry.Insert();
            end;
        end;
    end;
}