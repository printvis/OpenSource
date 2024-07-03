PageExtension 80121 "PTE SOI S.O." extends "Sales Order" //"PVS pageextension6010136"
{
    layout
    {
        addafter("Salesperson Code")
        {
            field("PTE SOIOrderType"; Rec."PTE SOI Order Type Code")
            {
                ApplicationArea = All;
                Caption = 'Order Type';
                ToolTip = 'Displays the selected OrderType for the attached PrintVis Case - if not filled in you may select an Ordertype from a LookUp in the field.';
            }
            field("PTE SOIStatusCode"; Rec."PTE SOI Status Code")
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Displays the selected Status Code for the attached PrintVis Case - if not filled in you may select an Status Code from a LookUp in the field.';

                trigger OnValidate()
                begin
                    // <PRINTVIS>
                    CurrPage.Update(false);
                    // </PRINTVIS>
                end;
            }
            field("PTE SOIManualResponsible"; Rec."PTE SOI Manual Responsible")
            {
                ApplicationArea = All;
                ToolTip = 'If the current responsible person has been modified manually, this field will be ticked to indicate so.';
            }
            field("PTE SOIPersonResponsible"; Rec."PTE SOI Person Responsible")
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Displays the set current ''responsible person'' from the attached PrintVis Case, due to the current status.';
            }
            field("PTE SOIDeadline"; Rec."PTE SOI Deadline")
            {
                ApplicationArea = All;
                ToolTip = 'Displays the set deadline from the attached PrintVis Case, due to the current status and when it was changed.';
            }
        }
        addafter("Ship-to Contact")
        {
            field("PTE SOIEndUserContact"; Rec."PVS End User Contact")
            {
                ApplicationArea = Basic, Suite;
            }
            field("PTE SOIEndUserContactName"; Rec."PVS End User Contact Name")
            {
                ApplicationArea = Basic, Suite;
                Importance = Promoted;
            }
        }
        addfirst(FactBoxes)
        {
            part("PTE SOI_Status"; "PTE SOI S.O. Status FactBox")
            {
                ApplicationArea = All;
                Caption = 'Status';
                SubPageLink = "Document Type" = field("Document Type"),
                              "No." = field("No.");
            }
        }
    }
    actions
    {
        addfirst(Navigation)
        {
            group("PTE SOIPrintVis")
            {
                Caption = 'PrintVis';
                ToolTip = 'PrintVis';
                action("PTE SOICustomerSale")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Sale';
                    Image = CustomerGroup;
                    ToolTip = 'Customer Sale';

                    trigger OnAction()
                    var
                        PVSSingleInstance: Codeunit "PVS SingleInstance";
                        PVSSalesorderManagement: Codeunit "PVS Salesorder Management";
                    begin
                        if not PVSSingleInstance.Is_PrintVis_Active() then
                            exit;

                        PVSSalesorderManagement.SalesHead_Form_Customer_Lines(Rec);
                    end;
                }
            }
        }
        addlast(processing)
        {
            action("PTE SOIChangeStatus")
            {
                ApplicationArea = All;
                Caption = 'Change Status';
                Image = ChangeStatus;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Change to next status';

                trigger OnAction()
                var
                    PVSSingleInstance: Codeunit "PVS SingleInstance";
                    SalesorderManagement: Codeunit "PTE SOI S.O. Mgt";
                begin
                    if not PVSSingleInstance.Is_PrintVis_Active() then
                        exit;

                    SalesorderManagement.SalesHead_Change_Next_Status(Rec, true);

                    Rec.Get(Rec."Document Type", Rec."No.");
                end;
            }
            action("PTE SOILog")
            {
                ApplicationArea = All;
                Caption = 'Log';
                Image = History;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Log';

                trigger OnAction()
                var
                    PVSSingleInstance: Codeunit "PVS SingleInstance";
                    PVSChangeLogManagement: Codeunit "PVS Change Log Management";
                begin
                    if not PVSSingleInstance.Is_PrintVis_Active() then
                        exit;

                    PVSChangeLogManagement.Show_Log_SalesHeader(Rec);
                end;
            }
            action("PTE SOIUserfields")
            {
                ApplicationArea = All;
                Caption = 'Userfields';
                Image = PeriodStatus;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Userfields';

                trigger OnAction()
                var
                    PVSSingleInstance: Codeunit "PVS SingleInstance";
                    PVSUserfieldManagement: Codeunit "PVS Userfield Management";
                begin
                    if not PVSSingleInstance.Is_PrintVis_Active() then
                        exit;

                    PVSUserfieldManagement.Form_Userfield_Edit(Database::"Sales Header", 0, '', Rec."No.", 0, 0, 0, 0, 0);
                end;
            }
        }
    }
}