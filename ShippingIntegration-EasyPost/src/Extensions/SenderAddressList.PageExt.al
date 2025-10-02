pageextension 80137 "SIEP Sender Address List" extends "PVS Sender Address List"
{
    layout
    {
        addlast(Control1)
        {
            field("SIEP Address Id"; Rec."SIEP Address Id")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = EasyPostEnabled;
            }
            field("SIEP Address Verified"; Rec."SIEP Address Verified")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = EasyPostEnabled;
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