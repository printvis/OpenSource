namespace PrintVis.BoldSign.CloudDrive;

using System.Utilities;

codeunit 80306 "PVS BS Cloud Drive Mgt."
{
    Access = Internal;

    /// <summary>
    /// Saves a document to a specified folder in the cloud storage.
    /// </summary>
    /// <param name="CaseID">The ID of the case associated with the document.</param>
    /// <param name="FolderGroupCode">The group code of the folder.</param>
    /// <param name="FolderID">The ID of the folder.</param>
    /// <param name="ServerFileName">The name of the file to be saved (without extension).</param>
    /// <param name="ReportInStream">The InStream containing the document data.</param>
    /// <returns>Boolean indicating whether the operation was successful.</returns>
    procedure SaveDocumentToFolder(CaseID: Integer;
        FolderGroupCode: Code[50];
        FolderID: Integer;
        ServerFileName: Text;
        var ReportInStream: InStream): Boolean
    var
        TempCloudStorage: Record "PVS Cloud Storage" temporary;
        Folder: Record "PVS Folder";
        CloudMgt: Codeunit "PVS Cloud Graph Management";
        LocalTempBlob: Codeunit "Temp Blob";
        NoFolderErr: Label 'Could not find a folder to save the report. Check the folder setup.';
        ReportOutStream: OutStream;
        FileName: Text;
        NewFileID: Text;
    begin
        LocalTempBlob.CreateOutStream(ReportOutStream);
        CopyStream(ReportOutStream, ReportInStream);

        if not this.TryGetFolder(Folder, CaseID, FolderGroupCode, FolderID) then begin
            Message(NoFolderErr);
            exit(false);
        end;

        CloudMgt.GetFolder(0, Folder."Cloud ID", Folder."Cloud ID", false, TempCloudStorage);

        FileName := this.GenerateUniqueFileName(TempCloudStorage, ServerFileName);

        FileName := FileName.TrimStart().TrimEnd();

        exit(CloudMgt.UploadFile(LocalTempBlob, FileName, Folder."Cloud ID", NewFileID));
    end;

    local procedure TryGetFolder(var Folder: Record "PVS Folder"; CaseID: Integer; FolderGroupCode: Code[50]; FolderID: Integer): Boolean
    begin
        Folder.SetRange(ID, CaseID);
        Folder.SetRange("Group Code", FolderGroupCode);
        Folder.SetRange("Folder ID", FolderID);

        if Folder.FindFirst() then
            exit(true);

        Folder.Set_SkipBackgroundCloud(true);
        Folder.Folder_Create_Folders();

        Folder.SetRange(ID, CaseID);
        Folder.SetRange("Group Code", FolderGroupCode);
        Folder.SetRange("Folder ID", FolderID);
        exit(Folder.FindFirst());
    end;

    local procedure GenerateUniqueFileName(var TempCloudStorage: Record "PVS Cloud Storage"; BaseFileName: Text): Text
    var
        UniqueFileName: Text;
    begin
        UniqueFileName := BaseFileName;

        TempCloudStorage.SetFilter(Name, '%1', BaseFileName + '*');
        if TempCloudStorage.Count > 0 then
            UniqueFileName := BaseFileName + ' - ' + Format(TempCloudStorage.Count + 1);

        exit(UniqueFileName + '.pdf');
    end;
}