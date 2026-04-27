# Copy Price Method

PrintVis Copy-To and Copy-From functionality makes an exact copy of the case or job being copied. This extension adjusts that behavior so that the job line price method is automatically reset to **Calculated** when the copy is completed, rather than retaining the price method from the source job.

## What this extension includes

- Codeunit 80279 **"OS Copy Price Method"**

## How it works

The codeunit subscribes to the `OnAfterCopyCompleteJob` event in `PVS Copy Management`. When a job copy is completed:

1. It validates the **Price Method** field on the newly created job, setting it to **Calculated**.
2. It saves the change by calling Modify on the job record.

## Prerequisites to run the functionality

- PrintVis dependency available (minimum version 26.4.1.1).
- Business Central application compatible with version 26.0.0.0.

## What you will need to do for this extension to work

- Install the .app extension in your environment.
- Ensure the PrintVis app is installed and meets the dependency version.
- The price method reset runs automatically after every job copy — no additional configuration is required.
