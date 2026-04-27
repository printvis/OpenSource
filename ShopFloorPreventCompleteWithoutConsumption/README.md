# Shop Floor Prevent Complete Without Consumption

This extension adds a validation check to the Shop Floor completion process in PrintVis. When an operator attempts to complete a plan through Shop Floor, the extension verifies that material consumption has already been registered. If no consumption has been recorded, an error is thrown and the completion is blocked.

## What this extension includes

- Codeunit 80176 **"PTE SF post check compl. sub"**

## How it works

The codeunit subscribes to the `OnBeforeShopFloorJournalEntryCompleteJob` event in `PVS Shop Floor Management`. When a plan is being completed through Shop Floor:

1. It checks the **PVS Job Costing Entry** table for any entries linked to the planning unit that have an item number (material consumption).
2. It also checks the **PVS Job Costing Journal Line** table for any unposted journal lines with an item number for the same planning unit.
3. If neither table has consumption entries, an error is raised and the completion is blocked.

## Prerequisites to run the functionality

- PrintVis version PV22: 22.16.3.0 or later, PV23: 23.10.1.4 or later, or PV24: 24.5.1.4 or later.

## What you will need to do for this extension to work

- Install the .app extension in your environment.
- Ensure the PrintVis app is installed and meets the minimum version requirement.
- The consumption check runs automatically during Shop Floor completion — no additional configuration is required.
