namespace PrintVis.BoldSign.Configuration;

table 80304 "PVS BS Brand"
{
    Caption = 'BoldSign Brand';
    DataClassification = CustomerContent;
    DrillDownPageId = "PVS BS Brands";
    LookupPageId = "PVS BS Brands";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(3; "BoldSign Brand ID"; Guid)
        {
            Caption = 'BoldSign Brand ID';
            ToolTip = 'Specifies the brand ID from the BoldSign portal (Settings > Brands).';
        }
        field(4; Active; Boolean)
        {
            Caption = 'Active';
            ToolTip = 'Specifies whether this brand is used for new signature requests. Only one brand can be active.';

            trigger OnValidate()
            var
                OtherBrand: Record "PVS BS Brand";
            begin
                if not Rec.Active then
                    exit;

                OtherBrand.SetFilter("Code", '<>%1', Rec."Code");
                OtherBrand.SetRange(Active, true);
                OtherBrand.ModifyAll(Active, false);
            end;
        }

        field(10; BackgroundColor; Text[30])
        {
            Caption = 'Background Color';
            ToolTip = 'Specifies the background color of the emails sent to the signers, for example red or #FF0000.';
        }
        field(11; ButtonColor; Text[30])
        {
            Caption = 'Button Color';
            ToolTip = 'Specifies the button color in the emails sent to the signers.';
        }
        field(12; ButtonTextColor; Text[30])
        {
            Caption = 'Button Text Color';
            ToolTip = 'Specifies the button text color in the emails sent to the signers.';
        }
        field(13; EmailDisplayName; Text[50])
        {
            Caption = 'Email Display Name';
            ToolTip = 'Specifies the sender name of the emails. You can use {SenderName} as a placeholder.';
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    internal procedure GetActiveBrandId(var BrandId: Guid): Boolean
    var
        Brand: Record "PVS BS Brand";
    begin
        Brand.SetRange(Active, true);
        if not Brand.FindFirst() then
            exit(false);

        BrandId := Brand."BoldSign Brand ID";
        exit(not IsNullGuid(BrandId));
    end;
}
