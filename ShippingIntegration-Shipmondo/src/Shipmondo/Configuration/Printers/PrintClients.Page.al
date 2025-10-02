page 80186 "SISM Print Clients"
{
    ApplicationArea = All;
    Caption = 'Print Clients';
    PageType = List;
    SourceTable = "SISM Print Client";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Printers)
            {
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the name of the warehouse printer';
                }
                field(Hostname; Rec.Hostname)
                {
                    ToolTip = 'Specifies the hostname of the computer where the printer is connected';
                }
                field(Printer; Rec.Printer)
                {
                    ToolTip = 'Specifies the printer model';
                }
                field("Label Format"; Rec."Label Format")
                {
                    ToolTip = 'Specifies the format of labels used by this printer';
                }
                field("Default Printer"; Rec."Default Printer")
                {
                    ToolTip = 'Specifies if this is the default printer';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GetPrinters)
            {
                Caption = 'Get Printers';
                Image = Import;

                trigger OnAction()
                var
                    ShipmondoMgt: Codeunit "SISM Implementation";
                    PrinterImportedMsg: Label 'Printers imported successfully';
                begin
                    if ShipmondoMgt.GetPrinters() then
                        Message(PrinterImportedMsg);
                end;
            }
        }
        area(Promoted)
        {
            actionref(GetPrinters_Promoted; GetPrinters) { }
        }
    }
}
