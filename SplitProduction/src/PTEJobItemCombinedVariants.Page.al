Page 80180 "PTE Job Item Combined Variants"
{
    Caption = 'Job Item Combined Sheets';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPart;
    ShowFilter = false;
    SourceTable = "PVS Job Item Variant";
    SourceTableTemporary = true;
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                FreezeColumn = Variant;
                field("Variant"; Get_Variant_Code())
                {
                    ApplicationArea = All;
                    captionclass = VariantTxt;
                    Editable = false;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                }
                field(GetMaxUp; Get_Max_Up())
                {
                    ApplicationArea = All;
                    Caption = 'Max UP''s';
                    Width = 5;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'The quantity of each variant of this component is determined by the user in page 6010649.';
                    Width = 7;
                }
                field(SheetID; Rec."Sheet ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'SheetID is the unique identifier for the Sheets/Rolls this component is printed on. The field is for internal system use only. ';
                    Width = 5;
                }
                field(NoofUps; Rec."No. of Ups")
                {
                    ApplicationArea = All;
                    ToolTip = 'Based on the sheetID parameters of printing sheet format and job item format PrintVis will calculate how many ups will fit on the printing sheet. This will determin how many component ups each variant can have as a maximum.';
                    Width = 6;
                }
                field(U01; Get_UP(1))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(1);
                    Editable = false;
                    StyleExpr = Style01;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(1);
                    end;
                }
                field(U02; Get_UP(2))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(2);
                    Editable = false;
                    StyleExpr = Style02;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(2);
                    end;
                }
                field(U03; Get_UP(3))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(3);
                    Editable = false;
                    StyleExpr = Style03;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(3);
                    end;
                }
                field(U04; Get_UP(4))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(4);
                    Editable = false;
                    StyleExpr = Style04;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(4);
                    end;
                }
                field(U05; Get_UP(5))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(5);
                    Editable = false;
                    StyleExpr = Style05;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(5);
                    end;
                }
                field(U06; Get_UP(6))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(6);
                    Editable = false;
                    StyleExpr = Style06;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(6);
                    end;
                }
                field(U07; Get_UP(7))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(7);
                    Editable = false;
                    StyleExpr = Style07;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(7);
                    end;
                }
                field(U08; Get_UP(8))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(8);
                    Editable = false;
                    StyleExpr = Style08;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(8);
                    end;
                }
                field(U09; Get_UP(9))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(9);
                    Editable = false;
                    StyleExpr = Style09;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(9);
                    end;
                }
                field(U10; Get_UP(10))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(10);
                    Editable = false;
                    StyleExpr = Style10;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(10);
                    end;
                }
                field(U11; Get_UP(11))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(11);
                    Editable = false;
                    StyleExpr = Style11;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(11);
                    end;
                }
                field(U12; Get_UP(12))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(12);
                    Editable = false;
                    StyleExpr = Style12;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(12);
                    end;
                }
                field(U13; Get_UP(13))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(13);
                    Editable = false;
                    StyleExpr = Style13;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(13);
                    end;
                }
                field(U14; Get_UP(14))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(14);
                    Editable = false;
                    StyleExpr = Style14;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(14);
                    end;
                }
                field(U15; Get_UP(15))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(15);
                    Editable = false;
                    StyleExpr = Style15;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(15);
                    end;
                }
                field(U16; Get_UP(16))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(16);
                    Editable = false;
                    StyleExpr = Style16;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(16);
                    end;
                }
                field(U17; Get_UP(17))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(17);
                    Editable = false;
                    StyleExpr = Style17;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(17);
                    end;
                }
                field(U18; Get_UP(18))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(18);
                    Editable = false;
                    StyleExpr = Style18;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(18);
                    end;
                }
                field(U19; Get_UP(19))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(19);
                    Editable = false;
                    StyleExpr = Style19;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(19);
                    end;
                }
                field(U20; Get_UP(20))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(20);
                    Editable = false;
                    StyleExpr = Style20;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(20);
                    end;
                }
                field(U21; Get_UP(21))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(21);
                    Editable = false;
                    StyleExpr = Style21;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(21);
                    end;
                }
                field(U22; Get_UP(22))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(22);
                    Editable = false;
                    StyleExpr = Style22;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(22);
                    end;
                }
                field(U23; Get_UP(23))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(23);
                    Editable = false;
                    StyleExpr = Style23;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(23);
                    end;
                }
                field(U24; Get_UP(24))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(24);
                    Editable = false;
                    StyleExpr = Style24;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(24);
                    end;
                }
                field(U25; Get_UP(25))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(25);
                    Editable = false;
                    StyleExpr = Style25;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(25);
                    end;
                }
                field(U26; Get_UP(26))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(26);
                    Editable = false;
                    StyleExpr = Style26;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(26);
                    end;
                }
                field(U27; Get_UP(27))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(27);
                    Editable = false;
                    StyleExpr = Style27;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(27);
                    end;
                }
                field(U28; Get_UP(28))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(28);
                    Editable = false;
                    StyleExpr = Style28;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(28);
                    end;
                }
                field(U29; Get_UP(29))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(29);
                    Editable = false;
                    StyleExpr = Style29;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(29);
                    end;
                }
                field(U30; Get_UP(30))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(30);
                    Editable = false;
                    StyleExpr = Style30;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(30);
                    end;
                }
                field(U31; Get_UP(31))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(31);
                    Editable = false;
                    StyleExpr = Style31;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(31);
                    end;
                }
                field(U32; Get_UP(32))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(32);
                    Editable = false;
                    StyleExpr = Style32;
                    ToolTip = 'This is a calculated Flow Field. The field show the name of the item picked on this same line.';
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(32);
                    end;
                }
                field(U33; Get_UP(33))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(33);
                    Caption = '<U33>', Locked = true;
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(33);
                    end;
                }
                field(U34; Get_UP(34))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(34);
                    Caption = '<U34>', Locked = true;
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(34);
                    end;
                }
                field(U35; Get_UP(35))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(35);
                    Caption = '<U35>', Locked = true;
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(35);
                    end;
                }
                field(U36; Get_UP(36))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(36);
                    Caption = '<U36>', Locked = true;
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(36);
                    end;
                }
                field(U37; Get_UP(37))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(37);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(37);
                    end;
                }
                field(U38; Get_UP(38))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(38);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(38);
                    end;
                }
                field(U39; Get_UP(39))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(39);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(39);
                    end;
                }
                field(U40; Get_UP(40))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(40);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(40);
                    end;
                }
                field(U41; Get_UP(41))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(41);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(41);
                    end;
                }
                field(U42; Get_UP(42))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(42);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(42);
                    end;
                }
                field(U43; Get_UP(43))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(43);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(43);
                    end;
                }
                field(U44; Get_UP(44))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(44);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(44);
                    end;
                }
                field(U45; Get_UP(45))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(45);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(45);
                    end;
                }
                field(U46; Get_UP(46))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(46);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(46);
                    end;
                }
                field(U47; Get_UP(47))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(47);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(47);
                    end;
                }
                field(U48; Get_UP(48))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(48);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(48);
                    end;
                }
                field(U49; Get_UP(49))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(49);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(49);
                    end;
                }
                field(U50; Get_UP(50))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(50);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(50);
                    end;
                }
                field(U51; Get_UP(51))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(51);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(51);
                    end;
                }
                field(U52; Get_UP(52))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(52);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(52);
                    end;
                }
                field(U53; Get_UP(53))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(53);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(53);
                    end;
                }
                field(U54; Get_UP(54))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(54);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(54);
                    end;
                }
                field(U55; Get_UP(55))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(55);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(55);
                    end;
                }
                field(U56; Get_UP(56))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(56);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(56);
                    end;
                }
                field(U57; Get_UP(57))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(57);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(57);
                    end;
                }
                field(U58; Get_UP(58))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(58);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(58);
                    end;
                }
                field(U59; Get_UP(59))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(59);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(59);
                    end;
                }
                field(U60; Get_UP(60))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(60);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(60);
                    end;
                }
                field(U61; Get_UP(61))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(61);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(61);
                    end;
                }
                field(U62; Get_UP(62))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(62);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(62);
                    end;
                }
                field(U63; Get_UP(63))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(63);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(63);
                    end;
                }
                field(U64; Get_UP(64))
                {
                    ApplicationArea = All;
                    captionclass = Get_Col_Caption(64);
                    Editable = false;
                    StyleExpr = Style32;
                    Width = 5;

                    trigger OnAssistEdit()
                    begin
                        Select_PlateChange(64);
                    end;
                }
            }
            // part(Control1160230020; "PVS Job Item Combined PlateCng")
            // {
            //     ApplicationArea = All;
            //     SubPageLink = ID = field(ID),
            //                   Job = field(Job),
            //                   Version = field(Version),
            //                   "Job Item No." = field("Job Item No.");
            // }
        }
    }

    actions
    {
        // area(creation)
        // {
        //     action(VariantSets)
        //     {
        //         ApplicationArea = All;
        //         Caption = 'Divide in Forms';
        //         Image = CopyBOMVersion;
        //         ToolTip = 'Divide in Forms';

        //         trigger OnAction()
        //         begin
        //             Rec.Create_Variant_Forms(true);
        //             Number_of_Forms := 0;
        //             Global_MaxUp := 0;
        //             Display();
        //         end;
        //     }
        // }
        area(processing)
        {
            action("Previous Job Item")
            {
                ApplicationArea = All;
                Caption = 'Previous Job Item';
                Image = PreviousRecord;
                ToolTip = 'Previous Job Item';

                trigger OnAction()
                var
                    Local_JobItem: Record "PVS Job Item";
                begin
                    if not Local_JobItem.Get(Global_JobItemRec.ID, Global_JobItemRec.Job, Global_JobItemRec.Version, Global_JobItemRec."Job Item No.", Global_JobItemRec."Entry No.") then
                        exit;
                    Local_JobItem.SetRange(ID, Global_JobItemRec.ID);
                    Local_JobItem.SetRange(Job, Global_JobItemRec.Job);
                    Local_JobItem.SetRange(Version, Global_JobItemRec.Version);
                    if Local_JobItem.Next(-1) = 0 then
                        if not Local_JobItem.FindLast() then
                            Local_JobItem := Global_JobItemRec;

                    Update_JobItem();
                    SET_RECORD(Local_JobItem);
                    Global_MaxUp := 0;
                    Number_of_Forms := 0;
                    Display();
                end;
            }
            action("Next Job Item")
            {
                ApplicationArea = All;
                Caption = 'Next Job Item';
                Image = NextRecord;
                ToolTip = 'Next Job Item';

                trigger OnAction()
                var
                    Local_JobItem: Record "PVS Job Item";
                begin
                    if not Local_JobItem.Get(Global_JobItemRec.ID, Global_JobItemRec.Job, Global_JobItemRec.Version, Global_JobItemRec."Job Item No.", Global_JobItemRec."Entry No.") then
                        exit;
                    Local_JobItem.SetRange(ID, Global_JobItemRec.ID);
                    Local_JobItem.SetRange(Job, Global_JobItemRec.Job);
                    Local_JobItem.SetRange(Version, Global_JobItemRec.Version);
                    if Local_JobItem.Next() = 0 then
                        if not Local_JobItem.FindFirst() then
                            Local_JobItem := Global_JobItemRec;

                    Update_JobItem();
                    SET_RECORD(Local_JobItem);
                    Global_MaxUp := 0;
                    Number_of_Forms := 0;
                    Display();
                end;
            }
        }
        // area(Promoted)
        // {
        //     group(Category_Process)
        //     {
        //         Caption = 'Process';

        //         actionref(VariantSets_Promoted; VariantSets)
        //         {
        //         }
        //         actionref("Previous Job Item_Promoted"; "Previous Job Item")
        //         {
        //         }
        //         actionref("Next Job Item_Promoted"; "Next Job Item")
        //         {
        //         }
        //     }
        // }
    }

    trigger OnAfterGetRecord()
    begin
        Set_StyleExpression();
    end;

    trigger OnClosePage()
    begin
        Update_JobItem();
    end;

    trigger OnOpenPage()
    begin
        Display();
    end;

    procedure SetTmp(var in_Tmp: Record "PVS Job Item Variant" temporary)
    begin
        Rec.Copy(in_Tmp, true);
    end;

    var
        Global_JobItemRec: Record "PVS Job Item";
        PVS: Codeunit "PVS Global";
        CalcMgt: Codeunit "PVS Calculation Management";
        SheetMgt: Codeunit "PVS Sheet Management";
        Style01: Text[50];
        Style02: Text[50];
        Style03: Text[50];
        Style04: Text[50];
        Style05: Text[50];
        Style06: Text[50];
        Style07: Text[50];
        Style08: Text[50];
        Style09: Text[50];
        Style10: Text[50];
        Style11: Text[50];
        Style12: Text[50];
        Style13: Text[50];
        Style14: Text[50];
        Style15: Text[50];
        Style16: Text[50];
        Style17: Text[50];
        Style18: Text[50];
        Style19: Text[50];
        Style20: Text[50];
        Style21: Text[50];
        Style22: Text[50];
        Style23: Text[50];
        Style24: Text[50];
        Style25: Text[50];
        Style26: Text[50];
        Style27: Text[50];
        Style28: Text[50];
        Style29: Text[50];
        Style30: Text[50];
        Style31: Text[50];
        Style32: Text[50];
        VariantTxt: Text;
        Global_MaxUp: Integer;
        Number_of_Forms: Integer;
        Text003Lbl: label '%1 Up', Comment = '%1 Refers to the Up value';
        Text004Lbl: label 'Variants: %1', Comment = '%1 Refers to the Variant';

    procedure SET_RECORD(in_JobItemRec: Record "PVS Job Item")
    begin
        Global_JobItemRec := in_JobItemRec;
        Rec.SetRange(Rec.ID, in_JobItemRec.ID);
        Rec.SetRange(Rec.Job, in_JobItemRec.Job);
        Rec.SetRange(Rec.Version, in_JobItemRec.Version);
        Rec.SetRange(Rec."Job Item No.", in_JobItemRec."Job Item No.");

        //Display();
    end;

    procedure Get_Col_Caption(in_Col: Integer) Result: Text
    begin
        if in_Col <= Get_Max_Up() then
            Result := StrSubstNo(Text003Lbl, in_Col);
    end;

    procedure Display()
    begin
        if Global_JobItemRec.Description <> '' then
            VariantTxt := StrSubstNo(Text004Lbl, Global_JobItemRec.Description)
        else begin
            Global_JobItemRec.CalcFields(Global_JobItemRec."Component Type Description");
            VariantTxt := StrSubstNo(Text004Lbl, Global_JobItemRec."Component Type Description");
        end;

        VariantTxt := VariantTxt + StrSubstNo(' (%1)', Global_JobItemRec.Quantity);
    end;

    local procedure Update_JobItem()
    var
        CaseRec: Record "PVS Case";
        JobRec: Record "PVS Job";
        SheetRec: Record "PVS Job Sheet";
        PlanMgt: Codeunit "PVS Planning Management";
        CaseModificationAllowed: Codeunit "PVS Case Modification Allowed";
        RecRef: RecordRef;
    begin
        if not CaseRec.Get(Global_JobItemRec.ID) then
            exit;

        if not JobRec.Get(Global_JobItemRec.ID, Global_JobItemRec.Job, Global_JobItemRec.Version) then
            exit;

        // PVSW111.00.02
        if not CaseModificationAllowed.Case_Is_Modification_Allowed(CaseRec, CaseRec, JobRec.Status, JobRec.Active, false, RecRef) then
            // IF NOT Main.Case_Is_Modification_Allowed(CaseRec,CaseRec,JobRec.Status,JobRec.Active,FALSE) THEN
            // PVSW111.00.02
            exit;

        if SheetRec.Get(Global_JobItemRec."Sheet ID") then
            SheetMgt.Update_Sheet_From_JobItems(SheetRec);
        CalcMgt.Main_Calculate_Job(Global_JobItemRec.ID, Global_JobItemRec.Job, Global_JobItemRec.Version);

        PlanMgt.Adjust_Limits(0, Global_JobItemRec.ID, Global_JobItemRec.Job);
    end;

    procedure Set_StyleExpression()
    begin
        Style01 := Get_StyleExpression(1);
        Style02 := Get_StyleExpression(2);
        Style03 := Get_StyleExpression(3);
        Style04 := Get_StyleExpression(4);
        Style05 := Get_StyleExpression(5);
        Style06 := Get_StyleExpression(6);
        Style07 := Get_StyleExpression(7);
        Style08 := Get_StyleExpression(8);
        Style09 := Get_StyleExpression(9);
        Style10 := Get_StyleExpression(10);
        Style11 := Get_StyleExpression(11);
        Style12 := Get_StyleExpression(12);
        Style13 := Get_StyleExpression(13);
        Style14 := Get_StyleExpression(14);
        Style15 := Get_StyleExpression(15);
        Style16 := Get_StyleExpression(16);
        Style17 := Get_StyleExpression(17);
        Style18 := Get_StyleExpression(18);
        Style19 := Get_StyleExpression(19);
        Style20 := Get_StyleExpression(20);
        Style21 := Get_StyleExpression(21);
        Style22 := Get_StyleExpression(22);
        Style23 := Get_StyleExpression(23);
        Style24 := Get_StyleExpression(24);
        Style25 := Get_StyleExpression(25);
        Style26 := Get_StyleExpression(26);
        Style27 := Get_StyleExpression(27);
        Style28 := Get_StyleExpression(28);
        Style29 := Get_StyleExpression(29);
        Style30 := Get_StyleExpression(30);
        Style31 := Get_StyleExpression(31);
        Style32 := Get_StyleExpression(32);
    end;

    procedure Get_StyleExpression(in_Up: Integer) Result: Text[50]
    var
        i: Integer;
    begin
        if Rec."No. of Ups" <> in_Up then
            exit('None');

        i := (Rec."Sheet ID" MOD 8);

        // TODO
        // Use Generic Function

        case i of
            0:
                Result := 'StrongAccent';
            1:
                Result := 'Attention';
            2:
                Result := 'AttentionAccent';
            3:
                Result := 'Favorable';
            4:
                Result := 'Unfavorable';
            5:
                Result := 'Ambiguous';
            6:
                Result := 'Subordinate';
            7:
                Result := 'None';
        end;
    end;

    procedure Select_PlateChange(in_Up: Integer)
    var
        PlateChangeRec: Record "PVS Job Item Plate Changes";
    begin
        if in_Up > Get_Max_Up() then
            exit;

        PlateChangeRec.SetCurrentkey(ID);
        PlateChangeRec.SetRange(ID, Rec.ID);
        PlateChangeRec.SetRange(Job, Rec.Job);
        PlateChangeRec.SetRange(Version, Rec.Version);
        PlateChangeRec.SetRange("Job Item No.", Rec."Job Item No.");

        if Page.RunModal(page::"PVS Job Item Plate Changes", PlateChangeRec) <> Action::LookupOK then
            exit;

        Rec."Sheet ID" := PlateChangeRec."Change No.";
        Rec.Validate(Rec."No. of Ups", in_Up);

        Rec.Get(Rec.ID, Rec.Job, Rec.Version, Rec."Job Item No.", Rec."Variant Entry No.");

        Set_StyleExpression();
        CurrPage.Update(false);

        OnAfterSelectPlateChange(PlateChangeRec);
    end;

    procedure Get_UP(in_Up: Integer) Result: Text[1024]
    var
        Loc_UP: Decimal;
    begin
        if in_Up > Get_Max_Up() then
            exit;

        Loc_UP := Rec.Quantity / in_Up;

        Result := PVS.Format_Decimal(Loc_UP, 0);
    end;

    procedure Get_Max_Up() Result: Integer
    var
        ImpositionRec: record "PVS Imposition Code";
        VariantRec: Record "PVS Job Item Variant";
        Forms: Integer;
        Sets: Decimal;
    begin
        if Global_MaxUp > 0 then
            exit(Global_MaxUp);

        VariantRec.SetRange(ID, Global_JobItemRec.ID);
        VariantRec.SetRange(Job, Global_JobItemRec.Job);
        VariantRec.SetRange(Version, Global_JobItemRec.Version);
        VariantRec.SetRange("Job Item No.", Global_JobItemRec."Job Item No.");
        if VariantRec.FindLast() then
            Forms := VariantRec."Variant Forms";

        Forms := Forms + 1;

        if Global_JobItemRec."Pages In Sheet" <> 0 then
            Sets := Global_JobItemRec."Pages With Print" / Global_JobItemRec."Pages In Sheet"
        else
            Sets := 1;

        Result := ROUND(Global_JobItemRec.JobItems_On_Sheet() * Forms / ROUND(Sets, 1, '>'), 1, '>');


        // Double, tripple, .. production
        if (Global_JobItemRec."Imposition Type" <> '') then
            if ImpositionRec.Get(Global_JobItemRec."Imposition Type") then begin
                if ImpositionRec."Double Production" then
                    if ImpositionRec.Production = 0 then
                        ImpositionRec.Production := 2;
                if ImpositionRec.Production > 1 then
                    if ((Global_JobItemRec."Pages With Print" * ImpositionRec.Production) > Global_JobItemRec."Pages In Sheet") then begin
                        Sets := Sets * ImpositionRec.Production;
                        Sets := ROUND(Sets, 1, '>');

                        Result := ROUND(Global_JobItemRec.JobItems_On_Sheet() * ImpositionRec.Production * Forms / Sets, 1, '>');
                    end;
            end;

        Global_MaxUp := Result;

    end;

    procedure Get_Variant_Code(): Text
    begin
        if Number_of_Forms = 0 then
            Number_of_Forms := Rec.Get_Number_of_Forms();

        if Number_of_Forms < 2 then
            exit(Rec."Variant Code")
        else
            exit(StrSubstNo('%1 (%2)', Rec."Variant Code", Rec."Variant Forms" + 1));
    end;

    /// <summary>
    /// This event is triggered in function " Select_PlateChange " in the Page "PVS Job Item Combined Variants" – Its called at the end of the function after the PageUpdate if the user has successfully Closed the LookUp
    /// </summary>
    /// <param name="Rec">The current PVS Job Item Plate Change Record</param>

    [IntegrationEvent(false, false)]
    procedure OnAfterSelectPlateChange(var JobItemPlateChanges: Record "PVS Job Item Plate Changes")
    begin
    end;

}