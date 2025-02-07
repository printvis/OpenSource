Page 80200 "PVS Sync Table Setup"
{
    ApplicationArea = All;
    Caption = 'PrintVis Sync Table Setup';
    DataCaptionExpression = Rec."Table Name";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "PVS Sync Table Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(TableNo; Rec."Table No.")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleExpression;
                }
                field(TableName; Rec."Table Name")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleExpression;
                }
                field(SyncActive; Rec."Sync Active")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleExpression;
                    ToolTip = 'When an Item Type Code has been selected, the desciption is presented here.';
                }
                field(SyncDirection; Rec."Sync Direction")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleExpression;
                }
                field(SkipValidateOnInsertModify; Rec."Skip Validate On Insert/Modify")
                {
                    ApplicationArea = All;
                    ToolTip = 'When an Item Type Code has been selected, the desciption is presented here.';
                }
                field("Skip Validate On Insert/Modify"; Rec."Skip Validate On Insert/Modify")
                {
                    ApplicationArea = All;
                    ToolTip = 'Skip Validate On Insert/Modify";"Skip Validate On Insert/Modify';
                }
                field(LinkedTo; Rec."Linked To")
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = StyleExpression;
                }
                field(SyncOrder; Rec."Sync Order")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleExpression;
                    ToolTip = 'When an Item Type Code has been selected, the desciption is presented here.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Fields)
            {
                ApplicationArea = All;
                Caption = 'Fields';
                Image = "Table";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    OpenFieldPage();
                end;
            }
            action("Field Mapping")
            {
                ApplicationArea = All;
                Caption = 'Field Mapping';
                Image = SuggestField;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    ShowMappingPage();
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetStyle();
    end;

    trigger OnAfterGetRecord()
    begin
        SetStyle();
    end;

    var
        SyncChangeManagement: Codeunit "PVS Sync Change Management";
        [InDataSet]
        StyleExpression: Text;

    local procedure OpenFieldPage()
    var
        "Field": Record "Field";
    begin
        Field.FilterGroup(4);
        Field.SetRange(TableNo, Rec."Table No.");
        Field.FilterGroup(0);
        Page.RunModal(Page::"PVS Sync Field Setup", Field);
        Field.FilterGroup(4);
        Field.SetRange(TableNo);
        Field.FilterGroup(0);
    end;

    local procedure ShowMappingPage()
    var
        PVSSyncFieldMapping: Record "PVS Sync Field Mapping";
    begin
        PVSSyncFieldMapping.FilterGroup(4);
        PVSSyncFieldMapping.SetRange("Table No.", Rec."Table No.");
        PVSSyncFieldMapping.FilterGroup(0);
        Page.RunModal(Page::"PVS Sync Field Mapping", PVSSyncFieldMapping);
        PVSSyncFieldMapping.FilterGroup(4);
        PVSSyncFieldMapping.SetRange("Table No.");
        PVSSyncFieldMapping.FilterGroup(0);
    end;

    local procedure SetStyle()
    begin
        StyleExpression := 'Standard';
        if Rec."Linked To" <> 0 then
            StyleExpression := 'Subordinate'
        else
            if SyncChangeManagement.IsSystemTable(Rec."Table No.") then
                StyleExpression := 'StandardAccent'
            else
                if SyncChangeManagement.IsSpecialTable(Rec."Table No.") then
                    StyleExpression := 'Ambiguous';
    end;
}
