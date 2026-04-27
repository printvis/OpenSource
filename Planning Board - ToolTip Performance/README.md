# Planning Board Tooltip Performance

When loading the Planning Board, significant time is spent generating tooltips for each planning unit based on the configured setup. This extension improves reload performance by caching the generated tooltip text on the planning unit record and reusing it on subsequent loads, only generating new tooltips for planning units that have not been cached yet.

## What this extension includes

- Table extension 80800 **"PTE Planning Unit"** extends **"PVS Job Planning Unit"** — adds two fields to store the cached tooltip text and search text.
- Codeunit 80800 **"PTE ToolTip"** — event subscribers that cache and reuse tooltip text.

## How it works

The codeunit subscribes to three events in the Planning Board data pipeline:

1. When the Planning Board is opened (`OnBeforeSetJSONSettings`), all cached tooltip texts are cleared so they are regenerated fresh on the first load.
2. After a tooltip is generated for a planning unit (`OnAfterTooltipText2`), the tooltip text and search text are saved to the two new fields on the planning unit record.
3. Before a tooltip is generated (`OnBeforeTooltipText`), if a cached tooltip text already exists on the planning unit, it is returned immediately and `IsHandled` is set to true, skipping the standard tooltip generation entirely.

## Prerequisites to run the functionality

- PrintVis dependency available (minimum version 26.0.0.0).
- Business Central application compatible with version 26.0.0.0.

## What you will need to do for this extension to work

- Install the .app extension in your environment.
- Ensure the PrintVis app is installed and meets the dependency version.
- The caching logic runs automatically — no additional configuration is required.

