Page 80201 "PVS Sync Log API"
{
    // Example Server Endpoints: http://server.domain.com:port/ServerInstance/api/printvis/multicompany/v2.0

    APIGroup = 'multicompany';
    APIPublisher = 'printvis';
    APIVersion = 'v2.0';
    Caption = 'Sync Log API';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'syncLogEntry';
    EntitySetName = 'syncLogEntries';
    ODataKeyFields = ID;
    PageType = API;
    SourceTable = "PVS Sync Log Entry";
    SourceTableView = where(Status = filter(<> Processed));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Id; Rec.ID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Displays which Table to synchronize';
                }
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(TableNo; Rec."Table No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Displays which Table to synchronize';
                }
                field(Type; TypeInt)
                {
                    ApplicationArea = All;
                }
                field(LogType; LogTypeInt)
                {
                    ApplicationArea = All;
                }
                field(LogField; Rec."Log Field")
                {
                    ApplicationArea = All;
                    ToolTip = 'Displays which Table to synchronize';
                }
                field("RecordID"; NewRecordID)
                {
                    ApplicationArea = All;
                }
                field(OldRecordID; OldRecordID)
                {
                    ApplicationArea = All;
                }
                field(CreatedDateTime; Rec."Created DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Displays which Table to synchronize';
                }
                field(SortingOrder; Rec."Sorting Order")
                {
                    ApplicationArea = All;
                }
                field(Status; StatusInt)
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
                    ToolTip = 'Displays which Table to synchronize';
                }
                field(DestinationBusinessGroup; Rec."Destination Business Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Displays which Table to synchronize';
                }
                field(RecordObject; RecordObject)
                {
                    ApplicationArea = All;
                }
                field(RecordObjectSize; Rec."Record Object Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'Displays which Table to synchronize';
                }
                field(ErrorMessage; ErrorMessage)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetVarsOnAfterGetRecord();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        Base64Convert: Codeunit "Base64 Convert";
        OStream: OutStream;
        t: Text;
    begin
        if NewRecordID <> '' then
            t := PVSBusinessCentralAPI.ConvertValueFromBase64(NewRecordID);
        if not Evaluate(Rec."Record ID", PVSBusinessCentralAPI.ConvertValueFromBase64(NewRecordID)) then
            Error(ErrorRecordID);
        if OldRecordID <> '' then
            if not Evaluate(Rec."Old Record ID", PVSBusinessCentralAPI.ConvertValueFromBase64(OldRecordID)) then
                Error(ErrorOldRecordID);
        if RecordObject <> '' then begin
            Rec."Record Object".CreateOutStream(OStream);
            OStream.WriteText(Base64Convert.FromBase64(RecordObject))
        end;
        if ErrorMessage <> '' then begin
            PVSBlobStorage.FromBase64String(TempBlob, ErrorMessage);
            Rec."Error Message" := TempBlob.Blob;
        end;
        if TypeInt > 0 then
            Rec.Type := TypeInt;
        if StatusInt > 0 then
            Rec.Status := StatusInt;
        if LogTypeInt > 0 then
            Rec."Log Type" := LogTypeInt;
    end;

    var
        TempBlob: Record "PVS TempBlob" temporary;
        PVSBusinessCentralAPI: Codeunit "PVS Business Central API";
        PVSBlobStorage: Codeunit "PVS Blob Storage";
        ErrorMessage: Text;
        NewRecordID: Text;
        OldRecordID: Text;
        RecordObject: Text;
        LogTypeInt: Integer;
        StatusInt: Integer;
        TypeInt: Integer;
        ErrorOldRecordID: label 'Invalid Old Record ID Passed';
        ErrorRecordID: label 'Invalid Record ID Passed';

    local procedure SetVarsOnAfterGetRecord()
    begin
        Clear(NewRecordID);
        Clear(OldRecordID);
        Clear(RecordObject);
        Clear(ErrorMessage);
        Clear(TempBlob);
        if Format(Rec."Record ID") <> '' then
            NewRecordID := PVSBusinessCentralAPI.ConvertValueToBase64(Format(Rec."Record ID"));
        if Format(Rec."Old Record ID") <> '' then
            OldRecordID := PVSBusinessCentralAPI.ConvertValueToBase64(Format(Rec."Old Record ID"));
        if Rec."Record Object".Hasvalue() then begin
            Rec.CalcFields("Record Object");
            TempBlob.Blob := Rec."Record Object";
            RecordObject := PVSBlobStorage.ToBase64String(TempBlob);
        end;
        if Rec."Error Message".Hasvalue() then begin
            Rec.CalcFields("Error Message");
            TempBlob.Blob := Rec."Error Message";
            ErrorMessage := PVSBlobStorage.ToBase64String(TempBlob);
        end;
        TypeInt := Rec.Type;
        StatusInt := Rec.Status;
        LogTypeInt := Rec."Log Type";
    end;
}

