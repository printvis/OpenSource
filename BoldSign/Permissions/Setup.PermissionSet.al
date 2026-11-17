namespace PrintVis.BoldSign.Permissions;

using PrintVis.BoldSign.Configuration;
using PrintVis.BoldSign.Workflows;
using PrintVis.BoldSign.Common;
using PrintVis.BoldSign.Integration.Services;

/// <summary>
/// Permission set for BoldSign setup.
/// </summary>
permissionset 80301 "PVS BS Setup"
{
    Assignable = true;
    Caption = 'BoldSign Setup';
    IncludedPermissionSets = "PVS BS User";
    Permissions =
        tabledata "PVS BS Brand" = RIMD,
        tabledata "PVS BS Document Workflow" = RIMD,
        tabledata "PVS BS Service Setup" = RIMD,
        page "PVS BS Brands" = X,
        page "PVS BS Document Workflows" = X,
        page "PVS BS Report Selection Setup" = X,
        page "PVS BS Select Report to Send" = X,
        page "PVS BS Service Setup" = X;
}