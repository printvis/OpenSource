Query 80101 "PTE SOI Count Sales Orders"
{
    // <PRINTVIS>
    //   Copy of Query 9060
    //   Filter Fields added
    // </PRINTVIS>

    Caption = 'Count Sales Orders';

    elements
    {
        dataitem(Sales_Header; "Sales Header")
        {
            DataItemTableFilter = "Document Type" = const(Order);
            filter(Status; Status)
            {
            }
            filter(Shipped; Shipped)
            {
            }
            filter(Completely_Shipped; "Completely Shipped")
            {
            }
            filter(Responsibility_Center; "Responsibility Center")
            {
            }
            filter(Shipped_Not_Invoiced; "Shipped Not Invoiced")
            {
            }
            filter(Ship; Ship)
            {
            }
            filter(Date_Filter; "Date Filter")
            {
            }
            filter(Late_Order_Shipping; "Late Order Shipping")
            {
            }
            filter(Shipment_Date; "Shipment Date")
            {
            }
            filter(PVS_Person_Responsible; "PTE SOI Person Responsible")
            {
            }
            filter(PVS_Coordinator; "PTE SOI Coordinator")
            {
            }
            column(Count_Orders)
            {
                Method = Count;
            }
        }
    }
}

