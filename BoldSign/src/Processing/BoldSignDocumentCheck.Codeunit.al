namespace PrintVis.BoldSign.Processing;

using System.Threading;
using PrintVis.BoldSign.Documents;
using PrintVis.BoldSign.Configuration;

codeunit 80308 "PVS BS BoldSign Document Check"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        Document: Record "PVS BS Document";
        ActivityLogMgt: Codeunit "PVS BS Activity Log Mgt.";
        SignatureStatusActivityDescriptionLbl: Label 'Signature Status Check';
        SignatureStatusFailedLbl: Label 'Failed to check signature status. Error: %1', Comment = '%1 = Error Message';
    begin
        Document.SetRange(Status, Enum::"PVS BS Document Status"::"Awaiting Signature");
        Document.SetFilter("Document ID", '<>%1', '00000000-0000-0000-0000-000000000000');
        if not Document.FindSet() then
            exit;

        repeat
            // Sleep added to avoid hitting API limits
            Sleep(550);
            if not Codeunit.Run(Codeunit::"PVS BS Refresh Document Status", Document) then
                ActivityLogMgt.LogFailure(Document, SignatureStatusActivityDescriptionLbl, StrSubstNo(SignatureStatusFailedLbl, GetLastErrorText()));
        until Document.Next() = 0;
    end;

}