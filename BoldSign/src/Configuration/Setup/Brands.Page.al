namespace PrintVis.BoldSign.Configuration;

using PrintVis.BoldSign.Integration.Services;

page 80310 "PVS BS Brands"
{
    ApplicationArea = All;
    Caption = 'BoldSign Brands';
    PageType = List;
    SourceTable = "PVS BS Brand";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the brand.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the brand.';
                }
                field("BoldSign Brand ID"; Rec."BoldSign Brand ID")
                {
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field(BackgroundColor; Rec.BackgroundColor)
                {
                    ApplicationArea = All;
                }
                field(ButtonColor; Rec.ButtonColor)
                {
                    ApplicationArea = All;
                }
                field(ButtonTextColor; Rec.ButtonTextColor)
                {
                    ApplicationArea = All;
                }
                field(EmailDisplayName; Rec.EmailDisplayName)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RefreshBrands)
            {
                ApplicationArea = All;
                Caption = 'Retrieve from BoldSign';
                Image = GetLines;
                ToolTip = 'Retrieves the brands defined in BoldSign and adds or updates them here.';

                trigger OnAction()
                var
                    BrandService: Codeunit "PVS BS Signature Service";
                begin
                    BrandService.RefreshBrands();
                    CurrPage.Update(false);
                end;
            }
            action(CreateBrand)
            {
                ApplicationArea = All;
                Caption = 'Create in BoldSign';
                Image = New;
                ToolTip = 'Creates the selected brand in BoldSign. You are asked for the logo (PNG, JPEG or SVG, max. 512 KB).';

                trigger OnAction()
                var
                    BrandService: Codeunit "PVS BS Signature Service";
                    LogoInStream: InStream;
                    LogoFileName: Text;
                    SelectLogoLbl: Label 'Select the brand logo';
                begin
                    if not UploadIntoStream(SelectLogoLbl, '', 'Images (*.png;*.jpg;*.jpeg;*.svg)|*.png;*.jpg;*.jpeg;*.svg', LogoFileName, LogoInStream) then
                        exit;

                    BrandService.CreateBrand(Rec, LogoInStream, LogoFileName);
                    CurrPage.Update(false);
                end;
            }
        }
        area(Promoted)
        {
            actionref(RefreshBrandsPromoted; RefreshBrands) { }
            actionref(CreateBrandPromoted; CreateBrand) { }
        }
    }
}
