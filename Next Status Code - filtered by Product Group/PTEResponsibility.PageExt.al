pageextension 80278 "PTE Status Responsiblity Area" extends "PVS Status Responsiblity Area"
{
    layout
    {
        addafter(OrderType)
        {
            field("Product Group"; Rec."Product Group")
            {
                ApplicationArea = All;
                ToolTip = 'Product Group relates to the "Code" field in table "Product Group".The Product Group can be selected from the Product Group table.If you want a specific status sequence for specific Order type, you select the desired Order type by a look-up in the field. Please note that the selected setup will only apply to the selected order type. Therefore, a set of Responsibility areas must exist for each Order type along with a set without Order type which the system will choose if the order type is different than the one/those defined in Responsibility areas or is not filled in. ';
            }
        }
        modify(CustomerGroup)
        {
            Visible = false;
            Caption = 'Product Group';
        }
    }
}
