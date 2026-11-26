namespace PrintVis.BoldSign.Workflows;

codeunit 80310 "PVS BS Doc. Workflow Mgt."
{
    Access = Internal;
    Permissions = tabledata "PVS Case" = RM,
                  tabledata "PVS Job Planning Unit" = RM;

    /// <summary>
    /// Updates the status of a case to a new status code.
    /// </summary>
    /// <param name="CaseID">The ID of the case to update.</param>
    /// <param name="NextStatusCode">The new status code to set.</param>
    procedure UpdateCaseStatus(CaseID: Integer; NextStatusCode: Code[20])
    var
        PrintVisCase: Record "PVS Case";
    begin
        if not PrintVisCase.Get(CaseID) then
            exit;

        PrintVisCase.Validate("Status Code", NextStatusCode);
        PrintVisCase.Modify();
    end;

    /// <summary>
    /// Updates the rejection code of a case.
    /// </summary>
    /// <param name="CaseID">The ID of the case to update.</param>
    /// <param name="RejectionCode">The rejection code to set.</param>
    procedure UpdateCaseRejectionCode(CaseID: Integer; RejectionCode: Code[20])
    var
        PrintVisCase: Record "PVS Case";
    begin
        if not PrintVisCase.Get(CaseID) then
            exit;

        PrintVisCase.Validate("Rejection Code", RejectionCode);
        PrintVisCase.Modify();
    end;

    /// <summary>
    /// Updates the milestones of a case
    /// </summary>
    /// <param name="CaseID">The ID of the case to update.</param>
    /// <param name="MilestoneCode">The code of the milestone to complete.</param>
    /// <param name="MilestoneComment">Optional comment to add to the milestone.</param>
    procedure UpdateCaseMilestones(CaseID: Integer; MilestoneCode: Code[20]; MilestoneComment: Text[250])
    var
        JobPlanningUnit: Record "PVS Job Planning Unit";
        EndingDateTime: DateTime;
    begin
        EndingDateTime := CurrentDateTime;

        JobPlanningUnit.SetRange(ID, CaseID);
        JobPlanningUnit.SetRange(Unit, MilestoneCode);
        if JobPlanningUnit.FindSet() then
            repeat
                JobPlanningUnit."End Date" := EndingDateTime.Date;
                JobPlanningUnit.Ending := EndingDateTime;
                JobPlanningUnit.Validate(Completed, true);
                JobPlanningUnit.Modify();
                if (MilestoneComment <> '') then
                    this.SetJobPlanningUnitComment(JobPlanningUnit, MilestoneComment);
            until JobPlanningUnit.Next() = 0;
    end;

    local procedure SetJobPlanningUnitComment(JobPlanningUnit: Record "PVS Job Planning Unit"; Comment: Text[250])
    var
        JobTextDescription: Record "PVS Job Text Description";
        NextEntryNo: Integer;
    begin
        JobTextDescription.SetRange("Table ID", Database::"PVS Job Planning Unit");
        JobTextDescription.SetRange(Code, '');
        JobTextDescription.SetRange(ID, JobPlanningUnit.ID);
        JobTextDescription.SetRange(Job, JobPlanningUnit.Job);
        JobTextDescription.SetRange(Version, JobPlanningUnit."Simulation Version");
        JobTextDescription.SetRange("No.", JobPlanningUnit."Plan ID");
        if JobTextDescription.FindLast() then
            NextEntryNo := JobPlanningUnit."Entry No." + 10000
        else
            NextEntryNo := 10000;

        JobTextDescription."Table ID" := Database::"PVS Job Planning Unit";
        JobTextDescription.Code := '';
        JobTextDescription.ID := JobPlanningUnit.ID;
        JobTextDescription.Job := JobPlanningUnit.Job;
        JobTextDescription.Version := JobPlanningUnit."Simulation Version";
        JobTextDescription."No." := JobPlanningUnit."Plan ID";
        JobTextDescription."Entry No." := NextEntryNo;
        JobTextDescription.Text := Comment;
        JobTextDescription.Insert();
    end;
}