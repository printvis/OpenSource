# Add Rich Text Case Description to Job Ticket

This extension can be used at companies that want to have the Rich Text case descriptions added to the standard PrintVis printed job tickets (6010303 and 6010900). Be aware that some rich text formatting cannot be recognized within RDLC reports (example: images, tables, colors)

## What this extension includes:

- Report extensions (80500 and 80501) to extend 6010303 and 6010900 job ticket reports.
- Codeunits (80500 and 80501) to add rich text descriptions to the dataset.
- Table extensions (80500 and 80501) to add the rich text fields to the job ticket temporary tables.
- Enum extension 80501 to extend line type.

## What you will need to do for this extension to work

- Select the new report layout (Job Ticket Rich Text) when generating the job ticket report.