TableExtension 80105 "PTE SOI S. Header Archive" extends "Sales Header Archive" //"PVS tableextension6010128"
{
    fields
    {
        field(80101; "PTE SOI Reception"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Reception';
            Description = 'PRINTVIS';
            OptionCaption = 'Telephone,Fax,Letter,E-mail,Internet';
            OptionMembers = Telephone,Fax,Letter,"E-mail",Internet;
        }
        field(80102; "PTE SOI Calc. Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Calculation not completed';
            Description = 'PRINTVIS';
            OptionCaption = 'Calculate,Wait';
            OptionMembers = Calculate,Wait;
        }
        field(80103; "PTE SOI Price Method"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Price Method';
            Description = 'PRINTVIS';
            OptionCaption = 'As per Quote,In accordance with consumption,Manual Price';
            OptionMembers = "As per Quote","In accordance with consumption","Manual Price";
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
            TableRelation = if ("Document Type" = const(Quote)) "PVS Status Code".Code where(Status = filter(Quote ..),
                                                                                            User = filter(''))
            else
            if ("Document Type" = const(Order)) "PVS Status Code".Code where(Status = filter(Order ..),
                                                                                                                                                                 User = filter(''));
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
            TableRelation = "PVS User Setup" where(Coordinator = const(true));
        }
        field(80112; "PTE SOI Coordinator Name"; Text[80])
        {
            CalcFormula = lookup(User."Full Name" where("User Name" = field("PTE SOI Coordinator")));
            Caption = 'Coordinator Name';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80113; "PTE SOI Order Type Description"; Text[100])
        {
            CalcFormula = lookup("PVS Order Type".Description where(Code = field("PTE SOI Order Type Code")));
            Caption = 'Order Type Text';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80114; "PTE SOI Customer Group Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Group';
            Description = 'PRINTVIS';
            TableRelation = "PVS Customer Group";
        }
        field(80115; "PTE SOI Rejection Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Rejection Code';
            Description = 'PRINTVIS';
            TableRelation = "PVS Rejection Cause";
        }
        field(80116; "PTE SOI Rejection Text"; Text[100])
        {
            CalcFormula = lookup("PVS Rejection Cause".Description where(Code = field("PTE SOI Rejection Code")));
            Caption = 'Rejection Text';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80117; "PTE SOI Comment Case Mgt."; Boolean)
        {
            CalcFormula = exist("PVS Job Text Description" where("Table ID" = const(36),
                                                                  Code = field("No."),
                                                                  Type = const("Case Management Comment")));
            Caption = 'Comment Case Management';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80118; "PTE SOI Pri. Fin. Item Des."; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("PVS Primary Finished Item")));
            Caption = 'Primary Finished Item Description';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80119; "PTE SOI End User Contact"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'End User Contact';
            Description = 'PRINTVIS';
            TableRelation = Contact;
        }
        field(80120; "PTE SOI End User Contact Name"; Text[100])
        {
            CalcFormula = lookup(Contact.Name where("No." = field("PTE SOI End User Contact")));
            Caption = 'End User Contact Name';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Contact.Name;
        }
    }
}