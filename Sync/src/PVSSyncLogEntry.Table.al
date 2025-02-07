Table 80201 "PVS Sync Log Entry"
{
    Caption = 'Sync Log Entry';
    DrillDownPageID = "PVS Sync Log";
    LookupPageID = "PVS Sync Log";

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Table No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Table No.';
        }
        field(3; Type; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Type';
            OptionCaption = 'Insert,Modify,Rename,Delete,Special';
            OptionMembers = Insert,Modify,Rename,Delete,Special;
        }
        field(4; "Record ID"; RecordID)
        {
            DataClassification = CustomerContent;
            Caption = 'Record ID';
        }
        field(5; "Old Record ID"; RecordID)
        {
            DataClassification = CustomerContent;
            Caption = 'Old Record ID';
        }
        field(6; "Created DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Created DateTime';
        }
        field(7; "Last Process DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Last Process DateTime';
        }
        field(8; "Log Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Log Type';
            OptionCaption = 'Normal,Media';
            OptionMembers = Normal,Media;
        }
        field(9; "Log Field"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Log Field';
        }
        field(10; "Sorting Order"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Sorting Order';
        }
        field(20; Status; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
            OptionCaption = 'New,Processing,Notify,Error,Processed';
            OptionMembers = New,Processing,Notify,Error,Processed;
        }
        field(21; "Retries Remaining"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Retries Remaining';
            InitValue = 5;
        }
        field(30; "Source Business Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Source Business Group';
        }
        field(31; "Destination Business Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Destination Business Group';
        }
        field(40; ChangedCompany; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'ChangedCompany';
        }
        field(50; "Record Object"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Record Object';
        }
        field(51; "Record Object Size"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Record Object Size';
        }
        field(100; "Error Message"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Error Message';
        }
        field(8000; ID; Guid)
        {
            DataClassification = CustomerContent;
            Caption = 'Id';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Type, Status)
        {

        }
        key(Key3; Status, "Sorting Order", "Entry No.")
        {

        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Created DateTime" := CurrentDatetime();
        ID := CreateGuid();
    end;

    procedure View_RecordObject()
    var
        TempBLOB: Record "PVS TempBlob" temporary;
        PVSBlobStorage: Codeunit "PVS Blob Storage";
        NAVFileMgt: Codeunit "File Management";
        PVSFileMgt: Codeunit "PVS File Mgt.";
        Filename: Text;
        NewFileName: Text;
        Path: Text;
        ServerTempFileName: Text;
    begin
        if not "Record Object".Hasvalue() then
            exit;

        Filename := 'Record Object_%1.txt';


        Filename := StrSubstNo(Filename, "Entry No.");

        TempBLOB.Init();
        CalcFields("Record Object");
        TempBLOB.Blob := "Record Object";

        PVSBlobStorage.BlobExport(TempBLOB, Filename, false);

    end;
}

