namespace PrintVis.BoldSign.Utilities;

using System.Text;

page 80305 "PVS BS Document Preview"
{
    ApplicationArea = All;
    Caption = 'Document Preview';
    Extensible = false;
    PageType = Card;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                ShowCaption = false;
                usercontrol(PDFPreview; "PVS BS PDF Preview")
                {
                    trigger ControlAddinReady()
                    begin
                        CurrPage.PDFPreview.LoadPDF(this.ReportContentBase64);
                    end;
                }
            }
        }
    }

    var
        ReportContentBase64: Text;

    internal procedure SetDocumentContent(var DocumentInStream: InStream)
    var
        Base64Convert: Codeunit "Base64 Convert";
    begin
        this.ReportContentBase64 := Base64Convert.ToBase64(DocumentInStream);
    end;
}
