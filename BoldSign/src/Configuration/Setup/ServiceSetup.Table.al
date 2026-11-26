namespace PrintVis.BoldSign.Configuration;

table 80301 "PVS BS Service Setup"
{
    Caption = 'BoldSign Service Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary key"; Code[20])
        {
            Caption = 'Primary key';
        }
        field(2; Enabled; Boolean)
        {
            Caption = 'Enabled';
            ToolTip = 'Specifies if the BoldSign service is enabled.';
        }
        field(10; "Service Endpoint"; Text[250])
        {
            Caption = 'Service Endpoint';
            ToolTip = 'Specifies the BoldSign API base URL, including its API version.';

            trigger OnValidate()
            begin
                if (Rec."Service Endpoint" <> '') then
                    if Rec."Service Endpoint"[StrLen(Rec."Service Endpoint")] <> '/' then
                        Rec."Service Endpoint" := Rec."Service Endpoint" + '/';
            end;
        }
        field(11; "API Key ID"; Guid)
        {
            Caption = 'API Key ID';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(60; "Document Exp. DateFormula"; DateFormula)
        {
            Caption = 'Document Expiration Date';
            ToolTip = 'Specifies the expiration period for signing documents using a date formula (e.g. 1D = 1 day, 30D = 30 days). Leave blank for no expiration.';
        }
    }

    keys
    {
        key(Key1; "Primary key")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        Rec."API Key ID" := CreateGuid();
    end;

    internal procedure Initialize(): Boolean
    begin
        if Rec.Get() then
            exit(false);

        Clear(Rec);
        Rec.Validate("Service Endpoint", this.ServiceEndpointTok);
        Rec.Insert();
        exit(true);
    end;

    procedure IsEnabled(): Boolean
    begin
        if this.Get() and this.Enabled then
            exit(true);
    end;

    internal procedure GetServiceEndpoint(): Text
    var
        ServiceEndpoint: Text;
    begin
        ServiceEndpoint := Rec."Service Endpoint";
        if (ServiceEndpoint.EndsWith('/')) then
            ServiceEndpoint := CopyStr(ServiceEndpoint, 1, StrLen(ServiceEndpoint) - 1);

        exit(ServiceEndpoint);
    end;

    [NonDebuggable]
    internal procedure SaveApiKey(NewApiKey: SecretText)
    begin
        IsolatedStorage.Set(Rec."API Key ID", NewApiKey, DataScope::Company);
    end;

    [NonDebuggable]
    internal procedure GetApiKey() ApiKey: SecretText
    begin
        IsolatedStorage.Get(Rec."API Key ID", DataScope::Company, ApiKey);
    end;

    [NonDebuggable]
    internal procedure HasApiKey(): Boolean
    begin
        exit(IsolatedStorage.Contains(Rec."API Key ID", DataScope::Company));
    end;

    var
        ServiceEndpointTok: Label 'https://api.boldsign.com/v1', Locked = true;
}
