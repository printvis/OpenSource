namespace PrintVis.BoldSign.Documents;

using PrintVis.BoldSign.Workflows;

enum 80301 "PVS BS Document Status" implements "PVS BS IDocumentWorkflow"
{
    DefaultImplementation = "PVS BS IDocumentWorkflow" = "PVS BS No Workflow";
    Extensible = false;

    value(0; New)
    {
        Caption = 'New';
    }
    value(10; Uploaded)
    {
        Caption = 'Uploaded';
    }
    value(20; "Awaiting Signature")
    {
        Caption = 'Awaiting Signature';
        Implementation = "PVS BS IDocumentWorkflow" = "PVS BS Doc. Sent Workflow";
    }
    value(30; Signed)
    {
        Caption = 'Signed';
        Implementation = "PVS BS IDocumentWorkflow" = "PVS BS Doc. Signed Workflow";
    }
    value(40; Canceled)
    {
        Caption = 'Canceled';
        Implementation = "PVS BS IDocumentWorkflow" = "PVS BS Doc. Declined Workflow";
    }
    value(50; Removed)
    {
        Caption = 'Removed';
    }
    value(60; Error)
    {
        Caption = 'Error';
    }
    value(100; "Expired")
    {
        Caption = 'Expired';
        Implementation = "PVS BS IDocumentWorkflow" = "PVS BS Doc. Expired Workflow";
    }
}
