# Finished Goods Valuation

This extension provides a way to keep accurate cost values for finished goods output with a PrintVis case. It tracks the actual cost of finished goods items produced against PrintVis cases and supports adjusting those costs automatically through a job queue or manually through a dedicated page.

> **Note:** This extension currently assumes there is only one finished goods item per case.

## What this extension includes

- Table 80260 **"PTE PVS FG Valuation"** — stores a summary of PrintVis output per case and item, including estimated and actual costs.
- Page 80260 **"PTE PVS FG Valuation List"** — displays all PrintVis output summaries with actions to create output entries for existing output, adjust the current output cost, and perform general adjustments.
- Codeunit 80260 **"PTE PVS FG Valuation Mngt."** — manages the full valuation logic including cost adjustment. This codeunit can be scheduled via a job queue entry to keep valuations updated automatically.
- Codeunit **"PTE PVS FG Valuation Event Sub."** — event subscriber that automatically marks output lines for re-evaluation when relevant changes occur.

## How it works

The extension monitors PrintVis output and adjusts the cost of finished goods items to reflect actual production costs:

1. When output is posted against a PrintVis case, the event subscriber marks the corresponding valuation record as requiring re-evaluation.
2. The valuation management codeunit reads the estimated and actual costing entries from PrintVis and calculates the correct cost for the finished goods item.
3. The cost adjustment is written back to the item ledger using standard Business Central costing mechanisms.
4. The process can be triggered manually from the **PTE PVS FG Valuation List** page or automatically via a job queue entry pointing to codeunit 80260.

## How to configure

Step 1 Install the extension in your Business Central environment.

Step 2 Open the **PTE PVS FG Valuation List** page to view and manage existing valuation entries.

Step 3 Optionally, create a job queue entry pointing to codeunit 80260 to run the valuation adjustment automatically on a schedule.

## Prerequisites to run the functionality

- PrintVis dependency available (minimum version 23.0.0.0).
- Business Central application compatible with version 25.0.0.0.
- Only one finished goods item per case is supported in the current version.

## What you will need to do for this extension to work

- Install the extension in a Business Central environment with PrintVis installed.
- Ensure the PrintVis app is installed and meets the dependency version.
- Optionally configure a job queue entry for automated valuation updates.
