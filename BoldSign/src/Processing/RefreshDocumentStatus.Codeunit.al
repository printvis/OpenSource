namespace PrintVis.BoldSign.Processing;

using PrintVis.BoldSign.Documents;
using PrintVis.BoldSign.Integration.Services;

codeunit 80315 "PVS BS Refresh Document Status"
{
    Access = Internal;
    TableNo = "PVS BS Document";

    trigger OnRun()
    var
        Document: Record "PVS BS Document";
        IntegrationService: Codeunit "PVS BS Integration Service";
    begin
        Document.Copy(Rec);
        IntegrationService.GetSignatureProcessStatus(Document);
        Rec := Document;
        Commit();
    end;
}