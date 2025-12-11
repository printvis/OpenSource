table 80400 "PTE Sharepoint Folders"
{
    DataClassification = SystemMetadata;
    Caption = 'Sharepoint Folders';
    fields
    {
        field(1; CODE; Code[20])
        {
            Caption = 'Code';
            ToolTip = 'Code for the table';
        }
        field(2; "Folder Path"; Text[2048])
        {
            Caption = 'Folder path';
            ToolTip = 'The Folder path';
        }
        field(3; "Folder Name"; Text[50])
        {
            Caption = 'Folder Name';
            ToolTip = 'Name of the Folder';
            Editable = false;
        }
        field(4; "Folder Id"; Text[50])
        {
            Caption = 'Folder Id';
            ToolTip = 'The Folder Id';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; CODE)
        {
            Clustered = true;
        }
    }


    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    internal procedure _Folder_Path_OnAssistEdit_PathRoot(Folders_: Record "PTE Sharepoint Folders")
    var
        GraphMgt: Codeunit "PVS Cloud Graph Management";
        FileMgtCloud: Codeunit "PTE File Mgt Sharepoint";
        NewID: Text[50];
        FolderPath: Text;
    begin
        if GraphMgt.FilePicker(1, '', '', FolderPath, NewID) then begin
            Folders_."Folder Id" := NewID;
            if Folders_."Folder Id" <> '' then
                Folders_."Folder Path" := CopyStr(FolderPath, 1, MaxStrLen(Folders_."Folder Path"));
        end;
        Folders_."Folder Name" := FileMgtCloud.GetFolderFromPath(Folders_."Folder Path");

        Folders_.Modify(false);
    end;
}