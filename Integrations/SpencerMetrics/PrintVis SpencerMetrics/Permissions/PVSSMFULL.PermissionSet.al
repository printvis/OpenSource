namespace PrintVis.SpencerMetrics.Permissions;

using PrintVis.SpencerMetrics.CounterManagement;
using PrintVis.SpencerMetrics.Configuration;
using PrintVis.SpencerMetrics.Services;
using PrintVis.SpencerMetrics;
using PrintVis.SpencerMetrics.API;

permissionset 80290 "PVS SM FULL"
{
    Assignable = true;
    Caption = 'SpencerMetrics Full';
    Permissions = table "PVS SM Cost Center Setup" = X,
        tabledata "PVS SM Cost Center Setup" = RIMD,
        table "PVS SM Setup" = X,
        tabledata "PVS SM Setup" = RIMD,
        table "PVS SM Counter Entry" = X,
        tabledata "PVS SM Counter Entry" = RIMD,
        table "PVS SM Count Summary Buffer" = X,
        tabledata "PVS SM Count Summary Buffer" = RIMD,
        table "PVS SM Session Parameter" = X,
        tabledata "PVS SM Session Parameter" = RIMD,
        table "PVS SM Session Log" = X,
        tabledata "PVS SM Session Log" = RIMD,
        codeunit "PVS SM Api Client" = X,
        codeunit "PVS SM Counter Worker" = X,
        codeunit "PVS SM Event Handler" = X,
        codeunit "PVS SM Events" = X,
        codeunit "PVS SM Session Manager" = X,
        page "PVS SM Assign To Job Costing" = X,
        page "PVS SM Cost Center Setup" = X,
        page "PVS SM Counter Entries" = X,
        page "PVS SM Count FactBox" = X,
        page "PVS SM Order Sheet API" = X,
        query "PVS SM Counts Sum By UOM" = X;
}
