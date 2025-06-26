permissionset 80263 "PTE CIM 1 Permission"
{
    Assignable = true;
    Permissions = tabledata "PTE CIM 1 Upg. TT Device"=RIMD,
        tabledata "PTE CIM 1 Upg. TT. Controller"=RIMD,
        tabledata "PTE CIM 1 Upg. TT. Cost Center"=RIMD,
        table "PTE CIM 1 Upg. TT Device"=X,
        table "PTE CIM 1 Upg. TT. Controller"=X,
        table "PTE CIM 1 Upg. TT. Cost Center"=X,
        codeunit "PTE CIM 1 - UPG Functions"=X,
        codeunit "PTE CIM 2 Upg. L. W."=X,
        codeunit "PTE CIM 2 Upg. PrintVis L."=X,
        codeunit "PTE CIM 2 Upg. PrintVis Tags"=X,
        codeunit "PTE CIM 2 Upg. TT Codeunit"=X;
}