Pageextension 80201 "PVS Business Group Setup" extends "PVS Business Group Setup"
{
    layout
    {
        addafter(API)
        {
            group(OAuth)
            {
                Caption = 'OAuth';

                field("PVS Enable OAuth2"; Rec."PVS Enable OAuth2")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Rec."API Server FQDN" := 'api.businesscentral.dynamics.com';
                        Rec."API Server Uses SSL" := true;
                        Rec."PVS Redirect Url" := 'https://businesscentral.dynamics.com/OAuthLanding.htm';
                        Rec.Modify();
                    end;
                }
                field("PVS Client Id"; Rec."PVS Client Id")
                {
                    ApplicationArea = All;
                }
                field("PVS Client Secret"; ClientSecretTxt)
                {
                    Caption = 'Client Secret';
                    ApplicationArea = All;
                    Editable = false;
                    ExtendedDatatype = Masked;

                    trigger OnAssistEdit()
                    var
                        PasswordDialogMgt: Codeunit "Password Dialog Management";
                    begin
                        Rec.SetClientSecret(PasswordDialogMgt.OpenPasswordDialog(true, true));
                        CurrPage.Update(false);
                    end;
                }
                field("PVS Redirect Url"; Rec."PVS Redirect Url")
                {
                    ApplicationArea = All;
                }
                field("PVS Authorization Endpoint"; Rec."PVS Authorization Endpoint")
                {
                    ApplicationArea = All;
                }
                field("PVS Tenant Id"; Rec."PVS Tenant Id")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("PVS Token Acquired"; Rec."PVS Token Acquired")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("PVS OAuth Error Message"; Rec."PVS OAuth Error Message")
                {
                    ApplicationArea = All;
                }
            }
        }
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
            action("PVS Copy API")
            {
                ApplicationArea = All;
                Caption = 'Copy API Settings From Master Company';
                Image = CopyDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Copy API Settings From Master Company';

                trigger OnAction()
                begin
                    CopyApiSettings();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec.HasClientSecret() then
            ClientSecretTxt := Rec.GetClientSecret();
    end;

    var
        ClientSecretTxt: Text;

    procedure CopyApiSettings()
    var
        PVSBusinessGroup: Record "PVS Business Group";
        DataExistsLbl: label 'Settings exists on the Business Group, would you like to continue and overwrite?';
        InStr: InStream;
        OutStr: OutStream;
    begin
        if Rec."API Server FQDN" <> '' then
            if not Confirm(DataExistsLbl) then
                exit;
        PVSBusinessGroup.SetRange("Master Company", true);
        if not PVSBusinessGroup.FindFirst() then
            exit;
        Rec.Validate("API Password Key", PVSBusinessGroup."API Password Key");
        Rec.Validate("API Server FQDN", PVSBusinessGroup."API Server FQDN");
        Rec.Validate("API Server Instance", PVSBusinessGroup."API Server Instance");
        Rec.Validate("API Server Port", PVSBusinessGroup."API Server Port");
        Rec.Validate("API Server Uses SSL", PVSBusinessGroup."API Server Uses SSL");
        Rec.Validate("API Tenant", PVSBusinessGroup."API Tenant");
        Rec.Validate("API Service Name", PVSBusinessGroup."API Service Name");

        //OAuth part
        Rec.Validate("PVS Enable OAuth2", PVSBusinessGroup."PVS Enable OAuth2");
        Rec.Validate("PVS Client Id", PVSBusinessGroup."PVS Client Id");
        Rec.Validate("PVS Client Secret", PVSBusinessGroup."PVS Client Secret");
        Rec.Validate("PVS Redirect Url", PVSBusinessGroup."PVS Redirect Url");
        Rec.Validate("PVS Authorization Endpoint", PVSBusinessGroup."PVS Authorization Endpoint");
        Rec.Validate("PVS Tenant Id", PVSBusinessGroup."PVS Tenant Id");
        Rec.Validate("PVS Token Acquired", PVSBusinessGroup."PVS Token Acquired");
        if PVSBusinessGroup."PVS Access Token".HasValue() then begin
            PVSBusinessGroup.CalcFields("PVS Access Token");
            PVSBusinessGroup."PVS Access Token".CreateInStream(InStr);
            Rec."PVS Access Token".CreateOutStream(OutStr);
            CopyStream(OutStr, InStr);
            Rec.Validate("API Connection Verified", true);
        end;
        Rec.Modify();
    end;
}
