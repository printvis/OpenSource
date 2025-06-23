codeunit 80263 "PTE CIM 1 - UPG Functions"
{
    var
        IsPVSCIMInstalled: Boolean;
        PVSCIMIDLbl: Label 'FE465AD6-34B0-46B0-A1E2-23B28DB843D2', Locked = true;

        isPTECIMInstalled: Boolean;
        PTECIMIDLbl: Label '5452f323-059e-499a-9753-5d2c07eef904', Locked = true;

        APPIntegrationNameLbl: Label 'PrintVis CIM', Locked = true;
        TableNoCIMController: Integer;
        TableNoCIMDevice: Integer;
        TableNoCostCenter: Integer;

    local procedure IsCIMInstalled(): Boolean
    begin
        if IsPVSCIMInstalled or isPTECIMInstalled then
            exit(true);
        if IsPrintVisCIMinstalled() then
            exit(true);
        if IsPTEPrintVisCIMinstalled() then
            exit(true);
    end;

    local procedure IsPTEPrintVisCIMinstalled(): Boolean
    var
        ModuleInfo: ModuleInfo;
    begin
        if not NavApp.GetModuleInfo(PTECIMIDLbl, ModuleInfo) then
            exit(false);
        if ModuleInfo.Name <> APPIntegrationNameLbl then
            exit(false);

        isPTECIMInstalled := true;
        TableNoCIMController := 75915;
        TableNoCIMDevice := 75916;
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
        if not IsCIMInstalled() then
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
        if not IsCIMInstalled() then
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
        if not IsCIMInstalled() then
            exit;
        if MoveIntoPrintVis then begin
            TableNoFromInt := Database::"PTE CIM 1 Upg. TT. Cost Center";
            TableNoToInt := TableNoCostCenter;
        end
        else begin
            TableNoFromInt := TableNoCostCenter;
            TableNoToInt := Database::"PTE CIM 1 Upg. TT. Cost Center";
        end;
        LoopTableAndMoveData(TableNoFromInt, TableNoToInt, InsertAllowed, ModifyAllowed);
    end;

    local procedure LoopTableAndMoveData(in_TableNoFromInt: Integer; in_TableNoToInt: Integer; InsertAllowed: Boolean; ModifyAllowed: Boolean)
    var
        FieldFromRec: Record Field;
        FieldToRec: Record Field;
        fromRecRef: RecordRef;
        toRecRef: RecordRef;
    begin
        if not IsCIMInstalled() then
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
                if FieldFromRec.FindSet() then
                    repeat
                        FieldToRec.SetRange(TableNo, in_TableNoToInt);
                        FieldToRec.SetRange("No.", FieldFromRec."No.");
                        FieldToRec.SetRange(FieldName, FieldFromRec.FieldName);
                        FieldToRec.SetFilter(ObsoleteState, '<>%1', FieldToRec.ObsoleteState::Removed);
                        if FieldToRec.IsEmpty() then
                            FieldToRec.SetRange("No.");
                        if FieldToRec.IsEmpty() then begin
                            FieldToRec.SetRange("No.", FieldFromRec."No.");
                            FieldToRec.SetRange(FieldName);
                        end;
                        if not FieldToRec.isEmpty() then
                            TransferField(FieldFromRec, fromRecRef, toRecRef);
                    until FieldFromRec.Next() = 0;
                if InsertAllowed then
                    toRecRef.Insert(false);
                if ModifyAllowed then
                    toRecRef.Modify(false);
            until fromRecRef.Next() = 0;
    end;

    local procedure TransferField(toFieldRec: Record Field; var fromRecRef: RecordRef; var toRecRef: RecordRef)
    var
        fromFieldRef: FieldRef;
        toFieldRef: FieldRef;
    begin
        fromFieldRef := fromRecRef.Field(toFieldRec."No.");
        toFieldRef := toRecRef.Field(toFieldRec."No.");
        toFieldRef.Value := fromFieldRef.Value;
    end;

    procedure UpdatePVSCIMSystemJDFEnumValueInControllerTable()
    var
        FieldRec: FieldRef;
        toRecRef: RecordRef;
        TableNoToInt: Integer;
        EnumValue: Integer;
    begin
        if not IsCIMInstalled() then
            exit;

        TableNoToInt := TableNoCIMController;
        toRecRef.Open(TableNoToInt);
        if not toRecRef.FieldExist(50) then
            exit;


        if toRecRef.FindSet(true) then
            repeat
                FieldRec := toRecRef.Field(50);
                if Evaluate(EnumValue, format(FieldRec.Value())) then
                    if EnumValue = 0 then begin
                        FieldRec.Value := EnumValue + 1;
                        toRecRef.Modify(true);
                    end;
            until toRecRef.Next() = 0;
    end;
}