Tableextension 80118 "PVS PTE UBG Sales Header Arc" extends "Sales Header Archive" //"PVS tableextension6010128"
{
    fields
    {

        field(80121; "PTE UBG  Reception"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Reception';
            Description = 'PRINTVIS';
            OptionCaption = 'Telephone,Fax,Letter,E-mail,Internet';
            OptionMembers = Telephone,Fax,Letter,"E-mail",Internet;
        }
        field(80122; "PTE UBG  Calc. Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Calculation not completed';
            Description = 'PRINTVIS';
            OptionCaption = 'Calculate,Wait';
            OptionMembers = Calculate,Wait;
        }
        field(80123; "PTE UBG  Price Method"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Price Method';
            Description = 'PRINTVIS';
            OptionCaption = 'As per Quote,In accordance with consumption,Manual Price';
            OptionMembers = "As per Quote","In accordance with consumption","Manual Price";
        }
        field(80124; "PTE UBG  Order Type Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Order Type';
            Description = 'PRINTVIS';
            TableRelation = "PVS Order Type";
        }
        field(80125; "PTE UBG  Status Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Status Code';
            Description = 'PRINTVIS';
            TableRelation = if ("Document Type" = const(Quote)) "PVS Status Code".Code where(Status = filter(Quote ..),
                                                                                            User = filter(''))
            else
            if ("Document Type" = const(Order)) "PVS Status Code".Code where(Status = filter(Order ..), User = filter(''));
        }

        field(80126; "PTE UBG  Deadline"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Deadline';
            Description = 'PRINTVIS';
        }
        field(80127; "PTE UBG  Person Responsible"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Responsible';
            Description = 'PRINTVIS';
            NotBlank = true;
            TableRelation = "PVS Capacity Resource" where(Type = const(Person));
        }

        field(80128; "PTE UBG  Manual Responsible"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Manual Responsible';
            Description = 'PRINTVIS';
        }
        field(80129; "PTE UBG  Coordinator"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Coordinator';
            Description = 'PRINTVIS';
            TableRelation = "PVS User Setup" where(Coordinator = const(true));
        }


        field(80130; "PTE UBG  Customer Group Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Group';
            Description = 'PRINTVIS';
            TableRelation = "PVS Customer Group";
        }
        field(80131; "PTE UBG  Rejection Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Rejection Code';
            Description = 'PRINTVIS';
            TableRelation = "PVS Rejection Cause";
        }



        field(80132; "PTE UBG  End User Contact"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'End User Contact';
            Description = 'PRINTVIS';
            TableRelation = Contact;
        }
    }
}
