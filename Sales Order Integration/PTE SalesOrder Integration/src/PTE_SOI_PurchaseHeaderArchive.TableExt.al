TableExtension 80103 "PTE SOI Purchase Header Arc" extends "Purchase Header Archive" //"PVS tableextension6010130"
{
    fields
    {
        field(80101; "PTE SOI Archived"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Archived';
            Description = 'PRINTVIS';
            Editable = false;
        }

        field(80102; "PTE SOI Control Qty Incl. VAT"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Control amount including VAT';
            Description = 'PRINTVIS';

            ObsoleteReason = 'Not used anymore';
            ObsoleteTag = '22.0';
            ObsoleteState = Pending;
        }
        field(80103; "PTE SOI Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'NVS Status';
            Description = 'PRINTVIS';
            OptionCaption = 'Supply,Selected,Canceled';
            OptionMembers = Supply,Selected,Canceled;
        }
        field(80104; "PTE SOI Order Type Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Order Type';
            Description = 'PRINTVIS';
            TableRelation = "PVS Order Type";
        }
        field(80105; "PTE SOI Status Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Status Code';
            Description = 'PRINTVIS';
            TableRelation = "PVS Status Code".Code where(User = const(''));
        }
        field(80106; "PTE SOI Status Text"; Text[250])
        {
            CalcFormula = lookup("PVS Status Code".Text where(Code = field("PTE SOI Status Code"),
                                                               User = const('')));
            Caption = 'Status Description';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80107; "PTE SOI Deadline"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Deadline';
            Description = 'PRINTVIS';
        }
        field(80108; "PTE SOI Person Responsible"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Responsible';
            Description = 'PRINTVIS';
            NotBlank = true;
            TableRelation = "PVS Capacity Resource" where(Type = const(Person));
        }
        field(80109; "PTE SOI Person Respon. Name"; Text[50])
        {
            CalcFormula = lookup("PVS Capacity Resource".Name where("No." = field("PTE SOI Person Responsible")));
            Caption = 'Responsible Name';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80110; "PTE SOI Manual Responsible"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Manual Responsible';
            Description = 'PRINTVIS';
        }
        field(80111; "PTE SOI Coordinator"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Coordinator';
            Description = 'PRINTVIS';
            TableRelation = "PVS Capacity Resource" where(Type = const(Person),
                                                           Coordinator = const(true));
        }
        field(80112; "PTE SOI Coordinator Name"; Text[50])
        {
            CalcFormula = lookup("PVS Capacity Resource".Name where("No." = field("PTE SOI Coordinator")));
            Caption = 'Coordinator Name';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80113; "PTE SOI Expected Receipt Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Expected Receipt Time';
            Description = 'PRINTVIS';
        }
    }

}