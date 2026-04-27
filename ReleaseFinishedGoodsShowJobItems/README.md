# Release Finished Goods Show Job Items

This extension adds an option to the PrintVis Release Finished Goods page to filter estimated quantity and entries by Job Item rather than by Job. This gives more granular control when releasing finished goods for cases that have multiple job items with different output items.

## What this extension includes

- Codeunit 80175 **"PTE RFG Job Item Sub"**
- Table extension on **"PVS General Setup"** — adds the **Use Job Item** field to the Production tab.
- Page extension on **"PVS General Setup"** — exposes the **Use Job Item** field on the Production tab of the PrintVis General Setup page.

## How it works

The codeunit subscribes to two events on the **PVS Release finished goods** page and the **PVS Warehouse Mgt** codeunit:

1. When the **Use Job Item** flag is enabled in PrintVis General Setup, the `OnBeforeBuildItemVariantTMP` subscriber filters the item variant list by job item rather than by job, building the list from the item numbers assigned to each job item.
2. When suggesting quantity for release (`OnBeforeSuggest_Quantity`), the subscriber calculates the estimated quantity based on the job item's item number and the already-posted item ledger entries, computing the remaining quantity to release.

## How to configure

Step 1 Install the extension in your Business Central environment.

Step 2 Open **PrintVis General Setup** and go to the **Production** tab.

Step 3 Enable the **Use Job Item** field at the bottom of the tab. Once enabled, the Release Finished Goods page will filter by Job Item.

## Prerequisites to run the functionality

- PrintVis version PV22: 22.16.3.0 or later, PV23: 23.10.1.4 or later, or PV24: 24.5.1.4 or later.
- The **Use Job Item** flag must be enabled in PrintVis General Setup.

## What you will need to do for this extension to work

- Install the .app extension in your environment.
- Ensure the PrintVis app is installed and meets the minimum version requirement.
- Enable the **Use Job Item** field in PrintVis General Setup under the Production tab.
