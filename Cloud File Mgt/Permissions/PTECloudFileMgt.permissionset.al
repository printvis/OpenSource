permissionset 80400 PTECloudFileMgt
{
    Assignable = true;
    Permissions = tabledata "PTE Sharepoint Folders"=RIMD,
        table "PTE Sharepoint Folders"=X,
        codeunit "PTE File Mgt Sharepoint"=X,
        page "PTE SH Folders List"=X;
}