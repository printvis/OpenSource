controladdin "PVS BS PDF Utility"
{
    MaximumHeight = 1;
    MaximumWidth = 1;
    Scripts =
               'https://unpkg.com/pdf-lib@1.17.1/dist/pdf-lib.min.js',
               'src/Utilities/PDFUtility/Scripts/script.js';

    event ControlAddinReady();
    event MergeComplete(MergedPdfContent: Text);
    event MergeError(ErrorMessage: Text);
    event PageCountReady(PageCount: Integer);
    event SignatureBoxReady(PdfContent: Text);

    procedure MergePDFs(PdfContents: JsonArray);
    procedure GetPageCount(PdfContent: Text);
    procedure DrawSignatureBox(PdfContent: Text; PageNumber: Integer; X: Integer; Y: Integer; Width: Integer; Height: Integer);
}