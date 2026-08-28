page 75001 "PTE Product Job Item Sub"
{
    PageType = ListPart;
    SourceTable = "PTE Product Job Item";
    Caption = 'Product Job Items';
    InsertAllowed = false;
    DeleteAllowed = true;
    DelayedInsert = true;
    AutoSplitKey = true;
    SourceTableView = sorting("Product Code", "Job Item No.");
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Product Code"; Rec."Product Code")
                {

                    Visible = false;
                }
                field("Job Item No."; Rec."Job Item No.")
                {

                }
                field("Component Type"; Rec."Component Type")
                {

                }
                field("Component Type Description"; Rec."Component Type Description")
                {

                }
                field("No. Of Pages"; Rec."No. Of Pages")
                {

                }
                field("Pages With Print"; Rec."Pages With Print")
                {

                }
                field("Format Code"; Rec."Format Code")
                {

                }
                field("Format1"; Rec."Format1")
                {

                }
                field("Format2"; Rec."Format2")
                {

                }
                field(Weight; Rec.Weight)
                {

                }
                field("Imposition Code"; Rec."Imposition Code")
                {

                }
                field("Paper No."; Rec."Paper No.")
                {

                }
                field("Paper Description"; Rec."Paper Description")
                {

                }
                field(Finishing; Rec.Finishing)
                {

                }
                field("Colors Front"; Rec."Colors Front")
                {

                    trigger OnDrillDown()
                    begin
                        OpenColorsPage();
                    end;
                }
                field("Colors Back"; Rec."Colors Back")
                {

                    trigger OnDrillDown()
                    begin
                        OpenColorsPage();
                    end;
                }
                field("Media Type"; Rec."Media Type")
                {

                }
                field("List Of Units"; Rec."List Of Units")
                {


                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ProductRec: Record "PVS Product";
                        Temp_CalcUnitSetup: Record "PVS Calculation Unit Setup" temporary;
                        PageMgt: Codeunit "PVS Page Management";
                        ProductGroupCode: Code[20];
                    begin
                        if ProductRec.Get(Rec."Product Code") then
                            ProductGroupCode := ProductRec."Product Group Code";

                        PageMgt.Get_ListOfUnitTMP(ProductGroupCode, false, Temp_CalcUnitSetup);

                        Commit();
                        if Page.RunModal(Page::"PVS Calculation List of Units", Temp_CalcUnitSetup) = Action::LookupOK then begin
                            Rec.Validate("List Of Units", Temp_CalcUnitSetup.Code);
                            Text := Temp_CalcUnitSetup.Code;
                            exit(true);
                        end;
                    end;
                }
                field("Envelope Window Shape Type"; Rec."Envelope Window Shape Type")
                {

                }
                field("Envelope Window Size X"; Rec."Envelope Window Size X")
                {

                }
                field("Envelope Window Size Y"; Rec."Envelope Window Size Y")
                {

                }
                field(Opacity; Rec.Opacity)
                {

                }
                field("Opacity Level"; Rec."Opacity Level")
                {

                }
                field("Tool1"; Rec."Tool 1")
                {

                }
                field("Tool2"; Rec."Tool 2")
                {

                }
                field("Tool3"; Rec."Tool 3")
                {

                }
                field("Tool4"; Rec."Tool 4")
                {

                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(NewJobItem)
            {

                Caption = 'New Job Item';
                ToolTip = 'Creates a new product job item line for this product.';
                Image = NewRow;

                trigger OnAction()
                var
                    ProductJobItem: Record "PTE Product Job Item";
                begin
                    ProductJobItem.Init();
                    ProductJobItem."Product Code" := Rec."Product Code";
                    ProductJobItem.Insert(true);
                    CurrPage.Update(false);
                end;
            }
            action(CopyJobItem)
            {

                Caption = 'Copy Job Item';
                ToolTip = 'Creates a copy of the current product job item line.';
                Image = Copy;
                Enabled = HasJobItemLines;
                trigger OnAction()
                var
                    NewProductJobItem: Record "PTE Product Job Item";
                begin
                    Rec.TestField("Product Code");
                    NewProductJobItem := Rec;
                    NewProductJobItem."Job Item No." := 0;
                    NewProductJobItem.Insert(true);
                    CurrPage.Update(false);
                end;
            }
            action(ViewColors)
            {
                ApplicationArea = All;
                Caption = 'Colors / Materials';
                ToolTip = 'Opens the colors and materials lines for the selected job item.';
                Image = ItemLedger;
                trigger OnAction()
                begin
                    OpenColorsPage();
                end;
            }
        }

    }

    trigger OnAfterGetCurrRecord()
    var
        ProductJobItem: Record "PTE Product Job Item";
    begin
        ProductJobItem.SetRange("Product Code", Rec."Product Code");
        HasJobItemLines := not ProductJobItem.IsEmpty();
    end;

    var
        HasJobItemLines: Boolean;

    procedure GetCurrentJobItemNo(): Integer
    begin
        exit(Rec."Job Item No.");
    end;

    local procedure OpenColorsPage()
    var
        ProductMaterials: Record "PVS Product Materials";
    begin
        Rec.TestField("Product Code");
        ProductMaterials.SetRange("Product Code", Rec."Product Code");
        if Rec."Job Item No." <> 0 then
            ProductMaterials.SetRange("Job Item No.", Rec."Job Item No.");
        Page.RunModal(Page::"PTE Product Job Item Colors", ProductMaterials);
    end;
}
