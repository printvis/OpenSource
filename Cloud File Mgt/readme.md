# Cloud File Mgt

PrintVisCloud File Mgt functionality makes it easy to upload and move files to and from SharePoint
  

## What this extension includes:

- Procedures that makes it possible to Up -/ Download files to and from SharePoint that is not connected with any PVS Cases, such as import of files that.
below is a snippte on how to use whare the only input is the folder id's from the "PTE Sharepoint Folders" table.

```
    procedure DownloadFilesAndProcess(ImportFolderID: Code[50]; ArchiveFolderID: Code[50])
    var
        temp_CloudStorage: Record "PVS Cloud Storage" temporary;
        FileMgt: Codeunit "PTE File Mgt Sharepoint";
        TempBlob: Codeunit "Temp Blob";
        CloudStorageManagement: Codeunit "PVS Cloud Storage Management";
        ServerFileName: Text;
        _InStream: InStream;
        OStream: OutStream;
        XMLImportProcess: Codeunit "XML Import Process" ;
    begin 
        if not FileMgt.GetFilesList(ImportFolderID, temp_CloudStorage) then
            exit;

        if temp_CloudStorage.FindSet() then
            repeat
                TempBlob.CreateInStream(_InStream);
                TempBlob.CreateOutStream(OStream);
                CloudStorageManagement.DownloadServerFile(temp_CloudStorage, TempBlob, ServerFileName);

                if XMLImportProcess.ProcessFileImport(_InStream) then
                    if ArchiveFolderID <> '' then
                        FileMgt.MoveFileToFolderWithID(temp_CloudStorage, ArchiveFolderID);
            until temp_CloudStorage.Next() = 0;
    end;
    ```