TableExtension 80107 "PTE SOI Sales Line" extends "Sales Line" //"PVS tableextension6010102"
{
    fields
    {
        field(80101; "PTE SOI Qty. Order"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Prod. Quantity';
            Description = 'PRINTVIS';

            trigger OnValidate()
            var
                PVSalesorderManagement: Codeunit "PTE SOI S.O. Mgt";
            begin
                PVSalesorderManagement.SalesLine_Validate_PVS_Quantity(Rec);
            end;
        }

        field(80102; "PTE SOI Unit"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Unit';
            Description = 'PRINTVIS';
            OptionCaption = ' ,per 1000';
            OptionMembers = " ","per 1000";

            trigger OnValidate()
            begin
                if xRec."PTE SOI Unit" <> "PTE SOI Unit" then
                    Validate("PTE SOI Sales Price");
            end;
        }
        field(80103; "PTE SOI Sales Price"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            BlankZero = true;
            Caption = 'Prod. Price';
            Description = 'PRINTVIS';

            trigger OnValidate()
            var
                PVSalesorderManagement: Codeunit "PTE SOI S.O. Mgt";
            begin
                PVSalesorderManagement.SalesLine_Validate_PVS_Price(Rec);
            end;
        }
        field(80104; "PTE SOI Production Order"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Production Order';
            Description = 'PRINTVIS';

            trigger OnValidate()
            var
                PVSalesorderManagement: Codeunit "PTE SOI S.O. Mgt";
            begin
                PVSalesorderManagement.SalesLine_Validate_ProdOrder(Rec, xRec);
            end;
        }
        field(80105; "PTE SOI Page Unit"; Option)
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
        field(80106; "PTE SOI Pages"; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Pages';
            Description = 'PRINTVIS';

            trigger OnValidate()
            var
                PVSalesorderManagement: Codeunit "PTE SOI S.O. Mgt";
            begin
                PVSalesorderManagement.SalesLine_Validate_Pages(Rec);
            end;
        }
        field(80107; "PTE SOI Format Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Format Code';
            Description = 'PRINTVIS';
            TableRelation = "PVS Format Code" where(Type = filter(Miscellaneous | "Final format"));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                PVSalesorderManagement: Codeunit "PTE SOI S.O. Mgt";
            begin
                PVSalesorderManagement.SalesLine_Validate_Format(Rec);
            end;
        }
        field(80108; "PTE SOI Colors Front"; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Color Front';
            Description = 'PRINTVIS';

            trigger OnValidate()
            var
                PVSalesorderManagement: Codeunit "PTE SOI S.O. Mgt";
            begin
                PVSalesorderManagement.SalesLine_Validate_Colors(Rec);
            end;
        }
        field(80109; "PTE SOI Colors Back"; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Color Back';
            Description = 'PRINTVIS';

            trigger OnValidate()
            var
                PVSalesorderManagement: Codeunit "PTE SOI S.O. Mgt";
            begin
                PVSalesorderManagement.SalesLine_Validate_Colors(Rec);
            end;
        }
        field(80110; "PTE SOI Paper"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Paper';
            Description = 'PRINTVIS';
            TableRelation = Item where("PVS Item Type" = const(Paper));

            trigger OnValidate()
            var
                PVSalesorderManagement: Codeunit "PTE SOI S.O. Mgt";
            begin
                PVSalesorderManagement.SalesLine_Validate_Paper(Rec);
            end;
        }
        field(80111; "PTE SOI Unchanged Reprint"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Unchanged Reissue';
            Description = 'PRINTVIS';

            trigger OnValidate()
            var
                PVSalesorderManagement: Codeunit "PTE SOI S.O. Mgt";
            begin
                PVSalesorderManagement.SalesLine_Validate_Unchanged(Rec, xRec)
            end;
        }

        field(80112; "PTE SOI Production Qty."; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Quantity';
            Description = 'PRINTVIS';
        }
        field(80113; "PTE SOI Price Production Order"; Decimal)
        {
            BlankZero = true;
            CalcFormula = lookup("PVS Job"."Quoted Price" where(ID = field("PVS ID"),
                                                                 Job = field("PVS Job"),
                                                                 "Production Calculation" = const(true)));
            Caption = 'Price Production Order';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80114; "PTE SOI Job Cost. Dir. C. H."; Decimal)
        {
            BlankZero = true;
            CalcFormula = sum("PVS Job Costing Entry"."Direct Cost Total" where("Table ID" = const(6010325),
                                                                                 Type = const(Cost),
                                                                                 ID = field("PVS ID")));
            Caption = 'Job Cost. Direct Cost Hours';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80115; "PTE SOI Job Cost. Dir. C. Mat."; Decimal)
        {
            BlankZero = true;
            CalcFormula = sum("PVS Job Costing Entry"."Direct Cost Total" where("Table ID" = const(32),
                                                                                 Type = const(Cost),
                                                                                 ID = field("PVS ID")));
            Caption = 'Job Cost. Direct Cost Material';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80116; "PTE SOI Job Cost. Dir. C. P."; Decimal)
        {
            CalcFormula = sum("PVS Job Costing Entry"."Direct Cost Total" where("Table ID" = const(17),
                                                                                 Type = const(Cost),
                                                                                 ID = field("PVS ID")));
            Caption = 'Job Cost. Direct Cost Purchase';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80117; "PTE SOI Job Cost. Mat. C. P."; Decimal)
        {
            CalcFormula = sum("PVS Job Costing Entry"."Direct Cost Total" where("Table ID" = const(17),
                                                                                 Type = const(Cost),
                                                                                 ID = field("PVS ID"),
                                                                                 "Sub Contracting" = const(false)));
            Caption = 'Job Cost. Material Costs Purchase';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80118; "PTE SOI Job Cost. External P."; Decimal)
        {
            CalcFormula = sum("PVS Job Costing Entry"."Direct Cost Total" where("Table ID" = const(17),
                                                                                 Type = const(Cost),
                                                                                 ID = field("PVS ID"),
                                                                                 "Sub Contracting" = const(true)));
            Caption = 'Job Cost. Outwor Costs Purchase';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}

