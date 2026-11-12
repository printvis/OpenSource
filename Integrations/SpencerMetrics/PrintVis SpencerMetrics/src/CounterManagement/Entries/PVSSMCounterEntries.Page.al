namespace PrintVis.SpencerMetrics.CounterManagement;

using PrintVis.SpencerMetrics.Configuration;

page 80294 "PVS SM Counter Entries"
{
    ApplicationArea = All;
    Caption = 'SpencerMetrics Counter Entries';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "PVS SM Counter Entry";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(repeater)
            {
                field("Cost Center Code"; Rec."Cost Center Code") { }
                field("Entry No."; Rec."Entry No.") { }
                field("Current Count"; Rec."Current Count") { }
                field("Difference Count"; Rec."Difference Count") { }
                field("Current Time"; Rec."Current Time") { }
                field("Device Status"; Rec."Device Status") { }
                field(Speed; Rec.Speed) { }
                field("Include In Job Costing"; Rec."Include In Job Costing") { }
                field("Case ID"; Rec."Case ID") { }
                field("Plan ID"; Rec."Plan ID") { }
                field(UOM; Rec.UOM) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Cost Center Setup")
            {
                Caption = 'Cost Center Setup';
                Image = Setup;
                RunObject = page "PVS SM Cost Center Setup";
                ToolTip = 'Opens the setup page for SpencerMetrics';
            }
            action(Assign)
            {
                Caption = 'Assign to Job Costing';
                Image = Link;
                ToolTip = 'Allows the user to assign SpencerMetrics counts to job costing entries that were missed during shop floor recording';

                trigger OnAction()
                var
                    ConnectPage: Page "PVS SM Assign To Job Costing";
                    ErrorLbl: Label 'Only count entries that have not already been included in a job costing entry can be assigned';
                begin
                    Rec.TestField("Entry No.");
                    Rec.TestField("Cost Center Code");
                    Rec.TestField("Difference Count");
                    if Rec."Include In Job Costing" then
                        Error(ErrorLbl);

                    ConnectPage.SetContext(Rec);
                    ConnectPage.RunModal();
                end;
            }
        }
        area(Navigation)
        {
            action(XMLContent)
            {
                Caption = 'XML Content';
                Image = XMLFile;
                ToolTip = 'Displays the XML content of the counter entry';

                trigger OnAction()
                var
                    XmlContentNotFoundLbl: Label 'No XML content found';
                    XMLContent: Text;
                begin
                    XMLContent := Rec.GetXMLContent();
                    if (XMLContent = '') then
                        Message(XmlContentNotFoundLbl)
                    else
                        Message(XMLContent);
                end;
            }
        }
        area(Promoted)
        {
            actionref(AssignPromoted; Assign) { }
            actionref(XMLContentPromoted; XMLContent) { }
        }
    }
}