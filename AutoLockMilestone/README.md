# Auto lock milestones

Planning units in PrintVis can be marked as locked as a manual process by the user. Depending on setup, a locked planning unit cannot be moved unless it is unlocked.
 
This code automates the setting of status locked on planning units. If a planning unit marked as a milestone, is moved by the user, it will automatically be marked as locked. So it will require a manual unlocking before the milestone can be moved again

## What this extension includes:

- An event subscriber (codeunit 80199) that potentially replaces the normal procedure controlling the planning status after a manual move.

