table 75200 "PTE PVS FG Valuation"
{

    LookupPageId = "PTE PVS FG Valuation List";

    fields
    {
        field(1; "PVS ID"; Integer)
        {
            Caption = 'PVS ID';
            DataClassification = CustomerContent;
            TableRelation = "PVS Case".ID;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item."No.";
        }
        /*
        //For job level if needed
        field(3; Job; Integer)
        {
            Caption = 'Job';
            DataClassification = ToBeClassified;
        }
        field(5; BatchCode; Code[20])
        {
            Caption = 'Batch Code';
            DataClassification = ToBeClassified;
        }
        */
        field(6; Level; Integer)
        {
            Caption = 'Level';
            DataClassification = CustomerContent;
        }

        field(29; "Cost is Adjusted"; Boolean)
        {
            Caption = 'Cost is Adjusted';
            InitValue = true;
            DataClassification = ToBeClassified;
        }
        field(50; "Direct Total Cost Estimating"; decimal)
        {
            Caption = 'Direct Total Cost Material Calculated';
        }
        field(51; "Total Cost Estimated"; decimal)
        {
            Caption = 'Total Cost Calculated';
        }
        //Special SFG
        /*
        field(52; "SFG standard cost amount"; decimal)
        {
            Caption = 'SFG standard cost amount';
        }
        field(53; "SFG standard unit cost amount"; decimal)
        {
            Caption = 'SFG standard unit cost amount';
        }
        field(54; "FG Estimated Quantity"; Decimal)
        {
            Caption = 'SFG Estimated Quantity';
        }
        */
        field(60; "Direct Total Cost Material"; Decimal)
        {
            Caption = 'Direct Total Cost Material';
            FieldClass = FlowField;
            CalcFormula = Sum("PVS Job Costing Entry"."Direct Cost total" WHERE("Table ID" = CONST(32),
                                                                                 ID = FIELD("PVS ID"),
                                                                                 Type = CONST(Cost)));
            Editable = false;
        }

        field(61; "Direct Total Cost Larbor"; Decimal)
        {
            Caption = 'Direct Total Cost Larbor';
            FieldClass = FlowField;
            CalcFormula = Sum("PVS Job Costing Entry"."Direct Cost total" WHERE("Table ID" = CONST(6010325),
                                                                                 ID = FIELD("PVS ID"),
                                                                                 Type = CONST(Cost)));
            Editable = false;
        }

        field(62; "Total Cost Larbor"; Decimal)
        {
            Caption = 'Total Cost Larbor';
            FieldClass = FlowField;
            CalcFormula = Sum("PVS Job Costing Entry"."Total Self Cost" WHERE("Table ID" = CONST(6010325),
                                                                               ID = FIELD("PVS ID"),
                                                                               Type = CONST(Cost)));
            Editable = false;
        }

        field(70; "Cost Amount (Actual)"; Decimal)
        {
            Caption = 'Cost Amount (Actual)';
            DataClassification = CustomerContent;
        }

        field(95; "Material GenBusPostGrp"; Code[10])
        {
            Caption = 'Material Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
            DataClassification = CustomerContent;
        }

        field(96; "Larbor GenBusPostGrp"; Code[10])
        {
            Caption = 'Larbor Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
            DataClassification = CustomerContent;
        }

        field(98; "Overhead GenBusPostGrp"; Code[10])
        {
            Caption = 'Overhead Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
            DataClassification = CustomerContent;
        }

        field(105; "Material percent assigned"; Decimal)
        {
            Caption = 'Material percent assigned"';
            DataClassification = CustomerContent;
        }

        field(106; "Larbor percent assigned"; Decimal)
        {
            Caption = 'Larbor percent assigned';
            DataClassification = CustomerContent;
        }

        field(108; "Overhead percent assigned"; Decimal)
        {
            Caption = 'Overhead percent assigned';
            DataClassification = CustomerContent;
        }

        field(110; "Adjustement count"; Integer)
        {
            Caption = 'Adjustement count"';
            DataClassification = CustomerContent;
        }

        field(200; "Quantity Output"; Decimal)
        {
            Caption = 'Quantity Output';
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                  "PVS ID" = FIELD("PVS ID"),
                                                                  "Entry Type" = CONST(Purchase)
                                                                 ));
            Editable = false;

        }
    }

    keys
    {
        key(Key1; "PVS ID", "Item No.")
        {
            Clustered = true;
        }
        key(Key2; "Cost is Adjusted", Level)
        {
        }
        key(Key3; "Cost is Adjusted", "PVS ID")
        {
        }
    }

}