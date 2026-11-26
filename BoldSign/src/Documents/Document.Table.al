namespace PrintVis.BoldSign.Documents;

using PrintVis.BoldSign.Workflows;
using Microsoft.Foundation.Reporting;
using System.Reflection;
using PrintVis.BoldSign.Extensions;
using System.Security.AccessControl;

table 80303 "PVS BS Document"
{
    Caption = 'BoldSign Document';
    DataClassification = CustomerContent;
    DrillDownPageId = "PVS BS Document List";
    LookupPageId = "PVS BS Document List";

    fields
    {
        field(1; ID; BigInteger)
        {
            AutoIncrement = true;
            Caption = 'ID';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(7; "Case ID"; Integer)
        {
            Caption = 'Case ID';
        }
        field(8; "Report Type"; Enum "Report Selection Usage")
        {
            Caption = 'Report Type';
        }
        field(10; "Document ID"; Guid)
        {
            Caption = 'Document ID';
        }
        field(12; "Processed Document ID"; Guid)
        {
            Caption = 'Processed Document ID';
        }
        field(15; Status; Enum "PVS BS Document Status")
        {
            Caption = 'Status';

            trigger OnValidate()
            var
                ExecuteDocumentAction: Codeunit "PVS BS Execute Status Workflow";
            begin
                ExecuteDocumentAction.Execute(Rec);
            end;
        }
        field(30; "Started By User ID"; Guid)
        {
            Caption = 'Created By User ID';
            DataClassification = EndUserPseudonymousIdentifiers;
            Editable = false;
            TableRelation = User;
        }
        field(31; "Started By User Name"; Code[50])
        {
            CalcFormula = lookup(User."User Name" where("User Security ID" = field("Started By User ID")));
            Caption = 'Created By User';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Started On"; DateTime)
        {
            Caption = 'Started On';
        }
        field(50; "Expires On"; DateTime)
        {
            Caption = 'Expires On';
        }
        field(70; "Report Setup Code"; Code[50])
        {
            Caption = 'Report Setup Code';
            TableRelation = "PVS Report Setup";
        }
        field(71; "Allow Decline"; Boolean)
        {
            Caption = 'Allow Decline';
        }
        field(72; "Allow Delegate"; Boolean)
        {
            Caption = 'Allow Delegate';
        }
        field(73; "Report Selection Code"; Code[20])
        {
            Caption = 'Report Selection Code';
            TableRelation = "Report Selections";
        }
        field(90; "Sent Doc. Workflow"; Code[20])
        {
            Caption = 'Sent Document Workflow';
            TableRelation = "PVS BS Document Workflow";
        }
        field(91; "Sent Doc. Workflow Status"; Enum "PVS BS Doc. Workflow Status")
        {
            Caption = 'Sent Document Workflow Status';
        }
        field(100; "Signed Doc. Workflow"; Code[20])
        {
            Caption = 'Signed Document Workflow';
            TableRelation = "PVS BS Document Workflow";
        }
        field(101; "Signed Doc. Workflow Status"; Enum "PVS BS Doc. Workflow Status")
        {
            Caption = 'Signed Document Workflow Status';
        }
        field(110; "Expired Doc. Workflow"; Code[20])
        {
            Caption = 'Expired Document Workflow';
            TableRelation = "PVS BS Document Workflow";
        }
        field(111; "Expired Doc. Workflow Status"; Enum "PVS BS Doc. Workflow Status")
        {
            Caption = 'Expired Document Workflow Status';
        }
        field(120; "Declined Doc. Workflow"; Code[20])
        {
            Caption = 'Declined Document Workflow';
            TableRelation = "PVS BS Document Workflow";
        }
        field(121; "Declined Doc. Workflow Status"; Enum "PVS BS Doc. Workflow Status")
        {
            Caption = 'Declined Document Workflow Status';
        }
        field(200; "Error Details"; Blob)
        {
            Caption = 'Error Details';
        }
    }

    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
        key(Key2; "Case ID") { }
        key(Key3; Status, "Document ID") { }
    }

    internal procedure CreateNew(PrintVisCaseId: Integer;
        ReportType: Enum "Report Selection Usage";
        ReportID: Integer;
        DocumentExpirationDateFormula: DateFormula;
        SentDocumentWorkflow: Code[20];
        PostSigningWorkflow: Code[20];
        ExpiredDocumentWorkflow: Code[20];
        DeclinedDocumentWorkflow: Code[20];
        ReportCode: Code[50];
        AddDeclineButton: Boolean;
        AllowDelegate: Boolean): BigInteger
    begin
        Clear(Rec);
        Rec."Case ID" := PrintVisCaseId;
        Rec."Report Type" := ReportType;
        Rec.Validate(Status, Enum::"PVS BS Document Status"::New);
        Rec."Started By User ID" := UserSecurityId();
        Rec."Started On" := CurrentDateTime();

        if Format(DocumentExpirationDateFormula) <> '' then
            Rec."Expires On" := CreateDateTime(
                CalcDate(DocumentExpirationDateFormula, Rec."Started On".Date),
                Rec."Started On".Time);

        Rec."Sent Doc. Workflow" := SentDocumentWorkflow;
        if (Rec."Sent Doc. Workflow" <> '') then
            Rec."Sent Doc. Workflow Status" := Enum::"PVS BS Doc. Workflow Status"::Awaiting;

        Rec."Signed Doc. Workflow" := PostSigningWorkflow;
        if (Rec."Signed Doc. Workflow" <> '') then
            Rec."Signed Doc. Workflow Status" := Enum::"PVS BS Doc. Workflow Status"::Awaiting;

        Rec."Expired Doc. Workflow" := ExpiredDocumentWorkflow;
        if (Rec."Expired Doc. Workflow" <> '') then
            Rec."Expired Doc. Workflow Status" := Enum::"PVS BS Doc. Workflow Status"::Awaiting;

        Rec."Declined Doc. Workflow" := DeclinedDocumentWorkflow;
        if (Rec."Declined Doc. Workflow" <> '') then
            Rec."Declined Doc. Workflow Status" := Enum::"PVS BS Doc. Workflow Status"::Awaiting;

        Rec."Report Setup Code" := ReportCode;

        Rec."Allow Decline" := AddDeclineButton;
        Rec."Allow Delegate" := AllowDelegate;

        Rec.Insert();

        exit(Rec.ID);
    end;

    internal procedure SetErrorDetailsText(NewErrorDetails: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Rec."Error Details");
        Rec."Error Details".CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.WriteText(NewErrorDetails);
    end;

    internal procedure GetErrorDetailsText(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        Rec.CalcFields("Error Details");
        "Error Details".CreateInStream(InStream, TextEncoding::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), Rec.FieldName("Error Details")));
    end;
}
