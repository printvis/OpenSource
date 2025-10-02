page 80187 "SISM Pickup Points"
{
    ApplicationArea = All;
    Caption = 'Pickup Points';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "SISM Pickup Point";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Points)
            {
                field(Number; Rec."Number") { }
                field(ID; Rec."ID") { }
                field("Company Name"; Rec."Company Name") { }
                field(Name; Rec."Name")
                {
                    Visible = false;
                }
                field(Address; Rec."Address") { }
                field(City; Rec."City") { }
                field("Post Code"; Rec."Post Code") { }
                field("Country Code"; Rec."Country Code") { }
                field(Latitude; Rec."Latitude")
                {
                    Visible = false;
                }
                field(Longitude; Rec."Longitude")
                {
                    Visible = false;
                }
                field(Distance; Rec."Distance")
                {
                    Visible = false;
                }
            }
        }
    }

    procedure Load(ServiceCode: Text; CountryCode: Code[10]; PostCode: Code[20]; Address: Text)
    var
        ShipmondoMgt: Codeunit "SISM Mgt";
    begin
        ShipmondoMgt.ActivateErrorHandlingFor(this.ErrorMessageMgt, this.ErrorMessageHandler, this.ErrorContextElement, Rec.RecordId());
        ShipmondoMgt.GetPickupPoints(ServiceCode, CountryCode, PostCode, Address, Rec, this.ErrorMessageMgt);
    end;

    var
        ErrorContextElement: Codeunit "Error Context Element";
        ErrorMessageHandler: Codeunit "Error Message Handler";
        ErrorMessageMgt: Codeunit "Error Message Management";
}
