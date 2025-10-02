table 80186 "SISM Pickup Point"
{
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; Number; Code[20])
        {
            Caption = 'Number';
        }
        field(2; ID; Code[20])
        {
            Caption = 'ID';
        }
        field(3; "Company Name"; Text[100])
        {
            Caption = 'Company Name';
        }
        field(4; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(5; Address; Text[100])
        {
            Caption = 'Address';
        }
        field(6; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(7; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
        }
        field(8; City; Text[30])
        {
            Caption = 'City';
        }
        field(9; "Country Code"; Code[10])
        {
            Caption = 'Country Code';
        }
        field(10; Distance; Decimal)
        {
            Caption = 'Distance';
            DecimalPlaces = 2 : 5;
        }
        field(11; Longitude; Decimal)
        {
            Caption = 'Longitude';
            DecimalPlaces = 4 : 6;
        }
        field(12; Latitude; Decimal)
        {
            Caption = 'Latitude';
            DecimalPlaces = 4 : 6;
        }
        field(13; Agent; Code[20])
        {
            Caption = 'Agent';
        }
        field(14; "Carrier Code"; Code[20])
        {
            Caption = 'Carrier Code';
        }
        field(15; "Opening Hours"; Blob)
        {
            Caption = 'Opening Hours';
        }
        field(16; "In Delivery"; Boolean)
        {
            Caption = 'In Delivery';
        }
        field(17; "Out Delivery"; Boolean)
        {
            Caption = 'Out Delivery';
        }
    }

    keys
    {
        key(Key1; "Number")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Number", "Name") { }
    }

    procedure SetOpeningHours(NewOpeningHours: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Rec."Opening Hours");
        Rec."Opening Hours".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewOpeningHours);
        Rec.Modify();
    end;

    procedure GetOpeningHours() OpeningHours: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        Rec.CalcFields("Opening Hours");
        Rec."Opening Hours".CreateInStream(InStream, TextEncoding::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), Rec.FieldName("Opening Hours")));
    end;
}