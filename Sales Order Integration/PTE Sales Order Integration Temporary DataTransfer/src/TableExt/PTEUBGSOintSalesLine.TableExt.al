Tableextension 80117 "PTE UBG SOint Sales Line" extends "Sales Line" //"PVS tableextension6010102"
{
    fields
    {
        field(80119; "PTE UBG  Qty. Order"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Prod. Quantity';
            Description = 'PRINTVIS';
        }

        field(80120; "PTE UBG  Unit"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Unit';
            Description = 'PRINTVIS';
            OptionCaption = ' ,per 1000';
            OptionMembers = " ","per 1000";

        }
        field(80121; "PTE UBG  Sales Price"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            BlankZero = true;
            Caption = 'Prod. Price';
            Description = 'PRINTVIS';

        }
        field(80122; "PTE UBG  Production Order"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Production Order';
            Description = 'PRINTVIS';

        }
        field(80123; "PTE UBG  Page Unit"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Page Unit';
            Description = 'PRINTVIS';
            OptionCaption = 'Pages w. Print,Sheets,Total Pages';
            OptionMembers = "Pages w. Print",Sheets,"Total Pages";

        }
        field(80124; "PTE UBG  Pages"; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Pages';
            Description = 'PRINTVIS';

        }
        field(80125; "PTE UBG  Format Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Format Code';
            Description = 'PRINTVIS';
            TableRelation = "PVS Format Code" where(Type = filter(Miscellaneous | "Final format"));
            ValidateTableRelation = false;

        }
        field(80126; "PTE UBG  Colors Front"; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Color Front';
            Description = 'PRINTVIS';

        }
        field(80127; "PTE UBG  Colors Back"; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Color Back';
            Description = 'PRINTVIS';

        }
        field(80128; "PTE UBG  Paper"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Paper';
            Description = 'PRINTVIS';
            TableRelation = Item where("PVS Item Type" = const(Paper));

        }
        field(80129; "PTE UBG  Unchanged Reprint"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Unchanged Reissue';
            Description = 'PRINTVIS';

        }

        field(80130; "PTE UBG  Production Qty."; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Quantity';
            Description = 'PRINTVIS';
        }

    }
}

