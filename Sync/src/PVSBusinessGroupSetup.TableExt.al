Tableextension 80200 "PVS Business Group Setup" extends "PVS Business Group"
{
    fields
    {
        field(75515; "PVS Client Id"; Text[100])
        {
            Caption = 'Application (client) ID';
            DataClassification = CustomerContent;
        }
        field(75516; "PVS Client Secret"; Guid)
        {
            Caption = 'Client Secret';
            DataClassification = CustomerContent;
        }
        field(75517; "PVS Redirect Url"; Text[250])
        {
            Caption = 'Redirect URI';
            DataClassification = CustomerContent;
        }
        field(75518; "PVS Authorization Endpoint"; Text[250])
        {
            Caption = 'Authorization Endpoint';
            DataClassification = CustomerContent;
        }
        field(75519; "PVS Tenant Id"; Text[50])
        {
            Caption = 'Directory (tenant) ID';
            DataClassification = CustomerContent;
        }
        field(75520; "PVS Enable OAuth2"; Boolean)
        {
            Caption = 'Enable OAuth2';
            DataClassification = CustomerContent;
        }
        field(75521; "PVS Token Acquired"; Boolean)
        {
            Caption = 'Token Acquired';
            DataClassification = CustomerContent;
        }
        field(75522; "PVS Access Token"; GUID)
        {
            Caption = 'Access Token';
            DataClassification = CustomerContent;
        }
        field(75523; "PVS OAuth Error Message"; Text[250])
        {
            Caption = 'Error Message';
            DataClassification = CustomerContent;
        }
        field(75524; "PVS Access Token Key"; GUID)
        {
            Caption = 'Access Token Key';
            DataClassification = CustomerContent;
        }
    }


    procedure SetClientSecret(ClientSecret: Text)
    begin
        if IsNullGuid(Rec."PVS Client Secret") then
            Rec."PVS Client Secret" := CreateGuid();
        if IsolatedStorage.Contains(Rec."PVS Client Secret") then
            IsolatedStorage.Delete(Rec."PVS Client Secret");
        if ClientSecret = '' then exit;
        if EncryptionEnabled() then
            IsolatedStorage.SetEncrypted(Rec."PVS Client Secret", ClientSecret)
        else
            IsolatedStorage.Set(Rec."PVS Client Secret", ClientSecret);
        Rec.Modify();
    end;

    procedure SetClientSecret(ClientSecret: SecretText)
    begin
        if IsNullGuid(Rec."PVS Client Secret") then
            Rec."PVS Client Secret" := CreateGuid();
        if IsolatedStorage.Contains(Rec."PVS Client Secret") then
            IsolatedStorage.Delete(Rec."PVS Client Secret");
        if ClientSecret.IsEmpty() then exit;
        if EncryptionEnabled() then
            IsolatedStorage.SetEncrypted(Rec."PVS Client Secret", ClientSecret)
        else
            IsolatedStorage.Set(Rec."PVS Client Secret", ClientSecret);
        Rec.Modify();
    end;

    procedure GetClientSecret() Client_Secret: SecretText
    begin
        if IsNullGuid(Rec."PVS Client Secret") then
            exit;
        if IsolatedStorage.Contains(Rec."PVS Client Secret") then
            IsolatedStorage.Get(Rec."PVS Client Secret", Client_Secret)
    end;

    procedure HasClientSecret(): Boolean
    begin
        if not IsNullGuid(Rec."PVS Client Secret") then
            exit(IsolatedStorage.Contains(Rec."PVS Client Secret"));
    end;

    procedure SetAccessToken(AccessToken: SecretText)
    var
        BearerAccessToken: SecretText;
    begin
        if AccessToken.IsEmpty() then
            exit;
        if IsNullGuid(Rec."PVS Access Token Key") then
            Rec."PVS Access Token Key" := CreateGuid();
        IsolatedStorage.Set(Rec."PVS Access Token Key", AccessToken);
    end;


    procedure GetAccessToken() AccessToken: SecretText
    begin
        if not IsNullGuid(Rec."PVS Access Token Key") then
            if IsolatedStorage.Contains(Rec."PVS Access Token Key") then
                IsolatedStorage.Get(Rec."PVS Access Token Key", AccessToken);
    end;
}
