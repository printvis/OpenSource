Report 80101 "PTE SOI Purchase Order List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PurchaseOrderList.rdlc';
    Caption = 'PrintVis Purchase Order - List';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = sorting("Document Type", "No.");
            RequestFilterFields = "Document Type", "No.";
            column(FORMAT_TODAY_0_4_; Format(Today(), 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }

            column(UserId; UserId)
            {
            }
            column(PH_Document_Type; "Document Type")
            {
            }
            column(PH_No; "No.")
            {
            }
            column(PH_Order_Date; "Order Date")
            {
            }
            column(PH_P_Order_Type; "PTE SOI P-Order Type")
            {
            }
            column(PH_Coordinator; "PTE SOI Coordinator")
            {
            }
            column(PH_Sell_to_Customer_No; "Sell-to Customer No.")
            {
            }
            column(PH_Status; Status)
            {
            }
            column(PH_Person_Responsible; "PTE SOI Person Responsible")
            {
            }
            column(PH_Deadline; "PTE SOI Deadline")
            {
            }
            column(PH_Receive; Receive)
            {
            }
            column(PH_Expected_Receipt_Date; "Expected Receipt Date")
            {
            }
            column(PH_Buy_from_Vendor_No; "Buy-from Vendor No.")
            {
            }
            column(PH_Purchaser_Code; "Purchaser Code")
            {
            }
            column(Sales_HeaderCaption; Sales_HeaderCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(TypeCaption; TypeCaptionLbl)
            {
            }
            column(PH_No_Caption; FieldCaption("No."))
            {
            }
            column(PH_Order_Date_Caption; FieldCaption("Order Date"))
            {
            }
            column(PH_P_Order_Type_Caption; FieldCaption("PTE SOI P-Order Type"))
            {
            }
            column(PH_CoordinatorCaption; FieldCaption("PTE SOI Coordinator"))
            {
            }
            column(PH_Sell_to_Customer_No_Caption; FieldCaption("Sell-to Customer No."))
            {
            }
            column(PH_StatusCaption; FieldCaption(Status))
            {
            }
            column(PH_Person_Responsible_Caption; FieldCaption("PTE SOI Person Responsible"))
            {
            }
            column(PH_DeadlineCaption; FieldCaption("PTE SOI Deadline"))
            {
            }
            column(PH_ReceiveCaption; FieldCaption(Receive))
            {
            }
            column(PH_Expected_Receipt_Date_Caption; FieldCaption("Expected Receipt Date"))
            {
            }
            column(PH_Buy_from_Vendor_No_Caption; FieldCaption("Buy-from Vendor No."))
            {
            }
            column(PH_Purchaser_Code_Caption; FieldCaption("Purchaser Code"))
            {
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Sales_HeaderCaptionLbl: label 'Sales Header';
        TypeCaptionLbl: label 'Type';
}

