/// <summary>
/// SingleInstance codeunit that holds transient UI state for the PVS Product Setup pages.
/// Used to communicate the currently selected Product Job Item No. from the job item
/// subpage to sibling subpages (e.g. the Item Colors Part) without requiring a round-trip
/// through the parent page record.
/// </summary>
codeunit 75003 "PTE Product Setup State"
{
    SingleInstance = true;

    var
        CurrentJobItemNo: Integer;
        CurrentProductCode: Code[20];

    procedure SetCurrentJobItem(ProductCode: Code[20]; JobItemNo: Integer)
    begin
        CurrentProductCode := ProductCode;
        CurrentJobItemNo := JobItemNo;
    end;

    procedure GetCurrentJobItemNo(): Integer
    begin
        exit(CurrentJobItemNo);
    end;

    procedure GetCurrentProductCode(): Code[20]
    begin
        exit(CurrentProductCode);
    end;

    /// <summary>
    /// Opens the combined User Fields page for a Product.
    /// Field/option definitions are read from the Job User Field setup, while values are
    /// stored under the Product table keyed by the Product Code.
    /// </summary>
    procedure Form_Userfield_Edit_Product(in_Subtype: Integer; in_ProductCode: Code[50])
    var
        TempBufferRec: Record "PVS Userfield Field Buffer" temporary;
        UserFieldMgt: Codeunit "PVS Userfield Management";
        DataCode: Code[20];
    begin
        DataCode := CopyStr(in_ProductCode, 1, MaxStrLen(DataCode));
        if DataCode = '' then
            exit;

        UserFieldMgt.Populate_Initial_Values(Database::"PVS Product", in_Subtype, DataCode, '', 0, 0, 0, 0, 0);
        Commit();

        TempBufferRec.SetRange("Table ID", Database::"PVS Product");
        TempBufferRec.SetRange("Table Subtype", in_Subtype);
        TempBufferRec.SetRange("Table Code", DataCode);
        TempBufferRec.SetRange(ID1, 0);
        TempBufferRec.SetRange(ID2, 0);
        TempBufferRec.SetRange(ID3, 0);
        TempBufferRec.SetRange(ID4, 0);
        TempBufferRec.SetRange(ID5, 0);
        UserFieldMgt.Populate_Fields_Tmp_Buffer(TempBufferRec, true, 0, 0, 0, 0);

        Page.Run(Page::"PVS Userfields Combined", TempBufferRec);
    end;

    /// <summary>
    /// Copies the Product User Field values onto the Job User Fields when a Product is applied to a Job.
    /// </summary>
    procedure Transfer_Product_Userfields_To_Job(in_ProductCode: Code[50]; in_JobID: Integer; in_JobNo: Integer; in_Version: Integer)
    var
        FieldRec: Record "PVS Userfield Field";
        ProductValueRec: Record "PVS Userfield Field Value";
        JobValueRec: Record "PVS Userfield Field Value";
        ProductCode: Code[20];
        Subtype: Integer;
    begin
        ProductCode := CopyStr(in_ProductCode, 1, MaxStrLen(ProductCode));
        if ProductCode = '' then
            exit;
        if in_JobID = 0 then
            exit;

        for Subtype := 0 to 2 do begin
            FieldRec.Reset();
            FieldRec.SetRange("Table ID", Database::"PVS Job");
            FieldRec.SetRange("Table Subtype", Subtype);
            FieldRec.SetRange("Table Code", '');
            if FieldRec.FindSet() then
                repeat
                    ProductValueRec.Reset();
                    ProductValueRec.SetRange("Table ID", Database::"PVS Product");
                    ProductValueRec.SetRange("Table Subtype", Subtype);
                    ProductValueRec.SetRange("Table Code", ProductCode);
                    ProductValueRec.SetRange("Field No.", FieldRec."Field No.");
                    ProductValueRec.SetRange(ID1, 0);
                    ProductValueRec.SetRange(ID2, 0);
                    ProductValueRec.SetRange(ID3, 0);
                    ProductValueRec.SetRange(ID4, 0);
                    ProductValueRec.SetRange(ID5, 0);
                    ProductValueRec.SetRange(Code1, '');
                    if ProductValueRec.FindFirst() then
                        if ProductValueRec.Text <> '' then
                            if not JobValueRec.Get(Database::"PVS Job", Subtype, '', FieldRec."Field No.",
                                 in_JobID, in_JobNo, in_Version, 0, 0, '', 10000)
                            then begin
                                JobValueRec.Init();
                                JobValueRec."Table ID" := Database::"PVS Job";
                                JobValueRec."Table Subtype" := Subtype;
                                JobValueRec."Table Code" := '';
                                JobValueRec."Field No." := FieldRec."Field No.";
                                JobValueRec.ID1 := in_JobID;
                                JobValueRec.ID2 := in_JobNo;
                                JobValueRec.ID3 := in_Version;
                                JobValueRec.ID4 := 0;
                                JobValueRec.ID5 := 0;
                                JobValueRec.Code1 := '';
                                JobValueRec."Entry No." := 10000;
                                JobValueRec."Option Value Entry No." := ProductValueRec."Option Value Entry No.";
                                JobValueRec.Text := ProductValueRec.Text;
                                JobValueRec.Insert(true);
                            end else begin
                                JobValueRec."Option Value Entry No." := ProductValueRec."Option Value Entry No.";
                                JobValueRec.Text := ProductValueRec.Text;
                                JobValueRec.Modify(true);
                            end;
                until FieldRec.Next() = 0;
        end;
    end;
}
