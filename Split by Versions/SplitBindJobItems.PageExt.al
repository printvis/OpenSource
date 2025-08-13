pageextension 80280 "Split Bind Job Items" extends "PVS Job Items ListPart"
{
    layout
    {
        addafter(ComponentType)
        {
            field("Split Version"; Rec."Split Version")
            {
                ApplicationArea = All;
                ToolTip = 'The split version of the job item.';
                Editable = false;
            }
        }
    }
    actions
    {
        addafter("<Action34>")
        {
            action("SplitBindSplit")
            {
                ApplicationArea = All;
                Caption = 'Split by Version';
                Image = New;
                ToolTip = 'This action will split the selected job item into multiple job items, one for each version.';
                trigger OnAction()
                var
                    VersionRec: Record "PVS Job Text Description";
                    VersionRec2: Record "PVS Job Text Description";
                    NewJobItem: Record "PVS Job Item";
                    PageMgt: Codeunit "PVS Page Management";
                    PickVersions: Page "Split Bind Versions";
                    CopySheet: Codeunit "PVS Copy Sheet";
                    AdditionalVersion: Boolean;
                    Common: Boolean;
                    CALC_LIST: Code[20];
                    EntryNo: Integer;
                    View: Text[250];
                begin
                    AdditionalVersion := false;
                    EntryNo := 10000;
                    VersionRec.SetRange("ID", Rec."ID");
                    VersionRec.SetRange("Job", Rec."Job");
                    VersionRec.SetRange("Version", Rec."Version");
                    VersionRec.SetFilter("Type", 'Product Parts');
                    Common := Dialog.Confirm('Is this a common text being split?');
                    PickVersions.SetTableView(VersionRec);
                    PickVersions.LookupMode(true);
                    if PickVersions.RunModal() = Action::LookupOK then begin
                        PickVersions.SetSelectionFilter(VersionRec2);
                        if VersionRec2.FindSet() then
                            repeat
                                If AdditionalVersion = true then begin
                                    Clear(CopySheet);
                                    CopySheet.Set(Rec, false);
                                    CopySheet.Run();
                                    NewjobItem.Reset();
                                    NewJobItem.SetRange("ID", Rec."ID");
                                    NewJobItem.SetRange("Job", Rec."Job");
                                    NewJobItem.SetRange("Version", Rec."Version");
                                    NewJobItem.SetCurrentKey("Job Item No.");
                                    NewJobItem.Ascending(false);
                                    if NewJobItem.FindFirst() then begin
                                        NewJobItem.Quantity := VersionRec2.Quantity;
                                        NewJobItem."Split Version" := VersionRec2.Text;
                                        NewJobItem."Common Text" := Common;
                                        NewJobItem."Job Item No. 2" := Rec."Job Item No. 2";
                                        NewJobItem."Additional Version" := AdditionalVersion;
                                        NewJobItem.Modify(true);
                                        NewJobItem.CalcFields(NewJobItem."Controlling Sheet Unit");
                                        PageMgt.Job_Item_Input_Unit(NewJobItem, NewJobItem."Controlling Sheet Unit");
                                    end;
                                end else begin
                                    Rec.Quantity := VersionRec2.Quantity;
                                    Rec."Additional Version" := AdditionalVersion;
                                    Rec."Split Version" := VersionRec2.Text;
                                    Rec."Common Text" := Common;
                                    Rec.Modify(true);
                                    Rec.CalcFields(Rec."Controlling Sheet Unit");
                                    PageMgt.Job_Item_Input_Unit(Rec, Rec."Controlling Sheet Unit");
                                end;
                                AdditionalVersion := true;
                            until VersionRec2.Next() = 0;
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }
}