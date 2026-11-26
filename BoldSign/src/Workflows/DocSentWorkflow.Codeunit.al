namespace PrintVis.BoldSign.Workflows;

using PrintVis.BoldSign.Documents;

codeunit 80311 "PVS BS Doc. Sent Workflow" implements "PVS BS IDocumentWorkflow"
{
    Access = Internal;

    procedure Execute(var Document: Record "PVS BS Document")
    var
        DocumentWorkflow: Record "PVS BS Document Workflow";
        DocWorkflowMgt: Codeunit "PVS BS Doc. Workflow Mgt.";
    begin
        if Document."Sent Doc. Workflow" = '' then
            exit;

        if Document."Sent Doc. Workflow Status" in [
            Enum::"PVS BS Doc. Workflow Status"::" ",
            Enum::"PVS BS Doc. Workflow Status"::Completed
        ] then
            exit;

        if not DocumentWorkflow.Get(Document."Sent Doc. Workflow") then
            exit;

        if DocumentWorkflow."Update Milestone" and (DocumentWorkflow."Milestone to Complete" <> '') then
            DocWorkflowMgt.UpdateCaseMilestones(Document."Case ID", DocumentWorkflow."Milestone to Complete", '');

        if DocumentWorkflow."Update Status" and (DocumentWorkflow."Next Status Code" <> '') then
            DocWorkflowMgt.UpdateCaseStatus(Document."Case ID", DocumentWorkflow."Next Status Code");

        Document."Sent Doc. Workflow Status" := Enum::"PVS BS Doc. Workflow Status"::Completed;
        Document.Modify();
    end;
}