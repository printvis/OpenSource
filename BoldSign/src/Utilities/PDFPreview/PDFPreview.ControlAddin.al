namespace PrintVis.BoldSign.Utilities;

controladdin "PVS BS PDF Preview"
{
    HorizontalShrink = true;
    HorizontalStretch = true;
    MaximumHeight = 2000;
    MaximumWidth = 4000;
    MinimumHeight = 400;
    MinimumWidth = 100;
    Scripts =
        'https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.3.1.min.js',
        'https://unpkg.com/pdfobject@2.2.8/pdfobject.min.js',
        'src/Utilities/PDFPreview/Scripts/script.js';
    StartupScript = 'src/Utilities/PDFPreview/Scripts/startup.js';
    StyleSheets = 'src/Utilities/PDFPreview/Styles/style.css';
    VerticalShrink = true;
    VerticalStretch = true;

    event ControlAddinReady();

    procedure LoadPDF(ReportContent: Text)
}