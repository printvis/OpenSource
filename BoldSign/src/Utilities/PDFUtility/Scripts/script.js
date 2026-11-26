async function MergePDFs(pdfContentsArray) {
    try {
        const { PDFDocument } = PDFLib;
        const mergedPdf = await PDFDocument.create();
        
        // Parse JSON array if it's a string
        const pdfsToMerge = typeof pdfContentsArray === 'string' 
            ? JSON.parse(pdfContentsArray) 
            : pdfContentsArray;

        for (const base64Content of pdfsToMerge) {
            // Convert base64 to Uint8Array
            const pdfBytes = Uint8Array.from(atob(base64Content), c => c.charCodeAt(0));
            
            // Load the PDF document
            const pdf = await PDFDocument.load(pdfBytes);
            
            // Copy all pages from the current PDF to the merged document
            const copiedPages = await mergedPdf.copyPages(pdf, pdf.getPageIndices());
            copiedPages.forEach(page => mergedPdf.addPage(page));
        }

        // Save the merged PDF
        const mergedPdfBytes = await mergedPdf.save();
        
        // Convert to base64
        const mergedBase64 = btoa(
            new Uint8Array(mergedPdfBytes)
                .reduce((data, byte) => data + String.fromCharCode(byte), '')
        );

        // Trigger the MergeComplete event with the merged PDF content
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('MergeComplete', [mergedBase64]);
    } catch (error) {
        console.error('PDF merge error:', error);
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('MergeError', [error.message]);
    }
}

async function GetPageCount(pdfContentBase64) {
    try {
        const { PDFDocument } = PDFLib;
        const pdfBytes = Uint8Array.from(atob(pdfContentBase64), c => c.charCodeAt(0));
        const pdf = await PDFDocument.load(pdfBytes);
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('PageCountReady', [pdf.getPageCount()]);
    } catch (error) {
        console.error('PDF page count error:', error);
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('MergeError', [error.message]);
    }
}

// Boldsign draw rectangle for signature place: preview
const SIGNATURE_UNIT_TO_POINT = 1;

async function DrawSignatureBox(pdfContentBase64, pageNumber, x, y, width, height) {
    try {
        const { PDFDocument, rgb } = PDFLib;
        const pdfBytes = Uint8Array.from(atob(pdfContentBase64), c => c.charCodeAt(0));
        const pdf = await PDFDocument.load(pdfBytes);
        const pageIndex = Math.min(Math.max(pageNumber, 1), pdf.getPageCount()) - 1;
        const page = pdf.getPage(pageIndex);
        const boxWidth = width * SIGNATURE_UNIT_TO_POINT;
        const boxHeight = height * SIGNATURE_UNIT_TO_POINT;

        page.drawRectangle({
            x: x * SIGNATURE_UNIT_TO_POINT,
            y: page.getHeight() - (y * SIGNATURE_UNIT_TO_POINT) - boxHeight,
            width: boxWidth,
            height: boxHeight,
            borderColor: rgb(1, 0, 0),
            borderWidth: 1.5,
            color: rgb(1, 0, 0),
            opacity: 0.1,
            borderOpacity: 1
        });

        const markedBytes = await pdf.save();
        const markedBase64 = btoa(
            new Uint8Array(markedBytes)
                .reduce((data, byte) => data + String.fromCharCode(byte), '')
        );
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('SignatureBoxReady', [markedBase64]);
    } catch (error) {
        console.error('PDF signature box error:', error);
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('MergeError', [error.message]);
    }
}
