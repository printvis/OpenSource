pageextension 80181 "PTE Job Item Listpart" extends "PVS Job Items ListPart"
{
    layout
    {
        addafter(CALC_LIST)

        {
            field("PTE Controlling Sheet Text"; Rec."PTE Controlling Sheet Text")
            {
                ApplicationArea = all;
                ToolTip = 'Refers to the selected "List Of Units" Text/Description';
            }
        }
    }
    actions
    {
        addlast(processing)
        {

            action(PTEJobSignatures)
            {
                ApplicationArea = All;
                Caption = 'Job Signatures';
                Image = AccountingPeriods;
                ToolTip = 'Click to see Job Signatures';
                Visible = NotAdvancedCaseCard;
                trigger OnAction()
                var
                    PageMgt: Codeunit "PVS Page Management";
                begin
                    PageMgt.Call_Page_Job_PrintSignatures(Rec.ID, Rec.Job, Rec.Version);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        GSetup: Record "PVS General Setup";
    begin
        if GSetup.get('') then;
        NotAdvancedCaseCard := not GSetup."Use Advanced Case Card";
    end;

    trigger OnAfterGetRecord()
    begin
        rec.CalcFields("PTE Controlling Sheet Text");
    end;

    var
        NotAdvancedCaseCard: boolean;

}
