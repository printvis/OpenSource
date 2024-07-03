Tableextension 80115 "PTE UBG SOint Sales Header" extends "Sales Header" //"PVS tableextension6010101"
{
    fields
    {
        field(80117; "PTE UBG  Calc. Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Calculation not completed';
            Description = 'PRINTVIS';
            OptionCaption = 'Calculate,Wait';
            OptionMembers = Calculate,Wait;
        }
        field(80118; "PTE UBG  Price Method"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Price Method';
            Description = 'PRINTVIS';
            OptionCaption = 'As per Quote,In accordance with consumption,Manual Price';
            OptionMembers = "As per Quote","In accordance with consumption","Manual Price";
        }
        field(80119; "PTE UBG  Order Type Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Order Type';
            Description = 'PRINTVIS';
            TableRelation = "PVS Order Type";
        }
        field(80120; "PTE UBG  Status Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Status Code';
            Description = 'PRINTVIS';
            TableRelation = if ("Document Type" = const(Quote)) "PVS Status Code".Code where(Status = filter(Quote ..),
                                                                                            User = filter(''))
            else
            if ("Document Type" = const(Order)) "PVS Status Code".Code where(Status = filter(Order ..), User = filter(''));

        }

        field(80121; "PTE UBG  Deadline"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Deadline';
            Description = 'PRINTVIS';
        }
        field(80122; "PTE UBG  Person Responsible"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Responsible';
            Description = 'PRINTVIS';
            NotBlank = true;
            TableRelation = "PVS Capacity Resource" where(Type = const(Person));

        }

        field(80123; "PTE UBG  Manual Responsible"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Manual Responsible';
            Description = 'PRINTVIS';

        }

        field(80124; "PTE UBG  Coordinator"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Coordinator';
            Description = 'PRINTVIS';
            TableRelation = "PVS User Setup";
        }

    }
    keys
    {
        key(PVSKey2; "PTE UBG  Person Responsible")
        {
        }
    }
}
