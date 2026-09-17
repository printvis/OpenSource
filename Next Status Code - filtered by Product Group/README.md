# Next Status Code - filtered by Product Group

This extension customizes how PrintVis finds the next status code from Responsibility Areas.
It introduces Product Group as a setup field and uses it when evaluating which responsibility rule should determine the next status.

The matching works as follows when the system searches for a next status:

Status: Matches the current status code or blank.
Order Type: Matches the current order type or blank.
Product Group: Matches the case Product Group or blank.
Sell-To No.: Matches the current Sell-To customer number or blank.
From Date / To Date: Only rules valid on today’s date are considered.
If multiple records match, the last matching record is used. If that record has a value in Next Status, that value is returned as the new status code.

The Product Group value is maintained on the Responsibility Area setup and is linked to the PVS Product Group table.

## What this extension includes

- Codeunit 80278 "PTE Responsibility"
- Tableextension 80278 "PTE Status Responsiblity Area"
- Pageextension 80278 "PTE Status Responsiblity Area"

## How it works

The codeunit subscribes to the OnBeforeGetNewStatusFromResponsibilities event on the PVS Status Code table.

When next status is evaluated:

It reads the related case.
It filters responsibility lines by Status, Order Type, Product Group, Sell-To No., and date validity.
It picks the last matching line and returns its Next Status (if set).
It marks the event as handled, so this logic controls the result.

The table extension adds a Product Group field to responsibility setup.
On validation, the extension copies Product Group into Customer Group to preserve compatibility with existing matching behavior.

The page extension:
adds Product Group to the Responsibility Area page
hides Customer Group from the page

## Prerequisites to run the functionality

PrintVis app installed (dependency defined in this extension).
Business Central runtime and application versions compatible with this extension package.

## What you will need to do for this extension to work
Install the extension package in your environment.
Ensure PrintVis is installed in a compatible version.
Configure Responsibility Area records with:
Status / Order Type as needed
Product Group where product-specific routing is required
Sell-To No. where customer-specific routing is required
valid From Date / To Date ranges
Next Status for each rule you want applied
