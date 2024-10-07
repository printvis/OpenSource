pageextension 80180 "PTE Job" extends "PVS Job Card"
{
    actions
    {
        addafter("Product Parts")
        {
            action(Split)
            {
                Caption = 'Split Production';
                Image = Split;

                trigger OnAction()
                var
                    SplitPage: Page "PTE Job Split";

                begin
                    SplitPage.SetJob(Rec);
                    SplitPage.RunModal();
                end;
            }
            action(Prepare)
            {
                Caption = 'Prepare Job for Split Production';
                Image = AdjustEntries;

                trigger OnAction()
                var
                    OrderRec: Record "PVS Case";
                    PrepareMgt: Codeunit "PTE Prepare Job";
                begin
                    OrderRec.get(Rec.ID);
                    OrderRec.TestField(Type, OrderRec.Type::"Production Order");

                    PrepareMgt.PrepareJob(Rec);
                end;
            }
            /*
            action(ResetSplit)
            {
                Caption = 'Reset Split Production';
                Image = SplitChecks;

                trigger OnAction()
                var
                    SplitMgt: Codeunit "PTE Split Mgt";
                begin
                    SplitMgt.Reset_SplitOrders(ID);
                end;
            }
            */
        }
    }

    trigger OnOpenPage()
    begin
        //    Rec.SetRange(ID, 290);
        //    message('KT Test');
    end;

}