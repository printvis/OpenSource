# Establishes a Wait planning unit status based on status code setup that is ignored when auto scheduling

This extension can be used at companies that want to create planning units at a certain status but don't want auto-scheduling to schedule these planning units yet. An example would be that milestones are needed at a specific status but the production planning units should not yet be scheduled.

## What this extension includes:

- Codeunit (80207) to update the plan unit status to Wait when the case is moved to the selected status code.
- Table extensions (80207 and 80208) to rename an unused planning status = Wait and create a field on the General Setup page for Schedule Milestones Only status code.
- Page extensions (80207 and 80208) to add the field to the General Setup page and to update the Production Plan page so Wait status shows in the Inbox.

## What you will need to do for this extension to work

- Select the Status Code on the General Setup page where you want only Milestones in the Not Planned status while other planning units have a status of Wait.
