PageExtension 80112 "PTE SOI Purchase Invoice" extends "Purchase Invoice" //"PVS pageextension6010142"
{
    actions
    {
        addlast(processing)
        {
            action("PTE SOIUserFields")
            {
                ApplicationArea = All;
                Caption = 'User Fields';
                Image = PeriodStatus;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'User Fields';

                trigger OnAction()
                var
                    UserFieldMgt: Codeunit "PVS Userfield Management";
                begin
                    UserFieldMgt.Form_Userfield_Edit(38, 0, '', Rec."No.", 0, 0, 0, 0, 0);
                end;
            }
        }
    }

    var
        PTE_PVS_PurchMgt: Codeunit "PVS Purchase Management";
}