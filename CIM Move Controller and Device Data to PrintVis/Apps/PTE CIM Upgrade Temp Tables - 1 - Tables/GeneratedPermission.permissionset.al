permissionset 80263 "PTE CIM 1 Permission"
{
    Assignable = true;
    Permissions = tabledata "PTE CIM 1 Upg. TT Device" = RIMD,
        tabledata "PTE CIM 1 Upg. TT. Controller" = RIMD,
        tabledata "PTE CIM 1 Upg. TT. Cost Center" = RIMD,
        table "PTE CIM 1 Upg. TT Device" = X,
        table "PTE CIM 1 Upg. TT. Controller" = X,
        table "PTE CIM 1 Upg. TT. Cost Center" = X,
        codeunit "PTE CIM 1 - UPG Functions" = X;
}