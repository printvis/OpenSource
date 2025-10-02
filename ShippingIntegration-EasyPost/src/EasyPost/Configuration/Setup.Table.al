namespace PrintVis.OpenSource.EasyPost.Setup;

using PrintVis.OpenSource.EasyPost;

table 80134 "SIEP Setup"
{
    Caption = 'EasyPost Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            Caption = 'Primary Key';
        }
        field(2; Enabled; Boolean)
        {
            Caption = 'Enabled';
        }
        field(5; "Server Url"; Text[300])
        {
            Caption = 'Server Url';
        }
        field(6; "Authentication Server Url"; Text[300])
        {
            Caption = 'Authentication Server Url';
        }
        field(30; "Api Key ID"; Guid)
        {
            Caption = 'Api Key ID';
        }
        field(40; "Label Type"; Enum "PVS Label Type")
        {
            Caption = 'Label Type';
        }
        field(45; "Label Size"; Enum "SIEP Label Size")
        {
            Caption = 'Label Size';
        }
        field(50; "Shipment Tracking Url"; Text[250])
        {
            Caption = 'Tracking Url';
        }
        field(51; "Package Tracking Url"; Text[250])
        {
            Caption = 'Package Tracking Url';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure Initialize()
    begin
        if not this.Get() then begin
            this.Init();
            this."Api Key ID" := CreateGuid();
            this.Insert();
        end;
    end;

    procedure IsEnabled(): Boolean
    begin
        if this.Get() and Enabled then
            exit(true);
    end;

    procedure ApiKeyIsSet(): Boolean
    begin
        exit(IsolatedStorage.Contains("Api Key ID", this.GetApiKeyDataScope()))
    end;

    internal procedure GetApiKey() ApiKeyAsSecretText: SecretText
    var
        ApiKeyIsNotSetErr: Label 'API Key is not set!';
    begin
        if not this.ApiKeyIsSet() then
            Error(ApiKeyIsNotSetErr);

        IsolatedStorage.Get("Api Key ID", this.GetApiKeyDataScope(), ApiKeyAsSecretText);
    end;

    internal procedure SaveApiKey(in_NewApiKey: SecretText): Boolean
    begin
        if IsNullGuid("Api Key ID") then begin
            "Api Key ID" := CreateGuid();
            this.Modify();
        end;

        exit(IsolatedStorage.Set("Api Key ID", in_NewApiKey, this.GetApiKeyDataScope()));
    end;

    local procedure GetApiKeyDataScope(): DataScope
    begin
        exit(DataScope::Company);
    end;
}