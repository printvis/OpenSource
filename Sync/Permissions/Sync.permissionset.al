permissionset 80200 "PVS-BC Sync"
{
    Access = Public;
    Assignable = true;
    Caption = 'PVS Sync';
    Permissions = tabledata "PVS Sync Field Mapping" = RIMD,
                  tabledata "PVS Sync Field Setup" = RIMD,
                  tabledata "PVS Sync Log Entry" = RIMD,
                  tabledata "PVS Sync Table Setup" = RIMD;
}
