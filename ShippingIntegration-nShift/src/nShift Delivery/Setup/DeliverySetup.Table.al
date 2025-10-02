namespace PrintVis.OpenSource.NShift.Delivery.Setup;

table 80155 "SINS Delivery Setup"
{
    Caption = 'nShift Delivery Setup';
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
        field(20; "User Name"; Text[50])
        {
            Caption = 'User Name';
        }
        field(30; "Api Key ID"; Guid)
        {
            Caption = 'Api Key ID';
        }
        field(50; "Shipment Tracking Url"; Text[250])
        {
            Caption = 'Tracking Url';
            ToolTip = 'Specifies the URL to the Online tracking page. %1 will be replaced with the language code, %2 with the user name and %3 with the shipment number.';
        }
        field(55; "Language Code"; Enum "SINS Language Code")
        {
            Caption = 'Language Code';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure ApiKeyIsSet(): Boolean
    begin
        exit(IsolatedStorage.Contains("Api Key ID", GetApiKeyDataScope()))
    end;

    internal procedure GetApiKey() ApiKeyAsSecretText: SecretText
    var
        ApiKeyIsNotSetErr: Label 'API Key is not set!';
    begin
        if not ApiKeyIsSet() then
            Error(ApiKeyIsNotSetErr);

        IsolatedStorage.Get("Api Key ID", GetApiKeyDataScope(), ApiKeyAsSecretText);
    end;

    internal procedure SaveApiKey(in_NewApiKey: SecretText): Boolean
    begin
        if IsNullGuid("Api Key ID") then begin
            "Api Key ID" := CreateGuid();
            Modify();
        end;

        exit(IsolatedStorage.Set("Api Key ID", in_NewApiKey, GetApiKeyDataScope()));
    end;

    local procedure GetApiKeyDataScope(): DataScope
    begin
        exit(DataScope::Company);
    end;

    procedure Initialize()
    begin
        if not this.Get() then begin
            this.Init();
            "Api Key ID" := CreateGuid();
            this.Insert();
        end;
    end;

    procedure IsEnabled(): Boolean
    begin
        exit(this.Get() and this.Enabled);
    end;
}