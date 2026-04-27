# Avoid Same Planning Sorting

Whenever a new planning unit is created for sheet 0, this extension ensures its Sorting Order does not collide with an existing planning unit that shares the same Unit and Capacity Unit. If a conflict is found, the Sorting Order is incremented by 1 to avoid duplication.

## What this extension includes

- Codeunit 80421 **"PTE Avoid Same Sorting"**

## How it works

The codeunit subscribes to the `OnAfterFind_Create_TempPlanUnit` event in `PVS Planning Units Generate`. When a new planning unit is created:

1. It checks if the unit was just created (not pre-existing) and is on sheet 0.
2. It searches the temporary planning unit records for existing units in the same job with the same Unit and Capacity Unit that share the same Sorting Order.
3. If a conflict is found, the Sorting Order of the new planning unit is incremented by 1.

## Prerequisites to run the functionality

- PrintVis dependency available (minimum version 24.0.0.0).
- Business Central application compatible with version 27.0.0.0.

## What you will need to do for this extension to work

- Install the .app extension in your environment.
- Ensure the PrintVis app is installed and meets the dependency version.
- The conflict check runs automatically when new planning units are created — no additional configuration is required.

