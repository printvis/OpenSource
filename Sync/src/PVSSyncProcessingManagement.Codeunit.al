Codeunit 80200 "PVS Sync Processing Management"
{
    TableNo = "PVS Sync Log Entry";

    trigger OnRun()
    begin
        ProcessSyncLogEntry(Rec);
    end;

    var
        SkipFieldListBuffer: Record "Integer" temporary;
        TypeHelper: Codeunit "Type Helper";
        PVSBlobStorage: Codeunit "PVS Blob Storage";
        SyncJsonExchange: Codeunit "PVS Sync Json Exchange.";
        SyncCommunicationMgt: Codeunit "PVS Sync Communication Mgt";
        SyncOAuthCommMgt: Codeunit "PVS Sync OAuth Comm. Mgt.";
        SyncChangeManagement: Codeunit "PVS Sync Change Management";
        Method: Option Get,POST;
        ErrorKeyFields: label 'Too many Key fields for this table. Please contact the Administrator.';
        ErrorNonExistingRecord: label 'Record %1 does not exist.';
        EventNotHandled: label 'Event not handled by any subscriber code. Please contact the Administrator.';
        NoRecordObjectFound: label 'No record data found in Record Object Field. Please contact the Administrator.';

    procedure TestSync()
    begin
    end;

    procedure ProcessSyncLog()
    var
        BusinessGroup: Record "PVS Business Group";
        SyncLogEntry: Record "PVS Sync Log Entry";
        QrySyncLogEntries: Query "PVS Sync Log Entries";
        IsHandled: Boolean;
    begin
        BusinessGroup.SetRange(Company, COMPANYNAME());
        BusinessGroup.FindFirst();

        if not SyncLogEntry.FindLast then
            exit;

        QrySyncLogEntries.SetFilter(EntryNo, '..%1', SyncLogEntry."Entry No.");
        QrySyncLogEntries.SetRange(Status, SyncLogEntry.Status::New);

        // Process Local Source
        QrySyncLogEntries.SetRange(SourceBusinessGroup, BusinessGroup.Code);
        ProcessSyncLogEntries(QrySyncLogEntries);

        // Process Local Destination
        QrySyncLogEntries.SetRange(SourceBusinessGroup);
        QrySyncLogEntries.SetRange(DestinationBusinessGroup, BusinessGroup.Code);
        ProcessSyncLogEntries(QrySyncLogEntries);
        //<< OGPTI Performance & Locking improvements

        SyncLogEntry.Reset;
        SyncLogEntry.SetRange(Status, SyncLogEntry.Status::Processed);
        SyncLogEntry.SetFilter("Created DateTime", '..%1', CreateDateTime(CalcDate('<-2D>', Today), Time));
        OnBeforeDeleteSyncRecords(SyncLogEntry, IsHandled);
        if not SyncLogEntry.IsEmpty then
            SyncLogEntry.DeleteAll();
    end;

    procedure CompressSyncLogEntries();
    var
        SyncLogEntry: Record "PVS Sync Log Entry";
        TempSyncLogEntry: Record "PVS Sync Log Entry" temporary;
        SyncTableSetup: Record "PVS Sync Table Setup";
        TempSkipTables: Record Integer temporary;
        SyncChangeManagement: Codeunit "PVS Sync Change Management";
        Skip: Boolean;
    begin
        SyncLogEntry.Reset;
        SyncLogEntry.SetCurrentKey("Entry No.");
        SyncLogEntry.Ascending(false);
        SyncLogEntry.SetRange(Status, SyncLogEntry.Status::New);
        if SyncLogEntry.FindSet(false) then
            Repeat
                if not TempSkipTables.Get(SyncLogEntry."Table No.") then begin //-- OGPTI Performance & Locking improvements
                    TempSyncLogEntry.SetRange("Record ID", SyncLogEntry."Record ID");
                    TempSyncLogEntry.SetRange("Entry No.", SyncLogEntry."Entry No.");
                    TempSyncLogEntry.SetRange("Destination Business Group", SyncLogEntry."Destination Business Group");
                    if TempSyncLogEntry.IsEmpty then begin
                        Skip := false;
                        if SyncTableSetup.Get(SyncLogEntry."Table No.") then begin
                            if SyncTableSetup."Do not Compress Sync Log" then begin
                                Skip := true;
                                TempSkipTables.Number := SyncLogEntry."Table No.";
                                TempSkipTables.Insert;
                            end;
                        end;
                        if not Skip then begin
                            TempSyncLogEntry := SyncLogEntry;
                            if TempSyncLogEntry.Insert() then;
                        end;
                    end;
                end;
            until SyncLogEntry.Next() = 0;
        TempSyncLogEntry.Reset();

        if TempSyncLogEntry.FindSet() then
            repeat
                SyncChangeManagement.CompressLines(TempSyncLogEntry."Record ID", TempSyncLogEntry."Entry No.", TempSyncLogEntry."Destination Business Group");
            until TempSyncLogEntry.Next() = 0;
        Commit();
    end;

    procedure ProcessSyncLogEntryManual(SyncLogEntry: Record "PVS Sync Log Entry")
    var
        QrySyncLogEntries: Query "PVS Sync Log Entries";
    begin
        QrySyncLogEntries.SetRange(EntryNo, SyncLogEntry."Entry No.");
        ProcessSyncLogEntries(QrySyncLogEntries);
    end;

    local procedure ProcessSyncLogEntries(var QrySyncLogEntries: Query "PVS Sync Log Entries")
    var
        BusinessGroup: Record "PVS Business Group";
        SyncLogEntry: Record "PVS Sync Log Entry";
        TempBlob: Record "PVS TempBlob" temporary;
        SyncProcessingManagement: Codeunit "PVS Sync Processing Management";
    begin
        SyncChangeManagement.SetSkipTracking(true);
        QrySyncLogEntries.Open;
        while QrySyncLogEntries.Read do begin
            SyncLogEntry.LockTable;
            SyncLogEntry.Get(QrySyncLogEntries.EntryNo);
            SyncLogEntry.Status := SyncLogEntry.Status::Processing;
            SyncLogEntry."Last Process DateTime" := CurrentDateTime;
            Clear(SyncLogEntry."Error Message");
            SyncLogEntry.Modify;

            Commit;
            ClearLastError;

            if not SyncProcessingManagement.Run(SyncLogEntry) then begin // Call OnRun
                SyncLogEntry."Retries Remaining" -= 1;
                if SyncLogEntry.Type = SyncLogEntry.Type::Delete then
                    SyncLogEntry."Retries Remaining" := 0;
                if SyncLogEntry."Retries Remaining" < 1 then begin
                    SyncLogEntry."Retries Remaining" := 0;
                    SyncLogEntry.Status := SyncLogEntry.Status::Error;
                end else
                    SyncLogEntry.Status := SyncLogEntry.Status::New;

                PVSBlobStorage.WriteAsText(TempBlob, GetLastErrorText(), Textencoding::UTF8);
                SyncLogEntry."Error Message" := TempBlob.Blob;
                SyncLogEntry.Modify;
            end else begin
                SyncLogEntry.Status := SyncLogEntry.Status::Processed;
                SyncLogEntry.Modify;
            end;
        end;

        SyncChangeManagement.SetSkipTracking(false);
    end;

    local procedure ProcessSyncLogEntry(var SyncLogEntry: Record "PVS Sync Log Entry")
    var
        BusinessGroup: Record "PVS Business Group";
    begin
        SyncLogEntry.LockTable;
        SyncLogEntry.Get(SyncLogEntry."Entry No.");

        BusinessGroup.Get(SyncLogEntry."Destination Business Group");

        if BusinessGroup.Company = COMPANYNAME() then
            ProcessSyncLogEntryLocal(SyncLogEntry)
        else
            ProcessSyncLogEntryRemote(SyncLogEntry, BusinessGroup);
    end;

    local procedure ProcessSyncLogEntryRemote(var SyncLogEntry: Record "PVS Sync Log Entry"; BusinessGroup: Record "PVS Business Group")
    begin
        if BusinessGroup."Company in Same Database" then
            if ProcessSyncLogEntryRemoteChangeCompany(SyncLogEntry, BusinessGroup.Company) then
                exit;

        BusinessGroup.TestField("API Server FQDN");
        BusinessGroup.TestField("API Server Instance");
        BusinessGroup.TestField("API Service Name");
        BusinessGroup.TestField("API Connection Verified");

        if BusinessGroup."PVS Enable OAuth2" then
            ProcessSyncLogEntryWithOAuth(SyncLogEntry, BusinessGroup)
        else
            ProcessSyncLogEntryWithoutOAuth(SyncLogEntry, BusinessGroup);
    end;

    local procedure ProcessSyncLogEntryWithoutOAuth(var SyncLogEntry: Record "PVS Sync Log Entry"; BusinessGroup: Record "PVS Business Group")
    var
        JsonBody: Text;
        URL: Text;
    begin
        JsonBody := SyncJsonExchange.ConvertSyncLogEntryToApiEntity(SyncLogEntry);

        SyncCommunicationMgt.SetApiTargetCompany(BusinessGroup);
        URL := SyncCommunicationMgt.GetFQApiUrl(BusinessGroup."API Service Name");
        SyncCommunicationMgt.InitializeApi(URL);
        SyncCommunicationMgt.SetApiAuthentication(BusinessGroup."API User Name", BusinessGroup.GetPassword(), BusinessGroup."API Server uses Windows Auth");
        SyncCommunicationMgt.SetApiMethod(Method::POST, JsonBody);
        SyncCommunicationMgt.TryCallApi();
    end;

    local procedure ProcessSyncLogEntryWithOAuth(var SyncLogEntry: Record "PVS Sync Log Entry"; BusinessGroup: Record "PVS Business Group")
    var
        JsonBody: Text;
        URL: Text;
        ClientSecretMissingErr: Label 'You have to specify client secret for Business Group %1';
    begin
        BusinessGroup.TestField("PVS Client Id");
        BusinessGroup.TestField("PVS Authorization Endpoint");
        BusinessGroup.TestField("PVS Redirect Url");
        if not IsolatedStorage.Contains(BusinessGroup."PVS Client Secret") then
            Error(ClientSecretMissingErr, BusinessGroup.Code);

        JsonBody := SyncJsonExchange.ConvertSyncLogEntryToApiEntity(SyncLogEntry);

        SyncOAuthCommMgt.AcquireTokenFromCache(BusinessGroup);

        SyncOAuthCommMgt.SetApiTargetCompany(BusinessGroup);
        URL := SyncOAuthCommMgt.GetFQApiUrl(BusinessGroup."API Service Name");
        SyncOAuthCommMgt.InitializeApi(URL);
        SyncOAuthCommMgt.SetApiAuthentication(BusinessGroup);
        SyncOAuthCommMgt.SetApiMethod(Method::POST, JsonBody);
        SyncOAuthCommMgt.TryCallApi();
    end;

    procedure ProcessAllSyncLogEntriesChangeCompany()
    var
        PVSSyncLogEntry: Record "PVS Sync Log Entry";
        PVSBusinessGroup: Record "PVS Business Group";
        PVSBusinessGroup2: Record "PVS Business Group";
        QrySyncLogEntries: Query "PVS Sync Log Entries";
    begin
        PVSBusinessGroup2.SetRange(Company, CompanyName);
        PVSBusinessGroup2.FindFirst;
        PVSBusinessGroup.SetRange("Company in Same Database", true);
        PVSBusinessGroup.SetFilter(Code, '<>%1', PVSBusinessGroup2.Code);
        if PVSBusinessGroup.FindSet(false) then
            repeat
                QrySyncLogEntries.SetRange(Status, PVSSyncLogEntry.Status::New);
                QrySyncLogEntries.SetRange(DestinationBusinessGroup, PVSBusinessGroup.Code);
                if QrySyncLogEntries.Open then
                    while QrySyncLogEntries.Read do begin
                        PVSSyncLogEntry.LockTable;
                        PVSSyncLogEntry.Get(QrySyncLogEntries.EntryNo);
                        if ProcessSyncLogEntryRemoteChangeCompany(PVSSyncLogEntry, PVSBusinessGroup.Company) then
                            PVSSyncLogEntry.Modify;
                    end;
                Commit();
            until PVSBusinessGroup.Next() = 0;
    end;

    local procedure ProcessSyncLogEntryRemoteChangeCompany(var SyncLogEntry: Record "PVS Sync Log Entry"; BusinessGroup: Text): Boolean
    var
        PVSSyncLogEntryChangedCompany: Record "PVS Sync Log Entry";
    begin
        if not PVSSyncLogEntryChangedCompany.CHANGECOMPANY(BusinessGroup) then
            exit(false);
        SyncLogEntry.CalcFields("Record Object");
        PVSSyncLogEntryChangedCompany.TransferFields(SyncLogEntry);
        PVSSyncLogEntryChangedCompany."Entry No." := 0;
        PVSSyncLogEntryChangedCompany.Status := PVSSyncLogEntryChangedCompany.Status::New;
        PVSSyncLogEntryChangedCompany.Insert(true);
        CLEAR(PVSSyncLogEntryChangedCompany);
        SyncLogEntry.ChangedCompany := true;
        SyncLogEntry.Status := SyncLogEntry.Status::Processed;
        exit(true);
    end;

    local procedure ProcessSyncLogEntryLocal(var SyncLogEntry: Record "PVS Sync Log Entry")
    var
        TempBlob: Record "PVS TempBlob" temporary;
        RecID: RecordID;
        NewRecRef: RecordRef;
        RecRef: RecordRef;
        KeyRf: KeyRef;
        JsonRecord: Text;
        IsHandled: Boolean;
        NewRecord: Boolean;
    begin
        if SyncLogEntry.Type = SyncLogEntry.Type::Special then begin
            OnProcessSyncLogEntrySpecial(SyncLogEntry, IsHandled);
            if not IsHandled then
                Error(EventNotHandled);
            exit;
        end;

        if SyncChangeManagement.IsSpecialTable(SyncLogEntry."Table No.") then begin
            OnProcessSyncLogEntryForSpecialTable(SyncLogEntry, IsHandled);
            if IsHandled then
                exit;
        end;

        case SyncLogEntry.Type of
            SyncLogEntry.Type::Rename:
                begin
                    if not RecRef.Get(SyncLogEntry."Old Record ID") then
                        Error(ErrorNonExistingRecord, SyncLogEntry."Old Record ID");

                    RecID := SyncLogEntry."Record ID";
                    NewRecRef := RecID.GetRecord();
                    KeyRf := NewRecRef.KeyIndex(1);
                    case KeyRf.FieldCount() of
                        1:
                            RecRef.Rename(KeyRf.FieldIndex(1));
                        2:
                            RecRef.Rename(KeyRf.FieldIndex(1), KeyRf.FieldIndex(2));
                        3:
                            RecRef.Rename(KeyRf.FieldIndex(1), KeyRf.FieldIndex(2), KeyRf.FieldIndex(3));
                        4:
                            RecRef.Rename(KeyRf.FieldIndex(1), KeyRf.FieldIndex(2), KeyRf.FieldIndex(3), KeyRf.FieldIndex(4));
                        5:
                            RecRef.Rename(KeyRf.FieldIndex(1), KeyRf.FieldIndex(2), KeyRf.FieldIndex(3), KeyRf.FieldIndex(4), KeyRf.FieldIndex(5));
                        6:
                            RecRef.Rename(KeyRf.FieldIndex(1), KeyRf.FieldIndex(2), KeyRf.FieldIndex(3), KeyRf.FieldIndex(4), KeyRf.FieldIndex(5),
                                          KeyRf.FieldIndex(6));
                        7:
                            RecRef.Rename(KeyRf.FieldIndex(1), KeyRf.FieldIndex(2), KeyRf.FieldIndex(3), KeyRf.FieldIndex(4), KeyRf.FieldIndex(5),
                                          KeyRf.FieldIndex(6), KeyRf.FieldIndex(7));
                        8:
                            RecRef.Rename(KeyRf.FieldIndex(1), KeyRf.FieldIndex(2), KeyRf.FieldIndex(3), KeyRf.FieldIndex(4), KeyRf.FieldIndex(5),
                                          KeyRf.FieldIndex(6), KeyRf.FieldIndex(7), KeyRf.FieldIndex(8));
                        9:
                            RecRef.Rename(KeyRf.FieldIndex(1), KeyRf.FieldIndex(2), KeyRf.FieldIndex(3), KeyRf.FieldIndex(4), KeyRf.FieldIndex(5),
                                          KeyRf.FieldIndex(6), KeyRf.FieldIndex(7), KeyRf.FieldIndex(8), KeyRf.FieldIndex(9));
                        10:
                            RecRef.Rename(KeyRf.FieldIndex(1), KeyRf.FieldIndex(2), KeyRf.FieldIndex(3), KeyRf.FieldIndex(4), KeyRf.FieldIndex(5),
                                          KeyRf.FieldIndex(6), KeyRf.FieldIndex(7), KeyRf.FieldIndex(8), KeyRf.FieldIndex(9), KeyRf.FieldIndex(10));
                        11:
                            RecRef.Rename(KeyRf.FieldIndex(1), KeyRf.FieldIndex(2), KeyRf.FieldIndex(3), KeyRf.FieldIndex(4), KeyRf.FieldIndex(5),
                                          KeyRf.FieldIndex(6), KeyRf.FieldIndex(7), KeyRf.FieldIndex(8), KeyRf.FieldIndex(9), KeyRf.FieldIndex(10),
                                          KeyRf.FieldIndex(11));
                        12:
                            RecRef.Rename(KeyRf.FieldIndex(1), KeyRf.FieldIndex(2), KeyRf.FieldIndex(3), KeyRf.FieldIndex(4), KeyRf.FieldIndex(5),
                                          KeyRf.FieldIndex(6), KeyRf.FieldIndex(7), KeyRf.FieldIndex(8), KeyRf.FieldIndex(9), KeyRf.FieldIndex(10),
                                          KeyRf.FieldIndex(11), KeyRf.FieldIndex(12));
                        else
                            Error(ErrorKeyFields);
                    end;
                end;
            SyncLogEntry.Type::Delete:
                begin
                    if not RecRef.Get(SyncLogEntry."Record ID") then
                        Error(ErrorNonExistingRecord, SyncLogEntry."Record ID");
                    RecRef.Delete(SyncChangeManagement.IsValidateInsertModifyTable(SyncLogEntry."Table No."));
                end;
            SyncLogEntry.Type::Modify,
            SyncLogEntry.Type::Insert:
                begin
                    if not RecRef.Get(SyncLogEntry."Record ID") then
                        NewRecord := true;
                    if not SyncLogEntry."Record Object".Hasvalue() then
                        Error(NoRecordObjectFound);

                    SyncLogEntry.CalcFields("Record Object");
                    TempBlob.Blob := SyncLogEntry."Record Object";
                    JsonRecord := PVSBlobStorage.ReadAsText(TempBlob, TypeHelper.NewLine(), Textencoding::UTF8);

                    SyncJsonExchange.ConvertJsonStringToRecord(NewRecRef, JsonRecord, SyncLogEntry."Table No.", true, true);

                    if NewRecord then begin
                        RecRef.Close();
                        RecRef.Open(SyncLogEntry."Table No.");
                        RecRef.Init();
                    end;

                    if SyncLogEntry."Table No." IN [2000000183, 2000000184] then begin
                        if NOT NewRecord then
                            RecRef.DELETE(TRUE);
                        NewRecord := TRUE;
                    end;

                    CopyFields(RecRef, NewRecRef, NewRecord);
                    OnBeforeInsertModifyRecord(RecRef, SyncLogEntry);

                    if NewRecord then begin
                        //RecRef.INSERT(TRUE) // <002>
                        if not RecRef.Insert(SyncChangeManagement.IsValidateInsertModifyTable(SyncLogEntry."Table No.")) then
                            RecRef.Modify(SyncChangeManagement.IsValidateInsertModifyTable(SyncLogEntry."Table No."));
                    end else begin
                        //RecRef.MODifY(TRUE);  // <002>
                        if not RecRef.Modify(SyncChangeManagement.IsValidateInsertModifyTable(SyncLogEntry."Table No.")) then
                            RecRef.Insert(SyncChangeManagement.IsValidateInsertModifyTable(SyncLogEntry."Table No."));
                    end;
                end;
        end;
    end;

    local procedure IsKeyField(var RecRef: RecordRef; var FldRef: FieldRef): Boolean
    var
        KeyFldRef: FieldRef;
        KeyRf: KeyRef;
        i: Integer;
    begin
        KeyRf := RecRef.KeyIndex(1);
        for i := 1 to KeyRf.FieldCount() do begin
            KeyFldRef := KeyRf.FieldIndex(i);
            if KeyFldRef.Number() = FldRef.Number() then
                exit(true);
        end;
    end;

    procedure AddToSkipFieldList(FieldNumber: Integer; InitializeList: Boolean)
    begin
        if InitializeList then begin
            SkipFieldListBuffer.Reset();
            SkipFieldListBuffer.DeleteAll();
        end;
        if not IsInSkipFieldList(FieldNumber) then begin
            SkipFieldListBuffer.Init();
            SkipFieldListBuffer.Number := FieldNumber;
            SkipFieldListBuffer.Insert();
        end;
    end;

    local procedure IsInSkipFieldList(FieldNumber: Integer): Boolean
    begin
        exit(SkipFieldListBuffer.Get(FieldNumber));
    end;

    procedure CopyFields(var RecRef: RecordRef; var NewRecRef: RecordRef; NewRec: Boolean)
    var
        SyncFieldSetup: Record "PVS Sync Field Setup";
        SyncFieldMapping: Record "PVS Sync Field Mapping";
        "Field": Record "Field";
        FldRef: FieldRef;
        NewFldRef: FieldRef;
        DateValue: Date;
        DateTimeValue: DateTime;
        TimeValue: Time;
        GuidValue: Guid;
        DecimalValue: Decimal;
        BigIntegerValue: BigInteger;
        IntegerValue: Integer;
        OverWriteField: Boolean;
        SkipField: Boolean;
    begin
        Field.SetRange(TableNo, RecRef.Number());
        Field.SetRange("No.", 0, 2000000000 - 1);
        Field.SetFilter(ObsoleteState, '<>%1', Field.Obsoletestate::Removed);
        Field.SetRange(Class, Field.Class::Normal);
        if Field.FindSet(false) then
            repeat
                FldRef := RecRef.Field(Field."No.");
                if NewRec then
                    SkipField := false
                else
                    SkipField := IsKeyField(RecRef, FldRef);

                if (not SkipField) and (not IsInSkipFieldList(Field."No.")) then begin
                    NewFldRef := NewRecRef.Field(Field."No.");
                    if Lowercase(Format(FldRef.Type())) = 'blob' then begin
                        FldRef.CalcField();
                        if not NewRecRef.IsTemporary() then
                            NewFldRef.CalcField();
                    end;
                    if FldRef.Value() <> NewFldRef.Value() then begin
                        if not SyncFieldSetup.Get(Field.TableNo, Field."No.") then
                            SyncFieldSetup."Sync Mode" := SyncFieldSetup."sync mode"::ForceSync;
                        case SyncFieldSetup."Sync Mode" of
                            SyncFieldSetup."sync mode"::ForceSync:
                                FldRef.Value := NewFldRef.Value();
                            SyncFieldSetup."sync mode"::SkipIfNotEmpty:
                                begin
                                    case Lowercase(Format(FldRef.Type())) of
                                        'guid':
                                            begin
                                                GuidValue := FldRef.Value();
                                                OverWriteField := IsNullGuid(GuidValue);
                                            end;
                                        'option':
                                            begin
                                                IntegerValue := FldRef.Value();
                                                OverWriteField := IntegerValue = 0;
                                            end;
                                        'datetime':
                                            begin
                                                DateTimeValue := FldRef.Value();
                                                OverWriteField := DateTimeValue = 0DT;
                                            end;
                                        'date':
                                            begin
                                                DateValue := FldRef.Value();
                                                OverWriteField := DateValue = 0D;
                                            end;
                                        'time':
                                            begin
                                                TimeValue := FldRef.Value();
                                                OverWriteField := TimeValue = 0T;
                                            end;
                                        'boolean':
                                            OverWriteField := true;
                                        'integer', 'biginteger':
                                            begin
                                                BigIntegerValue := FldRef.Value();
                                                OverWriteField := BigIntegerValue = 0;
                                            end;
                                        'decimal':
                                            begin
                                                DecimalValue := FldRef.Value();
                                                OverWriteField := DecimalValue = 0;
                                            end;
                                        'media', 'mediaset':
                                            begin
                                                OverWriteField := TRUE;
                                            end;
                                        else
                                            OverWriteField := Format(FldRef.Value()) = '';
                                    end;
                                    if OverWriteField then
                                        FldRef.Value := NewFldRef.Value();
                                end;
                        end;
                        if SyncFieldSetup."Validate Field" = SyncFieldSetup."validate field"::Yes then
                            FldRef.Validate();
                    end;
                end;
            until Field.Next() = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnProcessSyncLogEntrySpecial(var SyncLogEntry: Record "PVS Sync Log Entry"; var IsHandled: Boolean)
    begin
        // Event to process special instances
    end;

    [IntegrationEvent(false, false)]
    local procedure OnProcessSyncLogEntryForSpecialTable(var SyncLogEntry: Record "PVS Sync Log Entry"; var IsHandled: Boolean)
    begin
        // Event to process special tables
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertModifyRecord(var RecRef: RecordRef; SyncLogEntry: Record "PVS Sync Log Entry");
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDeleteSyncRecords(var SyncLogEntry: Record "PVS Sync Log Entry"; var IsHandled: Boolean)
    begin
    end;
}

