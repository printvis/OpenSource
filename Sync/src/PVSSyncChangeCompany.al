Codeunit 80206 "PVS Sync Change Company"
{
    trigger OnRun()
    begin
        SyncProcessingManagement.ProcessAllSyncLogEntriesChangeCompany;
    end;

    var
        SyncProcessingManagement: Codeunit "PVS Sync Processing Management";
}
