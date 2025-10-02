namespace PrintVis.OpenSource.Shipmondo.Permissions;

using PrintVis.OpenSource.Shipmondo;
using PrintVis.OpenSource.Shipmondo.API;
using PrintVis.OpenSource.Shipmondo.Configuration;

permissionset 80184 "SISM ALl"
{
    Assignable = true;
    Caption = 'Shipmondo All';
    Permissions = table "SISM Print Client" = X,
        tabledata "SISM Print Client" = RIMD,
        table "SISM Setup" = X,
tabledata "SISM Setup" = RIMD,
        codeunit "SISM API Client" = X,
        codeunit "SISM Assisted Setup" = X,
        codeunit "SISM Event Handler" = X,
        codeunit "SISM Implementation" = X,
        codeunit "SISM Mgt" = X,
        codeunit "SISM Req. Builder" = X,
        codeunit "SISM Resp. Handler" = X,
        page "SISM Assisted Setup" = X,
        page "SISM Print Clients" = X,
        page "SISM Setup" = X;
}