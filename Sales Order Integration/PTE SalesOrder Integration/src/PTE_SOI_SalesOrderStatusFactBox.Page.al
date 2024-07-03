
Page 80101 "PTE SOI S.O. Status FactBox"
{
    Caption = 'PV Sales Order Status FactBox';
    PageType = CardPart;
    SourceTable = "Sales Header";

    layout
    {
        area(content)
        {
            field(NextStatusCode; Next_Status_Code)
            {
                ApplicationArea = All;
                Caption = 'Next Status Code';
                Editable = false;
            }
            field(SalespersonCode; Rec."Salesperson Code")
            {
                ApplicationArea = All;
            }
            field("PTE SOIPersonResponsible"; Rec."PTE SOI Person Responsible")
            {
                ApplicationArea = All;
                ToolTip = 'Displays the set current ''responsible person'' from the attached PrintVis Case, due to the current status.';
            }
            field("PTE SOICoordinator"; Rec."PTE SOI Coordinator")
            {
                ApplicationArea = All;
                ToolTip = 'Displays the set Coordinator from the attached PrintVis Case, to indicate who is in charge of the current job.';
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Next_Status_Code := SalesorderMgt.SalesHead_Get_Next_StatusTxt(Rec);
    end;

    var
        SalesorderMgt: Codeunit "PTE SOI S.O. Mgt";
        Next_Status_Code: Code[20];
}