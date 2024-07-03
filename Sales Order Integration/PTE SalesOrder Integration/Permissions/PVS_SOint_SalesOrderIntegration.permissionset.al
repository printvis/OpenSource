permissionset 80101 "PTE SOI Permission"
{
    Access = Public;
    Assignable = true;
    Caption = 'Sales Order Integration';
    Permissions = page "PTE SOI S.O. Status FactBox" = X,
                  page "PTE SOI Wareh. P. Rcpt L" = X;
    //page "PVS Warehouse Purch. Rcpt. Sub" = X,
    //page "PVS Warehouse Purchase Receipt" = X;
}
