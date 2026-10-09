table 75003 "PTE Product Userfield ID"
{
    Caption = 'Product Userfield Value';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
            ToolTip = 'Specifies the internal identifier of this stored default User Field value line.';
        }
        field(2; "Product Code"; Code[50])
        {
            Caption = 'Product Code';
            DataClassification = CustomerContent;
            NotBlank = true;
            TableRelation = "PVS Product".Code;
            ToolTip = 'Specifies the product this default User Field value belongs to.';
        }
        field(3; "Group Index"; Integer)
        {
            Caption = 'User Field Group';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies which of the three independent User Field groups (User Fields 1/2/3 on the Product Card, GroupIndex 0/1/2, mirrors "PVS Userfield Field Value"."Table Subtype") this default value belongs to. Field numbers are only unique within a single group, so this must be part of the unique key alongside "Field No." - otherwise two groups that both happen to use the same field number would collide.';
        }
        field(4; "Field No."; Integer)
        {
            Caption = 'Field No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the User Field number (as defined in the PrintVis Job User Field 1/2/3 setup) this default value is for.';
        }
        field(5; "Value Entry No."; Integer)
        {
            Caption = 'Value Entry No.';
            DataClassification = CustomerContent;
            BlankZero = true;
            ToolTip = 'Specifies the entry number of this value within the User Field (mirrors "PVS Userfield Field Value"."Entry No.", allowing more than one value to be stored for fields that support multiple entries).';
        }
        field(6; "Text"; Text[250])
        {
            Caption = 'Text';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the default value stored for this User Field, copied to the Job''s User Fields when this product is applied to a Job.';
        }
    }

    keys
    {
        key(Key1; "Entry No.","Product Code","Field No.","Value Entry No.")
        {
            Clustered = true;
        } 
    }

    /// <summary>
    /// Assigns "Entry No." as the current highest value + 1 (mirrors the pattern used by
    /// "PTE Product Job Item"."Job Item No."). Deliberately NOT using the built-in
    /// AutoIncrement property: Business Central computes AutoIncrement values as
    /// MAX(existing) + 1 at insert time rather than reserving a true monotonic sequence, so
    /// a DeleteAll immediately followed by several Inserts in the same transaction (see
    /// "PTE Product Template Mgt".CommitStagedJobUserFieldsToProduct) can hand out a value
    /// that collides with a row not yet fully cleared, raising a "record already exists"
    /// error. Explicitly computing the next value here avoids that failure mode.
    /// </summary>
    trigger OnInsert()
    var
        ProductUserfieldValue: Record "PTE Product Userfield ID";
    begin
        if "Entry No." = 0 then begin
            ProductUserfieldValue.SetCurrentKey("Entry No.");
            if ProductUserfieldValue.FindLast() then
                "Entry No." := ProductUserfieldValue."Entry No." + 1
            else
                "Entry No." := 1;
        end;
    end;

    /// <summary>
    /// Returns true if any default User Field values have already been saved for ProductCode.
    /// Used to skip the transfer to a Job entirely when a product has none.
    /// </summary>
    procedure HasValues(ProductCode: Code[50]): Boolean
    var
        ProductUserfieldID: Record "PTE Product Userfield ID";
    begin
        ProductUserfieldID.SetRange("Product Code", ProductCode);
        exit(not ProductUserfieldID.IsEmpty());
    end;
}
