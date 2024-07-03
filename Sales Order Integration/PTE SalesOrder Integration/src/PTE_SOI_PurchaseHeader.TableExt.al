TableExtension 80102 "PTE SOI Purchase Header" extends "Purchase Header" //"PVS tableextension6010103"
{
    fields
    {
        field(80101; "PTE SOI Control Qty Incl. VAT"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Control amount including VAT';
            Description = 'PRINTVIS';

            ObsoleteReason = 'Not used anymore';
            ObsoleteTag = '22.0';
            ObsoleteState = Pending;
        }
        field(80102; "PTE SOI Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
            Description = 'PRINTVIS';
            OptionCaption = 'Supply,Selected,Canceled';
            OptionMembers = Supply,Selected,Canceled;
        }
        field(80103; "PTE SOI P-Order Type"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Order Type';
            Description = 'PRINTVIS';
            TableRelation = "PVS Order Type";

            trigger OnValidate()
            var
                PVSPurchaseManagement: Codeunit "PTE SOI Purchase Order Mgt";
            begin
                PVSPurchaseManagement.PurchHead_Validate_OrderType(Rec);
            end;
        }
        field(80104; "PTE SOI Status Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Status Code';
            Description = 'PRINTVIS';
            TableRelation = "PVS Status Code".Code where(User = const(''));

            trigger OnValidate()
            var
                PVSPurchaseManagement: Codeunit "PTE SOI Purchase Order Mgt";
            begin
                PVSPurchaseManagement.PurchHead_Validate_StatusCode(Rec, xRec);
            end;
        }
        field(80105; "PTE SOI Status Text"; Text[250])
        {
            CalcFormula = lookup("PVS Status Code".Text where(Code = field("PTE SOI Status Code"),
                                                                       User = const('')));
            Caption = 'Status Description';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80106; "PTE SOI Deadline"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Deadline';
            Description = 'PRINTVIS';
        }
        field(80107; "PTE SOI Person Responsible"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Responsible';
            Description = 'PRINTVIS';
            NotBlank = true;
            TableRelation = "PVS Capacity Resource" where(Type = const(Person));

            trigger OnValidate()
            begin
                if CurrFieldNo = FieldNo("PTE SOI Person Responsible") then
                    "PTE SOI Manual Responsible" := true;
            end;
        }
        field(80108; "PTE SOI Person Respon. Name"; Text[50])
        {
            CalcFormula = lookup("PVS Capacity Resource".Name where("No." = field("PTE SOI Person Responsible")));
            Caption = 'Responsible Name';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                CalcFields("PTE SOI Person Respon. Name");
            end;
        }
        field(80109; "PTE SOI Manual Responsible"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Manual Responsible';
            Description = 'PRINTVIS';

            trigger OnValidate()
            var
                PVSPurchaseManagement: Codeunit "PTE SOI Purchase Order Mgt";
            begin
                if not "PTE SOI Manual Responsible" then
                    PVSPurchaseManagement.PurchHead_Get_Responsible(Rec);
            end;
        }
        field(80110; "PTE SOI Next Status"; Code[20])
        {
            CalcFormula = lookup("PVS Status Code"."Next Status" where(Code = field("PTE SOI Status Code"),
                                                                                User = const('')));
            Caption = 'Next Status';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80111; "PTE SOI Coordinator"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Coordinator';
            Description = 'PRINTVIS';
            TableRelation = "PVS Capacity Resource" where(Type = const(Person),
                                                                   Coordinator = const(true));

            trigger OnValidate()
            begin
                CalcFields("PTE SOI Coordinator Name");
            end;
        }
        field(80112; "PTE SOI Coordinator Name"; Text[50])
        {
            CalcFormula = lookup("PVS Capacity Resource".Name where("No." = field("PTE SOI Coordinator")));
            Caption = 'Coordinator Name';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80113; "PTE SOI Order Type Description"; Text[100])
        {
            CalcFormula = lookup("PVS Order Type".Description where(Code = field("PTE SOI P-Order Type")));
            Caption = 'Order Type Text';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80114; "PTE SOI Remaining Order"; Boolean)
        {
            CalcFormula = exist("Purchase Line" where("Document Type" = field("Document Type"),
                                                               "Document No." = field("No."),
                                                               "Outstanding Qty. (Base)" = filter(<> 0)));
            Caption = 'Remaing Order';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80115; "PTE SOI Expected Receipt Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Expected Receipt Time';
            Description = 'PRINTVIS';
        }
    }
}