tableextension 80500 "PTE Sorting Buffer" extends "PVS Sorting Buffer"
{
    fields
    {
        field(50100; "PTE Comment Rich Text SystemID"; Guid)
        { }
        field(50101; "PTE Comment Found"; Boolean)
        { }
        field(50102; "PTE Department Name"; Text[30])
        { }
    }

    procedure PTEGetRichText() TextValue: Text
    var
        JobTextDescriptionRec: Record "PVS Job Text Description";
    begin
        if not "PTE Comment Found" then
            exit;
        if not JobTextDescriptionRec.GetBySystemId(Rec."PTE Comment Rich Text SystemID") then
            exit;
        TextValue := JobTextDescriptionRec.GetRichText();
    end;
}