codeunit 80263 "PTE CIM 1 - UPG Functions"
{
    var
        IsPVSCIMInstalled: Boolean;
        PVSCIMIDLbl: Label 'FE465AD6-34B0-46B0-A1E2-23B28DB843D2', Locked = true;

        isPTECIMInstalled: Boolean;
        PTECIMIDLbl: Label '14c66b9c-4ebe-4f20-a46f-b3a31c219d2c', Locked = true;

        APPIntegrationNameLbl: Label 'PrintVis CIM', Locked = true;
        TableNoCIMController: Integer;
        TableNoCIMDevice: Integer;
        TableNoCostCenter: Integer;

    local procedure IsCIMInstalled(MoveIntoPrintVis: Boolean): Boolean
    begin
        if IsPVSCIMInstalled or isPTECIMInstalled then
            exit(true);
        if IsPrintVisCIMinstalled() then
            exit(true);
        if IsPTEPrintVisCIMinstalled(MoveIntoPrintVis) then
            exit(true);
    end;

    local procedure IsPTEPrintVisCIMinstalled(MoveIntoPrintVis: Boolean): Boolean
    var
        ModuleInfo: ModuleInfo;
    begin
        if not NavApp.GetModuleInfo(PTECIMIDLbl, ModuleInfo) then
            exit(false);
        if ModuleInfo.Name <> APPIntegrationNameLbl then
            exit(false);

        isPTECIMInstalled := true;
        if not MoveIntoPrintVis then begin
            TableNoCIMController := 75915;
            TableNoCIMDevice := 75916;
        end
        else begin
            TableNoCIMController := 6010915;
            TableNoCIMDevice := 6010916;
        end;
        TableNoCostCenter := 6010347;
        exit(isPTECIMInstalled);
    end;

    local procedure IsPrintVisCIMinstalled(): Boolean
    var
        ModuleInfo: ModuleInfo;
    begin
        if not NavApp.GetModuleInfo(PVSCIMIDLbl, ModuleInfo) then
            exit(false);
        if ModuleInfo.Name <> APPIntegrationNameLbl then
            exit(false);

        IsPVSCIMInstalled := true;
        TableNoCIMController := 6010915;
        TableNoCIMDevice := 6010916;
        TableNoCostCenter := 6010347;
        exit(IsPVSCIMInstalled);
    end;

    procedure MoveControllerToTable(MoveIntoPrintVis: Boolean; InsertAllowed: Boolean; ModifyAllowed: Boolean)
    var
        TableNoFromInt: Integer;
        TableNoToInt: Integer;
    begin
        if not IsCIMInstalled(MoveIntoPrintVis) then
            exit;
        if MoveIntoPrintVis then begin
            TableNoFromInt := Database::"PTE CIM 1 Upg. TT. Controller";
            TableNoToInt := TableNoCIMController;
        end
        else begin
            TableNoFromInt := TableNoCIMController;
            TableNoToInt := Database::"PTE CIM 1 Upg. TT. Controller";
        end;
        LoopTableAndMoveData(TableNoFromInt, TableNoToInt, InsertAllowed, ModifyAllowed);
    end;

    procedure MoveDeviceToTable(MoveIntoPrintVis: Boolean; InsertAllowed: Boolean; ModifyAllowed: Boolean)
    var
        TableNoFromInt: Integer;
        TableNoToInt: Integer;
    begin
        if not IsCIMInstalled(MoveIntoPrintVis) then
            exit;
        if MoveIntoPrintVis then begin
            TableNoFromInt := Database::"PTE CIM 1 Upg. TT Device";
            TableNoToInt := TableNoCIMDevice;
        end
        else begin
            TableNoFromInt := TableNoCIMDevice;
            TableNoToInt := Database::"PTE CIM 1 Upg. TT Device";
        end;
        LoopTableAndMoveData(TableNoFromInt, TableNoToInt, InsertAllowed, ModifyAllowed);
    end;


    procedure MoveCostCenterFieldToTable(MoveIntoPrintVis: Boolean; InsertAllowed: Boolean; ModifyAllowed: Boolean)
    var
        TableNoFromInt: Integer;
        TableNoToInt: Integer;
    begin
        if not IsCIMInstalled(MoveIntoPrintVis) then
            exit;
        if MoveIntoPrintVis then
            exit;
        TableNoFromInt := TableNoCostCenter;
        TableNoToInt := Database::"PTE CIM 1 Upg. TT. Cost Center";
        LoopTableAndMoveData(TableNoFromInt, TableNoToInt, InsertAllowed, ModifyAllowed);
    end;

    local procedure LoopTableAndMoveData(in_TableNoFromInt: Integer; in_TableNoToInt: Integer; InsertAllowed: Boolean; ModifyAllowed: Boolean)
    var
        FieldFromRec: Record Field;
        FieldToRec: Record Field;
        fromRecRef: RecordRef;
        toRecRef: RecordRef;
    begin
        if not IsCIMInstalled(false) then
            exit;

        fromRecRef.Open(in_TableNoFromInt);
        toRecRef.Open(in_TableNoToInt);

        if fromRecRef.IsEmpty() then
            exit;

        if fromRecRef.FindSet(true) then
            repeat
                FieldFromRec.SetRange(TableNo, in_TableNoFromInt);
                FieldFromRec.SetFilter("No.", '..%1', 1999999999);
                FieldFromRec.SetFilter(ObsoleteState, '<>%1', FieldFromRec.ObsoleteState::Removed);
                FieldFromRec.SetFilter(Class, '<>%1', FieldFromRec.Class::FlowFilter);
                if FieldFromRec.FindSet() then
                    repeat
                        FieldToRec.SetFilter(ObsoleteState, '<>%1', FieldToRec.ObsoleteState::Removed);
                        FieldToRec.SetFilter(Class, '<>%1', FieldToRec.Class::FlowFilter);
                        FieldToRec.SetRange(Type, FieldFromRec.Type);
                        FieldToRec.SetRange(TableNo, in_TableNoToInt);
                        FieldToRec.SetRange("No.", FieldFromRec."No.");
                        if FieldToRec.IsEmpty() then
                            FieldToRec.SetRange("No.", FieldFromRec."No." + 75000);
                        if FieldToRec.IsEmpty() then
                            if FieldFromRec."No." = 75050 then
                                if isPTECIMInstalled then
                                    if in_TableNoFromInt = Database::"PVS Cost Center" then
                                        FieldToRec.SetRange("No.", 6010050);
                        if FieldToRec.FindFirst() then
                            TransferField(FieldFromRec, FieldToRec, fromRecRef, toRecRef);
                    until FieldFromRec.Next() = 0;
                if InsertAllowed then
                    if toRecRef.Insert(false) then;
                if ModifyAllowed then
                    if toRecRef.Modify(false) then;
            until fromRecRef.Next() = 0;
    end;

    local procedure TransferField(fromFieldRec: Record Field; toFieldRec: Record Field; var fromRecRef: RecordRef; var toRecRef: RecordRef)
    var
        fromFieldRef: FieldRef;
        toFieldRef: FieldRef;
    begin
        fromFieldRef := fromRecRef.Field(fromFieldRec."No.");
        toFieldRef := toRecRef.Field(toFieldRec."No.");
        toFieldRef.Value := fromFieldRef.Value;
    end;

    procedure UpdatePVSCIMSystemJDFEnumValueInControllerTable()
    var
        FieldRec: FieldRef;
        toRecRef: RecordRef;
        TableNoToInt: Integer;
        EnumValue: Integer;
        FieldNo: integer;
    begin
        if not IsCIMInstalled(true) then
            exit;

        TableNoToInt := TableNoCIMController;
        toRecRef.Open(TableNoToInt);
        FieldNo := 50;
        if isPTECIMInstalled then
            FieldNo += 75000;
        if not toRecRef.FieldExist(FieldNo) then
            exit;


        if toRecRef.FindSet(true) then
            repeat
                FieldRec := toRecRef.Field(FieldNo);
                if Evaluate(EnumValue, format(FieldRec.Value())) then
                    if EnumValue = 0 then begin
                        FieldRec.Value := EnumValue + 1;
                        toRecRef.Modify(true);
                    end;
            until toRecRef.Next() = 0;
    end;
}