TableExtension 80109 "PTE SOI Purchase Line" extends "Purchase Line" //"PVS tableextension6010104"
{
    fields
    {
        field(80101; "PTE SOI Production Order"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Production Order';
            Description = 'PRINTVIS';

            trigger OnValidate()
            var
                PVSPurchaseManagement: Codeunit "PTE SOI Purchase Order Mgt";
            begin
                PVSPurchaseManagement.PurchLine_Validate_ProdOrder(Rec);
            end;
        }
        field(80102; "PTE SOI Page Unit"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Page Unit';
            Description = 'PRINTVIS';
            OptionCaption = 'Pages w. Print,Sheets,Total Pages';
            OptionMembers = "Pages w. Print",Sheets,"Total Pages";

            trigger OnValidate()
            begin
                Validate("PTE SOI Pages");
            end;
        }
        field(80103; "PTE SOI Pages"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Pages';
            Description = 'PRINTVIS';
        }
        field(80104; "PTE SOI Format Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Format Code';
            Description = 'PRINTVIS';
            TableRelation = "PVS Format Code" where(Type = filter(Miscellaneous | "Final format"));
            ValidateTableRelation = false;
        }
        field(80105; "PTE SOI Colors Front"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Color Front';
            Description = 'PRINTVIS';
        }
        field(80106; "PTE SOI Colors Back"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Color Back';
            Description = 'PRINTVIS';

            trigger OnValidate()
            var
                PVSPurchaseManagement: Codeunit "PTE SOI Purchase Order Mgt";
            begin
                PVSPurchaseManagement.PurchLine_Validate_Color(Rec);
            end;
        }
        field(80107; "PTE SOI Paper"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Paper';
            Description = 'PRINTVIS';
            TableRelation = Item where("PVS Item Type" = const(Paper));
        }
        field(80108; "PTE SOI Unchanged Reprint"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Unchanged Reissue';
            Description = 'PRINTVIS';
        }
        field(80110; "PTE SOI Price Production Order"; Decimal)
        {
            CalcFormula = lookup("PVS Job"."Quoted Price" where(ID = field("PVS ID 1"),
                                                                         "Production Calculation" = const(true)));
            Caption = 'Price Production Order';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }

        field(80111; "PTE SOI Job Description"; Text[250])
        {
            CalcFormula = lookup("PVS Case"."Job Name" where(ID = field("PVS ID 1")));
            Caption = 'PrintVis Job Description';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }

        field(80112; "PTE SOI PH Status Code"; Code[20])
        {
            CalcFormula = lookup("Purchase Header"."PTE SOI Status Code" where("Document Type" = field("Document Type"),
                                                                                    "No." = field("Document No.")));
            Caption = 'PO Status Code';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80113; "PTE SOI Customer Name"; Text[100])
        {
            CalcFormula = lookup("PVS Case"."Sell-To Name" where(ID = field("PVS ID 1")));
            Caption = 'Sell-to Name';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}