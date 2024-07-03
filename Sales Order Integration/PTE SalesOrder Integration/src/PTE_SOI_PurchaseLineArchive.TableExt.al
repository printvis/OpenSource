TableExtension 80104 "PTE SOI Purchase Line Arc" extends "Purchase Line Archive" //"PVS tableextension6010131"
{
    fields
    {
        field(80101; "PTE SOI Production Order"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Production Order';
            Description = 'PRINTVIS';
        }
        field(80102; "PTE SOI Page Unit"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Page Unit';
            Description = 'PRINTVIS';
            OptionCaption = 'Pages w. Print,Sheets,Total Pages';
            OptionMembers = "Pages w. Print",Sheets,"Total Pages";
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
        field(80109; "PTE SOI Price Production Order"; Decimal)
        {
            CalcFormula = lookup("PVS Job"."Quoted Price" where(ID = field("PVS ID 1"),
                                                                 "Production Calculation" = const(true)));
            Caption = 'Price Production Order';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80110; "PTE SOI Expected Receipt Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Expected Receipt Time';
            Description = 'PRINTVIS';
        }
    }
}