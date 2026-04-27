# CIM App Migration to PTE

This project provides the tools needed to migrate data from the old CIM OnPrem app to the new PTE app. The migration is a three-part process that moves data through temporary tables before loading it into the new extension.

## What this extension includes

- Source code and app.json for three migration app parts, each in its own folder under `src`.
- Enum and table definitions shared across migration parts.

## How it works

The migration is split into three parts, each requiring a separately compiled app:

1. **Part 1 — Move CIM data to the migration app**: Installs temporary tables and runs an upgrade that copies CIM data into them.
2. **Part 2 — Remove the old dependency**: Uninstalls the old CIM app and installs the new PrintVis and CIM versions.
3. **Part 3 — Move data to the new PTE app**: Installs the final migration app, which transfers data from the temporary tables into the new PrintVis CIM extension.

## How to configure

Step 1 Review the code in each `Upgrade Part` folder and compile the app for each part by copying the relevant app.json to the root directory and commenting/uncommenting the corresponding codeunit.

Step 2 Install **Part 1** (`PTE CIM 1 - upg temp tables`). This triggers the upgrade codeunit that moves data from PrintVis into the temporary tables.

Step 3 Uninstall and unpublish the old **PrintVis CIM** app.

Step 4 Install the new **PrintVis** (version 26.1.1.0) and **PrintVis CIM** (version 26.1.1.0) apps. Install PrintVis CIM with mode = Force.

Step 5 Install **Part 3** (`PTE CIM 1 - Move Data into PrintVis`). This triggers the upgrade that moves data from the temporary tables into the new PrintVis CIM extension.

Step 6 Uninstall and remove **Part 3** (select **Delete Extension Data**).

Step 7 Verify that data exists in PrintVis CIM Controller, CIM Device, and Cost Center Device Code.

Step 8 Uninstall and remove **Part 1** (select **Delete Extension Data**).

## Prerequisites to run the functionality

- The old PrintVis CIM app must be installed before starting the migration.
- PrintVis version 26.1.1.0 and PrintVis CIM version 26.1.1.0 must be available for installation.
- If the `PVS CIM Controller` or `PVS CIM Device` tables have custom fields, add them to the `PTE CIM 1 - upg temp tables` app before starting the migration, or those custom fields will not be migrated.

## What you will need to do for this extension to work

- Compile each migration app part separately by updating the app.json and commenting/uncommenting the relevant codeunit as described in each folder.
- Follow the migration steps in order. Do not skip steps.
- For OnPrem or Container environments, run the appropriate PowerShell script (found in the `OnPrem Scripts` folder) and update the input section at the top of the script before running.
