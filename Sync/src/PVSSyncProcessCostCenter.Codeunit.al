Codeunit 80201 "PVS Sync Process Cost Center"
{

    trigger OnRun()
    begin
    end;

    var
        TypeHelper: Codeunit "Type Helper";
        SyncJsonExchange: Codeunit "PVS Sync Json Exchange.";
        SyncChangeManagement: Codeunit "PVS Sync Change Management";
        SyncProcessingManagement: Codeunit "PVS Sync Processing Management";
        PVSBlobStorage: Codeunit "PVS Blob Storage";
        LogType: Option Insert,Modify,Rename,Delete,Special;
        IncorrectEntryNo: label 'Incorrect Entry No. (in Codeunit 75519 PVS Sync Process Cost Center)';
        IncorrectType: label 'Incorrect Type (in Codeunit 75519 PVS Sync Process Cost Center)';
        PrefixxRec: label 'x_';

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Sync Processing Management", 'OnProcessSyncLogEntryForSpecialTable', '', false, false)]
    local procedure ProcessCostCenterOnProcessSyncLogEntryForSpecialTable(var SyncLogEntry: Record "PVS Sync Log Entry"; var IsHandled: Boolean)
    begin
        if IsHandled then
            exit;

        IsHandled := ProcessSyncTable(SyncLogEntry);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Sync Change Management", 'OnValidateSyncTableFieldTableNo', '', false, false)]
    local procedure InsertSubTablesOnValidateSyncTableFieldTableNo(var SyncTableSetup: Record "PVS Sync Table Setup"; var IsHandled: Boolean)
    begin
        if IsHandled then
            exit;

        if SyncTableSetup."Table No." <> Database::"PVS Cost Center" then
            exit;

        IsHandled := true;
        SyncTableSetup."Sync Direction" := SyncTableSetup."sync direction"::MasterToLocal;
        SyncChangeManagement.AddSyncTableEntry(Database::"PVS Cost Center Alt. Rates", SyncTableSetup."Sync Direction", Database::"PVS Cost Center", SyncTableSetup."Sync Order");
        SyncChangeManagement.AddSyncTableEntry(Database::"PVS Cost Center Rates", SyncTableSetup."Sync Direction", Database::"PVS Cost Center", SyncTableSetup."Sync Order");
        SyncChangeManagement.AddSyncTableEntry(Database::"PVS Cost Center Configuration", SyncTableSetup."Sync Direction", Database::"PVS Cost Center", SyncTableSetup."Sync Order");
        SyncChangeManagement.AddSyncTableEntry(Database::"PVS Cost Center Operation", SyncTableSetup."Sync Direction", Database::"PVS Cost Center", SyncTableSetup."Sync Order");
        SyncChangeManagement.AddSyncTableEntry(Database::"PVS Speed Table", SyncTableSetup."Sync Direction", Database::"PVS Cost Center", SyncTableSetup."Sync Order");
        SyncChangeManagement.AddSyncTableEntry(Database::"PVS Speed Table Line", SyncTableSetup."Sync Direction", Database::"PVS Cost Center", SyncTableSetup."Sync Order");
        SyncChangeManagement.AddSyncTableEntry(Database::"PVS Scrap Table", SyncTableSetup."Sync Direction", Database::"PVS Cost Center", SyncTableSetup."Sync Order");
        SyncChangeManagement.AddSyncTableEntry(Database::"PVS Scrap Table Line", SyncTableSetup."Sync Direction", Database::"PVS Cost Center", SyncTableSetup."Sync Order");
        SyncChangeManagement.AddSyncTableEntry(Database::"PVS Calculation Unit Setup", SyncTableSetup."Sync Direction", Database::"PVS Cost Center", SyncTableSetup."Sync Order");
        SyncChangeManagement.AddSyncTableEntry(Database::"PVS Calc. Unit Setup Detail", SyncTableSetup."Sync Direction", Database::"PVS Cost Center", SyncTableSetup."Sync Order");
        SyncChangeManagement.AddSyncTableEntry(Database::"PVS Calc. Unit Setup Group", SyncTableSetup."Sync Direction", Database::"PVS Cost Center", SyncTableSetup."Sync Order");
        SyncChangeManagement.AddSyncTableEntry(Database::"PVS Calculation Formula", SyncTableSetup."Sync Direction", Database::"PVS Cost Center", SyncTableSetup."Sync Order");
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Sync Table Setup", 'OnAfterDeleteEvent', '', false, false)]
    local procedure DeleteSubTablesOnAfterDeleteSyncTable(var Rec: Record "PVS Sync Table Setup"; RunTrigger: Boolean)
    var
        SyncTableSetup: Record "PVS Sync Table Setup";
    begin
        if Rec."Table No." <> Database::"PVS Cost Center" then
            exit;

        if SyncTableSetup.Get(Database::"PVS Cost Center Alt. Rates") then
            SyncTableSetup.Delete();
        if SyncTableSetup.Get(Database::"PVS Cost Center Rates") then
            SyncTableSetup.Delete();
        if SyncTableSetup.Get(Database::"PVS Cost Center Configuration") then
            SyncTableSetup.Delete();
        if SyncTableSetup.Get(Database::"PVS Cost Center Operation") then
            SyncTableSetup.Delete();
        if SyncTableSetup.Get(Database::"PVS Speed Table") then
            SyncTableSetup.Delete();
        if SyncTableSetup.Get(Database::"PVS Speed Table Line") then
            SyncTableSetup.Delete();
        if SyncTableSetup.Get(Database::"PVS Scrap Table") then
            SyncTableSetup.Delete();
        if SyncTableSetup.Get(Database::"PVS Scrap Table Line") then
            SyncTableSetup.Delete();
        if SyncTableSetup.Get(Database::"PVS Calculation Unit Setup") then
            SyncTableSetup.Delete();
        if SyncTableSetup.Get(Database::"PVS Calc. Unit Setup Detail") then
            SyncTableSetup.Delete();
        if SyncTableSetup.Get(Database::"PVS Calc. Unit Setup Group") then
            SyncTableSetup.Delete();
        if SyncTableSetup.Get(Database::"PVS Calculation Formula") then
            SyncTableSetup.Delete();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Sync Change Management", 'OnAddRecordToSyncLogTable', '', false, false)]
    local procedure CheckIfProcessTableOnAddRecordToSyncLogTable(var RecRef: RecordRef; LogTypeOpt_IMRDS: Option; var ProcessTable: Boolean; var IsHandled: Boolean)
    begin
        case true of
            (RecRef.Number() in [Database::"PVS Cost Center",
                               Database::"PVS Cost Center Configuration"]):
                begin
                    IsHandled := true;
                    ProcessTable := true;
                    if LogTypeOpt_IMRDS = Logtype::Insert then
                        ProcessTable := false;
                end;
            (RecRef.Number() = Database::"PVS Calculation Unit Setup"):
                begin
                    IsHandled := true;
                    ProcessTable := true;
                    if LogTypeOpt_IMRDS = Logtype::Insert then
                        ProcessTable := false;
                end;
            (RecRef.Number() in [Database::"PVS Calc. Unit Setup Detail",
                               Database::"PVS Calc. Unit Setup Group"]):
                begin
                    IsHandled := true;
                    ProcessTable := true;
                    if LogTypeOpt_IMRDS in [Logtype::Rename, Logtype::Delete] then
                        ProcessTable := false;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Sync Change Management", 'OnIsSpecialTable', '', false, false)]
    local procedure CheckIfCostCenterRelatedOnIsSpecialTable(TableId: Integer; var IsSpecialTable: Boolean; var IsHandled: Boolean)
    begin
        if IsHandled then
            exit;

        IsHandled := true;
        IsSpecialTable := CheckIfSpecialTable(TableId);
    end;

    local procedure CheckIfSpecialTable(TableId: Integer): Boolean
    begin
        exit(TableId in [Database::"PVS Cost Center",
                         Database::"PVS Cost Center Alt. Rates",
                         Database::"PVS Cost Center Rates",
                         Database::"PVS Cost Center Configuration",
                         Database::"PVS Cost Center Operation",
                         Database::"PVS Speed Table",
                         Database::"PVS Speed Table Line",
                         Database::"PVS Scrap Table",
                         Database::"PVS Scrap Table Line",
                         Database::"PVS Calculation Unit Setup",
                         Database::"PVS Calc. Unit Setup Detail",
                         Database::"PVS Calc. Unit Setup Group"]);
    end;

    local procedure GetKeyValue(FieldName: Text; var NameValueBuffer: Record "Name/Value Buffer"): Text
    begin
        NameValueBuffer.Reset();
        NameValueBuffer.SetRange(Name, FieldName);
        if NameValueBuffer.FindFirst() then
            exit(NameValueBuffer.GetValue());
    end;

    local procedure SetKeyFields(var SyncLogEntry: Record "PVS Sync Log Entry"; var NameValueBuffer: Record "Name/Value Buffer")
    var
        CurrentRecordID: RecordID;
        RecRef: RecordRef;
        FldRef: FieldRef;
    begin
        NameValueBuffer.Reset();
        NameValueBuffer.DeleteAll();

        if Format(SyncLogEntry."Old Record ID") <> '' then begin
            CurrentRecordID := SyncLogEntry."Old Record ID";
            RecRef := CurrentRecordID.GetRecord();
            SetKeyFieldsFromRecRef(RecRef, NameValueBuffer, true);
        end;

        CurrentRecordID := SyncLogEntry."Record ID";
        RecRef := CurrentRecordID.GetRecord();
        SetKeyFieldsFromRecRef(RecRef, NameValueBuffer, false);
    end;

    local procedure SetKeyFieldsFromRecRef(var RecRef: RecordRef; var NameValueBuffer: Record "Name/Value Buffer"; IsxRec: Boolean)
    var
        KeyFldRef: FieldRef;
        KeyRf: KeyRef;
        Prefix: Text;
        i: Integer;
    begin
        KeyRf := RecRef.KeyIndex(1);
        for i := 1 to KeyRf.FieldCount() do begin
            KeyFldRef := KeyRf.FieldIndex(i);
            if IsxRec then
                Prefix := PrefixxRec;
            NameValueBuffer.AddNewEntry(Prefix + KeyFldRef.Name(), Format(KeyFldRef.Value(), 0, 9));
        end;
    end;

    local procedure GetJsonRecordRef(var SyncLogEntry: Record "PVS Sync Log Entry"; var RecRef: RecordRef)
    var
        TempBlob: Record "PVS TempBlob" temporary;
        JsonRecord: Text;
    begin
        SyncLogEntry.CalcFields("Record Object");
        TempBlob.Blob := SyncLogEntry."Record Object";
        JsonRecord := PVSBlobStorage.ReadAsText(TempBlob, TypeHelper.NewLine(), Textencoding::UTF8);

        SyncJsonExchange.ConvertJsonStringToRecord(RecRef, JsonRecord, SyncLogEntry."Table No.", true, true);
    end;

    local procedure ProcessSyncTable(var SyncLogEntry: Record "PVS Sync Log Entry"): Boolean
    var
        NameValueBuffer: Record "Name/Value Buffer" temporary;
    begin
        if not CheckIfSpecialTable(SyncLogEntry."Table No.") then
            exit(false);

        SetKeyFields(SyncLogEntry, NameValueBuffer);

        case SyncLogEntry."Table No." of
            Database::"PVS Cost Center":
                exit(ProcessCostCenter(SyncLogEntry, NameValueBuffer));
            Database::"PVS Cost Center Rates":
                exit(ProcessRates(SyncLogEntry, NameValueBuffer));
            Database::"PVS Cost Center Configuration":
                exit(ProcessConfiguration(SyncLogEntry, NameValueBuffer));
            Database::"PVS Cost Center Operation":
                exit(ProcessOperation(SyncLogEntry, NameValueBuffer));
            Database::"PVS Speed Table":
                exit(ProcessSpeedTable(SyncLogEntry, NameValueBuffer));
            Database::"PVS Speed Table Line":
                exit(ProcessSpeedTableLine(SyncLogEntry, NameValueBuffer));
            Database::"PVS Scrap Table":
                exit(ProcessScrapTable(SyncLogEntry, NameValueBuffer));
            Database::"PVS Scrap Table Line":
                exit(ProcessScrapTableLine(SyncLogEntry, NameValueBuffer));
            Database::"PVS Calculation Unit Setup":
                exit(ProcessCalcUnitSetup(SyncLogEntry, NameValueBuffer));
            Database::"PVS Calc. Unit Setup Detail":
                exit(ProcessCalcUnitSetupDetail(SyncLogEntry, NameValueBuffer));
            Database::"PVS Calc. Unit Setup Group":
                exit(ProcessCalcUnitSetupGroup(SyncLogEntry, NameValueBuffer));
        end;
    end;

    local procedure ProcessCostCenter(var SyncLogEntry: Record "PVS Sync Log Entry"; var NameValueBuffer: Record "Name/Value Buffer"): Boolean
    var
        CostCenter: Record "PVS Cost Center";
        NewRecRef: RecordRef;
        RecRef: RecordRef;
        CostCenterCode: Code[20];
        OldCode: Code[20];
    begin
        // Primary Key: Code

        case SyncLogEntry.Type of
            SyncLogEntry.Type::Rename:
                begin
                    OldCode := GetKeyValue(PrefixxRec + CostCenter.FieldName(Code), NameValueBuffer);
                    CostCenterCode := GetKeyValue(CostCenter.FieldName(Code), NameValueBuffer);

                    CostCenter.SetRange("Business Group Cost Center", OldCode);
                    CostCenter.ModifyAll("Business Group Cost Center", CostCenterCode);
                end;
            SyncLogEntry.Type::Delete:
                begin
                    CostCenterCode := GetKeyValue(CostCenter.FieldName(Code), NameValueBuffer);

                    CostCenter.SetRange("Business Group Cost Center", CostCenterCode);
                    CostCenter.ModifyAll("Business Group Cost Center", '');
                end;
            SyncLogEntry.Type::Modify:
                begin
                    GetJsonRecordRef(SyncLogEntry, NewRecRef);

                    SyncProcessingManagement.AddToSkipFieldList(CostCenter.FieldNo("Business Group Cost Center"), true);
                    SyncProcessingManagement.AddToSkipFieldList(CostCenter.FieldNo("Capacity Unit"), false);

                    CostCenterCode := GetKeyValue(CostCenter.FieldName(Code), NameValueBuffer);
                    CostCenter.SetRange("Business Group Cost Center", CostCenterCode);
                    if CostCenter.FindSet(true, false) then
                        repeat
                            RecRef.GetTable(CostCenter);
                            SyncProcessingManagement.CopyFields(RecRef, NewRecRef, false);
                            RecRef.SetTable(CostCenter);
                            CostCenter.Modify();
                        until CostCenter.Next() = 0;

                end;
        end;
        exit(true); // Handled
    end;

    local procedure ProcessRates(var SyncLogEntry: Record "PVS Sync Log Entry"; var NameValueBuffer: Record "Name/Value Buffer"): Boolean
    var
        CostCenterRates: Record "PVS Cost Center Rates";
        CostCenterRates2: Record "PVS Cost Center Rates";
        CostCenterConfiguration: Record "PVS Cost Center Configuration";
        NewRecRef: RecordRef;
        RecRef: RecordRef;
        NewDate: Date;
        OldDate: Date;
        AlternativeRateCode: Code[50];
        ConfigurationCode: Code[20];
        CostCenterCode: Code[20];
        CustomerGroupCode: Code[50];
        OldOperationCode: Code[20];
        OperationCode: Code[20];
        PriceGroupCode: Code[50];
        ProductGroupCode: Code[50];
    begin
        // Primary key: Cost Center Code,Configuration,Operation,Product Group,Price Group,Customer Group,Alternative Rates Code,Date

        ProductGroupCode := GetKeyValue(CostCenterRates.FieldName("Product Group"), NameValueBuffer);
        PriceGroupCode := GetKeyValue(CostCenterRates.FieldName("Price Group"), NameValueBuffer);
        CustomerGroupCode := GetKeyValue(CostCenterRates.FieldName("Customer Group"), NameValueBuffer);
        AlternativeRateCode := GetKeyValue(CostCenterRates.FieldName("Alternative Rates Code"), NameValueBuffer);

        case SyncLogEntry.Type of
            SyncLogEntry.Type::Rename: // Only Handle rename of Operation Code or Date
                begin
                    CostCenterCode := GetKeyValue(CostCenterRates.FieldName("Cost Center Code"), NameValueBuffer);
                    ConfigurationCode := GetKeyValue(CostCenterRates.FieldName(Configuration), NameValueBuffer);
                    OldOperationCode := GetKeyValue(PrefixxRec + CostCenterRates.FieldName(Operation), NameValueBuffer);
                    OperationCode := GetKeyValue(CostCenterRates.FieldName(Operation), NameValueBuffer);

                    if Evaluate(OldDate, GetKeyValue(CostCenterRates.FieldName(Date), NameValueBuffer)) then;
                    if Evaluate(NewDate, GetKeyValue(PrefixxRec + CostCenterRates.FieldName(Date), NameValueBuffer)) then;

                    if (OperationCode <> OldOperationCode) or (OldDate <> NewDate) then begin
                        CostCenterConfiguration.SetRange("Business Group Cost Center", CostCenterCode);
                        CostCenterConfiguration.SetRange("Business Group Configuration", ConfigurationCode);
                        if CostCenterConfiguration.FindSet(false, false) then
                            repeat
                                CostCenterRates.SetRange("Cost Center Code", CostCenterConfiguration."Cost Center Code");
                                CostCenterRates.SetRange(Configuration, CostCenterConfiguration.Configuration);
                                CostCenterRates.SetRange(Operation, OldOperationCode);
                                if CostCenterRates.FindSet(false, false) then
                                    repeat
                                        if CostCenterRates2.Get(CostCenterRates."Cost Center Code", CostCenterRates.Configuration, OldOperationCode,
                                                                 CostCenterRates."Product Group", CostCenterRates."Price Group", CostCenterRates."Customer Group",
                                                                      CostCenterRates."Alternative Rates Code", OldDate) then
                                            CostCenterRates2.Rename(CostCenterRates."Cost Center Code", CostCenterRates.Configuration, OperationCode,
                                                                        CostCenterRates."Product Group", CostCenterRates."Price Group", CostCenterRates."Customer Group",
                                                                        CostCenterRates."Alternative Rates Code", NewDate);
                                    until CostCenterRates.Next() = 0;
                            until CostCenterConfiguration.Next() = 0;
                    end;
                end;
            SyncLogEntry.Type::Delete:
                begin
                    CostCenterCode := GetKeyValue(CostCenterRates.FieldName("Cost Center Code"), NameValueBuffer);
                    ConfigurationCode := GetKeyValue(CostCenterRates.FieldName(Configuration), NameValueBuffer);

                    CostCenterConfiguration.SetRange("Business Group Cost Center", CostCenterCode);
                    CostCenterConfiguration.SetRange("Business Group Configuration", ConfigurationCode);
                    if CostCenterConfiguration.FindSet(false, false) then
                        repeat
                            OperationCode := GetKeyValue(CostCenterRates.FieldName(Operation), NameValueBuffer);
                            if Evaluate(OldDate, GetKeyValue(CostCenterRates.FieldName(Date), NameValueBuffer)) then;

                            CostCenterRates.SetRange("Cost Center Code", CostCenterConfiguration."Cost Center Code");
                            CostCenterRates.SetRange(Configuration, CostCenterConfiguration.Configuration);
                            CostCenterRates.SetRange(Operation, OperationCode);
                            CostCenterRates.SetRange("Product Group", ProductGroupCode);
                            CostCenterRates.SetRange("Price Group", PriceGroupCode);
                            CostCenterRates.SetRange("Customer Group", CustomerGroupCode);
                            CostCenterRates.SetRange("Alternative Rates Code", AlternativeRateCode);
                            CostCenterRates.SetRange(Date, OldDate);
                            CostCenterRates.DeleteAll(true);
                        until CostCenterConfiguration.Next() = 0;
                end;
            SyncLogEntry.Type::Insert,
            SyncLogEntry.Type::Modify:
                begin
                    GetJsonRecordRef(SyncLogEntry, NewRecRef);

                    CostCenterCode := GetKeyValue(CostCenterRates.FieldName("Cost Center Code"), NameValueBuffer);
                    ConfigurationCode := GetKeyValue(CostCenterRates.FieldName(Configuration), NameValueBuffer);
                    CostCenterConfiguration.SetRange("Business Group Cost Center", CostCenterCode);
                    CostCenterConfiguration.SetRange("Business Group Configuration", ConfigurationCode);
                    if CostCenterConfiguration.FindSet(true, false) then
                        repeat
                            OperationCode := GetKeyValue(CostCenterRates.FieldName(Operation), NameValueBuffer);
                            if Evaluate(OldDate, GetKeyValue(CostCenterRates.FieldName(Date), NameValueBuffer)) then;

                            CostCenterRates.SetRange("Cost Center Code", CostCenterConfiguration."Cost Center Code");
                            CostCenterRates.SetRange(Configuration, CostCenterConfiguration.Configuration);
                            CostCenterRates.SetRange("Product Group", ProductGroupCode);
                            CostCenterRates.SetRange("Price Group", PriceGroupCode);
                            CostCenterRates.SetRange("Customer Group", CustomerGroupCode);
                            CostCenterRates.SetRange("Alternative Rates Code", AlternativeRateCode);
                            //</003>
                            CostCenterRates.SetRange(Date, OldDate);
                            if CostCenterRates.FindFirst() then begin
                                RecRef.GetTable(CostCenterRates);
                                SyncProcessingManagement.CopyFields(RecRef, NewRecRef, false);
                                RecRef.SetTable(CostCenterRates);
                                CostCenterRates.Modify();
                            end else begin
                                RecRef.Close();
                                RecRef.Open(SyncLogEntry."Table No.");
                                RecRef.Init();
                                SyncProcessingManagement.CopyFields(RecRef, NewRecRef, true);
                                RecRef.SetTable(CostCenterRates);
                                CostCenterRates."Cost Center Code" := CostCenterConfiguration."Cost Center Code";
                                CostCenterRates.Configuration := CostCenterConfiguration.Configuration;
                                CostCenterRates."Product Group" := ProductGroupCode;
                                CostCenterRates."Price Group" := PriceGroupCode;
                                CostCenterRates."Customer Group" := CustomerGroupCode;
                                CostCenterRates."Alternative Rates Code" := AlternativeRateCode;
                                CostCenterRates.Insert(true);
                            end;
                        until CostCenterConfiguration.Next() = 0;

                end;
        end;
        exit(true); // Handled
    end;

    local procedure ProcessConfiguration(var SyncLogEntry: Record "PVS Sync Log Entry"; var NameValueBuffer: Record "Name/Value Buffer"): Boolean
    var
        CostCenterConfiguration: Record "PVS Cost Center Configuration";
        NewRecRef: RecordRef;
        RecRef: RecordRef;
        ConfigurationCode: Code[20];
        CostCenterCode: Code[20];
        OldConfigurationCode: Code[20];
        OldCostCenterCode: Code[20];
    begin
        // Primary Key: Cost Center Code,Configuration

        case SyncLogEntry.Type of
            SyncLogEntry.Type::Rename:
                begin
                    OldCostCenterCode := GetKeyValue(PrefixxRec + CostCenterConfiguration.FieldName("Cost Center Code"), NameValueBuffer);
                    CostCenterCode := GetKeyValue(CostCenterConfiguration.FieldName("Cost Center Code"), NameValueBuffer);
                    OldConfigurationCode := GetKeyValue(PrefixxRec + CostCenterConfiguration.FieldName(Configuration), NameValueBuffer);
                    ConfigurationCode := GetKeyValue(CostCenterConfiguration.FieldName(Configuration), NameValueBuffer);

                    if CostCenterCode <> OldCostCenterCode then begin
                        CostCenterConfiguration.SetRange("Business Group Cost Center", OldCostCenterCode);
                        CostCenterConfiguration.ModifyAll("Business Group Cost Center", CostCenterCode);
                    end;
                    if ConfigurationCode <> OldConfigurationCode then begin
                        CostCenterConfiguration.SetRange("Business Group Configuration", OldConfigurationCode);
                        CostCenterConfiguration.ModifyAll("Business Group Configuration", ConfigurationCode);
                    end;
                end;
            SyncLogEntry.Type::Delete:
                begin
                    CostCenterCode := GetKeyValue(CostCenterConfiguration.FieldName("Cost Center Code"), NameValueBuffer);
                    ConfigurationCode := GetKeyValue(CostCenterConfiguration.FieldName(Configuration), NameValueBuffer);

                    CostCenterConfiguration.SetRange("Business Group Cost Center", CostCenterCode);
                    CostCenterConfiguration.SetRange("Business Group Configuration", ConfigurationCode);
                    CostCenterConfiguration.ModifyAll("Business Group Configuration", '');
                end;
            SyncLogEntry.Type::Modify:
                begin
                    GetJsonRecordRef(SyncLogEntry, NewRecRef);

                    SyncProcessingManagement.AddToSkipFieldList(CostCenterConfiguration.FieldNo("Business Group Cost Center"), true);
                    SyncProcessingManagement.AddToSkipFieldList(CostCenterConfiguration.FieldNo("Business Group Configuration"), true);

                    CostCenterCode := GetKeyValue(CostCenterConfiguration.FieldName("Cost Center Code"), NameValueBuffer);
                    ConfigurationCode := GetKeyValue(CostCenterConfiguration.FieldName(Configuration), NameValueBuffer);
                    CostCenterConfiguration.SetRange("Business Group Cost Center", CostCenterCode);
                    CostCenterConfiguration.SetRange("Business Group Configuration", ConfigurationCode);
                    if CostCenterConfiguration.FindSet(true, false) then
                        repeat
                            RecRef.GetTable(CostCenterConfiguration);
                            SyncProcessingManagement.CopyFields(RecRef, NewRecRef, false);
                            RecRef.SetTable(CostCenterConfiguration);
                            CostCenterConfiguration.Modify();
                        until CostCenterConfiguration.Next() = 0;

                end;
        end;
        exit(true); // Handled
    end;

    local procedure ProcessOperation(var SyncLogEntry: Record "PVS Sync Log Entry"; var NameValueBuffer: Record "Name/Value Buffer"): Boolean
    var
        CostCenterConfiguration: Record "PVS Cost Center Configuration";
        CostCenterOperation: Record "PVS Cost Center Operation";
        CostCenterOperation2: Record "PVS Cost Center Operation";
        TempBlob: Record "PVS TempBlob" temporary;
        RecID: RecordID;
        NewRecRef: RecordRef;
        RecRef: RecordRef;
        FldRef: FieldRef;
        JsonRecord: Text;
        ConfigurationCode: Code[20];
        CostCenterCode: Code[20];
        OldOperationCode: Code[20];
        OperationCode: Code[20];
    begin
        // Primary Key: Cost Center Code,Configuration,Operation,Sell-To No.,Product Group

        // TODO: CHECK
        if (GetKeyValue(CostCenterOperation.FieldName("Product Group"), NameValueBuffer) <> '') or
           (GetKeyValue(CostCenterOperation.FieldName("Sell-To No."), NameValueBuffer) <> '') then
            exit; // Skip Local Specific Records

        case SyncLogEntry.Type of
            SyncLogEntry.Type::Rename: // Only handle rename of Operation Code
                begin
                    CostCenterCode := GetKeyValue(CostCenterOperation.FieldName("Cost Center Code"), NameValueBuffer);
                    ConfigurationCode := GetKeyValue(CostCenterOperation.FieldName(Configuration), NameValueBuffer);
                    OldOperationCode := GetKeyValue(PrefixxRec + CostCenterOperation.FieldName(Operation), NameValueBuffer);
                    OperationCode := GetKeyValue(CostCenterOperation.FieldName(Operation), NameValueBuffer);

                    if OperationCode <> OldOperationCode then begin
                        CostCenterConfiguration.SetRange("Business Group Cost Center", CostCenterCode);
                        CostCenterConfiguration.SetRange("Business Group Configuration", ConfigurationCode);
                        if CostCenterConfiguration.FindSet(false, false) then
                            repeat
                                CostCenterOperation.SetRange("Cost Center Code", CostCenterConfiguration."Cost Center Code");
                                CostCenterOperation.SetRange(Configuration, CostCenterConfiguration.Configuration);
                                CostCenterOperation.SetRange(Operation, OldOperationCode);
                                if CostCenterOperation.FindSet(false, false) then
                                    repeat
                                        if CostCenterOperation2.Get(CostCenterOperation."Cost Center Code", CostCenterOperation.Configuration, OldOperationCode,
                                                                 CostCenterOperation."Sell-To No.", CostCenterOperation."Product Group") then
                                            CostCenterOperation2.Rename(CostCenterOperation."Cost Center Code", CostCenterOperation.Configuration, OperationCode,
                                                                        CostCenterOperation."Sell-To No.", CostCenterOperation."Product Group");
                                    until CostCenterOperation.Next() = 0;
                            until CostCenterConfiguration.Next() = 0;
                    end;
                end;
            SyncLogEntry.Type::Delete:
                begin
                    CostCenterCode := GetKeyValue(CostCenterOperation.FieldName("Cost Center Code"), NameValueBuffer);
                    ConfigurationCode := GetKeyValue(CostCenterOperation.FieldName(Configuration), NameValueBuffer);

                    CostCenterConfiguration.SetRange("Business Group Cost Center", CostCenterCode);
                    CostCenterConfiguration.SetRange("Business Group Configuration", ConfigurationCode);
                    if CostCenterConfiguration.FindSet(false, false) then
                        repeat
                            OperationCode := GetKeyValue(CostCenterOperation.FieldName(Operation), NameValueBuffer);

                            CostCenterOperation.SetRange("Cost Center Code", CostCenterConfiguration."Cost Center Code");
                            CostCenterOperation.SetRange(Configuration, CostCenterConfiguration.Configuration);
                            CostCenterOperation.SetRange(Operation, OperationCode);
                            CostCenterOperation.SetRange("Sell-To No.", '');
                            CostCenterOperation.SetRange("Product Group", '');
                            CostCenterOperation.DeleteAll(true);
                        until CostCenterConfiguration.Next() = 0;
                end;
            SyncLogEntry.Type::Insert,
            SyncLogEntry.Type::Modify:
                begin
                    GetJsonRecordRef(SyncLogEntry, NewRecRef);

                    CostCenterCode := GetKeyValue(CostCenterOperation.FieldName("Cost Center Code"), NameValueBuffer);
                    ConfigurationCode := GetKeyValue(CostCenterOperation.FieldName(Configuration), NameValueBuffer);
                    CostCenterConfiguration.SetRange("Business Group Cost Center", CostCenterCode);
                    CostCenterConfiguration.SetRange("Business Group Configuration", ConfigurationCode);
                    if CostCenterConfiguration.FindSet(true, false) then
                        repeat
                            OperationCode := GetKeyValue(CostCenterOperation.FieldName(Operation), NameValueBuffer);

                            CostCenterOperation.SetRange("Cost Center Code", CostCenterConfiguration."Cost Center Code");
                            CostCenterOperation.SetRange(Configuration, CostCenterConfiguration.Configuration);
                            CostCenterOperation.SetRange(Operation, OperationCode);
                            CostCenterOperation.SetRange("Sell-To No.", '');
                            CostCenterOperation.SetRange("Product Group", '');
                            if CostCenterOperation.FindFirst() then begin
                                RecRef.GetTable(CostCenterOperation);
                                SyncProcessingManagement.CopyFields(RecRef, NewRecRef, false);
                                RecRef.SetTable(CostCenterOperation);
                                CostCenterOperation.Modify();
                            end else begin
                                RecRef.Close();
                                RecRef.Open(SyncLogEntry."Table No.");
                                RecRef.Init();
                                SyncProcessingManagement.CopyFields(RecRef, NewRecRef, true);
                                RecRef.SetTable(CostCenterOperation);
                                CostCenterOperation."Cost Center Code" := CostCenterConfiguration."Cost Center Code";
                                CostCenterOperation.Configuration := CostCenterConfiguration.Configuration;
                                CostCenterOperation.Operation := OperationCode;
                                CostCenterOperation.Insert(true);
                            end;
                        until CostCenterConfiguration.Next() = 0;

                end;
        end;
        exit(true); // Handled
    end;

    local procedure ProcessSpeedTable(var SyncLogEntry: Record "PVS Sync Log Entry"; var NameValueBuffer: Record "Name/Value Buffer"): Boolean
    var
        SpeedTable: Record "PVS Speed Table";
        NewRecRef: RecordRef;
        RecRef: RecordRef;
        OldCode: Code[20];
        SpeedTableCode: Code[20];
    begin
        // Primary Key: Code

        case SyncLogEntry.Type of
            SyncLogEntry.Type::Rename:
                begin
                    OldCode := GetKeyValue(PrefixxRec + SpeedTable.FieldName(Code), NameValueBuffer);
                    SpeedTableCode := GetKeyValue(SpeedTable.FieldName(Code), NameValueBuffer);

                    SpeedTable.SetRange("Business Group Speed Table", OldCode);
                    SpeedTable.ModifyAll("Business Group Speed Table", SpeedTableCode);
                end;
            SyncLogEntry.Type::Delete:
                begin
                    SpeedTableCode := GetKeyValue(SpeedTable.FieldName(Code), NameValueBuffer);

                    SpeedTable.SetRange("Business Group Speed Table", SpeedTableCode);
                    SpeedTable.ModifyAll("Business Group Speed Table", '');
                end;
            SyncLogEntry.Type::Modify:
                begin
                    GetJsonRecordRef(SyncLogEntry, NewRecRef);

                    SyncProcessingManagement.AddToSkipFieldList(SpeedTable.FieldNo("Business Group Speed Table"), true);

                    SpeedTableCode := GetKeyValue(SpeedTable.FieldName(Code), NameValueBuffer);
                    SpeedTable.SetRange("Business Group Speed Table", SpeedTableCode);
                    if SpeedTable.FindSet(true, false) then
                        repeat
                            RecRef.GetTable(SpeedTable);
                            SyncProcessingManagement.CopyFields(RecRef, NewRecRef, false);
                            RecRef.SetTable(SpeedTable);
                            SpeedTable.Modify();
                        until SpeedTable.Next() = 0;

                end;
        end;
        exit(true); // Handled
    end;

    local procedure ProcessSpeedTableLine(var SyncLogEntry: Record "PVS Sync Log Entry"; var NameValueBuffer: Record "Name/Value Buffer"): Boolean
    var
        SpeedTable: Record "PVS Speed Table";
        SpeedTableLine: Record "PVS Speed Table Line";
        NewRecRef: RecordRef;
        RecRef: RecordRef;
        CodeArray: array[6] of Code[50];
        xCodeArray: array[6] of Code[50];
        DecimalArray: array[5] of Decimal;
        xDecimalArray: array[4] of Decimal;
        Signature: Integer;
        xSignature: Integer;
    begin
        // Primary Key: Speed Table Code,Customer Group,Product Group,Format Code,Time Group,Paper Quality,Weight,Signature,Formula 1,Formula 2,From Quantity

        CodeArray[1] := GetKeyValue(SpeedTableLine.FieldName("Speed Table"), NameValueBuffer);
        CodeArray[2] := GetKeyValue(SpeedTableLine.FieldName("Customer Group"), NameValueBuffer);
        CodeArray[3] := GetKeyValue(SpeedTableLine.FieldName("Product Group"), NameValueBuffer);
        CodeArray[4] := GetKeyValue(SpeedTableLine.FieldName("Format Code"), NameValueBuffer);
        CodeArray[5] := GetKeyValue(SpeedTableLine.FieldName("Time Group"), NameValueBuffer);
        CodeArray[6] := GetKeyValue(SpeedTableLine.FieldName("Paper Quality"), NameValueBuffer);
        if Evaluate(DecimalArray[1], GetKeyValue(SpeedTableLine.FieldName(Weight), NameValueBuffer)) then;
        if Evaluate(Signature, GetKeyValue(SpeedTableLine.FieldName(Signature), NameValueBuffer)) then;
        if Evaluate(DecimalArray[2], GetKeyValue(SpeedTableLine.FieldName("Formula 1"), NameValueBuffer)) then;
        if Evaluate(DecimalArray[3], GetKeyValue(SpeedTableLine.FieldName("Formula 2"), NameValueBuffer)) then;
        if Evaluate(DecimalArray[4], GetKeyValue(SpeedTableLine.FieldName("From Qty."), NameValueBuffer)) then;

        case SyncLogEntry.Type of
            SyncLogEntry.Type::Rename:
                begin
                    xCodeArray[1] := GetKeyValue(PrefixxRec + SpeedTableLine.FieldName("Speed Table"), NameValueBuffer);
                    xCodeArray[2] := GetKeyValue(PrefixxRec + SpeedTableLine.FieldName("Customer Group"), NameValueBuffer);
                    xCodeArray[3] := GetKeyValue(PrefixxRec + SpeedTableLine.FieldName("Product Group"), NameValueBuffer);
                    xCodeArray[4] := GetKeyValue(PrefixxRec + SpeedTableLine.FieldName("Format Code"), NameValueBuffer);
                    xCodeArray[5] := GetKeyValue(PrefixxRec + SpeedTableLine.FieldName("Time Group"), NameValueBuffer);
                    xCodeArray[6] := GetKeyValue(PrefixxRec + SpeedTableLine.FieldName("Paper Quality"), NameValueBuffer);
                    if Evaluate(xDecimalArray[1], GetKeyValue(PrefixxRec + SpeedTableLine.FieldName(Weight), NameValueBuffer)) then;
                    if Evaluate(xSignature, GetKeyValue(PrefixxRec + SpeedTableLine.FieldName(Signature), NameValueBuffer)) then;
                    if Evaluate(xDecimalArray[2], GetKeyValue(PrefixxRec + SpeedTableLine.FieldName("Formula 1"), NameValueBuffer)) then;
                    if Evaluate(xDecimalArray[3], GetKeyValue(PrefixxRec + SpeedTableLine.FieldName("Formula 2"), NameValueBuffer)) then;
                    if Evaluate(xDecimalArray[4], GetKeyValue(PrefixxRec + SpeedTableLine.FieldName("From Qty."), NameValueBuffer)) then;

                    SpeedTable.SetRange("Business Group Speed Table", xCodeArray[1]);
                    if SpeedTable.FindSet(false, false) then
                        repeat
                            if SpeedTableLine.Get(SpeedTable.Code, xCodeArray[2], xCodeArray[3], xCodeArray[4], xCodeArray[5], xCodeArray[6],
                                                  xDecimalArray[1], xSignature, xDecimalArray[2], xDecimalArray[3], xDecimalArray[4]) then
                                SpeedTableLine.Rename(SpeedTable.Code, CodeArray[2], CodeArray[3], CodeArray[4], CodeArray[5], CodeArray[6],
                                                      DecimalArray[1], Signature, DecimalArray[2], DecimalArray[3], DecimalArray[4]);
                        until SpeedTable.Next() = 0;
                end;
            SyncLogEntry.Type::Delete:
                begin
                    SpeedTable.SetRange("Business Group Speed Table", CodeArray[1]);
                    if SpeedTable.FindSet(false, false) then
                        repeat
                            if SpeedTableLine.Get(SpeedTable.Code, CodeArray[2], CodeArray[3], CodeArray[4], CodeArray[5], CodeArray[6],
                                                  DecimalArray[1], Signature, DecimalArray[2], DecimalArray[3], DecimalArray[4]) then
                                SpeedTable.Delete();
                        until SpeedTable.Next() = 0;
                end;
            SyncLogEntry.Type::Insert,
            SyncLogEntry.Type::Modify:
                begin
                    GetJsonRecordRef(SyncLogEntry, NewRecRef);
                    SpeedTable.SetRange("Business Group Speed Table", CodeArray[1]);
                    if SpeedTable.FindSet(false, false) then
                        repeat
                            if SpeedTableLine.Get(SpeedTable.Code, CodeArray[2], CodeArray[3], CodeArray[4], CodeArray[5], CodeArray[6],
                                                  DecimalArray[1], Signature, DecimalArray[2], DecimalArray[3], DecimalArray[4]) then begin
                                RecRef.GetTable(SpeedTableLine);
                                SyncProcessingManagement.CopyFields(RecRef, NewRecRef, false);
                                RecRef.SetTable(SpeedTableLine);
                                SpeedTableLine.Modify();
                            end else begin
                                RecRef.Close();
                                RecRef.Open(SyncLogEntry."Table No.");
                                RecRef.Init();
                                SyncProcessingManagement.CopyFields(RecRef, NewRecRef, true);
                                RecRef.SetTable(SpeedTableLine);
                                SpeedTableLine."Speed Table" := SpeedTable.Code;
                                SpeedTableLine.Insert(true);
                            end;
                        until SpeedTable.Next() = 0;
                end;
        end;
        exit(true); // Handled
    end;

    local procedure ProcessScrapTable(var SyncLogEntry: Record "PVS Sync Log Entry"; var NameValueBuffer: Record "Name/Value Buffer"): Boolean
    var
        ScrapTable: Record "PVS Scrap Table";
        NewRecRef: RecordRef;
        RecRef: RecordRef;
        OldCode: Code[20];
        ScrapTableCode: Code[20];
    begin
        // Primary Key: Code

        case SyncLogEntry.Type of
            SyncLogEntry.Type::Rename:
                begin
                    OldCode := GetKeyValue(PrefixxRec + ScrapTable.FieldName(Code), NameValueBuffer);
                    ScrapTableCode := GetKeyValue(ScrapTable.FieldName(Code), NameValueBuffer);

                    ScrapTable.SetRange("Business Group Scrap Table", OldCode);
                    ScrapTable.ModifyAll("Business Group Scrap Table", ScrapTableCode);
                end;
            SyncLogEntry.Type::Delete:
                begin
                    ScrapTableCode := GetKeyValue(ScrapTable.FieldName(Code), NameValueBuffer);

                    ScrapTable.SetRange("Business Group Scrap Table", ScrapTableCode);
                    ScrapTable.ModifyAll("Business Group Scrap Table", '');
                end;
            SyncLogEntry.Type::Modify:
                begin
                    GetJsonRecordRef(SyncLogEntry, NewRecRef);

                    SyncProcessingManagement.AddToSkipFieldList(ScrapTable.FieldNo("Business Group Scrap Table"), true);

                    ScrapTableCode := GetKeyValue(ScrapTable.FieldName(Code), NameValueBuffer);
                    ScrapTable.SetRange("Business Group Scrap Table", ScrapTableCode);
                    if ScrapTable.FindSet(true, false) then
                        repeat
                            RecRef.GetTable(ScrapTable);
                            SyncProcessingManagement.CopyFields(RecRef, NewRecRef, false);
                            RecRef.SetTable(ScrapTable);
                            ScrapTable.Modify();
                        until ScrapTable.Next() = 0;

                end;
        end;
        exit(true); // Handled
    end;

    local procedure ProcessScrapTableLine(var SyncLogEntry: Record "PVS Sync Log Entry"; var NameValueBuffer: Record "Name/Value Buffer"): Boolean
    var
        ScrapTable: Record "PVS Scrap Table";
        ScrapTableLine: Record "PVS Scrap Table Line";
        NewRecRef: RecordRef;
        RecRef: RecordRef;
        CodeArray: array[4] of Code[50];
        xCodeArray: array[4] of Code[50];
        DecimalArray: array[3] of Decimal;
        xDecimalArray: array[3] of Decimal;
        IntegerArray: array[3] of Integer;
        xIntegerArray: array[3] of Integer;
    begin
        // Primary Key: Scrap Table,Product Group,Format Code,Scrap Group,No. of Runs,Weight,From Signature Quantity,Formula 1,Formula 2,From Quantity

        CodeArray[1] := GetKeyValue(ScrapTableLine.FieldName("Scrap Table"), NameValueBuffer);
        CodeArray[2] := GetKeyValue(ScrapTableLine.FieldName("Product Group"), NameValueBuffer);
        CodeArray[3] := GetKeyValue(ScrapTableLine.FieldName("Format Code"), NameValueBuffer);
        CodeArray[4] := GetKeyValue(ScrapTableLine.FieldName("Scrap Group"), NameValueBuffer);
        if Evaluate(IntegerArray[1], GetKeyValue(ScrapTableLine.FieldName("No. Of Runs"), NameValueBuffer)) then;
        if Evaluate(IntegerArray[2], GetKeyValue(ScrapTableLine.FieldName(Weight), NameValueBuffer)) then;
        if Evaluate(IntegerArray[3], GetKeyValue(ScrapTableLine.FieldName("From Signature Qty."), NameValueBuffer)) then;
        if Evaluate(DecimalArray[1], GetKeyValue(ScrapTableLine.FieldName("Formula 1"), NameValueBuffer)) then;
        if Evaluate(DecimalArray[2], GetKeyValue(ScrapTableLine.FieldName("Formula 2"), NameValueBuffer)) then;
        if Evaluate(DecimalArray[3], GetKeyValue(ScrapTableLine.FieldName("From Qty."), NameValueBuffer)) then;

        case SyncLogEntry.Type of
            SyncLogEntry.Type::Rename:
                begin
                    xCodeArray[1] := GetKeyValue(PrefixxRec + ScrapTableLine.FieldName("Scrap Table"), NameValueBuffer);
                    xCodeArray[2] := GetKeyValue(PrefixxRec + ScrapTableLine.FieldName("Product Group"), NameValueBuffer);
                    xCodeArray[3] := GetKeyValue(PrefixxRec + ScrapTableLine.FieldName("Format Code"), NameValueBuffer);
                    xCodeArray[4] := GetKeyValue(PrefixxRec + ScrapTableLine.FieldName("Scrap Group"), NameValueBuffer);
                    if Evaluate(xIntegerArray[1], GetKeyValue(PrefixxRec + ScrapTableLine.FieldName("No. Of Runs"), NameValueBuffer)) then;
                    if Evaluate(xIntegerArray[2], GetKeyValue(PrefixxRec + ScrapTableLine.FieldName(Weight), NameValueBuffer)) then;
                    if Evaluate(xIntegerArray[3], GetKeyValue(PrefixxRec + ScrapTableLine.FieldName("From Signature Qty."), NameValueBuffer)) then;
                    if Evaluate(xDecimalArray[1], GetKeyValue(PrefixxRec + ScrapTableLine.FieldName("Formula 1"), NameValueBuffer)) then;
                    if Evaluate(xDecimalArray[2], GetKeyValue(PrefixxRec + ScrapTableLine.FieldName("Formula 2"), NameValueBuffer)) then;
                    if Evaluate(xDecimalArray[3], GetKeyValue(PrefixxRec + ScrapTableLine.FieldName("From Qty."), NameValueBuffer)) then;

                    ScrapTable.SetRange("Business Group Scrap Table", xCodeArray[1]);
                    if ScrapTable.FindSet(false, false) then
                        repeat
                            if ScrapTableLine.Get(ScrapTable.Code, xCodeArray[2], xCodeArray[3], xCodeArray[4],
                                                  xIntegerArray[1], xIntegerArray[2], xIntegerArray[3],
                                                  xDecimalArray[1], xDecimalArray[2], xDecimalArray[3]) then
                                ScrapTableLine.Rename(ScrapTable.Code, CodeArray[2], CodeArray[3], CodeArray[4],
                                                      IntegerArray[1], IntegerArray[2], IntegerArray[3],
                                                      DecimalArray[1], DecimalArray[2], DecimalArray[3]);
                        until ScrapTable.Next() = 0;
                end;
            SyncLogEntry.Type::Delete:
                begin
                    ScrapTable.SetRange("Business Group Scrap Table", CodeArray[1]);
                    if ScrapTable.FindSet(false, false) then
                        repeat
                            if ScrapTableLine.Get(ScrapTable.Code, CodeArray[2], CodeArray[3], CodeArray[4],
                                                  IntegerArray[1], IntegerArray[2], IntegerArray[3],
                                                  DecimalArray[1], DecimalArray[2], DecimalArray[3]) then
                                ScrapTable.Delete();
                        until ScrapTable.Next() = 0;
                end;
            SyncLogEntry.Type::Insert,
            SyncLogEntry.Type::Modify:
                begin
                    GetJsonRecordRef(SyncLogEntry, NewRecRef);
                    ScrapTable.SetRange("Business Group Scrap Table", CodeArray[1]);
                    if ScrapTable.FindSet(false, false) then
                        repeat
                            if ScrapTableLine.Get(ScrapTable.Code, CodeArray[2], CodeArray[3], CodeArray[4],
                                                  IntegerArray[1], IntegerArray[2], IntegerArray[3],
                                                  DecimalArray[1], DecimalArray[2], DecimalArray[3]) then begin
                                RecRef.GetTable(ScrapTableLine);
                                SyncProcessingManagement.CopyFields(RecRef, NewRecRef, false);
                                RecRef.SetTable(ScrapTableLine);
                                ScrapTableLine.Modify();
                            end else begin
                                RecRef.Close();
                                RecRef.Open(SyncLogEntry."Table No.");
                                RecRef.Init();
                                SyncProcessingManagement.CopyFields(RecRef, NewRecRef, true);
                                RecRef.SetTable(ScrapTableLine);
                                ScrapTableLine."Scrap Table" := ScrapTable.Code;
                                ScrapTableLine.Insert(true);
                            end;
                        until ScrapTable.Next() = 0;
                end;
        end;
        exit(true); // Handled
    end;

    local procedure ProcessCalcUnitSetup(var SyncLogEntry: Record "PVS Sync Log Entry"; var NameValueBuffer: Record "Name/Value Buffer"): Boolean
    var
        CalculationUnitSetup: Record "PVS Calculation Unit Setup";
        NewRecRef: RecordRef;
        RecRef: RecordRef;
        CalculationUnitSetupCode: Code[20];
        OldCode: Code[20];
        UnitType: Integer;
    begin
        // Primary Key: Type, Code

        if not Evaluate(UnitType, GetKeyValue(CalculationUnitSetup.FieldName(Type), NameValueBuffer)) then
            Error(IncorrectType);

        case SyncLogEntry.Type of
            SyncLogEntry.Type::Rename:
                begin
                    OldCode := GetKeyValue(PrefixxRec + CalculationUnitSetup.FieldName(Code), NameValueBuffer);
                    CalculationUnitSetupCode := GetKeyValue(CalculationUnitSetup.FieldName(Code), NameValueBuffer);

                    CalculationUnitSetup.SetRange(Type, UnitType);
                    CalculationUnitSetup.SetRange("Business Group Calc. Unit", OldCode);
                    CalculationUnitSetup.ModifyAll("Business Group Calc. Unit", CalculationUnitSetupCode);
                end;
            SyncLogEntry.Type::Delete:
                begin
                    CalculationUnitSetupCode := GetKeyValue(CalculationUnitSetup.FieldName(Code), NameValueBuffer);

                    CalculationUnitSetup.SetRange(Type, UnitType);
                    CalculationUnitSetup.SetRange("Business Group Calc. Unit", CalculationUnitSetupCode);
                    CalculationUnitSetup.ModifyAll("Business Group Calc. Unit", '');
                end;
            SyncLogEntry.Type::Modify:
                begin
                    GetJsonRecordRef(SyncLogEntry, NewRecRef);

                    SyncProcessingManagement.AddToSkipFieldList(CalculationUnitSetup.FieldNo("Business Group Calc. Unit"), true);

                    CalculationUnitSetupCode := GetKeyValue(CalculationUnitSetup.FieldName(Code), NameValueBuffer);
                    CalculationUnitSetup.SetRange(Type, UnitType);
                    CalculationUnitSetup.SetRange("Business Group Calc. Unit", CalculationUnitSetupCode);
                    if CalculationUnitSetup.FindSet(true, false) then
                        repeat
                            RecRef.GetTable(CalculationUnitSetup);
                            SyncProcessingManagement.CopyFields(RecRef, NewRecRef, false);
                            RecRef.SetTable(CalculationUnitSetup);
                            CalculationUnitSetup.Modify();
                        until CalculationUnitSetup.Next() = 0;

                end;
        end;
        exit(true); // Handled
    end;

    local procedure ProcessCalcUnitSetupDetail(var SyncLogEntry: Record "PVS Sync Log Entry"; var NameValueBuffer: Record "Name/Value Buffer"): Boolean
    var
        CalculationUnitSetup: Record "PVS Calculation Unit Setup";
        CalculationUnitSetupDetail: Record "PVS Calc. Unit Setup Detail";
        NewRecRef: RecordRef;
        RecRef: RecordRef;
        CalculationUnitSetupCode: Code[20];
        OldCode: Code[20];
        EntryNo: Integer;
        UnitType: Integer;
    begin
        // Primary Key: Unit Type,Unit,Entry No.

        if not Evaluate(UnitType, GetKeyValue(CalculationUnitSetupDetail.FieldName("Unit Type"), NameValueBuffer)) then
            Error(IncorrectType);

        case SyncLogEntry.Type of
            SyncLogEntry.Type::Insert,
            SyncLogEntry.Type::Modify:
                begin
                    GetJsonRecordRef(SyncLogEntry, NewRecRef);

                    CalculationUnitSetupCode := GetKeyValue(CalculationUnitSetupDetail.FieldName(Unit), NameValueBuffer);
                    if not Evaluate(EntryNo, GetKeyValue(CalculationUnitSetupDetail.FieldName("Entry No."), NameValueBuffer)) then
                        Error(IncorrectEntryNo);

                    CalculationUnitSetup.SetRange(Type, UnitType);
                    CalculationUnitSetup.SetRange("Business Group Calc. Unit", CalculationUnitSetupCode);
                    if CalculationUnitSetup.FindSet(false, false) then begin
                        CalculationUnitSetupDetail.SetRange("Unit Type", UnitType);
                        CalculationUnitSetupDetail.SetRange(Unit, CalculationUnitSetup.Code);
                        CalculationUnitSetupDetail.SetRange("Entry No.", EntryNo);
                        if CalculationUnitSetupDetail.FindSet(true, false) then
                            repeat
                                RecRef.GetTable(CalculationUnitSetupDetail);
                                SyncProcessingManagement.CopyFields(RecRef, NewRecRef, false);
                                RecRef.SetTable(CalculationUnitSetupDetail);
                                CalculationUnitSetupDetail.Modify();
                            until CalculationUnitSetupDetail.Next() = 0
                        else begin

                            RecRef.Close();
                            RecRef.Open(SyncLogEntry."Table No.");
                            RecRef.Init();
                            SyncProcessingManagement.CopyFields(RecRef, NewRecRef, false);
                            RecRef.SetTable(CalculationUnitSetupDetail);
                            CalculationUnitSetupDetail."Cost Center Code" := CalculationUnitSetup."Cost Center Code";
                            CalculationUnitSetupDetail.Configuration := CalculationUnitSetup.Configuration;
                            CalculationUnitSetupDetail.Unit := CalculationUnitSetup.Code;
                            CalculationUnitSetupDetail."Entry No." := EntryNo;
                            if CalculationUnitSetupDetail.Insert(true) then;
                        end;
                    end;
                end;
        end;
        exit(true); // Handled
    end;

    local procedure ProcessCalcUnitSetupGroup(var SyncLogEntry: Record "PVS Sync Log Entry"; var NameValueBuffer: Record "Name/Value Buffer"): Boolean
    var
        CalculationUnitSetup: Record "PVS Calculation Unit Setup";
        CalculationUnitSetup2: Record "PVS Calculation Unit Setup";
        CalculationUnitSetupGroup: Record "PVS Calc. Unit Setup Group";
        NewRecRef: RecordRef;
        RecRef: RecordRef;
        CalculationUnitSetupCode: Code[20];
        OldCode: Code[20];
        EntryNo: Integer;
        UnitType: Integer;
    begin
        // Primary Key: Type,BOM Code,Entry No.

        if not Evaluate(UnitType, GetKeyValue(CalculationUnitSetupGroup.FieldName(Type), NameValueBuffer)) then
            Error(IncorrectType);

        case SyncLogEntry.Type of
            SyncLogEntry.Type::Insert,
            SyncLogEntry.Type::Modify:
                begin
                    GetJsonRecordRef(SyncLogEntry, NewRecRef);

                    CalculationUnitSetupCode := GetKeyValue(CalculationUnitSetupGroup.FieldName("BOM Code"), NameValueBuffer);
                    if not Evaluate(EntryNo, GetKeyValue(CalculationUnitSetupGroup.FieldName("Entry No."), NameValueBuffer)) then
                        Error(IncorrectEntryNo);

                    CalculationUnitSetup.SetRange(Type, UnitType);
                    CalculationUnitSetup.SetRange("Business Group Calc. Unit", CalculationUnitSetupCode);
                    if CalculationUnitSetup.FindSet(false, false) then begin
                        CalculationUnitSetupGroup.SetRange(Type, UnitType);
                        CalculationUnitSetupGroup.SetRange("BOM Code", CalculationUnitSetup.Code);
                        CalculationUnitSetupGroup.SetRange("Entry No.", EntryNo);
                        if CalculationUnitSetupGroup.FindSet(true, false) then
                            repeat
                                RecRef.GetTable(CalculationUnitSetupGroup);
                                SyncProcessingManagement.CopyFields(RecRef, NewRecRef, false);
                                RecRef.SetTable(CalculationUnitSetupGroup);
                                CalculationUnitSetup2.SetRange(Type, UnitType);
                                CalculationUnitSetup2.SetRange("Business Group Calc. Unit", CalculationUnitSetupGroup."Unit Code");
                                if CalculationUnitSetup2.FindFirst() then begin // Could be multiple, no other solution then pick first found
                                    CalculationUnitSetupGroup."Unit Code" := CalculationUnitSetup2.Code;
                                    CalculationUnitSetupGroup.Modify();
                                end;
                            until CalculationUnitSetupGroup.Next() = 0;
                    end;
                end;
        end;
        exit(true); // Handled
    end;
}

