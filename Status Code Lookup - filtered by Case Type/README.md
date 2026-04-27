# Status Code Lookup Filtered by Case Type

This extension adds an extra filter to the Status Code lookup on the PrintVis Case Card. When a user looks up a status code, only status codes appropriate for the current case type are shown, preventing selection of status codes that are not valid for the case's stage in the workflow.

The filter works as follows based on the case type:
- **Request** — shows status codes with Status set to Request, Quote, Order, or Production Order.
- **Quote** — shows status codes with Status set to Quote, Order, or Production Order.
- **Order** — shows status codes with Status set to Order or Production Order.
- **Production Order** — shows only status codes with Status set to Production Order.

The **Status** field used for filtering can be found on the Status Code card under the **General** tab in the **System Status** group.

## What this extension includes

- Codeunit 80174 **"PTE Status Code Sub. Filter"**

## How it works

The codeunit subscribes to the `OnLookUp_StatusCode_OnBeforeSettingStatusCodeFilter` event on the `PVS Case` table. When the Status Code lookup is triggered:

1. It reads the current case type from the case record.
2. It applies a range filter on the Status Code's **Status** field, starting from the current case type value upward, so only status codes at or above the current case stage are shown.

## Prerequisites to run the functionality

- PrintVis version PV22: 22.x.x.x or later, PV23: 23.x.x.x or later, or PV24: 24.x.x.x or later (the required event was introduced in these versions).

## What you will need to do for this extension to work

- Install the .app extension in your environment.
- Ensure the PrintVis app is installed and meets the minimum version requirement.
- Ensure the **Status** field is set on your Status Code records. The filter runs automatically during the Status Code lookup — no additional configuration is required.
