permissionsetextension 80101 "PTE SOI SOInt 365 Basic" extends "PVS 365 Basic"
{
    Permissions =
        Report "PTE SOI S.O. - List" = X,
        Report "PTE SOI Purchase Order List" = X,
        Codeunit "PTE SOI S.O. Sub" = X,
        Codeunit "PTE SOI S.O. Mgt" = X,
        Codeunit "PTE SOI SOint Prod Order Mgt" = X,
        Codeunit "PTE SOI Purchase Order Sub" = X,
        Codeunit "PTE SOI Purchase Order Mgt" = X,
        Codeunit "PTE SOI Status Management" = X,
        Codeunit "PTE SOI Web2PV Management" = X,
        page "PTE SOI S.O. Status FactBox" = X,
        page "PTE SOI Wareh. P. Rcpt L" = X,
        Query "PTE SOI Count Sales Orders" = X;

}