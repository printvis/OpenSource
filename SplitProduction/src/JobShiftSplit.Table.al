Table 80180 "PTE Job Shift Split"
{

    Caption = 'Job Item Split';
    TableType = Temporary;

    fields
    {
        field(1; ID; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'ID';
            TableRelation = "PVS Case";
            Editable = false;
        }
        field(2; Job; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Job';
            Editable = false;
        }
        field(3; Version; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Version';
            Editable = false;
        }
        // field(8; "Split No."; Integer)
        // {
        //     DataClassification = CustomerContent;
        //     BlankZero = true;
        //     Caption = 'Split';
        //     Editable = false;
        // }
        field(5; "Job Item No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Job Item No.';
            Editable = false;
        }
        field(6; "Variant Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Variant Entry No.';
            Editable = false;
        }
        field(7; "Change No."; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Change';
            Editable = false;
        }
        field(9; "Old Change No."; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Old Change';
            Editable = false;
        }
        field(10; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
            Editable = false;
        }
        field(11; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Quantity';
            DecimalPlaces = 0 : 0;
            Editable = false;
        }
        /*
                field(511; "Original Quantity"; Decimal)
                {
                    DataClassification = CustomerContent;
                    BlankZero = true;
                    Caption = 'NOT USED';
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                }

                field(512; "Unassigned Quantity"; Decimal)
                {
                    DataClassification = CustomerContent;
                    BlankZero = true;
                    Caption = 'Unassigned Quantity';
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                }
        */
        field(50; "Sorting Order"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Sorting';
        }
        // Fields from Job Item
        field(15; "Job Item No. 2"; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Job Item No.';
            Editable = false;
        }
        field(16; "Colors Front"; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Editable = false;
            Caption = 'Colors Front';
        }
        field(17; "Colors Back"; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Editable = false;
            Caption = 'Colors Back';
        }
        field(21; "Imposition Type"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Imposition Type';
            TableRelation = "PVS Imposition Code";//where(Machine = field("Controlling Sheet Unit"));
            trigger OnValidate()
            begin
                Rec.validate("Paper Item No.");
            end;
        }
        field(23; "No. Of Pages"; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'No. of pages';
            Editable = false;
        }
        field(25; "Pages With Print"; Decimal)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Pages with Print';
            DecimalPlaces = 0 : 4;
            Editable = false;
        }
        field(30; "Final Format Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Final Format Code';
            Editable = false;
            TableRelation = "PVS Format Code" where(Type = filter(Miscellaneous | "Final format"));
        }
        field(70; "Component Type"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Component Type';
            Editable = false;
            TableRelation = "PVS Component Types";
        }
        field(73; "Expanded From Job Item No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Expanded from Job Item No.';
            Editable = false;
        }
        field(202; "Paper Item No."; Code[20])
        {
            Caption = 'Paper Item No.';
            //Editable = false;
            TableRelation = Item;
            trigger OnValidate()
            var
                SheetRec: Record "PVS Job Sheet";
                JobItem: Record "PVS Job Item";
            begin
                if JobItem.get(Rec.ID, Rec.Job, Rec.Version, Rec."Job Item No.", 1) then
                    if SheetRec.get(JobItem."Sheet ID") then;
                SheetRec."Paper Item No." := Rec."Paper Item No.";
                SheetRec.Check_ECO_Label();
            end;
        }
        field(204; "Controlling Sheet Unit"; Code[20])
        {
            Caption = 'Controlling Unit';
            TableRelation = "PVS Calculation Unit Setup".Code where(Type = const(0), "List Of Units" = const(true));
            trigger OnValidate()
            begin
                SelectMachineManually(false);
            end;
        }
        field(205; Finishing; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Finishing';
            TableRelation = "PVS Finishing Types" where("Process Type" = filter(.. "Finishing sheet"));

            trigger OnLookup()
            begin
                //PageMgt.LookUp_Finishing_Sheet(Rec);
            end;
        }

        field(300; Changed; Boolean)
        {
        }
        field(301; "Changed Imposition Type"; Boolean)
        {
        }

        field(302; "Changed Paper Item No."; Boolean)
        {
        }
        field(304; "Changed Controlling Sheet Unit"; Boolean)
        {
        }
        field(305; "Changed Finishing"; Boolean)
        {
        }
        field(404; "Lookup Controlling Sheet Unit"; Boolean)
        {
        }

        // Calc fields

        field(801; "Component Type Description"; Text[50])
        {
            CalcFormula = lookup("PVS Component Types".Description where(Code = field("Component Type")));
            Caption = 'Component Type Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(803; "Paper Description"; Text[100])
        {
            Caption = 'Paper Description';
            Editable = false;
            CalcFormula = lookup(Item.Description where("No." = field("Paper Item No.")));
            FieldClass = FlowField;
        }
        field(805; "Paper Weight"; Decimal)
        {
            AutoFormatExpression = 'PVS_GeneralUnitDecimals';
            AutoFormatType = 10;
            BlankZero = true;
            Caption = 'Paper Weight';
            Editable = false;
            CalcFormula = lookup(Item."PVS Weight" where("No." = field("Paper Item No.")));
            FieldClass = FlowField;
        }
        field(806; "Paper Quality"; Code[20])
        {
            Caption = 'Paper Quality';
            Editable = false;
            CalcFormula = lookup(Item."PVS Item Quality Code" where("No." = field("Paper Item No.")));
            FieldClass = FlowField;
        }
        field(807; "Weight Unit"; Code[10])
        {
            Caption = 'Weight Unit';
            Editable = false;
            CalcFormula = lookup(Item."PVS Weight Unit" where("No." = field("Paper Item No.")));
            FieldClass = FlowField;
        }
        field(808; "Paper Sheet Format 1"; Decimal)
        {
            Caption = 'Paper Sheet Format 1';
            Editable = false;
            CalcFormula = lookup(Item."PVS Format 1" where("No." = field("Paper Item No.")));
            FieldClass = FlowField;
        }
        field(809; "Paper Sheet Format 2"; Decimal)
        {
            Caption = 'Paper Sheet Format 2';
            Editable = false;
            CalcFormula = lookup(Item."PVS Format 2" where("No." = field("Paper Item No.")));
            FieldClass = FlowField;
        }

        field(850; "Order No."; Code[20])
        {
            CalcFormula = lookup("PVS Case"."Order No." where(ID = field(ID)));
            Caption = 'Order No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(900; "Cost Center Configuration"; code[20])
        {
            Caption = 'Cost Center Configuration';
            Editable = false;
            CalcFormula = lookup("PVS Calculation Unit Setup".Configuration where(Type = const(0), "List Of Units" = const(true), code = field("Controlling Sheet Unit")));
            FieldClass = FlowField;
        }
        field(901; "Cost Center Code"; code[20])
        {
            Caption = 'Cost Center Code';
            Editable = false;
            CalcFormula = lookup("PVS Calculation Unit Setup"."Cost Center Code" where(Type = const(0), "List Of Units" = const(true), code = field("Controlling Sheet Unit")));
            FieldClass = FlowField;
        }
        field(902; "Min Print Format Length"; Decimal)
        {
            Caption = 'Machine Mininum Length';
            Editable = false;
            CalcFormula = lookup("PVS Cost Center Configuration"."Min Print Format Length" where("Cost Center Code" = field("Cost Center Code"), Configuration = field("Cost Center Configuration")));
            FieldClass = FlowField;
        }
        field(903; "Min Print Format Width"; Decimal)
        {
            Caption = 'Machine Mininum Width';
            Editable = false;
            CalcFormula = lookup("PVS Cost Center Configuration"."Min Print Format Width" where("Cost Center Code" = field("Cost Center Code"), Configuration = field("Cost Center Configuration")));
            FieldClass = FlowField;
        }
        field(904; "Max Print Format Length"; Decimal)
        {
            Caption = 'Machine Maximum Length';
            Editable = false;
            CalcFormula = lookup("PVS Cost Center Configuration"."Max Printing Format Length" where("Cost Center Code" = field("Cost Center Code"), Configuration = field("Cost Center Configuration")));
            FieldClass = FlowField;
        }
        field(905; "Max Print Format Width"; Decimal)
        {
            Caption = 'Machine Maximum Width';
            Editable = false;
            CalcFormula = lookup("PVS Cost Center Configuration"."Max Printing Format Width" where("Cost Center Code" = field("Cost Center Code"), Configuration = field("Cost Center Configuration")));
            FieldClass = FlowField;
        }
        field(906; "Controlling Sheet Text"; Text[100])
        {
            Caption = 'Machine';
            Editable = false;
            CalcFormula = lookup("PVS Calculation Unit Setup".Text where(Type = const(0), "List Of Units" = const(true), code = field("Controlling Sheet Unit")));
            FieldClass = FlowField;
        }

        field(1000; "Job Item Description"; Text[100])
        {
            Caption = 'Job Item Description';
            Editable = false;
            CalcFormula = lookup("PVS Job Item"."Description" where("ID" = field("ID"), Job = field("Job"), Version = field(Version), "Job Item No." = field("Job Item No.")));
            FieldClass = FlowField;
        }
        field(1004; "Original Job Item No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Original Job Item No.';
            Editable = false;
        }

        field(1005; "Split Job Item No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Split Job Item No.';
            Editable = true;
            trigger OnValidate()
            var
                TmpEntries: Record "PTE Job Shift Split" temporary;
            begin
                if Rec."Split Job Item No." <= 0 then begin
                    Rec."Split Job Item No." := 0;
                    exit;
                end;
                if CurrFieldNo = FieldNo("Split Job Item No.") then begin

                    Check_Manuel_SplitNo();
                    TmpEntries.Copy(rec, true);
                    TmpEntries.Reset();
                    TmpEntries.SetRange("Original Job Item No.", rec."Original Job Item No.");
                    TmpEntries.SetRange("Split Job Item No.", Rec."Split Job Item No.");
                    if TmpEntries.IsEmpty() then begin
                        TmpEntries.SetRange("Split Job Item No.");
                        TmpEntries.SetRange("Job Item No.", Rec."Split Job Item No.");
                    end;
                    if "Split Job Item No." <> 0 then
                        if TmpEntries.FindFirst() then begin
                            Rec.Validate("Controlling Sheet Unit", TmpEntries."Controlling Sheet Unit");
                            Rec.Validate("Paper Item No.", TmpEntries."Paper Item No.");
                            Rec.Validate(Finishing, TmpEntries.Finishing);
                            Rec.Validate("Imposition Type", TmpEntries."Imposition Type");
                            Rec.Modify(false);
                        end
                end
            end;
        }
        field(1011; Warning; Boolean)
        {
            Editable = false;
        }
    }
    keys
    {
        key(Key1; ID, Job, Version, "Job Item No.", "Change No.")
        {
            Clustered = true;
        }
        key(Key2; ID, Job, Version, "Job Item No. 2", "Change No.")
        {
        }

    }
    trigger OnModify()
    var
        ch: Record "PVS Job Item Plate Changes";
        HelperFunction: Codeunit "PTE Helperfunction";
        GlobalPVSJobItemTmp: Record "PVS Job Item" temporary;
        GlobalPVSJobSheetTmp: Record "PVS Job Sheet" temporary;
        GlobalCostCenterConfiguration: Record "PVS Cost Center Configuration";
        GlobalItem: Record Item;
    begin
        //HelperFunction.CheckPaperOK(true, Rec, GlobalPVSJobItemTmp, GlobalPVSJobSheetTmp, GlobalCostCenterConfiguration, GlobalItem);
        // Set Changed values
        Changed := false;
        SetChangedFields();
        if CurrFieldNo <> FieldNo("Split Job Item No.") then begin
            if not Changed then
                rec.Validate("Split Job Item No.", 0)
            else
                if (CurrFieldNo = FieldNo("Controlling Sheet Unit")) or (Rec."Lookup Controlling Sheet Unit") then
                    rec.validate("split Job Item No.", NewJobItemNo());
            if (CurrFieldNo <> FieldNo("Controlling Sheet Unit")) and (not Rec."Lookup Controlling Sheet Unit") then
                Update_VariantEntries();
        end;
    end;

    procedure SetChangedFields()
    var
        JobItemRec: Record "PVS Job Item";
        SheetRec: Record "PVS Job Sheet";
        DifferentFromPreviousChanges: Boolean;
    begin
        if not JobItemRec.get(ID, Job, Version, "Job Item No.", 1) then
            exit;
        if SheetRec.get(JobItemRec."Sheet ID") then begin
            "Changed Imposition Type" := (JobItemRec."Imposition Type" <> "Imposition Type");
            "Changed Paper Item No." := (SheetRec."Paper Item No." <> "Paper Item No.");
            "Changed Controlling Sheet Unit" := (SheetRec."Controlling Unit" <> "Controlling Sheet Unit");
            "Changed Finishing" := (SheetRec.Finishing <> Finishing);
            Changed := "Changed Controlling Sheet Unit" or "Changed Finishing" or "Changed Paper Item No." or "Changed Imposition Type";
            DifferentFromPreviousChanges := (Rec."Changed Finishing" <> xRec."Changed Finishing") or (rec."Paper Item No." <> xRec."Paper Item No.");
        end;
    end;

    local procedure Update_VariantEntries();
    var
        tmp: Record "PTE Job Shift Split" temporary;
    begin
        if "Variant Entry No." = 0 then
            exit;
        tmp.Copy(rec, true);
        tmp.reset;
        tmp.SetRange("Job Item No.", "Job Item No.");
        if Rec.Changed then
            if rec."Split Job Item No." <> 0 then
                tmp.SetRange("Split Job Item No.", rec."Split Job Item No.")
            else
                tmp.SetFilter("Change No.", '<>%1', "Change No.");
        if tmp.findset(true) then
            repeat
                tmp."Changed Imposition Type" := "Changed Imposition Type";
                tmp."Changed Paper Item No." := "Changed Paper Item No.";
                tmp."Changed Controlling Sheet Unit" := "Changed Controlling Sheet Unit";
                tmp."Changed Finishing" := "Changed Finishing";
                tmp.Changed := Changed;

                tmp."Imposition Type" := "Imposition Type";
                tmp."Paper Item No." := "Paper Item No.";
                tmp."Controlling Sheet Unit" := "Controlling Sheet Unit";
                tmp.Finishing := Finishing;
                tmp.validate("Split Job Item No.", "Split Job Item No.");
                tmp.Modify();
            until tmp.next = 0;
    end;

    local procedure NewJobItemNo(): integer;
    var
        tmp: Record "PTE Job Shift Split" temporary;
        HighestNewNo: Integer;
        ReuseOK: Boolean;
    begin

        tmp.Copy(Rec, true);

        // If only one platechange on jobitem, new no is 0
        if CurrFieldNo = FieldNo("Controlling Sheet Unit") then begin
            tmp.Reset();
            //does a Entry exists with a split job item no.
            //so a new entry that is in process of being made
            tmp.SetRange("Original Job Item No.", Rec."Original Job Item No.");
            tmp.SetRange("Controlling Sheet Unit", Rec."Controlling Sheet Unit");
            tmp.SetFilter("Split Job Item No.", '<>%1', 0);
            if tmp.FindFirst() then begin
                exit(tmp."Split Job Item No.");
            end
            else begin
                tmp.Setrange("Split Job Item No.", 0);
                tmp.SetFilter("Job Item No.", '<>%1', rec."Job Item No.");
                if tmp.FindFirst() then begin
                    exit(tmp."Job Item No.");
                end
            end
        end;


        tmp.reset;
        tmp.SetRange("Job Item No.", rec."Job Item No.");
        tmp.SetFilter("Change No.", '<>%1', Rec."Change No.");
        tmp.SetRange("Split Job Item No.", 0);
        if tmp.IsEmpty then
            exit(0);

        if "Split Job Item No." <> 0 then begin
            // can existing split no be reused
            ReuseOK := true;
            // is reusing another new no they must have equal attributes
            tmp.reset;
            tmp.SetRange("Split Job Item No.", "Split Job Item No.");
            // tmp.reset;
            // tmp.SetRange("Job Item No.", "Split Job Item No.");
            if tmp.findset then
                repeat
                    if (tmp."Job Item No." <> Rec."Job Item No.") or (tmp."Change No." <> rec."Change No.") then
                        if not Equal_Attributes(tmp, rec) then
                            ReuseOK := false;
                until (tmp.next = 0) or (not ReuseOK);
            if ReuseOK then
                exit("Split Job Item No.");
            tmp.Reset();
        end;

        tmp.reset;
        tmp.SetFilter("Split Job Item No.", '<>0');
        if tmp.IsEmpty then begin
            // find next job item no
            tmp.SetRange("Split Job Item No.");
            tmp.SetCurrentKey(ID, Job, Version, "Job Item No. 2");
            tmp.FindLast();
            exit(tmp."Job Item No. 2" + 1);
        end;
        tmp.findset();
        repeat
            if (tmp."Job Item No." <> Rec."Job Item No.") or (tmp."Change No." <> rec."Change No.") then begin
                if Equal_Attributes(tmp, Rec) then
                    exit(tmp."Split Job Item No.");
                if tmp."Split Job Item No." > HighestNewNo then
                    HighestNewNo := tmp."Split Job Item No.";
            end;
        until tmp.next = 0;
        exit(HighestNewNo + 1);
    end;

    local procedure Equal_Attributes(Rec1: Record "PTE Job Shift Split"; Rec2: Record "PTE Job Shift Split"): Boolean
    begin
        if (Rec1."Job Item No." = Rec2."Job Item No.") and
        (Rec1."Change No." = Rec2."Change No.") then
            exit(true);

        if (rec1."Original Job Item No." <> rec2."Original Job Item No.") and (Rec1."Job Item No." <> Rec2."Job Item No.") then exit(false);
        if Rec1."Imposition Type" <> Rec2."Imposition Type" then exit(false);
        if Rec1."Paper Item No." <> Rec2."Paper Item No." then exit(false);
        if Rec1."Controlling Sheet Unit" <> Rec2."Controlling Sheet Unit" then exit(false);
        exit(true);
    end;

    procedure Check_Manuel_SplitNo(): Boolean
    var
        tmp: Record "PTE Job Shift Split" temporary;
        HighestNewNo: Integer;
    begin
        if ("Split Job Item No." = 0) and (not Changed) then
            exit;
        if "Split Job Item No." = "Job Item No." then
            exit(RollBack(3, false));

        tmp.Copy(Rec, true);

        // If only one platechange on jobitem, new no is 0
        tmp.reset;
        // blank is not allowed
        if "Split Job Item No." = 0 then
            if Rec."Original Job Item No." <> Rec."Job Item No." then
                exit(RollBack(0, false));


        // Is it renumber to a another number (merge/move)
        // where it is from same origin
        tmp.Reset();
        tmp.SetRange("Original Job Item No.", "Original Job Item No.");
        tmp.SetRange("Job Item No.", "Split Job Item No.");
        if tmp.findfirst then
            if not ImpositionMergeCheck(rec."Imposition Type", tmp."Imposition Type") then
                exit(RollBack(4, false))
            else
                exit;

        // Is it trying to be moved to another origin?
        // That is not allowed

        tmp.SetFilter("Original Job Item No.", '<>%1', rec."Original Job Item No.");
        tmp.SetRange("Job Item No.", rec."Split Job Item No.");
        tmp.SetRange("Split Job Item No.", 0);
        if not tmp.IsEmpty() then
            exit(RollBack(2, false));

        // must be a new no
        tmp.Reset();
        tmp.SetRange("Job Item No. 2", "Split Job Item No.");
        if tmp.findset then
            repeat
                if (tmp."Job Item No." = "Job Item No.") and (tmp."Change No." = "Change No.") then
                    exit(RollBack(0, false));
            until tmp.next = 0;

        // is reusing another new no they must have equal attributes
        // tmp.Reset();
        // tmp.SetRange("Job Item No. 2");
        // tmp.SetRange("Split Job Item No.", "Split Job Item No.");
        // if tmp.findset then
        //     repeat
        //         if not Equal_Attributes(tmp, rec) then
        //             exit(RollBack(0, false));
        //     until tmp.next = 0;

    end;

    local procedure ImpositionMergeCheck(From_ImpositionCode: Code[20]; To_ImpositionCode: Code[20]) OK: Boolean
    var
        FromImpositionCode, ToImpositionCode : Record "PVS Imposition Code";
    begin
        if From_ImpositionCode = To_ImpositionCode then
            exit(true);
        FromImpositionCode.get(From_ImpositionCode);
        ToImpositionCode.get(To_ImpositionCode);
        exit(FromImpositionCode."Folding Pages" = ToImpositionCode."Folding Pages");

    end;

    local procedure RollBack(ErrorNo: integer; GiveError: Boolean): Boolean
    var
        Error000: Label 'Not a valid No.';
        Error001: Label 'This will empty Job Item %1, that at least 1 job item is splitted from';
        Error002: Label 'It is not allowed to merge plate changes from different components';
        Error003: Label 'This is the same Number';
        Error004: Label 'Must have same folding pages';
        ErrorTxt: Text;
    begin
        case ErrorNo of
            0:
                ErrorTxt := Error000;
            1:
                ErrorTxt := StrSubstNo(error001, rec."Job Item No.");
            2:
                ErrorTxt := Error002;
            3:
                ErrorTxt := Error003;
            4:
                ErrorTxt := Error004;
        end;
        if GiveError then
            error(ErrorTxt);
        rec."Split Job Item No." := xRec."Split Job Item No.";
        Message(ErrorTxt);
    end;

    procedure SelectMachineManually(IsLookUpMachine: Boolean)
    var
        TmpEntries: Record "PTE Job Shift Split" temporary;
    begin
        if (CurrFieldNo = FieldNo("Controlling Sheet Unit")) or (IsLookUpMachine) then begin
            TmpEntries.Copy(rec, true);
            TmpEntries.Reset();
            //does a Entry exists with a split job item no.
            //so a new entry that is in process of being made
            TmpEntries.SetRange("Original Job Item No.", Rec."Original Job Item No.");
            TmpEntries.SetRange("Controlling Sheet Unit", Rec."Controlling Sheet Unit");
            TmpEntries.SetFilter("Split Job Item No.", '<>%1', 0);
            if TmpEntries.FindFirst() then begin
                Rec.Validate("Paper Item No.", TmpEntries."Paper Item No.");
                Rec.Validate(Finishing, TmpEntries.Finishing);
                Rec.Validate("Imposition Type", TmpEntries."Imposition Type");
                Rec.Modify(true);
            end
            else begin
                TmpEntries.Setrange("Split Job Item No.", 0);
                TmpEntries.SetFilter("Job Item No.", '<>%1', rec."Job Item No.");
                if TmpEntries.FindFirst() then begin
                    Rec.Validate("Paper Item No.", TmpEntries."Paper Item No.");
                    Rec.Validate(Finishing, TmpEntries.Finishing);
                    Rec.Validate("Imposition Type", TmpEntries."Imposition Type");
                    Rec.Modify(true);
                end
            end
        end
        else
            Rec.validate("Paper Item No.");
    end;

}