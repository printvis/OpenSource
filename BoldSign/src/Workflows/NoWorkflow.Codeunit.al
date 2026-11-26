namespace PrintVis.BoldSign.Workflows;

using PrintVis.BoldSign.Documents;

codeunit 80309 "PVS BS No Workflow" implements "PVS BS IDocumentWorkflow"
{
    Access = Internal;

    procedure Execute(var Document: Record "PVS BS Document")
    begin
        exit;
    end;
}