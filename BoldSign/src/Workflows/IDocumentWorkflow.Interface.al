namespace PrintVis.BoldSign.Workflows;

using PrintVis.BoldSign.Documents;

interface "PVS BS IDocumentWorkflow"
{
    Access = Internal;

    /// <summary>
    /// Executes the workflow action for a document.
    /// </summary>
    /// <param name="Document">The document record to process.</param>
    procedure Execute(var Document: Record "PVS BS Document")
}