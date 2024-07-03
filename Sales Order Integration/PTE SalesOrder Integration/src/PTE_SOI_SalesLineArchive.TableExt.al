TableExtension 80106 "PTE SOI Sales Line Archive" extends "Sales Line Archive" //"PVS tableextension6010129"
{
    fields
    {
        field(80101; "PTE SOI Qty. Order"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Prod. Quantity';
            Description = 'PRINTVIS';
        }
        field(80102; "PTE SOI Unit"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Unit';
            Description = 'PRINTVIS';
            OptionCaption = ' ,per 1000';
            OptionMembers = " ","per 1000";
        }
        field(80103; "PTE SOI Sales Price"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            Caption = 'Price';
            Description = 'PRINTVIS';
        }
        field(80104; "PTE SOI Production Order"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Production Order';
            Description = 'PRINTVIS';
        }
        field(80105; "PTE SOI Page Unit"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Page Unit';
            Description = 'PRINTVIS';
            OptionCaption = 'Pages w. Print,Sheets,Total Pages';
            OptionMembers = "Pages w. Print",Sheets,"Total Pages";
        }
        field(80106; "PTE SOI Pages"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Pages';
            Description = 'PRINTVIS';
        }
        field(80107; "PTE SOI Format Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Format Code';
            Description = 'PRINTVIS';
            TableRelation = "PVS Format Code" where(Type = filter(Miscellaneous | "Final format"));
            ValidateTableRelation = false;
        }
        field(80108; "PTE SOI Colors Front"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Color Front';
            Description = 'PRINTVIS';
        }
        field(80109; "PTE SOI Colors Back"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Color Back';
            Description = 'PRINTVIS';
        }
        field(80110; "PTE SOI Paper"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Paper';
            Description = 'PRINTVIS';
            TableRelation = Item where("PVS Item Type" = const(Paper));
        }
        field(80111; "PTE SOI Unchanged Reprint"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Unchanged Reissue';
            Description = 'PRINTVIS';
        }
        field(80112; "PTE SOI Price Production Order"; Decimal)
        {
            CalcFormula = lookup("PVS Job"."Quoted Price" where(ID = field("PVS ID 1"),
                                                                 "Production Calculation" = const(true)));
            Caption = 'Price Production Order';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80113; "PTE SOI Production Qty."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';
            Description = 'PRINTVIS';
        }
        field(80114; "PTE SOI Job Cost. Dir. C. H."; Decimal)
        {
            CalcFormula = sum("PVS Job Costing Entry"."Direct Cost Total" where("Table ID" = const(6010325),
                                                                                 Type = const(Cost),
                                                                                 ID = field("PVS ID 1")));
            Caption = 'Job Cost. Direct Cost Hours';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80115; "PTE SOI Job Cost. Dir. C. Mat."; Decimal)
        {
            CalcFormula = sum("PVS Job Costing Entry"."Direct Cost Total" where("Table ID" = const(32),
                                                                                 Type = const(Cost),
                                                                                 ID = field("PVS ID 1")));
            Caption = 'Job Cost. Direct Cost Material';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80116; "PTE SOI Job Cost. Dir. Cost P."; Decimal)
        {
            CalcFormula = sum("PVS Job Costing Entry"."Direct Cost Total" where("Table ID" = const(17),
                                                                                 Type = const(Cost),
                                                                                 ID = field("PVS ID 1")));
            Caption = 'Job Cost. Direct Cost Purchase';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80117; "PTE SOI Job Cost. Mat. Cost P."; Decimal)
        {
            CalcFormula = sum("PVS Job Costing Entry"."Direct Cost Total" where("Table ID" = const(17),
                                                                                 Type = const(Cost),
                                                                                 ID = field("PVS ID 1"),
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
                                                                                 ID = field("PVS ID 1"),
                                                                                 "Sub Contracting" = const(true)));
            Caption = 'Job Cost. Outwor Costs Purchase';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}

