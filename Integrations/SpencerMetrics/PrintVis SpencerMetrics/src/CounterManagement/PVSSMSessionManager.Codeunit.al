namespace PrintVis.SpencerMetrics.CounterManagement;

using PrintVis.SpencerMetrics.Configuration;
using System.Threading;

codeunit 80294 "PVS SM Session Manager"
{
    Access = Internal;

    var
        SpencerMetricsLbl: Label 'SpencerMetrics: %1', Comment = '%1 = Error Message', Locked = true;

    procedure Start(in_CostCenter: Code[20])
    var
        SMCostCenterSetup: Record "PVS SM Cost Center Setup";
        JobQueueEntry: Record "Job Queue Entry";
        EmptyGuid: Guid;
        SessionStartErr: Label 'Failed to start session. %1', Comment = '%1 = Error Message';

    begin
        if not SMCostCenterSetup.Get(in_CostCenter) then
            exit;

        if SMCostCenterSetup.Enabled then
            exit;

        SMCostCenterSetup.Enabled := true;
        SMCostCenterSetup."Last Error" := '';
        SMCostCenterSetup.Modify(true);
        Commit();

        ClearLastError();

        Clear(JobQueueEntry);
        JobQueueEntry.Init();
        JobQueueEntry.ID := CreateGuid();
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := Codeunit::"PVS SM Counter Worker";
        JobQueueEntry."Record ID to Process" := SMCostCenterSetup.RecordId;
        JobQueueEntry."Run in User Session" := false;
        JobQueueEntry."Record ID to Process" := SMCostCenterSetup.RecordId;
        JobQueueEntry.Description := StrSubstNo(SpencerMetricsLbl, in_CostCenter);
        if not JobQueueEntry.Insert(true) then begin
            SMCostCenterSetup.Enabled := false;
            SMCostCenterSetup."Last Error" := StrSubstNo(SessionStartErr, GetLastErrorText());
            SMCostCenterSetup.Modify(true);
            Commit();
            LogSessionEvent(in_CostCenter, EmptyGuid, Enum::"PVS SM Session Event Type"::Start, false, SMCostCenterSetup."Last Error");
            exit;
        end;

        Codeunit.Run(Codeunit::"Job Queue - Enqueue", JobQueueEntry);

        SMCostCenterSetup.SetLastHeartbeat();
        SMCostCenterSetup."Job Queue Entry ID" := JobQueueEntry.ID;
        SMCostCenterSetup."Session Id" := 0;
        SMCostCenterSetup.Modify(true);
        Commit();
        LogSessionEvent(in_CostCenter, JobQueueEntry.ID, Enum::"PVS SM Session Event Type"::Start, true, '');
    end;

    procedure Stop(in_CostCenter: Code[20])
    var
        SMCostCenterSetup: Record "PVS SM Cost Center Setup";
        SessionParameter: Record "PVS SM Session Parameter";
        JobQueueEntry: Record "Job Queue Entry";
        CounterEntry: Record "PVS SM Counter Entry";
        StoppedJobQueueEntryId: Guid;
        StopSuccess: Boolean;
        ErrorMsg: Text;
    begin
        if not SMCostCenterSetup.Get(in_CostCenter) then
            exit;

        StoppedJobQueueEntryId := SMCostCenterSetup."Job Queue Entry ID";
        StopSuccess := true;
        ErrorMsg := '';

        SMCostCenterSetup.Enabled := false;
        SMCostCenterSetup."Last Error" := '';

        if not IsNullGuid(SMCostCenterSetup."Job Queue Entry ID") then
            if JobQueueEntry.Get(SMCostCenterSetup."Job Queue Entry ID") then begin
                JobQueueEntry.SetStatus(JobQueueEntry.Status::"On Hold");
                JobQueueEntry.Delete(true);
            end;

        if (SMCostCenterSetup."Session Id" <> 0) and SessionParameter.Get(SMCostCenterSetup."Session Id") then
            SessionParameter.Delete();

        SMCostCenterSetup."Session Id" := 0;
        Clear(SMCostCenterSetup."Job Queue Entry ID");
        SMCostCenterSetup.Modify(true);

        CounterEntry.Reset();
        CounterEntry.SetRange("Cost Center Code", in_CostCenter);
        CounterEntry.SetRange("Include In Job Costing", true);
        if CounterEntry.Count() > 0 then
            CounterEntry.DeleteAll();

        CounterEntry.Reset();
        CounterEntry.SetRange("Cost Center Code", in_CostCenter);
        CounterEntry.SetFilter("Difference Count", '=0');
        if CounterEntry.Count() > 0 then
            CounterEntry.DeleteAll();

        LogSessionEvent(in_CostCenter, StoppedJobQueueEntryId, Enum::"PVS SM Session Event Type"::Stop, StopSuccess, ErrorMsg);
    end;

    procedure Rotate(in_CostCenter: Code[20]): Boolean
    var
        SMCostCenterSetup: Record "PVS SM Cost Center Setup";
        SessionParameter: Record "PVS SM Session Parameter";
        OldJobQueueEntry: Record "Job Queue Entry";
        NewJobQueueEntry: Record "Job Queue Entry";
        OldSessionId: Integer;
        OldJobQueueEntryId: Guid;
        EmptyGuid: Guid;
        SessionStartErr: Label 'Failed to start rotated session. %1', Comment = '%1 = Error Message';
    begin
        if not SMCostCenterSetup.Get(in_CostCenter) then
            exit(false);

        if not SMCostCenterSetup.Enabled then
            exit(false);

        OldSessionId := SMCostCenterSetup."Session Id";
        OldJobQueueEntryId := SMCostCenterSetup."Job Queue Entry ID";

        ClearLastError();

        Clear(NewJobQueueEntry);
        NewJobQueueEntry.Init();
        NewJobQueueEntry.ID := CreateGuid();
        NewJobQueueEntry."Object Type to Run" := NewJobQueueEntry."Object Type to Run"::Codeunit;
        NewJobQueueEntry."Object ID to Run" := Codeunit::"PVS SM Counter Worker";
        NewJobQueueEntry."Record ID to Process" := SMCostCenterSetup.RecordId;
        NewJobQueueEntry."Run in User Session" := false;
        NewJobQueueEntry.Description := StrSubstNo(SpencerMetricsLbl, in_CostCenter);
        if not NewJobQueueEntry.Insert(true) then begin
            SMCostCenterSetup."Last Error" := StrSubstNo(SessionStartErr, GetLastErrorText());
            SMCostCenterSetup.Modify(true);
            Commit();
            LogSessionEvent(in_CostCenter, EmptyGuid, Enum::"PVS SM Session Event Type"::Start, false, SMCostCenterSetup."Last Error");
            exit(false);
        end;

        Codeunit.Run(Codeunit::"Job Queue - Enqueue", NewJobQueueEntry);

        LogSessionEvent(in_CostCenter, OldJobQueueEntryId, Enum::"PVS SM Session Event Type"::Stop, true, '');

        if not IsNullGuid(OldJobQueueEntryId) then
            if OldJobQueueEntry.Get(OldJobQueueEntryId) then begin
                OldJobQueueEntry.SetStatus(OldJobQueueEntry.Status::"On Hold");
                OldJobQueueEntry.Delete(true);
            end;


        if (OldSessionId <> 0) and SessionParameter.Get(OldSessionId) then
            SessionParameter.Delete();

        SMCostCenterSetup.SetLastHeartbeat();
        SMCostCenterSetup."Job Queue Entry ID" := NewJobQueueEntry.ID;
        SMCostCenterSetup."Session Id" := 0;
        SMCostCenterSetup."Last Error" := '';
        SMCostCenterSetup.Modify(true);
        Commit();

        LogSessionEvent(in_CostCenter, NewJobQueueEntry.ID, Enum::"PVS SM Session Event Type"::Start, true, '');

        exit(true);
    end;

    procedure GetExpectedEndDateTime(in_CostCenter: Code[20]; in_JobQueueEntryId: Guid): DateTime
    var
        SessionLog: Record "PVS SM Session Log";
    begin
        SessionLog.Reset();
        SessionLog.SetRange("Cost Center", in_CostCenter);
        SessionLog.SetRange("Job Queue Entry ID", in_JobQueueEntryId);
        SessionLog.SetRange("Event Type", Enum::"PVS SM Session Event Type"::Start);
        SessionLog.SetRange(Success, true);
        if SessionLog.FindLast() then
            exit(SessionLog."Expected End DateTime");
        exit(0DT);
    end;

    local procedure LogSessionEvent(
        in_CostCenter: Code[20];
        in_JobQueueEntryId: Guid;
        in_EventType: Enum "PVS SM Session Event Type";
        in_Success: Boolean;
        in_ErrorMessage: Text)
    var
        SessionLog: Record "PVS SM Session Log";
        SMSetup: Record "PVS SM Setup";
    begin
        Clear(SessionLog);
        SessionLog."Cost Center" := in_CostCenter;
        SessionLog."Job Queue Entry ID" := in_JobQueueEntryId;
        SessionLog."Event Type" := in_EventType;
        SessionLog."Event DateTime" := CurrentDateTime();
        SessionLog."User ID" := CopyStr(UserId(), 1, MaxStrLen(SessionLog."User ID"));
        SessionLog.Success := in_Success;
        SessionLog."Error Message" := CopyStr(in_ErrorMessage, 1, MaxStrLen(SessionLog."Error Message"));

        if (in_EventType = Enum::"PVS SM Session Event Type"::Start) and in_Success then begin
            SMSetup.Get();
            if SMSetup."Max Session Duration (min)" > 0 then
                SessionLog."Expected End DateTime" := SessionLog."Event DateTime" + (SMSetup."Max Session Duration (min)" * 60000);
        end;

        SessionLog.Insert(true);
    end;
}
