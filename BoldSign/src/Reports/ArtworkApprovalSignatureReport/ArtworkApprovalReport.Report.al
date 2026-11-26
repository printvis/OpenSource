namespace PrintVis.BoldSign.Reports;

using Microsoft.Bank.BankAccount;
using Microsoft.CRM.Contact;
using Microsoft.CRM.Team;
using Microsoft.Finance.Currency;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Foundation.Address;
using Microsoft.Foundation.Company;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Setup;
using Microsoft.Utilities;
using System.Globalization;

report 80301 "PVS BS Artwork Approval Report"
{
    ApplicationArea = All;
    Caption = 'PrintVis Artwork Approval Report';
    DefaultRenderingLayout = "PVS BS Artwork Approval";

    dataset
    {
        dataitem(PVSCase; "PVS Case")
        {
            RequestFilterFields = ID, "Order No.";

            column(BillToContactEmail; BillToContact."E-Mail") { }
            column(BillToContactEmailLbl; BillToContactEmailLbl) { }
            column(BillToContactMobilePhoneNo; BillToContact."Mobile Phone No.") { }
            column(BillToContactMobilePhoneNoLbl; BillToContactMobilePhoneNoLbl) { }
            column(BillToContactPhoneNo; BillToContact."Phone No.") { }
            column(BillToContactPhoneNoLbl; BillToContactPhoneNoLbl) { }
            column(BilltoCustomerNo_Lbl; FieldCaption("Bill-To No.")) { }
            column(BilltoCustumerNo; "Bill-To No.") { }
            column(CompanyAddress1; CompanyAddr[1]) { }
            column(CompanyAddress2; CompanyAddr[2]) { }
            column(CompanyAddress3; CompanyAddr[3]) { }
            column(CompanyAddress4; CompanyAddr[4]) { }
            column(CompanyAddress5; CompanyAddr[5]) { }
            column(CompanyAddress6; CompanyAddr[6]) { }
            column(CompanyAddress7; CompanyAddr[7]) { }
            column(CompanyAddress8; CompanyAddr[8]) { }
            column(CompanyBankAccountNo; CompanyBankAccount."Bank Account No.") { }
            column(CompanyBankAccountNo_Lbl; CompanyInfoBankAccNoLbl) { }
            column(CompanyBankBranchNo; CompanyBankAccount."Bank Branch No.") { }
            column(CompanyBankBranchNo_Lbl; CompanyBankAccount.FieldCaption("Bank Branch No.")) { }
            column(CompanyBankName; CompanyBankAccount.Name) { }
            column(CompanyBankName_Lbl; CompanyInfoBankNameLbl) { }
            column(CompanyEMail; CompanyInfo."E-Mail") { }
            column(CompanyGiroNo; CompanyInfo."Giro No.") { }
            column(CompanyGiroNo_Lbl; CompanyInfoGiroNoLbl) { }
            column(CompanyHomePage; CompanyInfo."Home Page") { }
            column(CompanyIBAN; CompanyBankAccount.IBAN) { }
            column(CompanyIBAN_Lbl; CompanyBankAccount.FieldCaption(IBAN)) { }
            column(CompanyLogoPosition; CompanyLogoPosition) { }
            column(CompanyPhoneNo; CompanyInfo."Phone No.") { }
            column(CompanyPhoneNo_Lbl; CompanyInfoPhoneNoLbl) { }
            column(CompanyPicture; DummyCompanyInfo.Picture) { }
            column(CompanyRegistrationNumber; CompanyInfo.GetRegistrationNumber()) { }
            column(CompanyRegistrationNumber_Lbl; CompanyInfo.GetRegistrationNumberLbl()) { }
            column(CompanySWIFT; CompanyBankAccount."SWIFT Code") { }
            column(CompanySWIFT_Lbl; CompanyBankAccount.FieldCaption("SWIFT Code")) { }
            column(CompanyVATRegistrationNo; CompanyInfo.GetVATRegistrationNumber()) { }
            column(CompanyVATRegistrationNo_Lbl; CompanyInfo.GetVATRegistrationNumberLbl()) { }
            column(CompanyVATRegNo; CompanyInfo.GetVATRegistrationNumber()) { }
            column(CompanyVATRegNo_Lbl; CompanyInfo.GetVATRegistrationNumberLbl()) { }
            column(Contact_Lbl; CompanyInfo.GetContactUsText()) { }
            column(Coordinator_E_Mail; "Coordinator E-Mail") { }
            column(Coordinator_Name; "Coordinator Name") { }
            column(Currency; GetCurrencySymbol()) { }
            column(CustomerAddress1; CustAddr[1]) { }
            column(CustomerAddress2; CustAddr[2]) { }
            column(CustomerAddress3; CustAddr[3]) { }
            column(CustomerAddress4; CustAddr[4]) { }
            column(CustomerAddress5; CustAddr[5]) { }
            column(CustomerAddress6; CustAddr[6]) { }
            column(CustomerAddress7; CustAddr[7]) { }
            column(CustomerAddress8; CustAddr[8]) { }
            column(CustomerPostalBarCode; FormatAddr.PostalBarCode(1)) { }
            column(DocumentDate; Format("Document Date", 0, 4)) { }
            column(DocumentDate_Lbl; FieldCaption("Document Date")) { }
            column(DocumentNo; PVSCase."Order No.") { }
            column(DocumentNo_Lbl; InvNoLbl) { }
            column(DocumentTitle_Lbl; ArtworkApprovalLbl) { }
            column(DueDate; Format("Due Date", 0, 4)) { }
            column(DueDate_Lbl; FieldCaption("Due Date")) { }
            column(EMail_Lbl; EMailLbl) { }
            column(EstimateFor_Lbl; EstimateForLbl) { }
            column(From_Lbl; FromLbl) { }
            column(HomePage_Lbl; HomePageLbl) { }
            column(LocalCurrency_Lbl; LocalCurrencyLbl) { }
            column(OrderNo; "Order No.") { }
            column(Questions_Lbl; QuestionsLbl) { }
            column(QuoteValidToDate; Format(Deadline, 0, 4)) { }
            column(Salesperson_E_Mail; "Salesperson E-Mail") { }
            column(SalesPerson_Lbl; SalespersonLbl) { }
            column(Salesperson_Name; "Salesperson Name") { }
            column(SalesPersonBlank_Lbl; SalesPersonText) { }
            column(SalesPersonName; SalespersonPurchaser.Name) { }
            column(SellToAddress; "Sell-To Address") { }
            column(SellToAddress2; "Sell-To Address 2") { }
            column(SellToContactEmail; SellToContact."E-Mail") { }
            column(SellToContactEmailLbl; SellToContactEmailLbl) { }
            column(SellToContactMobilePhoneNo; SellToContact."Mobile Phone No.") { }
            column(SellToContactMobilePhoneNoLbl; SellToContactMobilePhoneNoLbl) { }
            column(SellToContactName; SellToContact.Name) { }
            column(SellToContactPhoneNo; SellToContact."Phone No.") { }
            column(SellToContactPhoneNoLbl; SellToContactPhoneNoLbl) { }
            column(SelltoCustomerNo; "Sell-To No.") { }
            column(SelltoCustomerNo_Lbl; FieldCaption("Sell-To No.")) { }
            column(SellToName; "Sell-To Name") { }
            column(ShipToAddress1; ShipToAddr[1]) { }
            column(ShipToAddress2; ShipToAddr[2]) { }
            column(ShipToAddress3; ShipToAddr[3]) { }
            column(ShipToAddress4; ShipToAddr[4]) { }
            column(ShipToAddress5; ShipToAddr[5]) { }
            column(ShipToAddress6; ShipToAddr[6]) { }
            column(ShipToAddress7; ShipToAddr[7]) { }
            column(ShipToAddress8; ShipToAddr[8]) { }
            column(ShipToAddress_Lbl; ShiptoAddrLbl) { }
            column(Thanks_Lbl; ThanksLbl) { }
            column(YourReference; "Your Reference") { }
            column(YourReference__Lbl; FieldCaption("Your Reference")) { }
            dataitem(PVSJob; "PVS Job")
            {
                DataItemLink = ID = field(ID);

                column(PriceColumn1; PriceColumn1) { }
                column(PriceColumn2; PriceColumn2) { }
                column(PriceColumn3; PriceColumn3) { }
                column(PriceColumn4; PriceColumn4) { }
                column(PriceColumn5; PriceColumn5) { }
                column(PriceColumn6; PriceColumn6) { }
                dataitem(JobItem; "PVS Report Line")
                {
                    DataItemTableView = sorting("Sorting Order");
                    UseTemporary = true;

                    column(JobItemDescription; GetBlobReportDescriptionText()) { }
                    column(JobItemLabel; GetBlobReportLabelText()) { }
                }
                dataitem(ProductPart; "PVS Report Line")
                {
                    DataItemTableView = sorting("Sorting Order");
                    UseTemporary = true;
                    column(ProductPartDescription; GetBlobReportDescriptionText()) { }
                    column(ProductPartLabel; GetBlobReportLabelText()) { }
                }
                dataitem(Description1; "PVS Report Line")
                {
                    DataItemTableView = sorting("Sorting Order");
                    UseTemporary = true;

                    column(JobDescription1; GetBlobReportDescriptionText()) { }
                    column(JobLabel1; GetBlobReportLabelText()) { }
                }
                dataitem(Description2; "PVS Report Line")
                {
                    DataItemTableView = sorting("Sorting Order");
                    UseTemporary = true;

                    column(JobDescription2; GetBlobReportDescriptionText()) { }
                    column(JobLabel2; GetBlobReportLabelText()) { }
                }
                dataitem(Description3; "PVS Report Line")
                {
                    DataItemTableView = sorting("Sorting Order");
                    UseTemporary = true;

                    column(JobDescription3; GetBlobReportDescriptionText()) { }
                    column(JobLabel3; GetBlobReportLabelText()) { }
                }
                dataitem(Description4; "PVS Report Line")
                {
                    DataItemTableView = sorting("Sorting Order");
                    UseTemporary = true;

                    column(JobDescription4; GetBlobReportDescriptionText()) { }
                    column(JobLabel4; GetBlobReportLabelText()) { }
                }
                dataitem(Description5; "PVS Report Line")
                {
                    DataItemTableView = sorting("Sorting Order");
                    UseTemporary = true;

                    column(JobDescription5; GetBlobReportDescriptionText()) { }
                    column(JobLabel5; GetBlobReportLabelText()) { }
                }
                dataitem(Description6; "PVS Report Line")
                {
                    DataItemTableView = sorting("Sorting Order");
                    UseTemporary = true;

                    column(JobDescription6; GetBlobReportDescriptionText()) { }
                    column(JobLabel6; GetBlobReportLabelText()) { }
                }
                dataitem(Description7; "PVS Report Line")
                {
                    DataItemTableView = sorting("Sorting Order");
                    UseTemporary = true;

                    column(JobDescription7; GetBlobReportDescriptionText()) { }
                    column(JobLabel7; GetBlobReportLabelText()) { }
                }
                dataitem(Description8; "PVS Report Line")
                {
                    DataItemTableView = sorting("Sorting Order");
                    UseTemporary = true;

                    column(JobDescription8; GetBlobReportDescriptionText()) { }
                    column(JobLabel8; GetBlobReportLabelText()) { }
                }
                dataitem(Description9; "PVS Report Line")
                {
                    DataItemTableView = sorting("Sorting Order");
                    UseTemporary = true;

                    column(JobDescription9; GetBlobReportDescriptionText()) { }
                    column(JobLabel9; GetBlobReportLabelText()) { }
                }
                dataitem(Description10; "PVS Report Line")
                {
                    DataItemTableView = sorting("Sorting Order");
                    UseTemporary = true;

                    column(JobDescription10; GetBlobReportDescriptionText()) { }
                    column(JobLabel10; GetBlobReportLabelText()) { }
                }
                dataitem(Description11; "PVS Report Line")
                {
                    DataItemTableView = sorting("Sorting Order");
                    UseTemporary = true;

                    column(JobDescription11; GetBlobReportDescriptionText()) { }
                    column(JobLabel11; GetBlobReportLabelText()) { }
                }
                dataitem(Description12; "PVS Report Line")
                {
                    DataItemTableView = sorting("Sorting Order");
                    UseTemporary = true;

                    column(JobDescription12; GetBlobReportDescriptionText()) { }
                    column(JobLabel12; GetBlobReportLabelText()) { }
                }
                dataitem(Description13; "PVS Report Line")
                {
                    DataItemTableView = sorting("Sorting Order");
                    UseTemporary = true;

                    column(JobDescription13; GetBlobReportDescriptionText()) { }
                    column(JobLabel13; GetBlobReportLabelText()) { }
                }
                dataitem(Description14; "PVS Report Line")
                {
                    DataItemTableView = sorting("Sorting Order");
                    UseTemporary = true;

                    column(JobDescription14; GetBlobReportDescriptionText()) { }
                    column(JobLabel14; GetBlobReportLabelText()) { }
                }
                dataitem(Description15; "PVS Report Line")
                {
                    DataItemTableView = sorting("Sorting Order");
                    UseTemporary = true;

                    column(JobDescription15; GetBlobReportDescriptionText()) { }
                    column(JobLabel15; GetBlobReportLabelText()) { }
                }
                dataitem(Description16; "PVS Report Line")
                {
                    DataItemTableView = sorting("Sorting Order");
                    UseTemporary = true;

                    column(JobDescription16; GetBlobReportDescriptionText()) { }
                    column(JobLabel16; GetBlobReportLabelText()) { }
                }
                dataitem(Description17; "PVS Report Line")
                {
                    DataItemTableView = sorting("Sorting Order");
                    UseTemporary = true;

                    column(JobDescription17; GetBlobReportDescriptionText()) { }
                    column(JobLabel17; GetBlobReportLabelText()) { }
                }
                dataitem(Description18; "PVS Report Line")
                {
                    DataItemTableView = sorting("Sorting Order");
                    UseTemporary = true;

                    column(JobDescription18; GetBlobReportDescriptionText()) { }
                    column(JobLabel18; GetBlobReportLabelText()) { }
                }
                dataitem(Description19; "PVS Report Line")
                {
                    DataItemTableView = sorting("Sorting Order");
                    UseTemporary = true;

                    column(JobDescription19; GetBlobReportDescriptionText()) { }
                    column(JobLabel19; GetBlobReportLabelText()) { }
                }
                dataitem(Description20; "PVS Report Line")
                {
                    DataItemTableView = sorting("Sorting Order");
                    UseTemporary = true;

                    column(JobDescription20; GetBlobReportDescriptionText()) { }
                    column(JobLabel20; GetBlobReportLabelText()) { }
                }
                dataitem(ProductPrice; "PVS Report Line")
                {
                    DataItemTableView = sorting("Sorting Order");
                    UseTemporary = true;

                    column(PriceValue1; Value1) { }
                    column(PriceValue2; Value2) { }
                    column(PriceValue3; Value3) { }
                    column(PriceValue4; Value4) { }
                    column(PriceValue5; Value5) { }
                    column(PriceValue6; Value6) { }
                }

                trigger OnPreDataItem() //PVS Job
                var
                    UnsupportedJobFilterErr: Label 'Unsupported Job Filter: %1', Comment = '%1 = Status Filter';
                begin
                    PVSJob.SetRange(Active, true);

                    case ReportSetup."Job Filter" of
                        Enum::"PVS Job Filter"::"Active Quote":
                            PVSJob.SetRange(Status, PVSJob.Status::Quote);
                        Enum::"PVS Job Filter"::"Active Order":
                            PVSJob.SetRange(Status, PVSJob.Status::Order);
                        Enum::"PVS Job Filter"::"Active Production Order":
                            PVSJob.SetRange(Status, PVSJob.Status::"Production Order");
                        else
                            Error(UnsupportedJobFilterErr, ReportSetup."Job Filter");
                    end;
                end;

                trigger OnAfterGetRecord()
                var
                    PVSReportLine: Record "PVS Report Line";
                    OutHeaders: List of [Text];
                begin
                    Description1.DeleteAll();
                    Description2.DeleteAll();
                    Description3.DeleteAll();
                    Description4.DeleteAll();
                    Description5.DeleteAll();
                    Description6.DeleteAll();
                    Description7.DeleteAll();
                    Description8.DeleteAll();
                    Description9.DeleteAll();
                    Description10.DeleteAll();
                    Description11.DeleteAll();
                    Description12.DeleteAll();
                    Description13.DeleteAll();
                    Description14.DeleteAll();
                    Description15.DeleteAll();
                    Description16.DeleteAll();
                    Description17.DeleteAll();
                    Description18.DeleteAll();
                    Description19.DeleteAll();
                    Description20.DeleteAll();
                    JobItem.DeleteAll();
                    ProductPrice.DeleteAll();

                    Clear(OutHeaders);

                    PVSReportLine.SetRange(Code, ReportSetup.Code);

                    ReportManagement.SetLanguage(CurrReport.Language);

                    ReportManagement.GenerateJobBlock(PVSJob,
                        ReportSetup,
                        PVSReportLine,
                        JobItem);
                    ReportManagement.GenerateProductPartBlock(PVSJob,
                        ReportSetup,
                        PVSReportLine,
                        ProductPart);
                    ReportManagement.GeneratePriceBlock(PVSJob,
                        ReportSetup,
                        PVSReportLine,
                        ProductPrice);
                    ReportManagement.GenerateDescription(PVSJob,
                        ReportSetup,
                        PVSReportLine,
                        Description1,
                        Enum::"PVS Report Line Type"::Description1);
                    ReportManagement.GenerateDescription(PVSJob,
                        ReportSetup,
                        PVSReportLine,
                        Description2,
                        Enum::"PVS Report Line Type"::Description2);
                    ReportManagement.GenerateDescription(PVSJob,
                        ReportSetup,
                        PVSReportLine,
                        Description3,
                        Enum::"PVS Report Line Type"::Description3);
                    ReportManagement.GenerateDescription(PVSJob,
                        ReportSetup,
                        PVSReportLine,
                        Description4,
                        Enum::"PVS Report Line Type"::Description4);
                    ReportManagement.GenerateDescription(PVSJob,
                        ReportSetup,
                        PVSReportLine,
                        Description5,
                        Enum::"PVS Report Line Type"::Description5);
                    ReportManagement.GenerateDescription(PVSJob,
                        ReportSetup,
                        PVSReportLine,
                        Description6,
                        Enum::"PVS Report Line Type"::Description6);
                    ReportManagement.GenerateDescription(PVSJob,
                        ReportSetup,
                        PVSReportLine,
                        Description7,
                        Enum::"PVS Report Line Type"::Description7);
                    ReportManagement.GenerateDescription(PVSJob,
                        ReportSetup,
                        PVSReportLine,
                        Description8,
                        Enum::"PVS Report Line Type"::Description8);
                    ReportManagement.GenerateDescription(PVSJob,
                        ReportSetup,
                        PVSReportLine,
                        Description9,
                        Enum::"PVS Report Line Type"::Description9);
                    ReportManagement.GenerateDescription(PVSJob,
                        ReportSetup,
                        PVSReportLine,
                        Description10,
                        Enum::"PVS Report Line Type"::Description10);
                    ReportManagement.GenerateDescription(PVSJob,
                        ReportSetup,
                        PVSReportLine,
                        Description11,
                        Enum::"PVS Report Line Type"::Description11);
                    ReportManagement.GenerateDescription(PVSJob,
                        ReportSetup,
                        PVSReportLine,
                        Description12,
                        Enum::"PVS Report Line Type"::Description12);
                    ReportManagement.GenerateDescription(PVSJob,
                        ReportSetup,
                        PVSReportLine,
                        Description13,
                        Enum::"PVS Report Line Type"::Description13);
                    ReportManagement.GenerateDescription(PVSJob,
                        ReportSetup,
                        PVSReportLine,
                        Description14,
                        Enum::"PVS Report Line Type"::Description14);
                    ReportManagement.GenerateDescription(PVSJob,
                        ReportSetup,
                        PVSReportLine,
                        Description15,
                        Enum::"PVS Report Line Type"::Description15);
                    ReportManagement.GenerateDescription(PVSJob,
                        ReportSetup,
                        PVSReportLine,
                        Description16,
                        Enum::"PVS Report Line Type"::Description16);
                    ReportManagement.GenerateDescription(PVSJob,
                        ReportSetup,
                        PVSReportLine,
                        Description17,
                        Enum::"PVS Report Line Type"::Description17);
                    ReportManagement.GenerateDescription(PVSJob,
                        ReportSetup,
                        PVSReportLine,
                        Description18,
                        Enum::"PVS Report Line Type"::Description18);
                    ReportManagement.GenerateDescription(PVSJob,
                        ReportSetup,
                        PVSReportLine,
                        Description19,
                        Enum::"PVS Report Line Type"::Description19);
                    ReportManagement.GenerateDescription(PVSJob,
                        ReportSetup,
                        PVSReportLine,
                        Description20,
                        Enum::"PVS Report Line Type"::Description20);
                    PVSReportLine.Code := ReportSetup.Code;

                    ReportManagement.GetColumnHeaders(OutHeaders, PVSReportLine);
                    if OutHeaders.Count > 0 then
                        PriceColumn1 := OutHeaders.Get(1);
                    if OutHeaders.Count > 1 then
                        PriceColumn2 := OutHeaders.Get(2);
                    if OutHeaders.Count > 2 then
                        PriceColumn3 := OutHeaders.Get(3);
                    if OutHeaders.Count > 3 then
                        PriceColumn4 := OutHeaders.Get(4);
                    if OutHeaders.Count > 4 then
                        PriceColumn5 := OutHeaders.Get(5);
                    if OutHeaders.Count > 5 then
                        PriceColumn6 := OutHeaders.Get(6);

                    PVSCase.CalcFields("Coordinator E-Mail", "Salesperson E-Mail");
                end;
            }
            dataitem(Shipment; "PVS Report Line")
            {
                DataItemTableView = sorting("Sorting Order");
                UseTemporary = true;

                column(Shipment1; Value1) { }
                column(Shipment2; Value2) { }
                column(Shipment3; Value3) { }
                column(Shipment4; Value4) { }
                column(Shipment5; Value5) { }
                column(Shipment6; Value6) { }
            }

            trigger OnPreDataItem()
            begin
                DummyCompanyInfo.Picture := CompanyInfo.Picture;
            end;

            trigger OnAfterGetRecord()  //Case
            var
                PVSReportLine: Record "PVS Report Line";
            begin
                if SellToContact.Get("Sell-To Contact No.") then;
                if BillToContact.Get("Bill-To Contact No.") then;
                if not SellCust.Get("Sell-To No.") then
                    Clear(SellCust);

                SetLanguage(SellCust."Language Code");
                if SellToContact."Language Code" <> '' then
                    SetLanguage(SellToContact."Language Code");

                if not BillCust.Get("Bill-To No.") then
                    Clear(BillCust);

                FormatDocumentFields(PVSCase);

                Clear(CustAddr);
                FormatAddr.FormatAddr(CustAddr,
                    PVSCase."Sell-To Name",
                    PVSCase."Sell-To Name 2",
                    PVSCase."Sell-To Contact",
                    PVSCase."Sell-To Address",
                    PVSCase."Sell-To Address 2",
                    PVSCase."Sell-To City",
                    PVSCase."Sell-To Postal Code",
                    PVSCase."Sell-To County",
                    PVSCase."Sell-to Country/Region Code");

                CompressArray(CustAddr);

                FormatAddr.Company(CompanyAddr, CompanyInfo);

                CompanyBankAccount.CopyBankFieldsFromCompanyInfo(CompanyInfo);

                if FirstLineHasBeenOutput then
                    Clear(DummyCompanyInfo.Picture);

                FirstLineHasBeenOutput := true;

                if ReportManagement.GetGlobalReportCode() <> '' then
                    ReportSetup.SetRange(Code, ReportManagement.GetGlobalReportCode())
                else
                    ReportSetup.SetRange(Code, ReportManagement.FindReportCodeForCase(PVSCase, GetReportType()));
                if ReportSetup.FindFirst() then;

                PVSReportLine.SetRange(Code, ReportSetup.Code);
                ReportManagement.GenerateShipmentBlock(PVSCase, ReportSetup, PVSReportLine, Shipment);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Report Data")
                {
                    Caption = 'Report Data';
                    field("Report Setup Code"; ReportCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Report Setup Code';

                        trigger OnValidate()
                        begin
                            ReportManagement.SetGlobalReportCode(ReportCode);
                            ManualReportCode := true;
                            SaveToFolder := ReportManagement.SaveToFolder(ReportCode);
                            ShowSaveToFolder := SaveToFolder;
                            ReportManagement.SetSaveReport(SaveToFolder);
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            ReportSetupSelect: Record "PVS Report Setup";
                        begin
                            ReportSetupSelect.SetRange("Report Type", GetReportType());
                            if Page.RunModal(Page::"PVS Report Setup List", ReportSetupSelect) = Action::LookupOK then begin
                                ReportCode := ReportSetupSelect.Code;
                                ManualReportCode := true;
                                SaveToFolder := ReportManagement.SaveToFolder(ReportCode);
                                ShowSaveToFolder := SaveToFolder;
                                ReportManagement.SetSaveReport(SaveToFolder);
                            end;
                            ReportManagement.SetGlobalReportCode(ReportCode);
                            ReportManagement.SetGlobalID(PVSCase.GetFilter(ID));
                        end;
                    }
                    field(ManualQuoteOrderCodeField; ManualReportCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Manual Report Code';
                    }
                    field(SaveToFolderField; SaveToFolder)
                    {
                        ApplicationArea = All;
                        Caption = 'Save to Folder';
                        Enabled = ShowSaveToFolder;

                        trigger OnValidate()
                        begin
                            ReportManagement.SetSaveReport(SaveToFolder);
                        end;
                    }
                    field(EditReportTexts; EditReportTextsLbl)
                    {
                        ApplicationArea = All;
                        ShowCaption = false;
                        Style = StrongAccent;

                        trigger OnDrillDown()
                        var
                            CaseReportSetupLine: Page "PVS Case Report Setup Lines";
                            CaseId: Integer;
                            PleaseSelectReportSetupCodeFirstMsg: Label 'Please select a report setup code first.';
                        begin
                            if not Evaluate(CaseId, PVSCase.GetFilter(ID)) then
                                exit;

                            if (ReportCode = '') then begin
                                Message(PleaseSelectReportSetupCodeFirstMsg);
                                exit;
                            end;

                            Clear(CaseReportSetupLine);
                            CaseReportSetupLine.Initialize(CaseId, '', ReportCode);
                            CaseReportSetupLine.Run();
                        end;
                    }
                }
            }
        }

        trigger OnOpenPage()
        var
            CaseRec: Record "PVS Case";
        begin
            if CaseRec.Get(ReportManagement.IDTxtToInt(PVSCase.GetFilter(ID))) then begin
                ReportCode := ReportManagement.FindReportCodeForCase(CaseRec, GetReportType());
                if ReportCode <> ReportManagement.GetGlobalReportCode() then
                    if ReportManagement.GetGlobalReportCode() <> '' then begin
                        ManualReportCode := true;
                        ReportCode := ReportManagement.GetGlobalReportCode();
                    end;

                if not ManualReportCode then
                    ReportManagement.SetGlobalReportCode(ReportCode);
            end;

            SaveToFolder := ReportManagement.SaveToFolder(ReportCode);
            ShowSaveToFolder := SaveToFolder;
            ReportManagement.SetSaveReport(SaveToFolder);
        end;
    }

    rendering
    {
        layout("PVS BS Artwork Approval")
        {
            Caption = 'PrintVis Artwork Approval';
            LayoutFile = 'src/Reports/ArtworkApprovalSignatureReport/ArtworkApproval.docx';
            Summary = 'PrintVis Artwork Approval';
            Type = Word;
        }
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.SetAutoCalcFields(Picture);
        SalesSetup.Get();
        CompanyInfo.VerifyAndSetPaymentInfo();
    end;

    trigger OnPreReport()
    var
        CaseRec: Record "PVS Case";
    begin
        CompanyLogoPosition := SalesSetup."Logo Position on Documents";
        if ReportManagement.GetGlobalReportCode() = '' then begin
            ReportManagement.SetGlobalID(PVSCase.GetFilter(ID));
            CaseRec.Get(ReportManagement.GetGlobalID());
            ReportCode := ReportManagement.FindReportCodeForCase(CaseRec, GetReportType());
            ReportManagement.SetGlobalReportCode(ReportCode);
        end;
    end;

    trigger OnPostReport()
    var
        CaseRec: Record "PVS Case";
    begin
        if ReportManagement.GetSaveReport() then begin
            CaseRec.Get(ReportManagement.GetGlobalID());
            ReportManagement.SetSaveReport(false);
            ReportManagement.SaveReport(CurrReport.ObjectId(false), CaseRec, ReportManagement.GetGlobalReportCode());
        end;
    end;

    var
        CompanyBankAccount: Record "Bank Account";
        CompanyInfo: Record "Company Information";
        DummyCompanyInfo: Record "Company Information";
        BillToContact, SellToContact : Record Contact;
        BillCust, SellCust : Record Customer;
        ReportSetup: Record "PVS Report Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        FormatAddr: Codeunit "Format Address";
        GlobalLanguage: Codeunit Language;
        ReportManagement: Codeunit "PVS Report Mgt";
        FirstLineHasBeenOutput: Boolean;
        ManualReportCode, SaveToFolder, ShowSaveToFolder : Boolean;
        ReportCode: Code[50];
        CompanyLogoPosition: Integer;
        ArtworkApprovalLbl: Label 'Artwork Approval';
        BillToContactEmailLbl: Label 'Bill-to Contact Email';
        BillToContactMobilePhoneNoLbl: Label 'Bill-to Contact Mobile Phone No.';
        BillToContactPhoneNoLbl: Label 'Bill-to Contact Phone No.';
        CompanyInfoBankAccNoLbl: Label 'Account No.';
        CompanyInfoBankNameLbl: Label 'Bank';
        CompanyInfoGiroNoLbl: Label 'Giro No.';
        CompanyInfoPhoneNoLbl: Label 'Phone No.';
        EditReportTextsLbl: Label 'Edit Report Texts';
        EMailLbl: Label 'Email';
        EstimateForLbl: Label 'Estimate for';
        FromLbl: Label 'From';
        HomePageLbl: Label 'Home Page';
        InvNoLbl: Label 'No.';
        LocalCurrencyLbl: Label 'Local Currency';
        QuestionsLbl: Label 'Questions?';
        SalespersonLbl: Label 'Salesperson';
        SellToContactEmailLbl: Label 'Sell-to Contact Email';
        SellToContactMobilePhoneNoLbl: Label 'Sell-to Contact Mobile Phone No.';
        SellToContactPhoneNoLbl: Label 'Sell-to Contact Phone No.';
        ShiptoAddrLbl: Label 'Ship-to Address';
        ThanksLbl: Label 'Thank You!';
        PriceColumn1, PriceColumn2, PriceColumn3, PriceColumn4, PriceColumn5, PriceColumn6 : Text;
        SalesPersonText, TotalExclVATText, TotalInclVATText, TotalText : Text[50];
        CompanyAddr, CustAddr : array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];

    local procedure SetLanguage(LanguageCode: Code[10])
    begin
        CurrReport.Language := GlobalLanguage.GetLanguageIdOrDefault(LanguageCode);
    end;

    local procedure FormatDocumentFields(CaseRec: Record "PVS Case")
    var
        FormatDocument: Codeunit "Format Document";
    begin
        FormatDocument.SetTotalLabels(GetCurrencySymbol(), TotalText, TotalInclVATText, TotalExclVATText);
        FormatDocument.SetSalesPerson(SalespersonPurchaser, CaseRec.Salesperson, SalesPersonText);
    end;

    local procedure GetCurrencySymbol(): Text[10]
    var
        Currency: Record Currency;
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        if GeneralLedgerSetup.Get() then
            if (PVSCase."Currency Code" = '') or (PVSCase."Currency Code" = GeneralLedgerSetup."LCY Code") then
                exit(GeneralLedgerSetup.GetCurrencySymbol());

        if Currency.Get(PVSCase."Currency Code") then
            exit(Currency.GetCurrencySymbol());

        exit(PVSCase."Currency Code");
    end;

    local procedure GetReportType(): Enum "PVS Report Type"
    begin
        exit(Enum::"PVS Report Type"::"PVS BS Artwork Approval");
    end;
}