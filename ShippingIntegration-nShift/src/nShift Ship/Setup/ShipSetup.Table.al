namespace PrintVis.OpenSource.NShift.Ship.Setup;

table 80154 "SINS Ship Setup"
{
    Caption = 'nShift Ship Setup';
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
        field(15; "Actor ID"; Integer)
        {
            BlankZero = true;
            Caption = 'Actor ID';
            MinValue = 0;
        }
        field(25; "Client ID"; Text[100])
        {
            Caption = 'Client ID';
        }
        field(26; "Client Secret ID"; Guid)
        {
            Caption = 'Client Secret ID';
        }
        field(40; "Label Type"; Enum "PVS Label Type")
        {
            Caption = 'Label Type';
        }
        field(50; "Shipment Tracking Url"; Text[250])
        {
            Caption = 'Tracking Url';
        }
        field(51; "Package Tracking Url"; Text[250])
        {
            Caption = 'Package Tracking Url';
        }
        field(60; "Enable Price Calculation"; Boolean)
        {
            Caption = 'Price Calculation';
        }
        field(100; "Access Token ID"; Guid)
        {
            Caption = 'Access Token ID';
        }
        field(101; "Access Token Due DateTime"; DateTime)
        {
            Caption = 'Access Token Due DateTime';
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
            "Client Secret ID" := CreateGuid();
            this.Insert();
        end;
    end;

    internal procedure SaveClientSecret(in_NewClientSecret: SecretText): Boolean
    begin
        if IsNullGuid("Client Secret ID") then begin
            "Client Secret ID" := CreateGuid();
            this.Modify();
        end;

        exit(IsolatedStorage.Set("Client Secret ID", in_NewClientSecret, this.GetClientSecretDataScope()));
    end;

    internal procedure GetClientSecret() ClientSecretAsSecretText: SecretText
    var
        ClientSecretIsNotSetErr: Label 'Client Secret is not set!';
    begin
        if not this.ClientSecretIsSet() then
            Error(ClientSecretIsNotSetErr);

        IsolatedStorage.Get("Client Secret ID", this.GetClientSecretDataScope(), ClientSecretAsSecretText);
    end;

    procedure ClientSecretIsSet(): Boolean
    begin
        exit(IsolatedStorage.Contains("Client Secret ID", this.GetClientSecretDataScope()))
    end;

    local procedure GetClientSecretDataScope(): DataScope
    begin
        exit(DataScope::Company);
    end;

    internal procedure ClearAccessToken()
    var
        EmptyToken: SecretText;
    begin
        this.SaveAccessToken(EmptyToken, 0DT);
    end;

    internal procedure SaveAccessToken(in_NewToken: SecretText; in_NewTokenDueDateTime: DateTime)
    begin
        if IsNullGuid("Access Token ID") then begin
            "Access Token ID" := CreateGuid();
            this.Modify();
        end;

        this.SaveAccessToken(in_NewToken);

        "Access Token Due DateTime" := in_NewTokenDueDateTime;
        this.Modify();
    end;

    local procedure SaveAccessToken(in_NewAccessToken: SecretText)
    begin
        IsolatedStorage.Set("Access Token ID", in_NewAccessToken, AccessTokenDataScope());
    end;

    internal procedure GetAccessToken() AccessTokenAsSecretText: SecretText
    var
    begin
        IsolatedStorage.Get("Access Token ID", AccessTokenDataScope(), AccessTokenAsSecretText);
    end;

    local procedure AccessTokenDataScope(): DataScope
    begin
        exit(DataScope::Company);
    end;

    internal procedure AccessTokenIsValid(): Boolean
    begin
        exit(CurrentDateTime < "Access Token Due DateTime");
    end;

    procedure IsEnabled(): Boolean
    begin
        if this.Get() and Enabled then
            exit(true);
        exit(false);
    end;

    var
        RecordHasBeenRead: Boolean;
}