Table 80200 "PVS Sync Table Setup"
{
    Caption = 'Sync Table Setup';

    fields
    {
        field(1; "Table No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Table No.';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));

            trigger OnValidate()
            var
                SystemTableErr: Label 'Not possible to sync system tables.';
            begin
                SyncChangeManagement.ValidateSyncTableField(Rec, FieldNo("Table No."));
                if "Table No." >= 2000000000 then
                    Error(SystemTableErr);
            end;
        }
        field(2; "Sync Active"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Active';
            InitValue = true;

            trigger OnValidate()
            begin
                SyncChangeManagement.ValidateSyncTableField(Rec, FieldNo("Sync Active"));
            end;
        }
        field(10; "Sync Direction"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Sync Direction';
            OptionCaption = 'Master to Local,Local to master,All Business Groups,Manual';
            OptionMembers = MasterToLocal,LocalToMaster,AllBusinessGroup;

            trigger OnValidate()
            begin
                SyncChangeManagement.ValidateSyncTableField(Rec, FieldNo("Sync Direction"));
            end;
        }
        field(11; "Linked To"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Linked To';
            TableRelation = "PVS Sync Table Setup"."Table No.";
        }
        field(12; "Skip Validate On Insert/Modify"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Skip Validate On Insert/Modify';
        }
        field(13; "Do not Compress Sync Log"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Do not Compress Sync Log';
        }
        field(20; "Sync Order"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Sync Order';

            trigger OnValidate()
            begin
                SyncChangeManagement.ValidateSyncTableField(Rec, FieldNo("Sync Order"));
            end;
        }
        field(100; "Table Name"; Text[250])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object ID" = field("Table No.")));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Table No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        SyncChangeManagement: Codeunit "PVS Sync Change Management";
}

