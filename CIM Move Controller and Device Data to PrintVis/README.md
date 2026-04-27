# CIM Move Controller and Device Data to PrintVis

PrintVis version 26 introduced breaking changes to the PrintVis CIM app. Two tables — `PVS CIM Controller` and `PVS CIM Device` — were moved from the PrintVis CIM PTE app into the core PrintVis app. This project provides upgrade apps and scripts to transfer existing data from older installations into the new structure without data loss.

## What this extension includes

- App 1: **PTE CIM 1 - upg temp tables** — installs temporary tables and triggers an upgrade to move data out of the old CIM app.
- App 3: **PTE CIM 1 - Move Data into PrintVis** — triggers an upgrade to move data from the temporary tables into the new PrintVis CIM extension.
- PowerShell scripts for OnPrem/Container environments, located in the `OnPrem Scripts` folder.

## How it works

The upgrade process uses two temporary apps as intermediaries to safely transfer data through a breaking dependency change:

1. App 1 creates temporary tables and runs an upgrade codeunit that copies CIM Controller and Device data from the existing PrintVis CIM installation into those tables.
2. The old PrintVis CIM app is removed and the new versions of PrintVis and PrintVis CIM are installed.
3. App 3 runs an upgrade codeunit that reads the data from the temporary tables and inserts it into the new PrintVis CIM tables.

## How to configure

Step 1 If `PVS CIM Controller` or `PVS CIM Device` contain custom fields, add those fields to App 1 (`PTE CIM 1 - upg temp tables`) before proceeding, otherwise they will not be migrated.

Step 2 Install App 1 (`PTE CIM 1 - upg temp tables`). This triggers the upgrade and moves data from PrintVis into App 1.

Step 3 Uninstall and unpublish the old **PrintVis CIM** app.

Step 4 Install **PrintVis** version 26.1.1.0, then install **PrintVis CIM** version 26.1.1.0 with mode = Force.

Step 5 Install App 3 (`PTE CIM 1 - Move Data into PrintVis`). This triggers the upgrade and moves data from App 1 into the new PrintVis CIM tables.

Step 6 Uninstall and remove App 3 (select **Delete Extension Data**).

Step 7 Open Business Central and verify that data exists in PrintVis CIM Controller, CIM Device, and Cost Center Device Code (tables 80265, 80264, and 80263).

Step 8 Uninstall and remove App 1 (select **Delete Extension Data**).

## Prerequisites to run the functionality

- An existing installation of PrintVis CIM on a version prior to 26.1.1.0.
- PrintVis version 26.1.1.0 and PrintVis CIM version 26.1.1.0 available for installation.
- For OnPrem/Container environments, access to run PowerShell scripts against the Business Central instance.

## What you will need to do for this extension to work

- For Cloud environments: follow the steps above using the Business Central admin center.
- For OnPrem/Container environments: update and run the appropriate PowerShell script from the `OnPrem Scripts` folder before following the steps above.
- Follow the upgrade steps in order. Skipping steps may result in data loss.
