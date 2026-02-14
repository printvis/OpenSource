page 80400 "PTE SH Folders List"
{
    Caption = 'Sharepoint Folders List';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "PTE Sharepoint Folders";
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(CODE; rec.CODE)
                {
                    ApplicationArea = All;
                }
                field("Folder Name"; rec."Folder Name")
                {
                    ApplicationArea = all;
                }
                field(" Folder Path"; rec."Folder Path")
                {
                    ApplicationArea = All;
                    trigger OnAssistEdit()
                    var
                        Folders: Record "PTE Sharepoint Folders";
                    begin
                        Folders._Folder_Path_OnAssistEdit_PathRoot(Rec);
                        CurrPage.Update(false);
                    end;
                }
                field(" Folder Id"; rec."Folder Id")
                {
                    ApplicationArea = All;
                }

            }
        }

    }



}