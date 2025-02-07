Report 80200 "PVS Sync Job Queue Processor"
{
    Caption = 'PrintVis Sync Job Queue Processor';
    ProcessingOnly = true;
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        Commit(); //Roll back to here if Event fail
        OnAfterProcessing();
    end;

    trigger OnPreReport()
    begin
        SyncProcessingManagement.ProcessSyncLog();
    end;

    var
        SyncProcessingManagement: Codeunit "PVS Sync Processing Management";

    [IntegrationEvent(false, false)]
    local procedure OnAfterProcessing()
    begin
    end;
}

