Codeunit 80203 "PVS Sync Json Exchange."
{

    trigger OnRun()
    begin
    end;

    var
        PVSBusinessCentralAPI: Codeunit "PVS Business Central API";
        DataTypeManagement: Codeunit "Data Type Management";
        TypeHelper: Codeunit "Type Helper";
        JSONManagement: Codeunit "JSON Management";
        SavexRef: RecordRef;
        ValidCharacters: Text;

    procedure ConvertSyncLogEntryToApiEntity(SyncLogEntry: Record "PVS Sync Log Entry") JsonApiEntry: Text
    var
        RecRef: RecordRef;
        JObject: JsonObject;
    begin
        DataTypeManagement.GetRecordRef(SyncLogEntry, RecRef);

        // Specification from http://[FQDN]:[PORT]/[INSTANCE]/api/printvis/multicompany/v2.0/$metadata#companies/syncLogEntries
        // <Property Name="Id" Type="Edm.Guid" Nullable="false"/>
        // <Property Name="Entry_No" Type="Edm.Int64"/>
        // <Property Name="Table_No" Type="Edm.Int32"/>
        // <Property Name="Type" Type="Edm.String"/>
        // <Property Name="Log_Type" Type="Edm.String"/>
        // <Property Name="Log_Field" Type="Edm.Int32"/>
        // <Property Name="Record_ID" Type="Edm.String"/>
        // <Property Name="Old_Record_ID" Type="Edm.String"/>
        // <Property Name="Created_DateTime" Type="Edm.DateTimeOffset"/>
        // <Property Name="Sorting_Order" Type="Edm.Int32"/>
        // <Property Name="Status" Type="Edm.String"/>
        // <Property Name="Retries_Remaining" Type="Edm.Int32"/>
        // <Property Name="Source_Business_Group" Type="Edm.String" MaxLength="20"/>
        // <Property Name="Destination_Business_Group" Type="Edm.String" MaxLength="20"/>
        // <Property Name="Record_Object" Type="Edm.String"/>
        // <Property Name="Record_Object_Size" Type="Edm.Int32"/>
        // <Property Name="Error_Message" Type="Edm.String"/>

        WriteFieldToJSON(JObject, 'Id', SyncLogEntry.FieldNo(ID), RecRef, false);
        WriteFieldToJSON(JObject, 'TableNo', SyncLogEntry.FieldNo("Table No."), RecRef, false);
        WriteFieldToJSON(JObject, 'Type', SyncLogEntry.FieldNo(Type), RecRef, false);
        WriteFieldToJSON(JObject, 'LogType', SyncLogEntry.FieldNo("Log Type"), RecRef, false);
        WriteFieldToJSON(JObject, 'LogField', SyncLogEntry.FieldNo("Log Field"), RecRef, false);
        if Format(SyncLogEntry."Record ID") <> '' then
            WriteFieldToJSON(JObject, 'RecordID', SyncLogEntry.FieldNo("Record ID"), RecRef, false);
        if Format(SyncLogEntry."Old Record ID") <> '' then
            WriteFieldToJSON(JObject, 'OldRecordID', SyncLogEntry.FieldNo("Old Record ID"), RecRef, false);
        WriteFieldToJSON(JObject, 'CreatedDateTime', SyncLogEntry.FieldNo("Created DateTime"), RecRef, false);
        WriteFieldToJSON(JObject, 'SortingOrder', SyncLogEntry.FieldNo("Sorting Order"), RecRef, false);
        WriteFieldToJSON(JObject, 'SourceBusinessGroup', SyncLogEntry.FieldNo("Source Business Group"), RecRef, false);
        WriteFieldToJSON(JObject, 'DestinationBusinessGroup', SyncLogEntry.FieldNo("Destination Business Group"), RecRef, false);
        if SyncLogEntry."Record Object".Hasvalue() then
            WriteFieldToJSON(JObject, 'RecordObject', SyncLogEntry.FieldNo("Record Object"), RecRef, true);
        if SyncLogEntry."Record Object Size" > 0 then
            WriteFieldToJSON(JObject, 'RecordObjectSize', SyncLogEntry.FieldNo("Record Object Size"), RecRef, false);

        JObject.WriteTo(JsonApiEntry);
    end;

    procedure ConvertRecordToJsonString(RecordVariant: Variant; DoCalcField: Boolean): Text
    var
        RecRef: RecordRef;
    begin
        DataTypeManagement.GetRecordRef(RecordVariant, RecRef);
        exit(ConvertRecordRefToJsonString(RecRef, DoCalcField));
    end;

    procedure ConvertRecordRefToJsonString(var RecRef: RecordRef; DoCalcField: Boolean) JsonRecRef: Text
    var
        JObject: JsonObject;
    begin
        ProcessRecordRef(JObject, RecRef, DoCalcField);
        JObject.WriteTo(JsonRecRef);
    end;

    procedure ConvertRecordToJsonObject(RecordVariant: Variant; DoCalcField: Boolean): JsonObject
    var
        RecRef: RecordRef;
    begin
        DataTypeManagement.GetRecordRef(RecordVariant, RecRef);
        exit(ConvertRecordRefToJsonObject(RecRef, DoCalcField));
    end;

    procedure ConvertRecordRefToJsonObject(var RecRef: RecordRef; DoCalcField: Boolean) JObject: JsonObject
    begin
        ProcessRecordRef(JObject, RecRef, DoCalcField);
    end;


    procedure ConvertMediaToJsonString(var TenantMedia: Record "Tenant Media") JsonMedia: Text
    var
        TenantMediaRef: RecordRef;
        JObject: JsonObject;
    begin
        if not TenantMedia.Content.Hasvalue() then
            exit('{}')
        else begin
            TenantMediaRef.GetTable(TenantMedia);
            WriteFieldToJSON(JObject, GetSafename(TenantMedia.FieldName(Content)), TenantMedia.FieldNo(Content), TenantMediaRef, true);
            JObject.WriteTo(JsonMedia);
        end;
    end;

    procedure ConvertJsonStringToRecord(var RecRef: RecordRef; JsonRecord: Text; TableNo: Integer; IsNewRecord: Boolean; IsTemporary: Boolean)
    begin
        if IsNewRecord then begin
            RecRef.Close();
            RecRef.Open(TableNo, IsTemporary);
            RecRef.Init();
        end;
        GetFieldsFromJson(RecRef, JsonRecord);
    end;

    procedure SetRecordxRef(xRecRef: RecordRef)
    begin
        // Delete function? Never Used?
        SavexRef := xRecRef;
    end;

    procedure LoadResponseJsonArray(ResponseJson: Text) CollectionCount: Integer
    var
        JsonArrayValue: Text;
    begin
        Clear(JSONManagement);
        JSONManagement.InitializeObject(ResponseJson);

        if JSONManagement.GetStringPropertyValueByName('value', JsonArrayValue) then begin
            JSONManagement.InitializeCollection(JsonArrayValue);
            CollectionCount := JSONManagement.GetCollectionCount();
        end;
    end;

    procedure LoadResponseJson(ResponseJson: Text)
    var
        JsonArrayValue: Text;
    begin
        Clear(JSONManagement);
        JSONManagement.InitializeObject(ResponseJson);
    end;

    procedure GetJsonObjectFromArray(ArrayIndex: Integer) JsonObjectText: Text
    begin
        JSONManagement.GetObjectFromCollectionByIndex(JsonObjectText, ArrayIndex);
    end;

    procedure GetJsonPropertyValueByName(PropertyName: Text) PropertyValue: Text
    begin
        JSONManagement.GetStringPropertyValueByName(PropertyName, PropertyValue);
    end;

    local procedure ProcessRecordRef(JObject: JsonObject; var RecRef: RecordRef; DoCalcField: Boolean)
    var
        "Field": Record "Field";
    begin
        Field.SetRange(TableNo, RecRef.Number());
        Field.SetFilter(ObsoleteState, '<>%1', Field.Obsoletestate::Removed);
        Field.SetRange(Class, Field.Class::Normal);
        if Field.FindSet(false) then
            repeat
                WriteFieldToJSON(JObject, GetSafename(Field.FieldName), Field."No.", RecRef, DoCalcField);
            until Field.Next() = 0;
    end;

    local procedure GetFieldsFromJson(var RecRef: RecordRef; JsonRecord: Text)
    var
        TempBlob: Record "PVS TempBlob" temporary;
        "Field": Record "Field";
        PVSBlobStorage: Codeunit "PVS Blob Storage";
        JsonObject: Codeunit "JSON Management";
        DateFormulaValue: DateFormula;
        RecordIDValue: RecordID;
        FldRef: FieldRef;
        JsonProperty: Variant;
        UserTimeZoneOffset: Duration;
        DateValue: Date;
        DateTimeValue: DateTime;
        TimeValue: Time;
        JsonPropertyText: Text;
        GuidValue: Guid;
        DecimalValue: Decimal;
        OptionNumber: Option;
        BooleanValue: Boolean;
    begin
        JsonObject.InitializeObject(JsonRecord);

        Field.SetRange(TableNo, RecRef.Number());
        Field.SetFilter(ObsoleteState, '<>%1', Field.Obsoletestate::Removed);
        Field.SetRange("No.", 0, 2000000000 - 1);
        Field.SetRange(Class, Field.Class::Normal);
        Field.SetFilter(Type, '<>%1&<>%2', Field.Type::Media, Field.Type::MediaSet);
        if Field.FindSet(false) then
            repeat
                FldRef := RecRef.Field(Field."No.");
                if JsonObject.GetStringPropertyValueByName(GetSafename(Field.FieldName), JsonPropertyText) then begin

                    case Lowercase(Format(FldRef.Type())) of
                        'guid':
                            begin
                                Evaluate(GuidValue, JsonPropertyText);
                                FldRef.Value := GuidValue;
                            end;
                        'option':
                            begin
                                Evaluate(OptionNumber, JsonPropertyText);
                                FldRef.Value := OptionNumber;
                            end;
                        'datetime':
                            begin
                                if JsonPropertyText = '' then
                                    FldRef.Value := 0DT
                                else begin
                                    Evaluate(DateTimeValue, JsonPropertyText);
                                    if TypeHelper.GetUserTimezoneOffset(UserTimeZoneOffset) then
                                        DateTimeValue += UserTimeZoneOffset;
                                    FldRef.Value := DateTimeValue;
                                end;
                            end;
                        'date':
                            begin
                                if JsonPropertyText = '' then
                                    FldRef.Value := 0DT
                                else begin
                                    Evaluate(DateValue, JsonPropertyText, 9);
                                    FldRef.Value := DateValue;
                                end;
                            end;
                        'time':
                            begin
                                if JsonPropertyText = '' then
                                    FldRef.Value := 0DT
                                else begin
                                    Evaluate(TimeValue, JsonPropertyText, 9);
                                    if TypeHelper.GetUserTimezoneOffset(UserTimeZoneOffset) then
                                        TimeValue += UserTimeZoneOffset;
                                    FldRef.Value := TimeValue;
                                end;
                            end;
                        'blob', 'binary':
                            if JsonPropertyText <> '' then begin
                                PVSBlobStorage.FromBase64String(TempBlob, JsonPropertyText);
                                FldRef.Value := TempBlob.Blob;
                            end;
                        'boolean':
                            begin
                                Evaluate(BooleanValue, JsonPropertyText);
                                FldRef.Value := BooleanValue;
                            end;
                        'recordid':
                            begin
                                Evaluate(RecordIDValue, PVSBusinessCentralAPI.ConvertValueFromBase64(JsonPropertyText), 9);
                                FldRef.Value := RecordIDValue;
                            end;
                        'dateformula':
                            begin
                                Evaluate(DateFormulaValue, JsonPropertyText);
                                FldRef.Value := DateFormulaValue;
                            end;
                        'decimal':
                            begin
                                if StrPos(Format(1 / 2), '.') > 0 then begin
                                    if Evaluate(DecimalValue, ConvertStr(JsonPropertyText, ',', '.')) then;
                                end else begin
                                    if Evaluate(DecimalValue, ConvertStr(JsonPropertyText, '.', ',')) then;
                                end;
                                FldRef.Value := DecimalValue;
                            end;
                        else begin
                            FldRef.Value := JsonPropertyText;
                        end;
                    end;
                end;
            until Field.Next() = 0;
    end;

    local procedure WriteFieldToJSON(JObject: JsonObject; propertyName: Text; TargetFieldNumber: Integer; var TargetRecordRef: RecordRef; DoCalcField: Boolean)
    var
        TempBlob: Record "PVS TempBlob" temporary;
        TargetFieldRef: FieldRef;
        ValueVariant: Variant;
        DateValue: Date;
        DateTimeValue: DateTime;
        TimeValue: Time;
        Base64String: Text;
        OptionTextValue: Text;
        GuidValue: Guid;
        DecimalValue: Decimal;
        OldLangId: Integer;
        OptionNumber: Integer;
        IsNullValue: Boolean;
        PVSBlobStorage: Codeunit "PVS Blob Storage";
    begin
        TargetFieldRef := TargetRecordRef.Field(TargetFieldNumber);
        ValueVariant := TargetFieldRef.Value();

        case Lowercase(Format(TargetFieldRef.Type())) of
            'guid':
                begin
                    GuidValue := TargetFieldRef.Value();
                    ValueVariant := Lowercase(GetIdWithoutBrackets(GuidValue));
                end;
            'option':
                begin
                    OptionNumber := TargetFieldRef.Value();
                    ValueVariant := OptionNumber;
                end;
            'datetime':
                begin
                    DateTimeValue := TargetFieldRef.Value();
                    ValueVariant := DateTimeValue;
                    IsNullValue := DateTimeValue = 0DT;
                end;
            'date':
                begin
                    DateValue := TargetFieldRef.Value();
                    ValueVariant := DateValue;
                    IsNullValue := DateValue = 0D;
                end;
            'time':
                begin
                    TimeValue := TargetFieldRef.Value();
                    ValueVariant := TimeValue;
                    IsNullValue := TimeValue = 0T;
                end;
            'decimal':
                begin
                    DecimalValue := TargetFieldRef.Value();
                    ValueVariant := Format(DecimalValue, 0, 9);
                end;
            'blob', 'binary':
                begin

                    if DoCalcField then
                        TargetFieldRef.CalcField();
                    TempBlob.Blob := TargetFieldRef.Value();
                    if not TempBlob.Blob.Hasvalue() then begin
                        TargetFieldRef.CalcField();
                        TempBlob.Blob := TargetFieldRef.Value();
                    end;
                    Base64String := PVSBlobStorage.ToBase64String(TempBlob);
                    ValueVariant := Base64String;
                    IsNullValue := (Base64String = '');
                end;
            'recordid':
                begin
                    OldLangId := GlobalLanguage();
                    GlobalLanguage(1033);
                    Base64String := FORMAT(TargetFieldRef.VALUE, 0, 9);
                    ValueVariant := PVSBusinessCentralAPI.ConvertValueToBase64(Format(Base64String, 0, 0));
                    GlobalLanguage(OldLangId);
                end;
        end;

        OnBeforeAddingFieldToJson(TargetRecordRef.Number(), TargetFieldNumber, ValueVariant);

        AddJPropertyToJObject(JObject, propertyName, ValueVariant);
    end;

    procedure GetSafename(RawName: Text) SafeName: Text
    begin
        if ValidCharacters = '' then
            SafeName := ConvertStr(RawName, '''"/\ ', '_____')
        else
            SafeName := DelChr(RawName, '=', DelChr(RawName, '=', ValidCharacters));
    end;

    local procedure GetOptionNoFromOptionString(OptionString: Text; OptionValue: Text): Integer
    var
        SingleValue: Text;
        CommaPos: Integer;
        OptionCount: Integer;
    begin
        while OptionString <> '' do begin
            CommaPos := StrPos(OptionString, ',');
            if CommaPos > 0 then begin
                SingleValue := CopyStr(OptionString, 1, CommaPos - 1);
                OptionString := CopyStr(OptionString, CommaPos + 1);
            end else begin
                SingleValue := OptionString;
                OptionString := '';
            end;
            if SingleValue = OptionValue then
                exit(OptionCount);
            OptionCount += 1;
        end;
    end;

    [TryFunction]
    local procedure TryGetOptionString(OptionNumber: Integer; OptionString: Text; var ReturnValue: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAddingFieldToJson(TableNo: Integer; FieldNo: Integer; var ValueVariant: Variant)
    begin
    end;

    procedure SetValidNameChars(ValidChars: Text)
    begin
        ValidCharacters := ValidChars;
    end;

    procedure AddJPropertyToJObject(var Variables: JsonObject; propertyName: Text; value: Variant)
    var
        boolValue: Boolean;
        intValue: Integer;
        decValue: Decimal;
    begin
        case true of
            value.IsInteger():
                begin
                    intValue := value;
                    Variables.Add(propertyName, intValue);
                end;
            value.IsDecimal():
                begin
                    decValue := value;
                    Variables.Add(propertyName, decValue);
                end;
            value.IsBoolean():
                begin
                    boolValue := value;
                    Variables.Add(propertyName, boolValue);
                end;
            else
                Variables.Add(propertyName, Format(value, 0, 9));
        end;
    end;

    local procedure GetIdWithoutBrackets(Id: Guid): Text
    begin
        exit(CopyStr(Format(Id), 2, StrLen(Format(Id)) - 2));
    end;
}

