namespace PrintVis.BoldSign.Extensions;

using PrintVis.BoldSign.Documents;

pageextension 80303 "PVS BS Case Management" extends "PVS Case Management"
{
    layout
    {
        addlast(factboxes)
        {
            part("PVS BS Case Docs. FactBox"; "PVS BS Case Docs. FactBox")
            {
                ApplicationArea = All;
                Caption = 'BoldSign Documents';
                SubPageLink = ID = field(ID);
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            group("PVS BS PVS BS")
            {
                Caption = 'BoldSign';
                ShowAs = SplitButton;

                action("PVS BS Documents")
                {
                    ApplicationArea = All;
                    Caption = 'BoldSign Documents';
                    Image = Documents;
                    RunObject = page "PVS BS Document List";
                    RunPageLink = "Case ID" = field(ID);
                }
            }
        }
    }
}