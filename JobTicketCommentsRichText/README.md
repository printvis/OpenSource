# Add Rich Text Case Description to Job Ticket

This extension adds the rich text case description to the standard PrintVis printed job tickets (reports 6010303 and 6010900). Be aware that some rich text formatting cannot be rendered within RDLC reports — for example, images, tables, and colors are not supported.

## What this extension includes

- Report extension 80500 extends job ticket report 6010303.
- Report extension 80501 extends job ticket report 6010900.
- Codeunit 80500 adds rich text descriptions to the report dataset for report 6010303.
- Codeunit 80501 adds rich text descriptions to the report dataset for report 6010900.
- Table extension 80500 adds the rich text fields to the job ticket temporary table for report 6010303.
- Table extension 80501 adds the rich text fields to the job ticket temporary table for report 6010900.
- Enum extension 80501 extends the line type enum.

## How it works

Each report extension hooks into the job ticket dataset generation process. When a job ticket is generated:

1. The codeunit reads the rich text description from the PrintVis case and formats it for inclusion in the report dataset.
2. The formatted rich text lines are inserted into the temporary job ticket table using the extended line type.
3. The report layout renders the rich text lines as plain text, since RDLC does not support full rich text formatting.

## How to configure

Step 1 Install the extension in your Business Central environment.

Step 2 Open the report layout selection for the PrintVis job ticket reports (6010303 and 6010900).

Step 3 Select the **Job Ticket Rich Text** layout for the desired report.

## Prerequisites to run the functionality

- PrintVis dependency available (minimum version 24.0.0.0).
- Business Central application compatible with version 24.0.0.0.
- Rich text case descriptions must be entered on the PrintVis case for content to appear in the job ticket.

## What you will need to do for this extension to work

- Install the .app extension in your environment.
- Ensure the PrintVis app is installed and meets the dependency version.
- Select the **Job Ticket Rich Text** report layout when generating the job ticket report.
