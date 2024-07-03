PageExtension 80132 "PTE SOI Whse. Receipts List" extends "PVS Whse. Receipts List"
{
    layout
    {
        addlast(Control1)
        {
            field("PTE SOIRemainingOrder"; Rec."PTE SOI Remaining Order")
            {
                ApplicationArea = All;
                ToolTip = 'This field is Yes if there is still remaining quantity on any purchase order lines. It also provides access to the open purchase lines.';
                Visible = PTE_RemaingOrderVisible;
            }
            field("PTE SOIStatus"; Rec."PTE SOI Status")
            {
                ApplicationArea = All;
                ToolTip = 'This field shows the purchase status if the system is set up for automatic e-commerce communication.';
                Visible = false;
            }
            field("PTE SOIDeadline"; Rec."PTE SOI Deadline")
            {
                ApplicationArea = All;
                ToolTip = 'Displays the deadline as set for the current Status Code on the Purchase Order - the deadline indicates when the order must be dealt with in the current status.';
                Visible = false;
            }
            field("PTE SOIPersonResponsible"; Rec."PTE SOI Person Responsible")
            {
                ApplicationArea = All;
                ToolTip = 'Displays who is responsible for the Purchase Order (in the current status)';
                Visible = false;
            }
            field("PTE SOIPersonResponsibleName"; Rec."PTE SOI Person Respon. Name")
            {
                ApplicationArea = All;
                ToolTip = 'This is the name of the person which is currently responsible for this purchase order.';
                Visible = false;
            }
            field("PTE SOICoordinator"; Rec."PTE SOI Coordinator")
            {
                ApplicationArea = All;
                ToolTip = 'Displays who is the coordinator on the PrintVis case, if such is linked to the Purchase Order.';
                Visible = false;
            }
            field("PTE SOICoordinatorName"; Rec."PTE SOI Coordinator Name")
            {
                ApplicationArea = All;
                ToolTip = 'This is the name of the person who is the Coordinator of the PrintVis Case related to this purchase order.';
                Visible = false;
            }
        }
    }

    actions
    {
        addafter("<Action1160230004>")
        {
            action("PTE SOISO_Outstanding")
            {
                ApplicationArea = All;
                Caption = 'Outstanding only';
                Enabled = PTE_SOOutstandingEnabled;
                Image = ItemAvailabilitybyPeriod;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ShortCutKey = 'Shift+Ctrl+O';
                ToolTip = 'Outstanding only';

                trigger OnAction()
                begin
                    PTE_SOSelect_Outstanding := true;
                    PTE_SOOutstandingEnabled := not PTE_SOSelect_Outstanding;
                    PTE_SOOutstandingAllEnabled := PTE_SOSelect_Outstanding;
                    PTE_SO_SET_FILTER();
                end;
            }
            action("PTE SOISO_Outstanding_All")
            {
                ApplicationArea = All;
                Caption = 'All';
                Enabled = PTE_SOOutstandingAllEnabled;
                Image = ItemAvailabilitybyPeriod;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ShortCutKey = 'Shift+Ctrl+L';
                ToolTip = 'All';

                trigger OnAction()
                begin
                    PTE_SOSelect_Outstanding := false;
                    PTE_SOOutstandingEnabled := not PTE_SOSelect_Outstanding;
                    PTE_SOOutstandingAllEnabled := PTE_SOSelect_Outstanding;
                    PTE_SO_SET_FILTER();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        PTE_RemaingOrderVisible := true;
        PTE_SOSelect_Outstanding := true;
        PTE_SO_SET_FILTER();
    end;

    trigger OnAfterGetRecord()
    begin
        PTE_ExpectedReceiptDateOnFormat();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        PTE_SO_SET_FILTER();
    end;

    var
        PTE_RemaingOrderVisible: Boolean;
        PTE_SOSelect_Outstanding: Boolean;
        PTE_SOOutstandingEnabled: Boolean;
        PTE_SOOutstandingAllEnabled: Boolean;

    procedure PTE_SO_SET_FILTER()
    begin
        Rec.FilterGroup(0);
        case PTE_SOSelect_Outstanding of
            true:
                Rec.SetRange("PTE SOI Remaining Order", true);
            false:
                Rec.SetFilter("PTE SOI Remaining Order", '%1|%2', true, false);
        end;

        PTE_SOOutstandingEnabled := not PTE_SOSelect_Outstanding;
        PTE_SOOutstandingAllEnabled := PTE_SOSelect_Outstanding;

        CurrPage.Update(false);

    end;

    local procedure PTE_ExpectedReceiptDateOnFormat()
    begin
        Rec.CalcFields("PTE SOI Remaining Order");
        if (Rec."Expected Receipt Date" < Today()) and Rec."PTE SOI Remaining Order" then;

        if (Rec."Expected Receipt Date" = Today()) and Rec."PTE SOI Remaining Order" then;
    end;
}