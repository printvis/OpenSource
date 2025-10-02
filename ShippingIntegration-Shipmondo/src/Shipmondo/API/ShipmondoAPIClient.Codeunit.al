namespace PrintVis.OpenSource.Shipmondo.API;

using System.Text;
using PrintVis.OpenSource.Shipmondo.Configuration;

codeunit 80187 "SISM API Client"
{
    procedure RequestCreateShipmentQuote(in_JsonBody: Text; var out_HttpResponseMessage: HttpResponseMessage): Boolean
    begin
        exit(this.SendRequest('POST', 'quotes', in_JsonBody, out_HttpResponseMessage));
    end;

    procedure RequestCreateShipment(in_JsonBody: Text; var out_HttpResponseMessage: HttpResponseMessage): Boolean
    begin
        exit(this.SendRequest('POST', 'shipments', in_JsonBody, out_HttpResponseMessage));
    end;

    procedure RequestRetrieveLabels(in_ShipmentId: Text;
        in_LabelFormat: Enum "SISM Label Format";
        in_ScaleBy: Enum "SISM Label Scale By";
        in_ScaleSize: Integer;
        var out_HttpResponseMessage: HttpResponseMessage): Boolean
    var
        Index: Integer;
        LabelFormatName, QueryParameters, ScaleByName : Text;
    begin
        Index := in_LabelFormat.Ordinals().IndexOf(in_LabelFormat.AsInteger());
        in_LabelFormat.Names().Get(Index, LabelFormatName);
        QueryParameters := StrSubstNo('label_format=%1', LabelFormatName);

        Index := in_ScaleBy.Ordinals().IndexOf(in_ScaleBy.AsInteger());
        in_ScaleBy.Names().Get(Index, ScaleByName);
        QueryParameters += StrSubstNo('&scale_by=%1', ScaleByName);

        if (in_ScaleSize > 0) then
            QueryParameters += StrSubstNo('&scale_size=%1', in_ScaleSize);
        QueryParameters := StrSubstNo('?%1', QueryParameters);

        exit(this.SendRequest('GET', StrSubstNo('shipments/%1/labels%2', in_ShipmentId, QueryParameters), '', out_HttpResponseMessage));
    end;

    procedure RequestCancelShipment(in_ShipmentId: Text; var out_HttpResponseMessage: HttpResponseMessage): Boolean
    begin
        exit(this.SendRequest('PUT', StrSubstNo('shipments/%1/cancel', in_ShipmentId), '', out_HttpResponseMessage));
    end;

    procedure RequestCreatePrintJob(in_JsonBody: Text; var out_HttpResponseMessage: HttpResponseMessage): Boolean
    begin
        exit(this.SendRequest('POST', 'print_jobs', in_JsonBody, out_HttpResponseMessage));
    end;

    procedure RequestPrintJob(in_JsonBody: Text; var out_HttpResponseMessage: HttpResponseMessage): Boolean
    begin
        exit(this.SendRequest('POST', 'print_jobs', in_JsonBody, out_HttpResponseMessage));
    end;

    procedure RequestGetPrinters(var out_HttpResponseMessage: HttpResponseMessage): Boolean
    begin
        exit(this.SendRequest('GET', 'printers', '', out_HttpResponseMessage));
    end;

    procedure RequestGetPickupPoints(in_ServiceCode: Text; in_CountryCode: Code[10]; in_PostCode: Code[20]; in_Address: Text; var out_HttpResponseMessage: HttpResponseMessage): Boolean
    var
        QueryParameters: Text;
    begin
        QueryParameters := StrSubstNo('?carrier_code=%1&country_code=%2&zipcode=%3',
            in_ServiceCode,
            in_CountryCode,
            in_PostCode);

        if (in_Address <> '') then
            QueryParameters += StrSubstNo('&address=%1', in_Address);

        exit(this.SendRequest('GET', StrSubstNo('pickup_points%1', QueryParameters), '', out_HttpResponseMessage));
    end;

    local procedure SendRequest(in_Method: Text; in_Resource: Text; in_Body: Text; var out_HttpResponseMessage: HttpResponseMessage): Boolean
    var
        Setup: Record "SISM Setup";
        Client: HttpClient;
        Content: HttpContent;
        ContentHeader: HttpHeaders;
        HttpRequestMessage: HttpRequestMessage;
        RequestUrl: Text;
    begin
        Setup.Get();
        Setup.TestField("Server Url");

        RequestUrl := this.GetRequestUrl(Setup, in_Resource);

        if in_Body <> '' then begin
            Content.WriteFrom(in_Body);
            Content.GetHeaders(ContentHeader);
            ContentHeader.Clear();
            ContentHeader.Add('Content-Type', 'application/json');
            HttpRequestMessage.Content := Content;
        end;

        HttpRequestMessage.Method(in_Method);
        HttpRequestMessage.SetRequestUri(RequestUrl);

        this.AddAuthHeader(Client);

        exit(Client.Send(HttpRequestMessage, out_HttpResponseMessage));
    end;

    procedure AddAuthHeader(var out_HttpClient: HttpClient)
    begin
        this.AddBaseAuthHeader(out_HttpClient);
    end;

    local procedure AddBaseAuthHeader(var out_HttpClient: HttpClient)
    var
        Setup: Record "SISM Setup";
        Convert: Codeunit "Base64 Convert";
        AuthString: SecretText;
    begin
        Setup.Get();

        AuthString := SecretText.SecretStrSubstNo('Basic %1', Convert.ToBase64(SecretText.SecretStrSubstNo('%1:%2', Setup.Username, Setup.GetPassword())));

        out_HttpClient.DefaultRequestHeaders().Add('Authorization', AuthString);
    end;

    local procedure GetRequestUrl(in_Setup: Record "SISM Setup"; in_Resource: Text): Text
    begin
        exit(StrSubstNo('%1/%2', in_Setup."Server Url", in_Resource));
    end;
}