namespace PrintVis.BoldSign.Workflows;

using PrintVis.BoldSign.Documents;

codeunit 80313 "PVS BS Doc. Expired Workflow" implements "PVS BS IDocumentWorkflow"
{
    Access = Internal;

    procedure Execute(var Document: Record "PVS BS Document")
    var
        DocumentWorkflow: Record "PVS BS Document Workflow";
        DocWorkflowMgt: Codeunit "PVS BS Doc. Workflow Mgt.";
    begin
        if Document."Expired Doc. Workflow" = '' then
            exit;

        if Document."Expired Doc. Workflow Status" in [
            Enum::"PVS BS Doc. Workflow Status"::" ",
            Enum::"PVS BS Doc. Workflow Status"::Completed
        ] then
            exit;

        if not DocumentWorkflow.Get(Document."Expired Doc. Workflow") then
            exit;

        if DocumentWorkflow."Rejection Code" <> '' then
            DocWorkflowMgt.UpdateCaseRejectionCode(Document."Case ID", DocumentWorkflow."Rejection Code");

        if DocumentWorkflow."Update Milestone" and (DocumentWorkflow."Milestone to Complete" <> '') then
            DocWorkflowMgt.UpdateCaseMilestones(Document."Case ID", DocumentWorkflow."Milestone to Complete", '');

        if DocumentWorkflow."Update Status" and (DocumentWorkflow."Next Status Code" <> '') then
            DocWorkflowMgt.UpdateCaseStatus(Document."Case ID", DocumentWorkflow."Next Status Code");

        Document."Expired Doc. Workflow Status" := Enum::"PVS BS Doc. Workflow Status"::Completed;
        Document.Modify();
    end;
}