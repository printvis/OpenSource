permissionset 75000 ProductConfig
{
    Assignable = true;
    Permissions = tabledata "PTE Product Job Item" = RIMD,
        tabledata "PTE Product Userfield ID" = RIMD,
        tabledata "PVS Userfield Field Value" = RIMD,
        table "PTE Product Job Item" = X,
        table "PTE Product Userfield ID" = X,
        codeunit "PTE Product Template Mgt" = X,
        page "PTE Product Job Item Colors" = X,
        page "PTE Product Job Item Sub" = X;
}