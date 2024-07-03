
Page 80102 "PTE SOI Wareh. P. Rcpt L"
{
    AdditionalSearchTerms = 'Purchase Receipt List';
    ApplicationArea = All;
    Caption = 'PrintVis Purchase List';
    CardPageID = "PVS Warehouse Purchase Receipt";
    DataCaptionFields = "Document Type";
    Editable = false;
    PageType = List;
    SourceTable = "Purchase Header";
    SourceTableView = where("Document Type" = filter(Order));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(BuyfromVendorNo; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                }
                field(OrderAddressCode; Rec."Order Address Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Responsible Name is an automatic lookup in another table. The field  is not editable.';
                    Visible = false;
                }
                field(BuyfromVendorName; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                }
                field(VendorAuthorizationNo; Rec."Vendor Authorization No.")
                {
                    ApplicationArea = All;
                }
                field(BuyfromPostCode; Rec."Buy-from Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Responsible Name is an automatic lookup in another table. The field  is not editable.';
                    Visible = false;
                }
                field(BuyfromCountryRegionCode; Rec."Buy-from Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Responsible Name is an automatic lookup in another table. The field  is not editable.';
                    Visible = false;
                }
                field(BuyfromContact; Rec."Buy-from Contact")
                {
                    ApplicationArea = All;
                    ToolTip = 'Responsible Name is an automatic lookup in another table. The field  is not editable.';
                    Visible = false;
                }
                field(PaytoVendorNo; Rec."Pay-to Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Responsible Name is an automatic lookup in another table. The field  is not editable.';
                    Visible = false;
                }
                field(PaytoName; Rec."Pay-to Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Responsible Name is an automatic lookup in another table. The field  is not editable.';
                    Visible = false;
                }
                field(PaytoPostCode; Rec."Pay-to Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Responsible Name is an automatic lookup in another table. The field  is not editable.';
                    Visible = false;
                }
                field(PaytoCountryRegionCode; Rec."Pay-to Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Responsible Name is an automatic lookup in another table. The field  is not editable.';
                    Visible = false;
                }
                field(PaytoContact; Rec."Pay-to Contact")
                {
                    ApplicationArea = All;
                    ToolTip = 'Responsible Name is an automatic lookup in another table. The field  is not editable.';
                    Visible = false;
                }
                field(ShiptoCode; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Responsible Name is an automatic lookup in another table. The field  is not editable.';
                    Visible = false;
                }
                field(ShiptoName; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Responsible Name is an automatic lookup in another table. The field  is not editable.';
                    Visible = false;
                }
                field(ShiptoPostCode; Rec."Ship-to Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Responsible Name is an automatic lookup in another table. The field  is not editable.';
                    Visible = false;
                }
                field(ShiptoCountryRegionCode; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Responsible Name is an automatic lookup in another table. The field  is not editable.';
                    Visible = false;
                }
                field(ShiptoContact; Rec."Ship-to Contact")
                {
                    ApplicationArea = All;
                    ToolTip = 'Responsible Name is an automatic lookup in another table. The field  is not editable.';
                    Visible = false;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Responsible Name is an automatic lookup in another table. The field  is not editable.';
                    Visible = false;
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Responsible Name is an automatic lookup in another table. The field  is not editable.';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        DimMgt.LookupDimValueCodeNoUpdate(1);
                    end;
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Responsible Name is an automatic lookup in another table. The field  is not editable.';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        DimMgt.LookupDimValueCodeNoUpdate(2);
                    end;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Responsible Name is an automatic lookup in another table. The field  is not editable.';
                }
                field(PurchaserCode; Rec."Purchaser Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Responsible Name is an automatic lookup in another table. The field  is not editable.';
                    Visible = false;
                }
                field(AssignedUserID; Rec."Assigned User ID")
                {
                    ApplicationArea = All;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Responsible Name is an automatic lookup in another table. The field  is not editable.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action(PurchaseReservationAvail)
            {
                ApplicationArea = All;
                Caption = 'Purchase Reservation Avail.';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                RunObject = Report "Purchase Reservation Avail.";
                ToolTip = 'Purchase Reservation Avail.';
            }
        }
    }

    var
        DimMgt: Codeunit DimensionManagement;
}