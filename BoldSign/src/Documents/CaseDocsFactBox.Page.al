namespace PrintVis.BoldSign.Documents;

page 80306 "PVS BS Case Docs. FactBox"
{
    ApplicationArea = All;
    Caption = 'BoldSign Documents';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    SourceTable = "PVS Case";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(Documents)
            {
                ShowCaption = false;
                field("PVS BS New Documents"; Rec."PVS BS New Documents")
                {
                    Caption = 'New';
                }
                field("PVS BS Uploaded Documents"; Rec."PVS BS Uploaded Documents")
                {
                    Caption = 'Uploaded';
                }
                field("PVS BS Awaiting Sign. Docs."; Rec."PVS BS Awaiting Sign. Docs.")
                {
                    Caption = 'Awaiting Signature';
                }
                field("PVS BS Signed Documents"; Rec."PVS BS Signed Documents")
                {
                    Caption = 'Signed';
                }
                field("PVS BS Canceled Documents"; Rec."PVS BS Canceled Documents")
                {
                    Caption = 'Canceled';
                }
                field("PVS BS Removed Documents"; Rec."PVS BS Removed Documents")
                {
                    Caption = 'Removed';
                }
                field("PVS BS Error Documents"; Rec."PVS BS Error Documents")
                {
                    Caption = 'Error';
                }
            }
        }
    }
}