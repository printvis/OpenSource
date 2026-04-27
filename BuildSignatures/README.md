# Automated Job Signatures

PrintVis writes the Assembly Section into the Assembly Node of the JDF, which describes how the sections for the PrintVis Job Items are bound together. The Assembly setting must be made manually in **PrintVis Job Signatures** by the user.

This extension automates the building of **PrintVis Job Signatures** and covers the following scenarios:

- Sheets/Job Items with a component type marked as a cover are placed as the first line (Assembly Order = 1). Only one cover is supported.
- Residual sheets with 4 pages on the last job item are moved to the second-to-last position.
- Job Signatures are indented based on the CIP4 Binding/Finishing setup on the **PrintVis Cost Center Configuration** or **PrintVis Finishing Types**. Supported settings are HardCover (Assembly Order = List), SoftCover (Assembly Order = List), and SaddleStitch (Assembly Order = Collecting).

The code will only build the Job Signatures automatically if no manual changes have been made. To reset the manual settings, the user can use the **Rebuild Signatures** action.

## What this extension includes

- Codeunit 80198 **"PTE BuildSignatures"** — event subscriber that replaces the standard procedure for building the sorting order of signatures.
- Page extension 80198 **"PTE Job Print Signatures"** extends **"PVS Job Print Signatures"** — adds the **Rebuild Signatures** action.

## How it works

The codeunit subscribes to the `OnBeforeBuild_Entries` event on the `PVS Job Signatures` table. When job signatures are being built:

1. It determines the Assembly Style by checking the CIP4 Binding setting on the finishing calculation unit's Cost Center Configuration. If not found there, it falls back to the Finishing Types setup on the job. If neither is set, it defaults to **Gathering**.
2. Based on the binding type, the Assembly Style is set to: **List** (HardCover/SoftCover), **Collecting** (SaddleStitch), or **Gathering** (default).
3. Cover sheets are assigned Assembly Order 1. Remaining sheets follow in order, with residual sheets placed second-to-last.
4. Indentation is applied per the Assembly Style: Collecting uses incremental indentation, List indents all entries except the first, and Gathering applies no indentation.
5. If signatures have been set manually previously, those stored values are reused rather than overwritten.

## How to configure

Step 1 Install the extension in your Business Central environment.

Step 2 Ensure your Cost Center Configuration or Finishing Types have the **CIP4 Binding** field set to the appropriate binding type (HardCover, SoftCover, or SaddleStitch).

Step 3 Open a PrintVis Job and navigate to the Job Signatures worksheet. Signatures are built automatically based on the setup. Use the **Rebuild Signatures** action to reset any manual changes.

## Prerequisites to run the functionality

- PrintVis dependency available (minimum version 24.0.0.0).
- Business Central application compatible with version 24.0.0.0.
- CIP4 Binding must be configured on Cost Center Configuration or Finishing Types for automatic indentation to apply.

## What you will need to do for this extension to work

- Install the .app extension in your environment.
- Ensure the PrintVis app is installed and meets the dependency version.
- The logic runs automatically when job signatures are built — no additional configuration is required beyond the CIP4 Binding setup.

