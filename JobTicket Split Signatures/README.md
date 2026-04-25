# JobTicket Split Signatures

This extension adds functionality to the PrintVis job ticket generation process. In standard behavior, press section lines in the job ticket can contain a quantity of signatures greater than 1 on a single line. For companies that want each signature shown as an individual line, this extension modifies the generated dataset before the report is rendered.

When a line in the press section has multiple signatures, the extension splits that line into separate lines with one signature per line and adjusts the related decimal values so each inserted line represents a single signature. This improves readability and makes press output easier to review and process.

## What this extension includes

- Codeunit 80422 "Jobticket Split Signatures"
- Event subscriber on `PVS JobTicket Management`, event `OnAfterGetReportBuffer`

## How it works

The codeunit subscribes to the `OnAfterGetReportBuffer` event in `PVS JobTicket Management`. When job ticket data is prepared:

1. It filters the report buffer to the press section (`Report Section = 52`).
2. It identifies lines where `Decimal1 > 1` (multiple signatures).
3. For each matching line, it:
	- Sets the signature quantity to 1 on the original line.
	- Adjusts decimal values based on the number of signatures.
	- Inserts additional lines so each signature is represented as its own line.

The result is that multi-signature press lines are expanded into individual lines in the final job ticket dataset.

## How to configure

Step 1 Install the extension in your Business Central environment.

Step 2 Run the standard PrintVis job ticket process.

Step 3 No extra setup is required. The split logic runs automatically during dataset preparation.

## Prerequisites to run the functionality

- PrintVis dependency available (minimum version 26.0.0.0).
- Business Central application compatible with version 26.0.0.0.

## What you will need to do for this extension to work

- Install the .app extension in your environment.
- Ensure the PrintVis app is installed and meets the dependency version.
- Use the standard PrintVis job ticket generation flow (the subscriber runs automatically).

