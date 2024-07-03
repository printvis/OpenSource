Tableextension 80112 "PTE UBG SOint Purchase Line" extends "Purchase Line" //"PVS tableextension6010104"
{
    fields
    {
        field(80113; "PTE UBG  Production Order"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Production Order';
            Description = 'PRINTVIS';
        }
        field(80114; "PTE UBG  Page Unit"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Page Unit';
            Description = 'PRINTVIS';
            OptionCaption = 'Pages w. Print,Sheets,Total Pages';
            OptionMembers = "Pages w. Print",Sheets,"Total Pages";
        }
        field(80115; "PTE UBG  Pages"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Pages';
            Description = 'PRINTVIS';
        }
        field(80116; "PTE UBG  Format Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Format Code';
            Description = 'PRINTVIS';
            TableRelation = "PVS Format Code" where(Type = filter(Miscellaneous | "Final format"));
            ValidateTableRelation = false;
        }
        field(80117; "PTE UBG  Colors Front"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Color Front';
            Description = 'PRINTVIS';
        }
        field(80118; "PTE UBG  Colors Back"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Color Back';
            Description = 'PRINTVIS';
        }
        field(80119; "PTE UBG  Paper"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Paper';
            Description = 'PRINTVIS';
            TableRelation = Item where("PVS Item Type" = const(Paper));
        }
        field(80120; "PTE UBG  Unchanged Reprint"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Unchanged Reissue';
            Description = 'PRINTVIS';
        }

    }
}
