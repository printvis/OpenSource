Report 80102 "PTE SOI S.O. - List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/SalesOrderList.rdlc';
    Caption = 'PrintVis Sales Order - List';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.");
            RequestFilterFields = "Document Type", "No.";
            column(FORMAT_TODAY_0_4; Format(Today(), 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }

            column(UserId; UserId)
            {
            }
            column(SH_Document_Type; "Document Type")
            {
            }
            column(SH_Your_Reference; "Your Reference")
            {
            }
            column(SH_No; "No.")
            {
            }
            column(SH_Order_Date; "Order Date")
            {
            }
            column(SH_Requested_Delivery_Date; "Requested Delivery Date")
            {
            }
            column(SH_P_Order_Type; "PTE SOI Order Type Code")
            {
            }
            column(SH_P_Order_No; "PVS Order No.")
            {
            }
            column(SH_Coordinator; "PTE SOI Coordinator")
            {
            }
            column(SH_Salesperson_Code; "Salesperson Code")
            {
            }
            column(SH_Sell_to_Customer_No; "Sell-to Customer No.")
            {
            }
            column(SH_Production_Order; "PTE SOI Production Order")
            {
            }
            column(SH_Purchase_Order; "PTE SOI Purchase Order")
            {
            }
            column(SH_Status; Status)
            {
            }
            column(SH_Person_Responsible; "PTE SOI Person Responsible")
            {
            }
            column(SH_Deadline; "PTE SOI Deadline")
            {
            }
            column(SH_Caption; Sales_HeaderCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(TypeCaption; TypeCaptionLbl)
            {
            }
            column(SH_Your_Reference_Caption; FieldCaption("Your Reference"))
            {
            }
            column(SH_No__Caption; FieldCaption("No."))
            {
            }
            column(SH_Order_Date_Caption; FieldCaption("Order Date"))
            {
            }
            column(Requested_Delivery_DateCaption; Requested_Delivery_DateCaptionLbl)
            {
            }
            column(SH_P_Order_Type_Caption; FieldCaption("PTE SOI Order Type Code"))
            {
            }
            column(SH_P_Order_No__Caption; FieldCaption("PVS Order No."))
            {
            }
            column(SH_CoordinatorCaption; FieldCaption("PTE SOI Coordinator"))
            {
            }
            column(SH_Salesperson_Code_Caption; FieldCaption("Salesperson Code"))
            {
            }
            column(SH_Sell_to_Customer_No__Caption; FieldCaption("Sell-to Customer No."))
            {
            }
            column(SH_Production_Order_Caption; FieldCaption("PTE SOI Production Order"))
            {
            }
            column(SH_Purchase_Order_Caption; FieldCaption("PTE SOI Purchase Order"))
            {
            }
            column(SH_StatusCaption; FieldCaption(Status))
            {
            }
            column(SH_Person_Responsible_Caption; FieldCaption("PTE SOI Person Responsible"))
            {
            }
            column(SH_DeadlineCaption; FieldCaption("PTE SOI Deadline"))
            {
            }
        }
    }

    var
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Requested_Delivery_DateCaptionLbl: label 'Requested Delivery Date';
        Sales_HeaderCaptionLbl: label 'Sales Header';
        TypeCaptionLbl: label 'Type';
}

