pageextension 80134 "SIEP Shipping Setup" extends "PVS Shipping Setup"
{
    layout
    {
        addfirst(DefaultAddress)
        {
            group("SIEP Fields")
            {
                ShowCaption = false;
                Visible = EasyPostEnabled;

                field("SIEP Address Verified"; Rec."SIEP Address Verified")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("SIEP Address Id"; Rec."SIEP Address Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            group("SIEP Actions")
            {
                Caption = 'EasyPost';
                ShowAs = SplitButton;

                action("SIEP Verify Address")
                {
                    ApplicationArea = All;
                    Caption = 'Verify Address';
                    Enabled = EasyPostEnabled;
                    Image = ShipAddress;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    Visible = EasyPostEnabled;

                    trigger OnAction()
                    var
                        EasyPostMgt: Codeunit "SIEP Mgt.";
                    begin
                        Clear(ErrorMessageMgt);
                        Clear(ErrorMessageHandler);
                        Clear(ErrorContextElement);

                        if not EasyPostMgt.VerifyAddress(Enum::"PVS Shipping Action"::"SIEP Verify Address", Rec, ErrorMessageMgt) then
                            ErrorMessageHandler.ShowErrors();
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        EasyPostMgt.ActivateErrorHandlingFor(ErrorMessageMgt, ErrorMessageHandler, ErrorContextElement, Rec.RecordId());
    end;

    trigger OnAfterGetRecord()
    begin
        EasyPostEnabled := EasyPostMgt.IsEnabled();
    end;

    var
        ErrorContextElement: Codeunit "Error Context Element";
        ErrorMessageHandler: Codeunit "Error Message Handler";
        ErrorMessageMgt: Codeunit "Error Message Management";
        EasyPostMgt: Codeunit "SIEP Mgt.";
        EasyPostEnabled: Boolean;
}