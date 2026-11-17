namespace PrintVis.BoldSign.Extensions;

using Microsoft.Foundation.Reporting;
using PrintVis.BoldSign.Workflows;

tableextension 80301 "PVS BS Report Selections" extends "Report Selections"
{
    fields
    {
        field(80301; "PVS BS Use for BoldSign Sign."; Boolean)
        {
            Caption = 'Use for BoldSign Signature';
            DataClassification = CustomerContent;
        }
        field(80302; "PVS BS Sent Doc. Workflow"; Code[20])
        {
            Caption = 'BoldSign Sent Document Workflow';
            DataClassification = CustomerContent;
            TableRelation = "PVS BS Document Workflow";
        }
        field(80303; "PVS BS Signed Doc. Workflow"; Code[20])
        {
            Caption = 'BoldSign Signed Document Workflow';
            DataClassification = CustomerContent;
            TableRelation = "PVS BS Document Workflow";
        }
        field(80304; "PVS BS Expired Doc. Workflow"; Code[20])
        {
            Caption = 'BoldSign Expired Document Workflow';
            DataClassification = CustomerContent;
            TableRelation = "PVS BS Document Workflow";
        }
        field(80305; "PVS BS Declined Doc. Workflow"; Code[20])
        {
            Caption = 'BoldSign Declined Document Workflow';
            DataClassification = CustomerContent;
            TableRelation = "PVS BS Document Workflow";
        }
        field(80306; "PVS BS Add Decline Button"; Boolean)
        {
            Caption = 'BoldSign Add Decline button';
            DataClassification = CustomerContent;
            ToolTip = 'Gives this signer the ability to decline to sign by showing a "decline" button in their user interface. Declining cancels the signing process.';
        }
        field(80307; "PVS BS Allow Delegate"; Boolean)
        {
            Caption = 'BoldSign Allow Delegate';
            DataClassification = CustomerContent;
            ToolTip = 'Gives this signer the ability to delegate to someone else showing a "delegate" button in their user interface.';
        }
        field(80308; "PVS BS Sign. On Last Page"; Boolean)
        {
            Caption = 'BoldSign Signature On Last Page';
            DataClassification = CustomerContent;
            ToolTip = 'Places the signature field on the last page of the report. The artwork PDFs added in the wizard are not counted.';
        }
        field(80309; "PVS BS Sign. Page No."; Integer)
        {
            Caption = 'BoldSign Signature Page No.';
            DataClassification = CustomerContent;
            InitValue = 1;
            MinValue = 0;
            ToolTip = 'Specifies the page number of the signature field. Ignored when the signature is placed on the last page. 0 means page 1.';
        }
        field(80310; "PVS BS Sign. X"; Integer)
        {
            Caption = 'BoldSign Signature X';
            DataClassification = CustomerContent;
            InitValue = 50;
            MinValue = 0;
            ToolTip = 'Specifies the horizontal position of the signature field, measured from the left edge of the page.';
        }
        field(80311; "PVS BS Sign. Y"; Integer)
        {
            Caption = 'BoldSign Signature Y';
            DataClassification = CustomerContent;
            InitValue = 50;
            MinValue = 0;
            ToolTip = 'Specifies the vertical position of the signature field, measured from the top edge of the page.';
        }
        field(80312; "PVS BS Sign. Width"; Integer)
        {
            Caption = 'BoldSign Signature Width';
            DataClassification = CustomerContent;
            InitValue = 200;
            MinValue = 0;
            ToolTip = 'Specifies the width of the signature field. 0 means the default width (200).';
        }
        field(80313; "PVS BS Sign. Height"; Integer)
        {
            Caption = 'BoldSign Signature Height';
            DataClassification = CustomerContent;
            InitValue = 30;
            MinValue = 0;
            ToolTip = 'Specifies the height of the signature field. 0 means the default height (30).';
        }
    }
}