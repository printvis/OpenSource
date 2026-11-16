namespace PrintVis.SpencerMetrics.CounterManagement;

using System.Reflection;

table 80294 "PVS SM Counter Entry"
{
    Caption = 'SpencerMetrics Counter Entry';
    DataClassification = CustomerContent;
    DrillDownPageId = "PVS SM Counter Entries";
    LookupPageId = "PVS SM Counter Entries";

    fields
    {
        field(1; "Cost Center Code"; Code[20])
        {
            Caption = 'Cost Center Code';
            TableRelation = "PVs Cost Center";
            ToolTip = 'Cost Center Code for SpencerMetrics';
        }
        field(2; "Entry No."; BigInteger)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            ToolTip = 'Entry No. for SpencerMetrics';
            Editable = false;
        }
        field(3; "XML Content"; Blob)
        {
            Caption = 'XML Content';
            ToolTip = 'XML Content from SpencerMetrics';
        }
        field(4; "Current Count"; Integer)
        {
            Caption = 'Current Count';
            ToolTip = 'Current count from SpencerMetrics';
        }
        field(6; "Difference Count"; Integer)
        {
            Caption = 'Difference Count';
            ToolTip = 'Difference between previous count and current count';
        }
        field(7; "Current Time"; DateTime)
        {
            Caption = 'Current Time';
            ToolTip = 'Current date/time for this SpencerMetrics count';
        }
        field(8; "Device Status"; Code[50])
        {
            Caption = 'Device Status';
            ToolTip = 'SpencerMetrics device status';
        }
        field(9; Speed; Integer)
        {
            Caption = 'Speed';
            ToolTip = 'Calculated speed of the machine';
        }
        field(10; "Include In Job Costing"; Boolean)
        {
            Caption = 'Included in job costing';
            ToolTip = 'This is checked once the count has been included in a job costing entry';
        }
        field(13; "Case ID"; Integer)
        {
            Caption = 'Case ID';
            ToolTip = 'The Case ID associated with this count';
        }
        field(14; "Plan ID"; Integer)
        {
            Caption = 'Plan ID';
            ToolTip = 'The Plan ID associated with this count';
        }
        field(15; UOM; Code[20])
        {
            Caption = 'UOM';
            ToolTip = 'The UOM associated with this count';
        }
    }

    keys
    {
        key(PK; "Cost Center Code", "Entry No.")
        {
            Clustered = true;
        }
    }

    internal procedure GetNextEntryNo(in_CostCenterCode: Code[20]): BigInteger
    var
        CounterEntry: Record "PVS SM Counter Entry";
        NextEntryNo: BigInteger;
    begin
        CounterEntry.Reset();
        CounterEntry.SetRange("Cost Center Code", in_CostCenterCode);
        if CounterEntry.FindLast() then
            NextEntryNo := CounterEntry."Entry No."
        else
            NextEntryNo := 0;

        NextEntryNo += 1;

        exit(NextEntryNo);
    end;

    internal procedure SetXMLContent(in_XMLContent: Text)
    var
        OutStream: OutStream;
    begin
        Clear("XML Content");
        "XML Content".CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.WriteText(in_XMLContent);
    end;

    internal procedure GetXMLContent() XMLContent: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("XML Content");
        "XML Content".CreateInStream(InStream, TextEncoding::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName("XML Content")));
    end;
}