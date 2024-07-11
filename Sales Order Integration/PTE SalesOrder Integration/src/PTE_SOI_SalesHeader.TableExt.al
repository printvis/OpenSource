TableExtension 80108 "PTE SOI S. Header" extends "Sales Header" //"PVS tableextension6010101"
{
    fields
    {
        field(80101; "PTE SOI Calc. Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Calculation not completed';
            Description = 'PRINTVIS';
            OptionCaption = 'Calculate,Wait';
            OptionMembers = Calculate,Wait;
        }
        field(80102; "PTE SOI Price Method"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Price Method';
            Description = 'PRINTVIS';
            OptionCaption = 'As per Quote,In accordance with consumption,Manual Price';
            OptionMembers = "As per Quote","In accordance with consumption","Manual Price";
        }
        field(80103; "PTE SOI Order Type Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Order Type';
            Description = 'PRINTVIS';
            TableRelation = "PVS Order Type";

            trigger OnValidate()
            var
                PVSalesorderManagement: Codeunit "PTE SOI S.O. Mgt";
            begin
                PVSalesorderManagement.SalesHead_Validate_OrderType(Rec);
            end;
        }
        field(80104; "PTE SOI Status Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Status Code';
            Description = 'PRINTVIS';
            TableRelation = if ("Document Type" = const(Quote)) "PVS Status Code".Code where(Status = filter(Quote ..),
                                                                                            User = filter(''))
            else
            if ("Document Type" = const(Order)) "PVS Status Code".Code where(Status = filter(Order ..),
                                                                                                                                                                 User = filter(''));

            trigger OnLookup()
            var
                PVSalesorderManagement: Codeunit "PTE SOI S.O. Mgt";
            begin
                PVSalesorderManagement.SalesHead_OnLookUp_StatusCode(Rec);
            end;

            trigger OnValidate()
            var
                PVSalesorderManagement: Codeunit "PTE SOI S.O. Mgt";
            begin
                PVSalesorderManagement.SalesHead_Validate_StatusCode(Rec, xRec, true);
            end;
        }

        field(80105; "PTE SOI Deadline"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Deadline';
            Description = 'PRINTVIS';
        }
        field(80106; "PTE SOI Person Responsible"; Code[50])
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

        field(80107; "PTE SOI Manual Responsible"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Manual Responsible';
            Description = 'PRINTVIS';

            trigger OnValidate()
            var
                PVSalesorderManagement: Codeunit "PTE SOI S.O. Mgt";
            begin
                if not "PTE SOI Manual Responsible" then
                    PVSalesorderManagement.SalesHead_Get_Reponsible(Rec);
            end;
        }
        field(80109; "PTE SOI Coordinator"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Coordinator';
            Description = 'PRINTVIS';
            TableRelation = "PVS User Setup";

            trigger OnValidate()
            begin
                CalcFields("PTE SOI Coordinator Name");
            end;
        }
        field(80113; "PTE SOI Coordinator Name"; Text[50])
        {
            CalcFormula = lookup("PVS User Setup".Name where("User ID" = field("PTE SOI Coordinator")));
            Caption = 'Coordinator Name';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;

        }
        field(80114; "PTE SOI Order Type Description"; Text[100])
        {
            CalcFormula = lookup("PVS Order Type".Description where(Code = field("PTE SOI Order Type Code")));
            Caption = 'Order Type Text';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80115; "PTE SOI Comment Case Mgt."; Boolean)
        {
            CalcFormula = exist("PVS Job Text Description" where("Table ID" = const(36),
                                                                  Code = field("No."),
                                                                  Type = const("Case Management Comment")));
            Caption = 'Comment Case Management';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80116; "PTE SOI Next Status"; Code[20])
        {
            CalcFormula = lookup("PVS Status Code"."Next Status" where(Code = field("PTE SOI Status Code"),
                                                                        User = const('')));
            Caption = 'Next Status';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80117; "PTE SOI Production Order"; Boolean)
        {
            CalcFormula = exist("Sales Line" where("Document Type" = field("Document Type"),
                                                    "Document No." = field("No."),
                                                    Type = const(Item),
                                                    "PTE SOI Production Order" = const(true)));
            Caption = 'Production Order';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80118; "PTE SOI Purchase Order"; Boolean)
        {
            CalcFormula = exist("Sales Line" where("Document Type" = field("Document Type"),
                                                    "Document No." = field("No."),
                                                    Type = const(Item),
                                                    "Purchase Order No." = filter(<> ''),
                                                    "Purch. Order Line No." = filter(<> 0)));
            Caption = 'Purchase Order';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80119; "PTE SOI Person Respon. Name"; Text[50])
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
        field(80120; "PTE SOI Status Text"; Text[250])
        {
            CalcFormula = lookup("PVS Status Code".Text where(Code = field("PTE SOI Status Code"),
                                                               User = const('')));
            Caption = 'Status Description';
            Description = 'PRINTVIS';
            Editable = false;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(PTEPVSKey2; "PTE SOI Person Responsible")
        {
        }
    }
}