Page 80202 "PVS Sync Log"
{
    ApplicationArea = All;
    Caption = 'PrintVis Sync Log';
    InsertAllowed = false;
    PageType = List;
    SourceTable = "PVS Sync Log Entry";
    SourceTableView = order(descending);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(TableNo; Rec."Table No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays which Table to synchronize';
                }
                field(RecordIDName; Format(Rec."Record ID"))
                {
                    ApplicationArea = All;
                    Caption = 'Record ID';
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(LogType; Rec."Log Type")
                {
                    ApplicationArea = All;
                }
                field(LogField; Rec."Log Field")
                {
                    ApplicationArea = All;
                    ToolTip = 'Displays which Table to synchronize';
                }
                field(CreatedDateTime; Rec."Created DateTime")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays which Table to synchronize';
                }
                field(SortingOrder; Rec."Sorting Order")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(RetriesRemaining; Rec."Retries Remaining")
                {
                    ApplicationArea = All;
                    ToolTip = 'Displays which Table to synchronize';
                }
                field(SourceBusinessGroup; Rec."Source Business Group")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays which Table to synchronize';
                }
                field(DestinationBusinessGroup; Rec."Destination Business Group")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays which Table to synchronize';
                }
                field(RecordObjectSize; Rec."Record Object Size")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays which Table to synchronize';
                }
                field(ErrorMessage; ErrorMessage)
                {
                    ApplicationArea = All;
                    Caption = 'Error Message';
                    Editable = false;
                }
                field(ChangedCompany; Rec.ChangedCompany)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Process)
            {
                ApplicationArea = All;
                Caption = 'Process';
                Image = Start;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Process';

                trigger OnAction()
                var
                    SyncProcessingManagement: Codeunit "PVS Sync Processing Management";
                begin
                    SyncProcessingManagement.ProcessSyncLogEntryManual(Rec);
                end;
            }
            action("Export JSON as TXT")
            {
                ApplicationArea = All;
                Caption = 'Export JSON as TXT';
                Image = Text;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Export JSON as TXT';

                trigger OnAction()
                begin
                    Rec.View_RecordObject();
                end;
            }
            action(Settings)
            {
                ApplicationArea = All;
                Caption = 'Settings';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "PVS Sync Table Setup";
                ToolTip = 'Settings';
            }
            action(ToggleProcessed)
            {
                ApplicationArea = All;
                Caption = 'Show/Hide Processed';
                Image = ToggleBreakpoint;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Show/Hide Processed';

                trigger OnAction()
                begin
                    FilterProcessed(not ShowProcessed);
                end;
            }
            action(ReQueue)
            {
                ApplicationArea = All;
                Caption = 'Re-Queue Selected';
                Image = ResetStatus;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Re-Queue Selected';

                trigger OnAction()
                var
                    SyncLogEntry: Record "PVS Sync Log Entry";
                begin
                    if not Confirm(AreYouSureReQueue, false) then
                        exit;
                    CurrPage.SetSelectionFilter(SyncLogEntry);
                    if SyncLogEntry.FindSet(true) then
                        repeat
                            Clear(SyncLogEntry."Error Message");
                            SyncLogEntry.Status := SyncLogEntry.Status::New;
                            SyncLogEntry.Modify();
                        until SyncLogEntry.Next() = 0;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        GetText();
    end;

    trigger OnAfterGetRecord()
    begin
        GetText();
    end;

    trigger OnOpenPage()
    begin
        FilterProcessed(false);
    end;

    var
        PVSBlobStorage: Codeunit "PVS Blob Storage";
        TypeHelper: Codeunit "Type Helper";
        ErrorMessage: Text;
        ShowProcessed: Boolean;
        AreYouSureReQueue: label 'Are you sure you want to Re-Queue the selected entries?';

    local procedure GetText()
    var
        TempBlob: Record "PVS TempBlob" temporary;
    begin
        ErrorMessage := '';
        if not Rec."Error Message".Hasvalue() then
            exit;

        Rec.CalcFields("Error Message");
        TempBlob.Blob := Rec."Error Message";
        ErrorMessage := PVSBlobStorage.ReadAsText(TempBlob, TypeHelper.NewLine(), Textencoding::UTF8);
    end;

    local procedure FilterProcessed(Toggle: Boolean)
    begin
        ShowProcessed := Toggle;
        if ShowProcessed then
            Rec.SetRange(Status)
        else
            Rec.SetFilter(Status, '<>%1', Rec.Status::Processed);
        if Rec.FindFirst() then;
    end;
}

