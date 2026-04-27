# Add Scheduling Problem

This extension provides a framework for adding custom scheduling problem notifications to the PrintVis Planning Board. The included example adds a scheduling problem called **"Planned after delivery date"**, which turns any planning unit red and displays the problem if the scheduled ending time falls after the requested delivery date on the case.

## What this extension includes

- Codeunit 80195 **"SchedulingProblem"**

## How it works

The codeunit subscribes to the `OnBeforeInfoText` event on the `PVS Job Planning Unit` table. When the info text for a planning unit is being evaluated:

1. It calculates and reads the **Requested Delivery DateTime** from the related case.
2. If a delivery date is set and the planning unit's **Ending** time is after that date, it sets the info text to `'Planned after delivery date'`.
3. This causes the planning unit to appear red on the Planning Board with the problem description shown.

## Prerequisites to run the functionality

- PrintVis dependency available (minimum version 25.0.0.0).
- Business Central application compatible with version 26.0.0.0.

## What you will need to do for this extension to work

- Install the .app extension in your environment.
- Ensure the PrintVis app is installed and meets the dependency version.
- The scheduling problem check runs automatically — no additional configuration is required.
