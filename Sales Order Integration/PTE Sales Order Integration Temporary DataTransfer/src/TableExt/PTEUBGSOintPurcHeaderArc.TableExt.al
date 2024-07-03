Tableextension 80113 "PTE UBG SOint Purc Header Arc" extends "Purchase Header Archive" //"PVS tableextension6010130"
{
    fields
    {
        field(80114; "PTE UBG  Archived"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Archived';
            Description = 'PRINTVIS';
            Editable = false;
        }

        field(80115; "PTE UBG  Cont Amount Incl. VAT"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Control amount including VAT';
            Description = 'PRINTVIS';
            ObsoleteReason = 'Not used anymore';
            ObsoleteTag = '22.0';
            ObsoleteState = Pending;
        }
        field(80116; "PTE UBG  Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'NVS Status';
            Description = 'PRINTVIS';
            OptionCaption = 'Supply,Selected,Canceled';
            OptionMembers = Supply,Selected,Canceled;
        }
        field(80117; "PTE UBG  Order Type Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Order Type';
            Description = 'PRINTVIS';
            TableRelation = "PVS Order Type";
        }
        field(80118; "PTE UBG  Status Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Status Code';
            Description = 'PRINTVIS';
            TableRelation = "PVS Status Code".Code where(User = const(''));
        }

        field(80119; "PTE UBG  Deadline"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Deadline';
            Description = 'PRINTVIS';
        }
        field(80120; "PTE UBG  Person Responsible"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Responsible';
            Description = 'PRINTVIS';
            NotBlank = true;
            TableRelation = "PVS Capacity Resource" where(Type = const(Person));
        }

        field(80121; "PTE UBG  Manual Responsible"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Manual Responsible';
            Description = 'PRINTVIS';
        }
        field(80122; "PTE UBG  Coordinator"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Coordinator';
            Description = 'PRINTVIS';
            TableRelation = "PVS Capacity Resource" where(Type = const(Person),
                                                           Coordinator = const(true));
        }

        field(80123; "PTE UBG  Expected Receipt Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Expected Receipt Time';
            Description = 'PRINTVIS';
        }
    }

}
