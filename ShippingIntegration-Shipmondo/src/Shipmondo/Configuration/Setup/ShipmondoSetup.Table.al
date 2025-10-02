namespace PrintVis.OpenSource.Shipmondo.Configuration;

table 80184 "SISM Setup"
{
    Caption = 'Shipmondo Setup';
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
        field(30; Username; Text[100])
        {
            Caption = 'Username';
        }
        field(31; "Password ID"; Guid)
        {
            Caption = 'Password ID';
        }
        field(40; "Test Mode"; Boolean)
        {
            Caption = 'Test Mode';
        }
        field(50; "Label Format"; Enum "SISM Label Format")
        {
            Caption = 'Label Format';
        }
        field(51; "Scale By"; Enum "SISM Label Scale By")
        {
            Caption = 'Scale By';
        }
        field(52; "Scale Size"; Integer)
        {
            Caption = 'Scale Size';
        }
        field(60; "Shipment Tracking Url"; Text[250])
        {
            Caption = 'Shipment Tracking Url';
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
            this."Server Url" := 'https://app.shipmondo.com/api/public/v3';
            this."Label Format" := Enum::"SISM Label Format"::"10x19_pdf";
            this."Scale By" := Enum::"SISM Label Scale By"::"Not Set";
            this."Scale Size" := 0;
            this."Shipment Tracking Url" := 'https://track.shipmondo.com';
            this."Password ID" := CreateGuid();
            this.Insert();
        end;
    end;

    procedure SavePassword(NewPassword: SecretText): Boolean
    var
        PasswordEmptyErr: Label 'Password cannot be empty';
    begin
        if NewPassword.IsEmpty() then
            Error(PasswordEmptyErr);

        if IsNullGuid(this."Password ID") then begin
            this."Password ID" := CreateGuid();
            this.Modify();
        end;

        exit(IsolatedStorage.Set("Password ID", NewPassword, this.GetPasswordDataScope()))
    end;

    procedure GetPassword() PasswordAsSecretText: SecretText
    var
        PasswordIsNotSetErr: Label 'Password is not set';
    begin
        if not this.PasswordIsSet() then
            Error(PasswordIsNotSetErr);

        IsolatedStorage.Get("Password ID", this.GetPasswordDataScope(), PasswordAsSecretText);
    end;

    procedure PasswordIsSet(): Boolean
    begin
        exit(IsolatedStorage.Contains("Password ID", this.GetPasswordDataScope()));
    end;

    local procedure GetPasswordDataScope(): DataScope
    begin
        exit(DataScope::Company);
    end;
}