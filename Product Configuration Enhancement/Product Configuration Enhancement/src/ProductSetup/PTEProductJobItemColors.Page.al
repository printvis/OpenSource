/// <summary>
/// Popup list page showing PVS Product Materials (inks / consumables) for a specific
/// Product Job Item.  Opened from the "PTE Product Job Item Sub" page via the
/// "Colors / Materials" action or by drilling down on the Colors Front / Colors Back fields.
/// </summary>
page 75002 "PTE Product Job Item Colors"
{
    PageType = List;
    SourceTable = "PVS Product Materials";
    Caption = 'Job Item Colors / Materials';
    ApplicationArea = All;
    InsertAllowed = true;
    DeleteAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Item Quality Code"; Rec."Item Quality Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quality of the ink or consumable item.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ink or consumable item number.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Item: Record Item;
                    begin
                        // When an Item Quality Code is specified on the line, restrict the
                        // Item drilldown/lookup to items that share the same quality code.
                        if Rec."Item Quality Code" <> '' then
                            Item.SetRange("PVS Item Quality Code", Rec."Item Quality Code");

                        if Page.RunModal(0, Item) = Action::LookupOK then begin
                            Text := Item."No.";
                            exit(true);
                        end;
                        exit(false);
                    end;
                }
                field(Text; Rec.Text)
                {
                    ApplicationArea = All;
                    ToolTip = 'Description transferred from the selected item, may be overwritten.';
                }
                field("Text 2"; Rec."Text 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Secondary description transferred from the selected item, may be overwritten.';
                }
                field("F/B"; Rec."F/B")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the color is printed on the Front, Back, or Both sides.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the color type: Base Color, Spot Color, or Other.';
                }
                field("Coverage Pct."; Rec."Coverage Pct.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the percentage of the sheet area covered with this ink at 100% coverage.';
                }
                field("Area Per Weight"; Rec."Area Per Weight")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how much area is covered with one unit of ink at 100% coverage.';
                }
                field("No. Of Washups"; Rec."No. Of Washups")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of color changes and washups to count for this sheet.';
                }
                field("Cliche No."; Rec."Cliche No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cliche item number for flexo production.';
                    Visible = false;
                }
                field("Plate No."; Rec."Plate No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the printing plate item number.';
                    Visible = false;
                }
                field("Job Item No."; Rec."Job Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies which Product Job Item this material line belongs to.';
                }
                field("Product Code"; Rec."Product Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the product code.';
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number.';
                    Visible = false;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        ProductMaterials: Record "PVS Product Materials";
        FilterProductCode: Code[20];
        FilterJobItemNo: Integer;
    begin
        // Inherit the filtered Product Code and Job Item No. so every new line
        // is automatically linked to the correct product and job item.
        FilterProductCode := CopyStr(Rec.GetFilter("Product Code"), 1, MaxStrLen(Rec."Product Code"));
        Evaluate(FilterJobItemNo, Rec.GetFilter("Job Item No."));

        Rec."Product Code" := FilterProductCode;
        Rec."Job Item No." := FilterJobItemNo;

        // Auto-increment Entry No. within this product.
        ProductMaterials.SetRange("Product Code", FilterProductCode);
        if ProductMaterials.FindLast() then
            Rec."Entry No." := ProductMaterials."Entry No." + 1
        else
            Rec."Entry No." := 1;
    end;
}
