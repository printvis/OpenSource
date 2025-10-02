/// <summary>
/// Defines permissions for EasyPost functionality.
/// </summary>
permissionset 80136 "SIEP Permissions"
{
    Assignable = true;
    Caption = 'EasyPost Permissions';
    Permissions = table "SIEP Customs Item" = X,
        tabledata "SIEP Customs Item" = RIMD,
        table "SIEP Option" = X,
        tabledata "SIEP Option" = RIMD,
        table "SIEP Setup" = X,
tabledata "SIEP Setup" = RIMD,
        codeunit "SIEP API Client" = X,
        codeunit "SIEP Event Handler" = X,
        codeunit "SIEP Implementation" = X,
        codeunit "SIEP Mgt." = X,
        codeunit "SIEP Request Builder" = X,
        codeunit "SIEP Resp. Handler" = X,
        codeunit "SIEP Validation" = X,
        page "SIEP Options" = X,
        page "SIEP Setup" = X;
}