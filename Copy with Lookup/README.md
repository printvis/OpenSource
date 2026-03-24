# Copy With Lookup

This extension adds functionality to the PrintVis job copy process. When copying a job or order in PrintVis, calculation units are normally duplicated as-is from the source job. In some cases, however, it is desirable for certain calculation units to be re-inserted fresh rather than copied with potentially stale or context-specific values. A common example is a calculation unit that depends on current pricing or configuration that may have changed since the original job was created.

If a calculation unit is marked with the "Lookup on Copy" flag, this extension comes into play. After the copy is completed, it identifies those flagged calculation units on the new job, clears them, and re-validates them so that they are re-inserted through the standard lookup mechanism. The job is then recalculated to reflect the updated values. This ensures that the copied job reflects current setup data rather than carrying over values from the original.

## What this extension includes

- New field **"Lookup on Copy"** on the Calculation Unit Setup page and table, used to flag which calculation units should be re-inserted on copy.
- Table extension 80420 **"PTE CalcUnit Lookup on Copy"** extends **"PVS Calculation Unit Setup"**
- Page extension 80420 **"PTE CalcUnit Lookup on Copy"** extends **"PVS Calculation Unit Setup"**
- Codeunit 80420 **"PTE Copy With Lookup"**

## How it works

The codeunit subscribes to the `OnAfterMainCopyJobToOrder` event in `PVS Copy Management`. When a job is copied:

1. It scans all calculation units on the newly created job.
2. For each unit that is of type **Calculation Unit** and has **"Lookup on Copy"** enabled in the setup, it re-validates (clears and re-inserts) the unit using the standard PrintVis validation mechanism.
3. Once all affected units are re-processed, the job is recalculated to ensure all values are current and consistent.

## How to configure

**Step 1** Open the **PVS Calculation Unit Setup** page and locate the calculation units that should be re-inserted when a job is copied.

**Step 2** Enable the **Lookup on Copy** field on each applicable calculation unit. Note: this field is only available for units that are not of the "List Of Units" type.

**Step 3** Once configured, no further action is needed. The re-insertion happens automatically whenever a job is copied using the standard PrintVis copy functionality.

## Prerequisites to run the functionality

- The calculation units to be re-inserted must be of type **Calculation Unit** in the Calculation Unit Setup.
- The **"Lookup on Copy"** field must be enabled on the desired units before any copy is performed.

## What you will need to do for this extension to work

- Create a PTE and install it on an environment.
- Events used in this extension are available from **PV26** and ongoing.
