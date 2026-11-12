namespace PrintVis.SpencerMetrics.CounterManagement;

page 80296 "PVS SM Assign To Job Costing"
{
    ApplicationArea = All;
    Caption = 'Assign Count to Job Costing Entry';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            group(CountInfo)
            {
                Caption = 'Count';
                field("Count Entry No."; CountEntryNo)
                {
                    Caption = 'Count Entry No.';
                    ToolTip = 'The Entry No. of the Count entry that will be added to the Job Costing Entry.';
                    Editable = false;
                }
                field("Count Cost Center"; CountCostCenterTxt)
                {
                    Caption = 'Count Cost Center';
                    ToolTip = 'The Cost Center of the Count entry that will be added to the Job Costing Entry.';
                    Editable = false;
                }
                field("Count Quantity"; CountQty)
                {
                    Caption = 'Count Quantity';
                    Editable = false;
                    ToolTip = 'Quantity from the Count entry that will be added to the Job Costing Entry.';
                }
            }

            group(JobCosting)
            {
                Caption = 'Job Costing';
                field(JobCostingEntryNo; JobCostingEntryNo)
                {
                    Caption = 'Job Costing Entry';
                    ToolTip = 'Choose a Job Costing Entry with the same Cost Center; entries with Type = Login are excluded.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        JobCostingEntry: Record "PVS Job Costing Entry";
                        ActionChosen: Action;
                    begin
                        JobCostingEntry.Reset();
                        if CountCostCenterTxt <> '' then
                            JobCostingEntry.SetRange("Cost Center Code", CountCostCenterTxt);
                        JobCostingEntry.SetFilter("Costing Type", '%1', JobCostingEntry."Costing Type"::Time);
                        ActionChosen := PAGE.RunModal(PAGE::"PVS Job Costing - Details", JobCostingEntry);
                        if ActionChosen = Action::LookupOK then begin
                            JobCostingEntryNo := JobCostingEntry."Entry No.";
                            Text := Format(JobCostingEntryNo);
                            exit(true);
                        end;

                        exit(false);
                    end;
                }
            }
        }
    }

    procedure SetContext(in_CounterEntry: Record "PVS SM Counter Entry")
    begin
        this.CounterEntry := in_CounterEntry;
    end;

    trigger OnOpenPage()
    begin
        this.CountEntryNo := this.CounterEntry."Entry No.";
        this.CountCostCenterTxt := this.CounterEntry."Cost Center Code";
        this.CountQty := this.CounterEntry."Difference Count";
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        JobCostingEntry: Record "PVS Job Costing Entry";
    begin
        if CloseAction <> Action::OK then
            exit(true);

        if JobCostingEntryNo = 0 then
            Error(SelectJobCostingEntryErr);

        if not JobCostingEntry.Get(JobCostingEntryNo) then
            Error(JobCostingEntryNotFoundErr, JobCostingEntryNo);

        if (CountCostCenterTxt <> '') and (JobCostingEntry."Cost Center Code" <> CountCostCenterTxt) then
            Error(CostCenterMismatchErr);

        JobCostingEntry.Validate("Quantity", JobCostingEntry."Quantity" + CountQty);
        JobCostingEntry.Modify(true);

        this.CounterEntry.Validate("Include In Job Costing", true);
        this.CounterEntry.Validate("Case ID", JobCostingEntry.ID);
        this.CounterEntry.Validate("Plan ID", JobCostingEntry."Plan ID");
        this.CounterEntry.Validate(UOM, JobCostingEntry.UOM);
        this.CounterEntry.Modify(true);

        exit(true);
    end;

    var
        CounterEntry: Record "PVS SM Counter Entry";
        CountEntryNo: BigInteger;
        CountCostCenterTxt: Code[20];
        CountQty: Integer;
        JobCostingEntryNo: Integer;
        CostCenterMismatchErr: Label 'Selected Job Costing Entry has a different Cost Center.';
        JobCostingEntryNotFoundErr: Label 'Job Costing Entry %1 was not found.', Comment = '%1 = Job Costing Entry No.';
        SelectJobCostingEntryErr: Label 'Please select a Job Costing Entry before clicking OK.';
}