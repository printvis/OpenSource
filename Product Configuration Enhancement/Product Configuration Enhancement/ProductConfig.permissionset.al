permissionset 75000 ProductConfig
{
    Assignable = true;
    Permissions = tabledata "PTE Product Job Item" = RIMD,
        table "PTE Product Job Item" = X,
        codeunit "PTE Product Setup State" = X,
        codeunit "PTE Product Template Mgt" = X,
        page "PTE Product Job Item Colors" = X,
        page "PTE Product Job Item Sub" = X;
}