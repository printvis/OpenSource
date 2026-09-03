table 75000 "PTE Product Job Item"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Product Code"; Code[20])
        {
            Caption = 'Product Code';
            DataClassification = SystemMetadata;
            TableRelation = "PVS Product".Code;
            ToolTip = 'Specifies the product code.';
        }
        field(2; "Job Item No."; Integer)
        {
            Caption = 'Job Item No.';
            DataClassification = SystemMetadata;
            ToolTip = 'Specifies the job item number.';
        }
        field(6010116; "Format Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Format Code';
            ToolTip = 'Rather than using Format1 and Format2, a Format Code may be entered to give the size of the Paper/Substrate or Plate.';
            TableRelation = "PVS Format Code" where(Type = filter(Miscellaneous | "Final format"));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                GeneralSetup: Record "PVS General Setup";
                FormatCode: Record "PVS Format Code";
            begin
                if not FormatCode.Get(Rec."Format Code") then
                    exit;

                if GeneralSetup.Get() then;

                if GeneralSetup."Manual Grain Direction" then begin
                    Rec.Validate(Width, FormatCode."Width Centimeter");
                    Rec.Validate(Length, FormatCode."Length Centimeter");
                end else
                    if GeneralSetup."Format Entry" = GeneralSetup."format entry"::"Depth x Width" then begin
                        Rec.Validate("Format1", FormatCode."Length Centimeter");
                        Rec.Validate("Format2", FormatCode."Width Centimeter");
                    end else begin
                        Rec.Validate("Format1", FormatCode."Width Centimeter");
                        Rec.Validate("Format2", FormatCode."Length Centimeter");
                    end;
            end;
        }
        field(6010051; "Format1"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 0;
            DecimalPlaces = 2 : 6;
            BlankZero = true;
            Caption = 'Format1';
            ToolTip = 'Size of the current product (width or length depending on setup).';
        }
        field(6010052; "Format2"; Decimal) //widrg
        {
            DataClassification = CustomerContent;
            AutoFormatType = 0;
            DecimalPlaces = 2 : 6;
            BlankZero = true;
            Caption = 'Format2';
            ToolTip = 'Size of the current product (width or length depending on setup).';
        }
        //Refactored to Length and Width fields only used for the format code validation, the Format1 and Format2 fields are used for the actual format code values.
        field(6010130; Length; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 0;
            DecimalPlaces = 2 : 6;
            Caption = 'Length';
            ToolTip = 'Specifies the length used for format code validation.';
            Description = 'PRINTVIS';
        }
        //Refactored to Length and Width fields only used for the format code validation, the Format1 and Format2 fields are used for the actual format code values.

        field(6010131; Width; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 0;
            DecimalPlaces = 2 : 6;
            Caption = 'Width';
            ToolTip = 'Specifies the width used for format code validation.';
        }

        field(6010054; "Weight"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 0;
            DecimalPlaces = 2 : 6;
            BlankZero = true;
            Caption = 'Weight';
            ToolTip = 'Displays the weight of the Paper.';
        }
        field(6010073; "Imposition Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Imposition Code';
            TableRelation = "PVS Imposition Code";
            ToolTip = 'Use to link a specific Imposition Type to the Item that will be transferred to the new case if: 1.Field is empty in template, AND 2. Number of items in the length and width on imposition code must match length and width [leaves] of the template case, or the "Manual Pages On The Sheet" is set to True, by entering manual pages on sheet or impose 1/2.';

            trigger OnValidate()
            var
                ImpositionRec: Record "PVS Imposition Code";
            begin
                if "Imposition Code" <> '' then begin
                    ImpositionRec.Get("Imposition Code");
                    Rec."Format1" := ImpositionRec."Format 1";
                    Rec."Format2" := ImpositionRec."Format 2";
                end;
            end;
        }
        field(6010105; "Paper No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Paper No.';
            ToolTip = 'Specifies the paper/substrate item number.';
            TableRelation = Item;

            trigger OnValidate()
            var
                ItemRec: Record Item;
            begin
                // Mirror PVS Job Sheet.Change_Paper: pull the paper weight from the item.
                // Only overwrite when the item has a weight defined, to avoid clearing a
                // manually entered value when the paper item has no weight.
                if ItemRec.Get("Paper No.") then
                    if ItemRec."PVS Weight" <> 0 then
                        Validate(Weight, ItemRec."PVS Weight");
            end;
        }
        field(6010115; "Paper Description"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Paper No.")));
            Caption = 'Paper Description';
            ToolTip = 'Specifies the description of the paper/substrate item.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6010106; "Finishing"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Finishing';
            ToolTip = 'If a certain Finishing Type code is to be added to estimations for this Job Item, enter it here.';
            TableRelation = "PVS Finishing Types";
        }
        field(6010330; "Colors Front"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Colors Front';
            ToolTip = 'Displays number of colors on the front side.';
        }
        field(6010331; "Colors Back"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Colors Back';
            ToolTip = 'Displays number of colors on the back side.';
        }
        field(6010401; "Tool 1"; Code[20])
        {
            DataClassification = CustomerContent;
            captionclass = 'PVS,FIELD6010388-1';
            Caption = 'Tool 1';
            ToolTip = 'Displays the first Tool for the current PrintVis Product, to properly load the required tools when doing re-runs of the product.';
            TableRelation = "PVS Tool";
        }
        field(6010402; "Tool 2"; Code[20])
        {
            DataClassification = CustomerContent;
            captionclass = 'PVS,FIELD6010388-2';
            Caption = 'Tool 2';
            ToolTip = 'Displays the second Tool for the current PrintVis Product, to properly load the required tools when doing re-runs of the product.';
            TableRelation = "PVS Tool";
        }
        field(6010403; "Tool 3"; Code[20])
        {
            DataClassification = CustomerContent;
            captionclass = 'PVS,FIELD6010388-3';
            Caption = 'Tool 3';
            ToolTip = 'Displays the third Tool for the current PrintVis Product, to properly load the required tools when doing re-runs of the product.';
            TableRelation = "PVS Tool";
        }
        field(6010404; "Tool 4"; Code[20])
        {
            DataClassification = CustomerContent;
            captionclass = 'PVS,FIELD6010388-4';
            Caption = 'Tool 4';
            ToolTip = 'Displays the fourth Tool for the current PrintVis Product, to properly load the required tools when doing re-runs of the product.';
            TableRelation = "PVS Tool";
        }
        field(6010410; "Media Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Media Type';
            ToolTip = 'Specifies the media type (e.g. Envelope).';
            OptionCaption = ' ,Envelope,Envelope Plain,Envelope Window';
            OptionMembers = " ",Envelope,"Envelope Plain","Envelope Window";
        }
        field(6010420; "List Of Units"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'List Of Units';
            ToolTip = 'Specifies the list of units code.';
            TableRelation = "PVS Calculation Unit Setup".Code where("List Of Units" = const(true));

            trigger OnValidate()
            begin
                ResolveConfiguration();
            end;
        }
        field(6010421; "Configuration"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Configuration';
            ToolTip = 'Specifies the Cost Center Configuration to use for the List Of Units. Resolved automatically when unambiguous, or selected manually when the machine/cost center has more than one matching configuration (mirrors the "PVS Calculation Configurations" selection shown on the PVS Job Item).';
        }
        field(6010411; "Envelope Window Shape Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Envelope Window Shape Type';
            ToolTip = 'Specifies the shape type of the envelope window.';
            OptionCaption = ' ,Rectangular,Round,Path';
            OptionMembers = " ",Rectangular,Round,Path;
        }
        field(6010412; "Envelope Window Size X"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 0;
            DecimalPlaces = 2 : 6;
            BlankZero = true;
            Caption = 'Envelope Window Size X';
            ToolTip = 'Specifies the horizontal size of the envelope window.';
        }
        field(6010413; "Envelope Window Size Y"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 0;
            DecimalPlaces = 2 : 6;
            BlankZero = true;
            Caption = 'Envelope Window Size Y';
            ToolTip = 'Specifies the vertical size of the envelope window.';
        }
        field(6010414; "Opacity"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Opacity';
            ToolTip = 'Specifies the opacity type of the product.';
            OptionCaption = ' ,Opaque,Translucent,Transparent';
            OptionMembers = " ",Opaque,Translucent,Transparent;
        }
        field(6010415; "Opacity Level"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 0;
            BlankZero = true;
            Caption = 'Opacity Level';
            ToolTip = 'Specifies the opacity level of the product.';
            DecimalPlaces = 0 : 0;
        }
        field(70; "Component Type"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Component Type';
            ToolTip = 'Specifies the component type for this job item, defining how it is treated in the production calculation.';
            TableRelation = "PVS Component Types";
        }
        field(71; "Component Type Description"; Text[50])
        {
            CalcFormula = lookup("PVS Component Types".Description where(Code = field("Component Type")));
            Caption = 'Component Type Description';
            ToolTip = 'Specifies the description of the component type.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "No. Of Pages"; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'No. of Pages';
            ToolTip = 'Specifies the total number of pages for this job item. Must be an even number.';

            trigger OnValidate()
            var
                unevenErr: Label 'No. of pages cannot be uneven';
            begin
                if ("No. Of Pages" mod 2) <> 0 then
                    Error(unevenErr);
            end;
        }
        field(25; "Pages With Print"; Decimal)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Pages with Print';
            ToolTip = 'Specifies the number of pages that carry print for this job item.';
            DecimalPlaces = 0 : 4;
        }
    }

    keys
    {
        key(Key1; "Product Code", "Job Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    trigger OnInsert()
    var
        ProductJobItem: Record "PTE Product Job Item";
        ProductRec: Record "PVS Product";
    begin
        if "Job Item No." = 0 then begin
            ProductJobItem.SetRange("Product Code", "Product Code");
            if ProductJobItem.FindLast() then
                "Job Item No." := ProductJobItem."Job Item No." + 1
            else
                "Job Item No." := 1;
        end;
        ProductRec.Get("Product Code");
        if ProductRec."Format Code" <> '' then
            Validate("Format Code", ProductRec."Format Code")
        else begin

            "Format1" := ProductRec."Format1";
            "Format2" := ProductRec."Format2";
            Length := ProductRec.Length;
            Width := ProductRec.Width;
        end;
        Weight := ProductRec.Weight;
        "Imposition Code" := ProductRec."Imposition Code";
        "Paper No." := ProductRec."Paper No.";
        Finishing := ProductRec.Finishing;
        "Colors Front" := ProductRec."Colors Front";
        "Colors Back" := ProductRec."Colors Back";
        "Tool 1" := ProductRec."Tool 1";
        "Tool 2" := ProductRec."Tool 2";
        "Tool 3" := ProductRec."Tool 3";
        "Tool 4" := ProductRec."Tool 4";
        "Media Type" := ProductRec."Media Type";
        "Envelope Window Shape Type" := ProductRec."Envelope Window Shape Type";
        "Envelope Window Size X" := ProductRec."Envelope Window Size X";
        "Envelope Window Size Y" := ProductRec."Envelope Window Size Y";
        Opacity := ProductRec.Opacity;
        "Opacity Level" := ProductRec."Opacity Level";

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    /// <summary>
    /// Resolves the Cost Center Configuration for the current "List Of Units" selection,
    /// mirroring the base app's ambiguity handling on the real PVS Job Item (page
    /// "PVS Calculation Configurations" / 6010357): candidate configurations are filtered
    /// by this line's current Format1/Format2/Weight against each configuration's
    /// Min/Max Printing Format and Weight ranges.
    /// - 0 matches: "Configuration" is cleared (left for manual/runtime resolution).
    /// - 1 match: assigned silently.
    /// - 2+ matches: the user is prompted via "PVS Calculation Configurations" to pick one.
    /// </summary>
    local procedure ResolveConfiguration()
    var
        TempMatchingUnitSetup: Record "PVS Calculation Unit Setup" temporary;
        Page_Configurations: Page "PVS Calculation Configurations";
        Config_ARR: array[100] of Code[20];
        Config_Max: Integer;
        MatchCount: Integer;
    begin
        Rec.Configuration := '';

        if "List Of Units" = '' then
            exit;

        MatchCount := GetMatchingConfigurations(TempMatchingUnitSetup);
        case MatchCount of
            0:
                exit;
            1:
                begin
                    TempMatchingUnitSetup.FindFirst();
                    Rec.Configuration := TempMatchingUnitSetup.Configuration;
                end;
            else begin
                Commit();
                Clear(Page_Configurations);
                Page_Configurations.Set_Filter_Units(TempMatchingUnitSetup);
                if Page_Configurations.RunModal() = Action::OK then begin
                    Page_Configurations.Find_Marked(Config_Max, Config_ARR);
                    if Config_Max > 0 then
                        if TempMatchingUnitSetup.Get(TempMatchingUnitSetup.Type::"Price Unit", Config_ARR[1]) then
                            Rec.Configuration := TempMatchingUnitSetup.Configuration;
                end;
            end;
        end;
    end;

    /// <summary>
    /// Builds the set of Cost Center Configurations that are compatible with this line's
    /// current Format1/Format2/Weight, under the Cost Center resolved from the "List Of
    /// Units" calculation unit. Each match is represented by its concrete "PVS Calculation
    /// Unit Setup" record, because the "PVS Calculation Configurations" picker page
    /// (6010357) actually has SourceTable = "PVS Calculation Unit Setup" (confirmed from
    /// the base app symbols) - not "PVS Cost Center Configuration". Also used by the sub
    /// page to let the user manually reopen the picker and override the automatically
    /// resolved Configuration.
    /// </summary>
    /// <param name="TempMatchingUnitSetup">Filled with one Calculation Unit Setup record per matching Configuration.</param>
    /// <returns>The number of matching configurations found.</returns>
    procedure GetMatchingConfigurations(var TempMatchingUnitSetup: Record "PVS Calculation Unit Setup" temporary): Integer
    var
        UnitSetup: Record "PVS Calculation Unit Setup";
        CostCenterConfig: Record "PVS Cost Center Configuration";
        CandidateUnitSetup: Record "PVS Calculation Unit Setup";
    begin
        TempMatchingUnitSetup.Reset();
        TempMatchingUnitSetup.DeleteAll();

        if "List Of Units" = '' then
            exit(0);

        if not UnitSetup.Get(UnitSetup.Type::"Price Unit", "List Of Units") then
            exit(0);

        if UnitSetup."Cost Center Code" = '' then
            exit(0);

        CostCenterConfig.SetRange("Cost Center Code", UnitSetup."Cost Center Code");
        if CostCenterConfig.FindSet() then
            repeat
                if IsConfigurationMatch(CostCenterConfig) then begin
                    CandidateUnitSetup.Reset();
                    CandidateUnitSetup.SetRange(Type, CandidateUnitSetup.Type::"Price Unit");
                    CandidateUnitSetup.SetRange("Cost Center Code", CostCenterConfig."Cost Center Code");
                    CandidateUnitSetup.SetRange(Configuration, CostCenterConfig.Configuration);
                    CandidateUnitSetup.SetRange("List Of Units", false);
                    if CandidateUnitSetup.FindFirst() then
                        if not TempMatchingUnitSetup.Get(CandidateUnitSetup.Type, CandidateUnitSetup.Code) then begin
                            TempMatchingUnitSetup := CandidateUnitSetup;
                            TempMatchingUnitSetup.Insert();
                        end;
                end;
            until CostCenterConfig.Next() = 0;

        exit(TempMatchingUnitSetup.Count());
    end;

    /// <summary>
    /// Checks whether the given Cost Center Configuration's Min/Max Printing Format and
    /// Weight ranges accommodate this line's current Format1/Format2/Weight values. A
    /// blank/zero limit on the configuration, or a blank/zero value on this line, is
    /// treated as "no constraint" for that dimension.
    /// </summary>
    local procedure IsConfigurationMatch(CostCenterConfig: Record "PVS Cost Center Configuration"): Boolean
    begin
        if (Format1 <> 0) then begin
            if (CostCenterConfig."Max Printing Format Length" <> 0) and (Format1 > CostCenterConfig."Max Printing Format Length") then
                exit(false);
            if (CostCenterConfig."Min Print Format Length" <> 0) and (Format1 < CostCenterConfig."Min Print Format Length") then
                exit(false);
        end;

        if (Format2 <> 0) then begin
            if (CostCenterConfig."Max Printing Format Width" <> 0) and (Format2 > CostCenterConfig."Max Printing Format Width") then
                exit(false);
            if (CostCenterConfig."Min Print Format Width" <> 0) and (Format2 < CostCenterConfig."Min Print Format Width") then
                exit(false);
        end;

        if (Weight <> 0) then begin
            if (CostCenterConfig."Max Weight" <> 0) and (Weight > CostCenterConfig."Max Weight") then
                exit(false);
            if (CostCenterConfig."Min Weight" <> 0) and (Weight < CostCenterConfig."Min Weight") then
                exit(false);
        end;

        exit(true);
    end;

}
