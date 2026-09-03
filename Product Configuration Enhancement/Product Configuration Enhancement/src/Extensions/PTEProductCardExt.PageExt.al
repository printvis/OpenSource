pageextension 75006 "PTE Product Card Ext" extends "PVS Product Card"
{
    layout
    {
        // Hide the base "Inks and Consumables" product colors part; the Product Job Item
        // sub page below replaces it for job-item based colors/materials configuration.
        modify(InksAndConsumables)
        {
            Visible = false;
        }

        addafter(InksAndConsumables)
        {
            part(PTE_ProductJobItemSub; "PTE Product Job Item Sub")
            {
                ApplicationArea = All;
                Caption = 'Product Job Items';
                SubPageLink = "Product Code" = field("Code");
            }
        }
    }

    actions
    {
        addafter(AdditionalInfo)
        {
            group("PTE_UserFields")
            {
                Caption = 'User Fields';
                action("PTE_PUSH_USERFIELDS_1")
                {
                    ApplicationArea = All;
                    Caption = 'User Fields 1';
                    Image = PeriodStatus;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+Ctrl+F1';
                    ToolTip = 'User Fields (1) JOB';
                    Visible = PUSH_USERFIELDS_1Visible;

                    trigger OnAction()
                    var
                        UserFieldMgt: Codeunit "PVS Userfield Management";
                        Code1: Code[20];
                    begin
                        Code1 := CopyStr(Rec.Code, 1, MaxStrLen(Code1));
                        UserFieldMgt.Form_Userfield_Edit(6010313, 0, '', Code1, 0, 0, 0, 0, 0);
                    end;
                }
                action("PTE_PUSH_USERFIELDS_2")
                {
                    ApplicationArea = All;
                    Caption = 'User Fields 2';
                    Image = ReopenPeriod;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+Ctrl+F2';
                    ToolTip = 'User Fields (2) JOB';
                    Visible = PUSH_USERFIELDS_2Visible;

                    trigger OnAction()
                    var
                        UserFieldMgt: Codeunit "PVS Userfield Management";
                        Code1: Code[20];
                    begin
                        Code1 := CopyStr(Rec.Code, 1, MaxStrLen(Code1));
                        UserFieldMgt.Form_Userfield_Edit(6010313, 1, '', Code1, 0, 0, 0, 0, 0);
                    end;
                }
                action("PTE_PUSH_USERFIELDS_3")
                {
                    ApplicationArea = All;
                    Caption = 'User Fields 3';
                    Image = ClosePeriod;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+Ctrl+F3';
                    ToolTip = 'User Fields (3) JOB';
                    Visible = PUSH_USERFIELDS_3Visible;

                    trigger OnAction()
                    var
                        UserFieldMgt: Codeunit "PVS Userfield Management";
                        Code1: Code[20];
                    begin
                        Code1 := CopyStr(Rec.Code, 1, MaxStrLen(Code1));
                        UserFieldMgt.Form_Userfield_Edit(6010313, 2, '', Code1, 0, 0, 0, 0, 0);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        SetupRec: Record "PVS General Setup";
    begin
        SetupRec.Get();

        PUSH_USERFIELDS_1Visible := SetupRec."Enable User Fields Job 1";
        PUSH_USERFIELDS_2Visible := SetupRec."Enable User Fields Job 2";
        PUSH_USERFIELDS_3Visible := SetupRec."Enable User Fields Job 3";
    end;

    var
        PUSH_USERFIELDS_1Visible: Boolean;
        PUSH_USERFIELDS_2Visible: Boolean;
        PUSH_USERFIELDS_3Visible: Boolean;
}
