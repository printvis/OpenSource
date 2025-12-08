codeunit 80279 "OS Copy Price Method"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Copy Management", 'OnAfterCopyCompleteJob', '', true, true)]
    local procedure OnAfterCopyCompleteJob(var in_From_JobRec: Record "PVS Job"; var in_To_JobRec: Record "PVS Job"; in_Is_Template_Copy: Boolean)
    begin
        in_To_JobRec.Validate("Price Method", in_To_JobRec."Price Method"::Calculated);
        in_To_JobRec.Modify(true);
    end;
}