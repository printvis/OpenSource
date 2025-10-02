tableextension 80185 "SISM Job Shipment" extends "PVS Job Shipment"
{
    fields
    {
        field(80184; "SISM Print Label"; Boolean)
        {
            Caption = 'Print Label';
            ToolTip = 'Specifies whether to print the label via the print client. When enabled, shipment labels will be sent automatically to the print queue using the specified printer.';
        }
        field(80185; "SISM Printer Name"; Text[250])
        {
            Caption = 'Printer Name';
            DataClassification = CustomerContent;
            TableRelation = "SISM Print Client";
        }
        field(80186; "SISM Printer Label Format"; Text[30])
        {
            CalcFormula = lookup("SISM Print Client"."Label Format" where("Name" = field("SISM Printer Name")));
            Caption = 'Label Format';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80187; "SISM Printer Hostname"; Text[100])
        {
            CalcFormula = lookup("SISM Print Client"."Hostname" where("Name" = field("SISM Printer Name")));
            Caption = 'Hostname';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80188; "SISM Service Point ID"; Code[20])
        {
            Caption = 'Service Point ID';
            DataClassification = CustomerContent;
        }
    }
}