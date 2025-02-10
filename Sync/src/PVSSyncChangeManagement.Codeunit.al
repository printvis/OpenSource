Codeunit 80205 "PVS Sync Change Management"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        BusinessGroupTemp: Record "PVS Business Group" temporary;
        SyncTableSetupTemp: Record "PVS Sync Table Setup" temporary;
        PVSBlobStorage: Codeunit "PVS Blob Storage";
        SyncJsonExchange: Codeunit "PVS Sync Json Exchange.";
        SourceBusinessGroupCode: Code[20];
        LogType: Option Insert,Modify,Rename,Delete,Special;
        Initialized: Boolean;
        IsMasterCompany: Boolean;
        SkipTracking: Boolean;
        CacheWarning: label 'Beware that changes will not be activated through all clients until they reconnect';

    local procedure AddRecordToSyncLogTable(var RecRef: RecordRef; var xRecRef: RecordRef; LogTypeOpt: Option)
    var
        FldRef: FieldRef;
        xFldRef: FieldRef;
        i: Integer;
        IsHandled: Boolean;
        ProcessTable: Boolean;
        ChangeExists: Boolean;
    begin
        if RecRef.Number > 2000000000 - 1 then
            exit;

        if SkipTracking then
            exit;

        if RecRef.IsTemporary() then
            exit;

        LogType := LogTypeOpt;

        if LogType = Logtype::Insert then
            if xRecRef.Get(RecRef.RecordId()) then
                exit;

        OnAddRecordToSyncLogTable(RecRef, LogTypeOpt, ProcessTable, IsHandled);
        if IsHandled then
            if not ProcessTable then
                exit;

        Initialize();

        if not TableSetupForSync(RecRef.Number()) then
            exit;

        BusinessGroupTemp.Reset();
        case SyncTableSetupTemp."Sync Direction" of
            SyncTableSetupTemp."sync direction"::LocalToMaster:
                if not IsMasterCompany then
                    BusinessGroupTemp.SetRange("Master Company", true);
            SyncTableSetupTemp."sync direction"::MasterToLocal:
                if IsMasterCompany then
                    BusinessGroupTemp.SetRange("Master Company", false);
            SyncTableSetupTemp."sync direction"::AllBusinessGroup:
                if IsMasterCompany then
                    BusinessGroupTemp.SetRange("Master Company", false)
                else
                    BusinessGroupTemp.SetFilter(Company, '<>%1', COMPANYNAME());
        end;

        if BusinessGroupTemp.IsEmpty() then
            exit;

        if LogType = Logtype::Modify then
            if not xRecRef.Get(RecRef.RecordId()) then
                exit;

        if LogType = Logtype::Modify then begin
            if not xRecRef.Get(RecRef.RecordId()) then
                exit;
            ChangeExists := false;
            for i := 1 to RecRef.FieldCount() do begin
                FldRef := RecRef.FieldIndex(i);
                if FldRef.Number > 2000000000 then
                    break;

                xFldRef := xRecRef.FieldIndex(i);
                if Format(FldRef.CLASS()) = 'Normal' then
                    if Format(FldRef.Value()) <> Format(xFldRef.Value()) then begin
                        ChangeExists := true;
                        break;
                    end;
            end;
            if not ChangeExists then
                exit;
        end;

        if BusinessGroupTemp.FindSet(false) then
            repeat
                AddRecordForBusinessGroup(RecRef, xRecRef, BusinessGroupTemp.Code, LogType);
            until BusinessGroupTemp.Next() = 0;

        if LogType in [Logtype::Insert, Logtype::Modify] then
            CheckForMediaFields(RecRef, xRecRef, BusinessGroupTemp);
    end;

    local procedure CheckForMediaFields(var RecRef: RecordRef; var xRecRef: RecordRef; var BusinessGroupTemp: Record "PVS Business Group")
    var
        "Field": Record "Field";
    begin
        exit;

        Field.SetRange(TableNo, RecRef.Number());
        Field.SetFilter(ObsoleteState, '<>%1', Field.Obsoletestate::Removed);
        Field.SetRange(Class, Field.Class::Normal);
        Field.SetFilter(Type, '%1|%2', Field.Type::Media, Field.Type::MediaSet);
        if Field.FindSet(false) then
            repeat
                case Field.Type of
                    Field.Type::Media:
                        CheckMediaField(RecRef, xRecRef, BusinessGroupTemp, Field."No.");
                    Field.Type::MediaSet:
                        CheckMediasetField(RecRef, xRecRef, BusinessGroupTemp, Field."No.");
                end;
            until Field.Next() = 0;
    end;

    local procedure CheckMediaField(var TargetRecordRef: RecordRef; var SourceRecordRef: RecordRef; var BusinessGroupTemp: Record "PVS Business Group"; TargetFieldNo: Integer)
    var
        TenantMedia: Record "Tenant Media";
        xRecRef: RecordRef;
        SourceFieldRef: FieldRef;
        TargetFieldRef: FieldRef;
        SourceGuidValue: Guid;
        TargetGuidValue: Guid;
    begin
        exit;
        if SourceRecordRef.Number() > 0 then begin
            SourceFieldRef := SourceRecordRef.Field(TargetFieldNo);
            SourceGuidValue := SourceFieldRef.Value();
        end else
            Clear(SourceGuidValue);

        TargetFieldRef := TargetRecordRef.Field(TargetFieldNo);
        TargetGuidValue := TargetFieldRef.Value();

        if SourceGuidValue <> TargetGuidValue then begin
            TenantMedia.Get(TargetGuidValue);
            if BusinessGroupTemp.FindSet(false) then
                repeat
                    AddMediaRecordForBusinessGroup(TenantMedia, TargetRecordRef, TargetFieldNo, BusinessGroupTemp.Code);
                until BusinessGroupTemp.Next() = 0;
        end;
    end;

    local procedure CheckMediasetField(var TargetRecordRef: RecordRef; var SourceRecordRef: RecordRef; var BusinessGroupTemp: Record "PVS Business Group"; TargetFieldNo: Integer)
    var
        TenantMediaSet: Record "Tenant Media Set";
        TenantMedia: Record "Tenant Media";
        xRecRef: RecordRef;
        SourceFieldRef: FieldRef;
        TargetFieldRef: FieldRef;
        MediaGuid: Guid;
        SourceGuidValue: Guid;
        TargetGuidValue: Guid;
    begin
        if SourceRecordRef.Number() > 0 then begin
            SourceFieldRef := SourceRecordRef.Field(TargetFieldNo);
            SourceGuidValue := SourceFieldRef.Value();
        end else
            Clear(SourceGuidValue);

        TargetFieldRef := TargetRecordRef.Field(TargetFieldNo);
        TargetGuidValue := TargetFieldRef.Value();

        if SourceGuidValue <> TargetGuidValue then begin
            TenantMediaSet.SetRange(ID, TargetGuidValue);
            if TenantMediaSet.IsEmpty() then
                exit;

            if BusinessGroupTemp.FindSet(false) then
                repeat
                    if TenantMediaSet.FindSet(false) then begin
                        repeat
                            Evaluate(MediaGuid, Format(TenantMediaSet."Media ID"));
                            TenantMedia.Get(MediaGuid);
                            AddMediaRecordForBusinessGroup(TenantMedia, TargetRecordRef, TargetFieldNo, BusinessGroupTemp.Code);
                        until TenantMediaSet.Next() = 0;
                    end;
                until BusinessGroupTemp.Next() = 0;
        end;
    end;

    procedure AddRecordForBusinessGroup(var RecRef: RecordRef; var xRecRef: RecordRef; BusinessGroupCode: Code[20]; RecordLogType: Option)
    var
        SyncLogEntry: Record "PVS Sync Log Entry";
        TempBlob: Record "PVS TempBlob" temporary;
    begin
        SyncLogEntry.Init();
        SyncLogEntry."Table No." := RecRef.Number();
        SyncLogEntry.Type := RecordLogType;
        SyncLogEntry."Record ID" := RecRef.RecordId();
        if LogType = Logtype::Rename then
            SyncLogEntry."Old Record ID" := xRecRef.RecordId();
        SyncLogEntry."Retries Remaining" := 20;
        SyncLogEntry."Source Business Group" := SourceBusinessGroupCode;
        SyncLogEntry."Destination Business Group" := BusinessGroupCode;
        SyncLogEntry."Sorting Order" := SyncLogEntry."Sorting Order";
        if LogType <> Logtype::Delete then begin
            PVSBlobStorage.WriteAsText(TempBlob, SyncJsonExchange.ConvertRecordRefToJsonString(RecRef, false), Textencoding::UTF8);
            SyncLogEntry."Record Object" := TempBlob.Blob;
            SyncLogEntry."Record Object Size" := TempBlob.Blob.Length();
        end;
        SyncLogEntry.Insert(true);
    end;

    procedure AddMediaRecordForBusinessGroup(var TenantMedia: Record "Tenant Media"; var RecRef: RecordRef; MediaFieldNo: Integer; BusinessGroupCode: Code[20])
    var
        SyncLogEntry: Record "PVS Sync Log Entry";
        TempBlob: Record "PVS TempBlob" temporary;
    begin
        SyncLogEntry.Init();
        SyncLogEntry."Table No." := RecRef.Number();
        SyncLogEntry."Log Type" := SyncLogEntry."Log type"::Media;
        SyncLogEntry."Log Field" := MediaFieldNo;
        SyncLogEntry.Type := LogType;
        SyncLogEntry."Record ID" := RecRef.RecordId();
        SyncLogEntry."Retries Remaining" := 20;
        SyncLogEntry."Source Business Group" := SourceBusinessGroupCode;
        SyncLogEntry."Destination Business Group" := BusinessGroupCode;
        PVSBlobStorage.WriteAsText(TempBlob, SyncJsonExchange.ConvertMediaToJsonString(TenantMedia), Textencoding::UTF8);
        SyncLogEntry."Record Object" := TempBlob.Blob;
        SyncLogEntry."Record Object Size" := TempBlob.Blob.Length();
        SyncLogEntry.Insert(true);
    end;

    local procedure TableSetupForSync(TableNo: Integer): Boolean
    var
        SyncTableSetup: Record "PVS Sync Table Setup";
    begin
        Initialize();

        if not SyncTableSetupTemp.Get(TableNo) then
            if not SyncTableSetup.Get(TableNo) then
                exit(false)
            else begin
                SyncTableSetupTemp := SyncTableSetup;
                SyncTableSetupTemp.Insert();
            end;

        if not SyncTableSetupTemp."Sync Active" then
            exit(false);

        if IsMasterCompany then
            exit(SyncTableSetupTemp."Sync Direction" <> SyncTableSetupTemp."sync direction"::LocalToMaster)
        else
            exit(SyncTableSetupTemp."Sync Direction" <> SyncTableSetupTemp."sync direction"::MasterToLocal);
    end;

    local procedure Initialize()
    var
        BusinessGroup: Record "PVS Business Group";
        SyncTableSetupTemp: Record "PVS Sync Table Setup" temporary;
    begin
        if Initialized then
            exit;

        BusinessGroupTemp.Reset();
        BusinessGroupTemp.DeleteAll();

        if BusinessGroup.FindSet(false) then
            repeat
                BusinessGroupTemp := BusinessGroup;
                BusinessGroupTemp.Insert();
                if (BusinessGroup.Company = COMPANYNAME()) then begin
                    IsMasterCompany := BusinessGroup."Master Company";
                    SourceBusinessGroupCode := BusinessGroup.Code;
                end;
            until BusinessGroup.Next() = 0;

        Initialized := true;
    end;

    procedure SetSkipTracking(Toggle: Boolean)
    begin
        SkipTracking := Toggle;
    end;

    procedure GetSkipTracking(): Boolean
    begin
        exit(SkipTracking);
    end;

    procedure ResetLocalClient()
    begin
        SyncTableSetupTemp.Reset();
        SyncTableSetupTemp.DeleteAll();
        Initialized := false;
    end;

    local procedure NotifyCache()
    var
        CacheNotification: Notification;
    begin
        if SkipTracking then
            exit;

        ResetLocalClient();
        CacheNotification.Message := CacheWarning;
        CacheNotification.Scope := Notificationscope::LocalScope;
        CacheNotification.ID := '3bf1c6fe-decc-4303-a1f5-6a913c6682b0';
        CacheNotification.Send();
    end;

    procedure ValidateSyncTableField(var SyncTableSetup: Record "PVS Sync Table Setup"; FieldNumber: Integer)
    var
        SyncTableSetup2: Record "PVS Sync Table Setup";
        IsHandled: Boolean;
    begin
        case FieldNumber of
            SyncTableSetup.FieldNo("Table No."):
                OnValidateSyncTableFieldTableNo(SyncTableSetup, IsHandled);

            SyncTableSetup.FieldNo("Sync Active"):
                begin
                    SyncTableSetup2.SetRange("Linked To", SyncTableSetup."Table No.");
                    if not SyncTableSetup2.IsEmpty() then
                        SyncTableSetup2.ModifyAll("Sync Active", SyncTableSetup."Sync Active");
                end;

            SyncTableSetup.FieldNo("Sync Direction"):
                begin
                    SyncTableSetup2.SetRange("Linked To", SyncTableSetup."Table No.");
                    if not SyncTableSetup2.IsEmpty() then
                        SyncTableSetup2.ModifyAll("Sync Direction", SyncTableSetup."Sync Direction");
                end;

            SyncTableSetup.FieldNo("Sync Order"):
                begin
                    SyncTableSetup2.SetRange("Linked To", SyncTableSetup."Table No.");
                    if not SyncTableSetup2.IsEmpty() then
                        SyncTableSetup2.ModifyAll("Sync Order", SyncTableSetup."Sync Order");
                end;

        end;
    end;

    procedure AddSyncTableEntry(TableId: Integer; Direction: Option; LinkedTo: Integer; SyncOrder: Integer)
    var
        SyncTableSetup: Record "PVS Sync Table Setup";
    begin
        if SyncTableSetup.Get(TableId) then begin
            if SyncTableSetup."Linked To" <> LinkedTo then begin
                SyncTableSetup."Linked To" := LinkedTo;
                SyncTableSetup.Modify();
            end;
            exit;
        end;

        SyncTableSetup."Table No." := TableId;
        SyncTableSetup."Sync Active" := true;
        SyncTableSetup."Sync Direction" := Direction;
        SyncTableSetup."Linked To" := LinkedTo;
        SyncTableSetup."Sync Order" := SyncOrder;
        SyncTableSetup.Insert();
    end;

    procedure CompressLines(inRecID: RecordID; EntryID: Integer; BusGroup: Code[50])
    var
        PVSBusinessGroup: Record "PVS Business Group";
        PVSSyncLogEntry: Record "PVS Sync Log Entry";
    begin
        PVSSyncLogEntry.reset;
        PVSSyncLogEntry.setrange(Status, PVSSyncLogEntry.Status::New);
        PVSSyncLogEntry.setrange("Entry No.", 0, EntryID - 1);
        PVSSyncLogEntry.setrange("Record ID", inRecID);
        PVSSyncLogEntry.setrange(Type, PVSSyncLogEntry.Type::Insert, PVSSyncLogEntry.Type::Modify);
        PVSSyncLogEntry.setrange("Destination Business Group", BusGroup);
        if PVSSyncLogEntry.IsEmpty then exit;
        PVSSyncLogEntry.DeleteAll();
    end;

    procedure IsSystemTable(TableId: Integer): Boolean
    begin
        exit(TableId in [Database::"PVS Sync Table Setup",
                         Database::"PVS Sync Field Setup",
                         Database::"PVS Sync Field Mapping"]);
    end;

    procedure IsSpecialTable(TableId: Integer): Boolean
    var
        IsHandled: Boolean;
        IsSpecialTable: Boolean;
    begin
        OnIsSpecialTable(TableId, IsSpecialTable, IsHandled);
        exit(IsSpecialTable);
    end;

    procedure IsValidateInsertModifyTable(TableId: Integer): Boolean
    var
        SyncTableSetup: Record "PVS Sync Table Setup";
    begin
        if SyncTableSetup.Get(TableId) then
            exit(not SyncTableSetup."Skip Validate On Insert/Modify");
        exit(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::GlobalTriggerManagement, 'OnAfterGetDatabaseTableTriggerSetup', '', false, false)]
    local procedure GetTableOnAfterGetDatabaseTableTriggerSetup(TableId: Integer; var OnDatabaseInsert: Boolean; var OnDatabaseModify: Boolean; var OnDatabaseDelete: Boolean; var OnDatabaseRename: Boolean)
    var
        TriggerTable: Boolean;
    begin
        TriggerTable := TableSetupForSync(TableId);
        if TriggerTable then begin
            OnDatabaseDelete := TriggerTable;
            OnDatabaseInsert := TriggerTable;
            OnDatabaseModify := TriggerTable;
            OnDatabaseRename := TriggerTable;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::GlobalTriggerManagement, 'OnAfterOnDatabaseInsert', '', true, true)]
    local procedure CheckSyncSetupOnAfterOnDatabaseInsert(RecRef: RecordRef)
    var
        xRecRef: RecordRef;
    begin
        AddRecordToSyncLogTable(RecRef, xRecRef, Logtype::Insert);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::GlobalTriggerManagement, 'OnAfterOnDatabaseModify', '', true, true)]
    local procedure CheckSyncSetupOnAfterOnDatabaseModify(RecRef: RecordRef)
    var
        xRecRef: RecordRef;
    begin
        AddRecordToSyncLogTable(RecRef, xRecRef, Logtype::Modify);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::GlobalTriggerManagement, 'OnAfterOnDatabaseDelete', '', true, true)]
    local procedure CheckSyncSetupOnAfterOnDatabaseDelete(RecRef: RecordRef)
    var
        xRecRef: RecordRef;
    begin
        AddRecordToSyncLogTable(RecRef, xRecRef, Logtype::Delete);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::GlobalTriggerManagement, 'OnAfterOnDatabaseRename', '', true, true)]
    local procedure CheckSyncSetupOnAfterOnDatabaseRename(RecRef: RecordRef; xRecRef: RecordRef)
    begin
        AddRecordToSyncLogTable(RecRef, xRecRef, Logtype::Rename);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Sync Json Exchange.", 'OnBeforeAddingFieldToJson', '', false, false)]
    local procedure CheckFieldMappingOnBeforeAddToJson(TableNo: Integer; FieldNo: Integer; var ValueVariant: Variant)
    var
        SyncFieldSetup: Record "PVS Sync Field Setup";
        SyncFieldMapping: Record "PVS Sync Field Mapping";
        FromCode: Code[250];
        Amount: Decimal;
        ExchangeRate: Decimal;
        Handled: Boolean;
    begin
        OnBeforeCheckFieldMappingOnBeforeAddToJson(TableNo, FieldNo, ValueVariant, Handled);
        if Handled then
            EXIT;

        if ValueVariant.ISCODE() then begin

            FromCode := ValueVariant;
            if not SyncFieldMapping.Get(TableNo, FieldNo, BusinessGroupTemp.Code, FromCode) then
                exit;

            ValueVariant := SyncFieldMapping."To Code";
        end;

        if ValueVariant.IsDecimal() then begin
            if BusinessGroupTemp."Local Currency Code" = '' then
                exit;
            if not SyncFieldSetup.Get(TableNo, FieldNo) then
                exit;
            if not SyncFieldSetup."Convert to Local Currency" then
                exit;

            Amount := ValueVariant;
            ExchangeRate := CurrencyExchangeRate.ExchangeRate(WorkDate(), BusinessGroupTemp."Local Currency Code");
            Amount *= ExchangeRate;
            ValueVariant := Amount;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Sync Table Setup", 'OnAfterInsertEvent', '', true, true)]
    local procedure T6010515_NotifyCacheOnAfterInsert(var Rec: Record "PVS Sync Table Setup"; RunTrigger: Boolean)
    begin
        if not Rec.IsTemporary() then
            NotifyCache();
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Sync Table Setup", 'OnAfterModifyEvent', '', true, true)]
    local procedure T6010515_NotifyCacheOnAfterModify(var Rec: Record "PVS Sync Table Setup"; var xRec: Record "PVS Sync Table Setup"; RunTrigger: Boolean)
    begin
        if not Rec.IsTemporary() then
            NotifyCache();
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Sync Table Setup", 'OnAfterDeleteEvent', '', true, true)]
    local procedure T6010515_NotifyCacheOnAfterDelete(var Rec: Record "PVS Sync Table Setup"; RunTrigger: Boolean)
    begin
        if not Rec.IsTemporary() then
            NotifyCache();
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Sync Table Setup", 'OnAfterRenameEvent', '', true, true)]
    local procedure T6010515_NotifyCacheOnAfterRename(var Rec: Record "PVS Sync Table Setup"; var xRec: Record "PVS Sync Table Setup"; RunTrigger: Boolean)
    begin
        if not Rec.IsTemporary() then
            NotifyCache();
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Sync Field Setup", 'OnAfterInsertEvent', '', true, true)]
    local procedure T6010516_NotifyCacheOnAfterInsert(var Rec: Record "PVS Sync Field Setup"; RunTrigger: Boolean)
    begin
        if not Rec.IsTemporary() then
            NotifyCache();
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Sync Field Setup", 'OnAfterModifyEvent', '', true, true)]
    local procedure T6010516_NotifyCacheOnAfterModify(var Rec: Record "PVS Sync Field Setup"; var xRec: Record "PVS Sync Field Setup"; RunTrigger: Boolean)
    begin
        if not Rec.IsTemporary() then
            NotifyCache();
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Sync Field Setup", 'OnAfterDeleteEvent', '', true, true)]
    local procedure T6010516_NotifyCacheOnAfterDelete(var Rec: Record "PVS Sync Field Setup"; RunTrigger: Boolean)
    begin
        if not Rec.IsTemporary() then
            NotifyCache();
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Sync Field Setup", 'OnAfterRenameEvent', '', true, true)]
    local procedure T6010516_NotifyCacheOnAfterRename(var Rec: Record "PVS Sync Field Setup"; var xRec: Record "PVS Sync Field Setup"; RunTrigger: Boolean)
    begin
        if not Rec.IsTemporary() then
            NotifyCache();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnIsSpecialTable(TableId: Integer; var IsSpecialTable: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnValidateSyncTableFieldTableNo(var SyncTableSetup: Record "PVS Sync Table Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAddRecordToSyncLogTable(var RecRef: RecordRef; LogTypeOpt_IMRDS: Option; var ProcessTable: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckFieldMappingOnBeforeAddToJson(TableNo: Integer; FieldNo: Integer; var ValueVariant: Variant; var Handled: Boolean);
    begin
    end;

}

