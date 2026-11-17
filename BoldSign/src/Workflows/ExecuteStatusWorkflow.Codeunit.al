namespace PrintVis.BoldSign.Workflows;

using PrintVis.BoldSign.Documents;

codeunit 80303 "PVS BS Execute Status Workflow"
{
    Access = Internal;

    /// <summary>
    /// Executes the status workflow for a document.
    /// </summary>
    /// <param name="Document">The document record to process.</param>
    procedure Execute(var Document: Record "PVS BS Document")
    begin
        this.Execute(Document, Document.Status);
    end;

    local procedure Execute(var Document: Record "PVS BS Document"; DocumentAction: Interface "PVS BS IDocumentWorkflow")
    begin
        DocumentAction.Execute(Document);
    end;
}