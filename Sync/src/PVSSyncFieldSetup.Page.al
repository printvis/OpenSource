Page 80203 "PVS Sync Field Setup"
{
    Caption = 'Sync Field Setup';
    DataCaptionExpression = Rec.TableName + ' ' + Rec.FieldName;
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Field";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(TableNo; Rec.TableNo)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(TableName; Rec.TableName)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(FieldName; Rec.FieldName)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Field Caption"; Rec."Field Caption")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Force Sync"; ForceSync)
                {
                    ApplicationArea = All;
                    Caption = 'Force Sync';

                    trigger OnValidate()
                    begin
                        if ForceSync then begin
                            Skip := false;
                            SkipIfNotEmpty := false;
                        end;
                        UpdateRec();
                    end;
                }
                field("Skip"; Skip)
                {
                    ApplicationArea = All;
                    Caption = 'Always Skip';

                    trigger OnValidate()
                    begin
                        if Skip then begin
                            ForceSync := false;
                            SkipIfNotEmpty := false;
                        end;
                        UpdateRec();
                    end;
                }
                field(SkipIfNotEmpty; SkipIfNotEmpty)
                {
                    ApplicationArea = All;
                    Caption = 'Skip if not Empty';

                    trigger OnValidate()
                    begin
                        if SkipIfNotEmpty then begin
                            ForceSync := false;
                            Skip := false;
                        end;
                        UpdateRec();
                    end;
                }
                field("Validate Field"; ValidateField)
                {
                    ApplicationArea = All;
                    Caption = 'Validate Field';

                    trigger OnValidate()
                    begin
                        UpdateRec();
                    end;
                }
                field("Convert to Local Currency"; ConvertToLocalCurr)
                {
                    ApplicationArea = All;
                    Caption = 'Convert to Local Currency';

                    trigger OnValidate()
                    begin
                        CheckDecimalField();
                        UpdateRec();
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Field Mapping")
            {
                ApplicationArea = All;
                Image = SuggestField;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Caption = 'Field Mapping';

                trigger OnAction()
                begin
                    ShowMappingPage();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        GetRec();
        TransFromRec();
    end;

    var
        SyncFieldSetup: Record "PVS Sync Field Setup";
        Selection: Option ForceSync,AlwaysSkip,SkipIfNotEmpty;
        ValidateField: Option No,Yes;
        ConvertToLocalCurr: Boolean;
        ForceSync: Boolean;
        Skip: Boolean;
        SkipIfNotEmpty: Boolean;
        ErrorNoDecimal: label 'This field is not a decimal field';

    local procedure UpdateRec()
    begin
        if ForceSync then
            Selection := Selection::ForceSync;
        if Skip then
            //Selection := Selection::SkipIfNotEmpty; //CHG01
            Selection := Selection::AlwaysSkip;       //CHG01
        if SkipIfNotEmpty then
            Selection := Selection::SkipIfNotEmpty;

        GetRec();
        TransToRec();
        if (Selection = Selection::ForceSync) and (SyncFieldSetup."Validate Field" = SyncFieldSetup."validate field"::No) and (not SyncFieldSetup."Convert to Local Currency") then begin
            if SyncFieldSetup.Delete() then;
        end else
            if not SyncFieldSetup.Modify() then
                SyncFieldSetup.Insert();
        TransFromRec();
    end;

    local procedure GetRec()
    begin
        if not SyncFieldSetup.Get(Rec.TableNo, Rec."No.") then begin
            SyncFieldSetup.Init();
            SyncFieldSetup."Table No." := Rec.TableNo;
            SyncFieldSetup."Field No." := Rec."No.";
        end;
    end;

    local procedure TransFromRec()
    begin
        Selection := SyncFieldSetup."Sync Mode";
        ForceSync := false;
        Skip := false;
        SkipIfNotEmpty := false;
        if Selection = Selection::ForceSync then
            ForceSync := true;
        if Selection = Selection::AlwaysSkip then
            Skip := true;
        if Selection = Selection::SkipIfNotEmpty then
            SkipIfNotEmpty := true;

        ValidateField := SyncFieldSetup."Validate Field";
        ConvertToLocalCurr := SyncFieldSetup."Convert to Local Currency";
    end;

    local procedure TransToRec()
    begin
        SyncFieldSetup."Sync Mode" := Selection;
        SyncFieldSetup."Validate Field" := ValidateField;
        SyncFieldSetup."Convert to Local Currency" := ConvertToLocalCurr;
    end;

    local procedure ShowMappingPage()
    var
        SyncFieldMapping: Record "PVS Sync Field Mapping";
    begin
        SyncFieldMapping.FilterGroup(4);
        SyncFieldMapping.SetRange("Table No.", Rec.TableNo);
        SyncFieldMapping.SetRange("Field No.", Rec."No.");
        SyncFieldMapping.FilterGroup(0);
        Page.RunModal(Page::"PVS Sync Field Mapping", SyncFieldMapping);
        SyncFieldMapping.FilterGroup(4);
        SyncFieldMapping.SetRange("Table No.");
        SyncFieldMapping.SetRange("Field No.");
        SyncFieldMapping.FilterGroup(0);
    end;

    local procedure CheckDecimalField()
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
    begin
        if not ConvertToLocalCurr then
            exit;

        if Rec.Type <> Rec.Type::Decimal then
            Error(ErrorNoDecimal);
    end;
}
