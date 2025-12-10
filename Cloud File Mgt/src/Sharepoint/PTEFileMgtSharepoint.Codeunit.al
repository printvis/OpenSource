codeunit 80400 "PTE File Mgt Sharepoint"
{
    SingleInstance = true;

    procedure Helper_Upload_SingleFile(TempBlob: Codeunit "Temp Blob"; SubFolderPathId: Text; ServerFileName: Text)
    var
        TempCloudStorage: Record "PVS Cloud Storage" temporary;
    begin
        // *****************************************
        // * Upload generated files using Sharepoint
        // *****************************************
        if SubFolderPathId = '' then
            Error('No folder selected!');

        if not TempCloudStorage.IsTemporary() then
            Error('Not temporary!');
        GlobalProvider := GlobalProvider::Graph;
        CloudStorageManagement.FillBufferOnOpenPage(TempCloudStorage, AuthProviderRec, GlobalProvider, WriteAccessVisible, DeleteAccessVisible, ReadAccessVisible, SubFolderPathId, GlobalCaption);

        TempCloudStorage.Reset();
        TempCloudStorage.SetRange(Name, 'FolderName');

        TempCloudStorage.SetRange(Type, TempCloudStorage.Type::Folder);
        if TempCloudStorage.FindFirst() then
            Helper_Upload_File(TempCloudStorage, TempBlob, ServerFileName)
        else begin
            TempCloudStorage.Reset();
            TempCloudStorage.SetRange(Name, '.');
            TempCloudStorage.SetRange(Type, TempCloudStorage.Type::Folder);
            if TempCloudStorage.FindFirst() then
                // Helper_CreateFolder(TempCloudStorage, SubFolderPath);
                Helper_Upload_File(TempCloudStorage, TempBlob, ServerFileName);
        end;
    end;

    local procedure Helper_Upload_File(var CloudStorage: Record "PVS Cloud Storage"; TempBlob: Codeunit "Temp Blob"; ServerFileName: Text): Boolean
    var
        NewFileID: Text;
    begin
        if CloudStorage.Provider = CloudStorage.Provider::Graph then
            Helper_Upload_FileWithoutDialog(true, CloudStorage, NewFileID, TempBlob, ServerFileName);

        exit(NewFileID <> '');
    end;

    local procedure Helper_Upload_FileWithoutDialog(inRefreshTree: Boolean; var outTempCloudStorageRec: Record "PVS Cloud Storage"; var outNewFileID: Text; TempBlob: Codeunit "Temp Blob"; ServerFileName: Text)
    begin
        if outTempCloudStorageRec.Type <> outTempCloudStorageRec.Type::Folder then
            Error(SelectFolder_Lbl);

        if ServerFileName <> '' then begin
            MiscFct.OpenDialog(UploadStart_Lbl);
            if GraphMgt.UploadFile(TempBlob, ServerFileName, outTempCloudStorageRec.ID, outNewFileID) then begin
                MiscFct.CloseDialog();
                if inRefreshTree then begin
                    outTempCloudStorageRec."Contents Count" += 1;
                    outTempCloudStorageRec.Modify();
                    GraphMgt.GetFolder(outTempCloudStorageRec.Level, outTempCloudStorageRec.ID, outTempCloudStorageRec.Name, false, outTempCloudStorageRec);
                end;
            end else begin
                MiscFct.CloseDialog();
                Error(UploadError_Lbl, NAVFileMgt.GetFileName(ServerFileName));
            end;
        end;

    end;

    procedure GetFilesList(FolderId: Text; var CloudStorage_Out: Record "PVS Cloud Storage" temporary): Boolean
    var
        AuthProviderRec_: Record "PVS Auth. Providers";
        temp_CloudStorage_: Record "PVS Cloud Storage" temporary;
        GlobalCaption_: Text;
        GlobalProvider_: Option " ",Graph;
        DeleteAccessVisible_: Boolean;
        ReadAccessVisible_: Boolean;
        WriteAccessVisible_: Boolean;
    begin
        GlobalProvider_ := GlobalProvider_::Graph;

        CloudStorageManagement.FillBufferOnOpenPage(
          temp_CloudStorage_, AuthProviderRec_, GlobalProvider_,
          WriteAccessVisible_, DeleteAccessVisible_, ReadAccessVisible_,
          FolderId, GlobalCaption_);

        CloudStorageManagement.ExpandAll(temp_CloudStorage_, FolderId, 'Folder Expanding');
        temp_CloudStorage_.SetRange(type, temp_CloudStorage_.type::File);
        temp_CloudStorage_.SetFilter(Name, '<>%1|<>%2', '', '.');
        temp_CloudStorage_.Reset();
        temp_CloudStorage_.SetRange(type, temp_CloudStorage_.type::File);
        temp_CloudStorage_.SetFilter(Name, '<>%1|<>%2', '', '.');
        if not temp_CloudStorage_.FindSet() then
            error('is empty, please check setup / sharepoint');
        repeat
            CloudStorage_Out := temp_CloudStorage_;
            CloudStorage_Out.Insert();
        until temp_CloudStorage_.Next() = 0;

        exit(true);
    end;

    procedure FileExists(FolderId: Text; FileName: Text): Boolean //used in JDF APP
    var
        Temp_CloudStorage_Out: Record "PVS Cloud Storage" temporary;
    begin
        if not GetFilesList(FolderId, Temp_CloudStorage_Out) then
            exit;

        WHILE STRPOS(FileName, '\') <> 0 DO
            FileName := CopyStr(FileName, 1 + STRPOS(FileName, '\'));

        Temp_CloudStorage_Out.SetRange(Name, FileName);
        if not Temp_CloudStorage_Out.IsEmpty then
            exit(true)
    end;

    procedure GetFolderFromPath(Path: Text): Text[50]
    var
        Index: Integer;
        Str: Text[50];
    begin
        Index := Path.LastIndexOf('/');
        Str := CopyStr(Path, Index + 1, 50);
        exit(Str);
    end;


    procedure GetFolderID(Code_in: Code[20]): Code[50];
    var
        Folders: Record "PTE Sharepoint Folders";
        Folder_Error_Lbl: Label 'Can not find folder %1', Comment = '%1 = Folder Code';
    begin
        Folders.SetRange(CODE, Code_in);
        if Folders.IsEmpty() then
            Error(Folder_Error_Lbl, Code_in);

        Folders.FindFirst();
        exit(Folders."Folder Id")


    end;

    procedure MoveFileToFolderWithID(CloudStorage_: Record "PVS Cloud Storage" temporary; To_Folder_Id: Text)
    var
        FileMgtCloud: Codeunit "PTE File Mgt Sharepoint";
        CloudStorageManagement_: Codeunit "PVS Cloud Storage Management";
        CloudGraphManagement: Codeunit "PVS Cloud Graph Management";
        TempBlob: Codeunit "Temp Blob";
        _InStream: InStream;
        OStream: OutStream;

        ServerFileName: Text;
    begin
        if CloudStorage_.Type <> CloudStorage_.Type::File then
            exit;

        CloudStorageManagement_.DownloadServerFile(CloudStorage_, TempBlob, ServerFileName);
        TempBlob.CreateInStream(_InStream);

        TempBlob.CreateOutStream(OStream);
        FileMgtCloud.Helper_Upload_SingleFile(TempBlob, To_Folder_Id, CloudStorage_.Name);

        CloudGraphManagement.DeleteFile(CloudStorage_.ID, CloudStorage_.name, true);
    end;

    var
        AuthProviderRec: Record "PVS Auth. Providers";
        NAVFileMgt: Codeunit "File Management";
        GraphMgt: Codeunit "PVS Cloud Graph Management";
        CloudStorageManagement: Codeunit "PVS Cloud Storage Management";
        MiscFct: Codeunit "PVS Misc. Fct.";
        DeleteAccessVisible: Boolean;
        ReadAccessVisible: Boolean;
        WriteAccessVisible: Boolean;
        SelectFolder_Lbl: Label 'Please select a folder to upload the file to';
        UploadError_Lbl: Label 'Uploading of file %1 failed', Comment = '%1 = File name';
        UploadStart_Lbl: Label 'Uploading file to OneDrive...';
        GlobalProvider: Option " ",Graph;
        GlobalCaption: Text;
}