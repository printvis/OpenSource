pageextension 80198 "PTE Job Print Signatures" extends "PVS Job Print Signatures"
{
    actions
    {
        addafter(In)
        {
            action(Rebuild)
            {
                Caption = 'Rebuild signatures';
                ToolTip = 'Rebuild signatures';
                ApplicationArea = All;
                Image = Create;
                trigger OnAction()
                var
                    PVSJob: Record "PVS Job";
                    PVSJobSheet: Record "PVS Job Sheet";
                    PVSJobSignatures: Record "PVS Job Signatures";
                begin
                    if Rec.ID = 0 then
                        exit;
                    if not PVSJob.get(Rec.ID, Rec.Job, Rec.Version) then
                        exit;

                    PVSJobSheet.SetRange(ID, Rec.ID);
                    PVSJobSheet.SetRange(Job, Rec.Job);
                    PVSJobSheet.SetRange(Version, Rec.Version);
                    if PVSJobSheet.findset() then
                        repeat
                            PVSJobSignatures.Setrange("Sheet ID", PVSJobSheet."Sheet ID");
                            PVSJobSignatures.DeleteAll();
                        until PVSJobSheet.next() = 0;
                    if Rec.IsTemporary then
                        Rec.DeleteAll();
                    PVSJobSignatures.Build_Entries_From_Job(PVSJob.ID, PVSJob.Job, PVSJob.Version, Rec);
                    Rec.SetCurrentkey("Assembly Order");
                    if Rec.FindFirst() then;
                end;
            }

        }
        addlast(Promoted)
        {
            actionref(Rebuil_Promoted; Rebuild)
            {
            }
        }
    }
}
