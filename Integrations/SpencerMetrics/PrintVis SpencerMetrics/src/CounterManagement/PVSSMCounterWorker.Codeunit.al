namespace PrintVis.SpencerMetrics.CounterManagement;

using PrintVis.SpencerMetrics.Configuration;
using System.Threading;
using PrintVis.SpencerMetrics.Services;

codeunit 80293 "PVS SM Counter Worker"
{
    Access = Internal;
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        SMCostCenterSetup: Record "PVS SM Cost Center Setup";
        SessionParameter: Record "PVS SM Session Parameter";
        CostCenterCode: Code[20];
        KeepRunning: Boolean;
        Interval: Integer;
        MySessionId: Integer;
        CostCenterSetupNotFoundErr: Label 'Cost center setup not found for %1', Comment = '%1 = RecordId';
    begin
        if not SMCostCenterSetup.Get(Rec."Record ID to Process") then
            Error(CostCenterSetupNotFoundErr, Rec."Record ID to Process");

        CostCenterCode := SMCostCenterSetup."Cost Center";
        MySessionId := SessionId();
        KeepRunning := true;

        Clear(SessionParameter);
        SessionParameter."Session Id" := MySessionId;
        SessionParameter."Setup Code" := CostCenterCode;
        if not SessionParameter.Insert(true) then
            SessionParameter.Modify(true);

        SMCostCenterSetup."Session Id" := MySessionId;
        SMCostCenterSetup.SetLastHeartbeat();
        SMCostCenterSetup.Modify();
        Commit();

        if SMCostCenterSetup."Interval (ms)" < 5000 then
            Interval := 5000
        else
            Interval := SMCostCenterSetup."Interval (ms)";

        while KeepRunning do begin
            SMCostCenterSetup.Get(CostCenterCode);
            SMCostCenterSetup.SetLastHeartbeat();
            SMCostCenterSetup.Modify();
            Commit();

            if ShouldRotateSession(CostCenterCode, Rec.ID) then
                if RotateSession(CostCenterCode) then
                    KeepRunning := false;

            if KeepRunning then begin
                this.DoTick(CostCenterCode);

                if not SMCostCenterSetup.Enabled then
                    KeepRunning := false;

                if KeepRunning then
                    Sleep(Interval);
            end;
        end;
    end;

    procedure DoTick(in_CostCenter: Code[20])
    var
        SpencerMetricsApiClient: Codeunit "PVS SM Api Client";
    begin
        SpencerMetricsApiClient.ProcessSpencerMetricsData(in_CostCenter);
    end;

    local procedure ShouldRotateSession(in_CostCenter: Code[20]; in_JobQueueEntryId: Guid): Boolean
    var
        SessionManager: Codeunit "PVS SM Session Manager";
        ExpectedEnd: DateTime;
    begin
        ExpectedEnd := SessionManager.GetExpectedEndDateTime(in_CostCenter, in_JobQueueEntryId);
        if ExpectedEnd = 0DT then
            exit(false);
        exit(CurrentDateTime() >= ExpectedEnd);
    end;

    local procedure RotateSession(in_CostCenter: Code[20]): Boolean
    var
        SessionManager: Codeunit "PVS SM Session Manager";
    begin
        exit(SessionManager.Rotate(in_CostCenter));
    end;
}
