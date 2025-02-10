Page 80204 "PVS Sync Field Mapping"
{
    Caption = 'Sync Field Mapping';
    DataCaptionExpression = Rec."Field Name";
    PageType = List;
    SourceTable = "PVS Sync Field Mapping";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(TableNo; Rec."Table No.")
                {
                    ApplicationArea = All;
                }
                field(FieldNo; Rec."Field No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'The Type is mainly an internal field, defining which fields and functions are avaliable to the viewer.The Type options are;- Team- Blocked- Manning- Open Period- Template Team- Template Manning- Master Calendar';
                }
                field(BusinessGroup; Rec."Business Group")
                {
                    ApplicationArea = All;
                }
                field(FromCode; Rec."From Code")
                {
                    ApplicationArea = All;
                }
                field(ToCode; Rec."To Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'When an Item Type Code has been selected, the desciption is presented here.';
                }
                field(FieldName; Rec."Field Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
