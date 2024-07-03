PageExtension 80102 "PVS SOint Purchase Order Sub" extends "Purchase Order Subform" //"PVS pageextension6010145"
{
    layout
    {
        addafter("No.")
        {
            field("PTE SOIProductionOrder"; Rec."PTE SOI Production Order")
            {
                ApplicationArea = All;
                ToolTip = 'Displays if the current purchase line is linked to a specific PrintVis Case.';
                Visible = PTE_PVS_ShowPVS;

                trigger OnValidate()
                begin
                    PTE_Purchaseorder_Mgt.PurchLine_Validate_ProdOrder(Rec);
                end;
            }
            field("PTE SOICustomerName"; Rec."PTE SOI Customer Name")
            {
                ApplicationArea = All;
                ToolTip = 'Displays which Customer Name is set on the PrintVis Case the line is linked to, if any.';
                Visible = false;
            }
            field("PTE SOIJobDescription"; Rec."PTE SOI Job Description")
            {
                ApplicationArea = All;
                ToolTip = 'Displays which Jobname is set on the PrintVis Case the line is linked to, if any.';
                Visible = false;
            }
        }

        addafter("Bin Code")
        {
            field("PTE SOIPageUnit"; Rec."PTE SOI Page Unit")
            {
                ApplicationArea = All;
                Importance = Additional;
                ToolTip = 'Displays how to count the pages - either as; Pages w. print, leafs (sheets) or as Total Pages';
                Visible = false;
            }
            field("PTE SOIPages"; Rec."PTE SOI Pages")
            {
                ApplicationArea = All;
                CaptionClass = PTE_CFIMgt.GetCaption(0, Enum::"PVS CFI"::Pages);
                Importance = Additional;
                ToolTip = 'Displays the No. of Pages (matter) of the product, as set on the PrintVis Case linked to the line.';
                Visible = false;
            }
            field("PTE SOIFormatCode"; Rec."PTE SOI Format Code")
            {
                ApplicationArea = All;
                CaptionClass = PTE_CFIMgt.GetCaption(0, Enum::"PVS CFI"::FormatCode);
                ToolTip = 'Displays the Size of the product, from the PrintVis Case the line is linked to.';
                Visible = false;
            }
            field("PTE SOIColorsFront"; Rec."PTE SOI Colors Front")
            {
                ApplicationArea = All;
                CaptionClass = PTE_CFIMgt.GetCaption(0, Enum::"PVS CFI"::ColorsFront);
                Importance = Additional;
                ToolTip = 'Displays the Colors Front for the product, from the PrintVis Case the line is linked to.';
                Visible = false;
            }
            field("PTE SOIColorsBack"; Rec."PTE SOI Colors Back")
            {
                ApplicationArea = All;
                CaptionClass = PTE_CFIMgt.GetCaption(0, Enum::"PVS CFI"::ColorsBack);
                Importance = Additional;
                ToolTip = 'Displays the Colors Back for the product, from the PrintVis Case the line is linked to.';
                Visible = false;
            }
            field("PTE SOIPaper"; Rec."PTE SOI Paper")
            {
                ApplicationArea = All;
                Importance = Additional;
                CaptionClass = PTE_CFIMgt.GetCaption(0, Enum::"PVS CFI"::Paper);
                ToolTip = 'Displays the Paper item number for the product, from the PrintVis Case the line is linked to.';
                Visible = false;
            }
            field("PTE SOIUnchangedReprint"; Rec."PTE SOI Unchanged Reprint")
            {
                ApplicationArea = All;
                Importance = Additional;
                ToolTip = 'Displays if the linked PrintVis Case is marked as ''Unchanged Reissue''';
                Visible = false;
            }

        }
    }
    var
        PTE_CFIMgt: Codeunit "PVS CFI Mgt";
        PTE_Purchaseorder_Mgt: Codeunit "PTE SOI Purchase Order Mgt";
        PTE_PVS_ShowPVS: Boolean;

    trigger OnOpenPage()
    begin
        PTE_PVS_ShowPVS := true;
    end;
}