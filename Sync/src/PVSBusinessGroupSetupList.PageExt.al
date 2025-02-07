Pageextension 80200 "PVS Business Group Setup List" extends "PVS Business Group Setup List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addfirst(Processing)
        {
            action("PVS VerifyConnection")
            {
                ApplicationArea = All;
                Caption = 'Verify Connection';
                Image = ValidateEmailLoggingSetup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Verify Connection';

                trigger OnAction()
                var
                    SyncCommunicationMgt: Codeunit "PVS Sync Communication Mgt";
                    SyncOAuthCommMgt: Codeunit "PVS Sync OAuth Comm. Mgt.";
                    ConnectionVerified: label 'Connection Verified';
                begin
                    if Rec."PVS Enable OAuth2" then begin
                        if SyncOAuthCommMgt.GetAccessToken(Rec) then
                            Message(ConnectionVerified);
                    end else
                        if SyncCommunicationMgt.CheckApi(Rec) then
                            Message(ConnectionVerified);
                end;
            }
        }
    }

}
