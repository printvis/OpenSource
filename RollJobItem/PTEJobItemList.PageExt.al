pageextension 80100 "PTE Job Items ListPart Extend" extends "PVS Job Items ListPart"
{
    layout
    {
        addbefore(PaperWeight)
        {
            field("Roll Item No"; SheetRec."Roll Item No")
            {
                ApplicationArea = All;
                DrillDown = false;
                Editable = true;
                Lookup = true;
                QuickEntry = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    Roll_LookUp();
                end;

                trigger OnValidate()
                var
                    ItemRec: Record Item;
                begin
                    ItemRec.TestField(Blocked, false);
                    CurrPage.Update(true);
                end;
            }
        }
    }

    var
        SheetRec: Record "PVS Job Sheet";


    trigger OnAfterGetRecord()
    begin
        if SheetRec.Get(Rec."Sheet ID") then;
    end;

    procedure Roll_LookUp()
    var
        PageMgt: Codeunit "PVS Page Management";
        RollNo: Code[20];
    begin
        if not PageMgt.LookUp_JobItem_Paper_Item(Rec, RollNo) then
            exit;

        SheetRec."Roll Item No" := RollNo;
        SheetRec.Modify(true);
    end;
}