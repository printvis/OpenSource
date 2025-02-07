tableextension 80501 "PTE Job Ticket 2 Rich Text" extends "PVS Job Ticket Temp"
{
    fields
    {
        field(50100; "PTE Comment Rich Text SystemID"; Guid)
        { }
        field(50101; "PTE Comment Found"; Boolean)
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