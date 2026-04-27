# Auto Lock Milestones

Planning units in PrintVis can be marked as locked as a manual process by the user. Depending on setup, a locked planning unit cannot be moved unless it is first unlocked.

This extension automates the locking of planning units that are marked as milestones. If a milestone planning unit is moved by the user, it is automatically set to **Locked** status. It must then be manually unlocked before the milestone can be moved again.

## What this extension includes

- Codeunit 80199 **"PTE AutoLock Milestone"**

## How it works

The codeunit subscribes to the `On_Before_Check_Planning_Method` event in `PVS Planning Management`. When the planning status of a planning unit is being evaluated after a move:

1. It checks if the planning unit is marked as a **Milestone**.
2. It verifies that the planning unit has a start time (i.e., it has been moved).
3. It confirms the current planning status is **Variable Planned**.
4. If all conditions are met, the planning status is set to **Locked** and the standard procedure is bypassed.

## Prerequisites to run the functionality

- PrintVis dependency available (minimum version 24.0.0.0).
- Business Central application compatible with version 24.0.0.0.
- Planning units must be marked as **Milestone** for the auto-lock logic to apply.

## What you will need to do for this extension to work

- Install the .app extension in your environment.
- Ensure the PrintVis app is installed and meets the dependency version.
- Mark the relevant planning units as **Milestone**. The lock is applied automatically when a milestone is moved.

