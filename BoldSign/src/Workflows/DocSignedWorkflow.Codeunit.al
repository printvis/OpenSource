namespace PrintVis.BoldSign.Workflows;

using PrintVis.BoldSign.Documents;

codeunit 80312 "PVS BS Doc. Signed Workflow" implements "PVS BS IDocumentWorkflow"
{
    Access = Internal;

    procedure Execute(var Document: Record "PVS BS Document")
    var
        DocumentAction: Record "PVS BS Document Workflow";
        DocWorkflowMgt: Codeunit "PVS BS Doc. Workflow Mgt.";
        BoldSignSignedLbl: Label 'BoldSign Signed';
        MilestoneComment: Text[250];
    begin
        if Document."Signed Doc. Workflow" = '' then
            exit;

        if Document."Signed Doc. Workflow Status" in [
            Enum::"PVS BS Doc. Workflow Status"::" ",
            Enum::"PVS BS Doc. Workflow Status"::Completed
        ] then
            exit;

        if not DocumentAction.Get(Document."Signed Doc. Workflow") then
            exit;

        MilestoneComment := DocumentAction."Milestone Comment";
        if MilestoneComment = '' then
            MilestoneComment := BoldSignSignedLbl;

        if DocumentAction."Update Milestone" and (DocumentAction."Milestone to Complete" <> '') then
            DocWorkflowMgt.UpdateCaseMilestones(Document."Case ID", DocumentAction."Milestone to Complete", MilestoneComment);

        if DocumentAction."Update Status" and (DocumentAction."Next Status Code" <> '') then
            DocWorkflowMgt.UpdateCaseStatus(Document."Case ID", DocumentAction."Next Status Code");

        Document."Signed Doc. Workflow Status" := Enum::"PVS BS Doc. Workflow Status"::Completed;
        Document.Modify();
    end;
}