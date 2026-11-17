namespace PrintVis.BoldSign.Permissions;

using PrintVis.BoldSign.Configuration;
using PrintVis.BoldSign.Workflows;
using PrintVis.BoldSign.Processing;
using PrintVis.BoldSign.Documents;
using PrintVis.BoldSign.Common;
using PrintVis.BoldSign.Integration.Services;
using PrintVis.BoldSign.Utilities;
using PrintVis.BoldSign.Integration.Http;

/// <summary>
/// Permission set for BoldSign user.
/// </summary>
permissionset 80302 "PVS BS User"
{
    Assignable = true;
    Caption = 'BoldSign User';
    Permissions =
        tabledata "PVS BS Brand" = R,
        tabledata "PVS BS Document" = RIMD,
        tabledata "PVS BS Document Workflow" = R,
        tabledata "PVS BS Service Setup" = Rm,
        codeunit "PVS BS Activity Log Mgt." = X,
        codeunit "PVS BS Doc. Download Service" = X,
        codeunit "PVS BS BoldSign Document Check" = X,
        codeunit "PVS BS BoldSign Mgt." = X,
        codeunit "PVS BS Execute Status Workflow" = X,
        codeunit "PVS BS Http Client" = X,
        codeunit "PVS BS Integration Service" = X,
        codeunit "PVS BS Refresh Document Status" = X,
        codeunit "PVS BS Signature Service" = X,
        codeunit "PVS BS Subscribers" = X,
        codeunit "PVS BS Utility" = X,
        page "PVS BS Case Docs. FactBox" = X,
        page "PVS BS Document List" = X,
        page "PVS BS Select Report to Send" = X,
        page "PVS BS Service Setup" = X,
        page "PVS BS Document Workflows" = X;
}