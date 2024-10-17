# Split Production

This extension adds functionality to the PrintVis **versioning functionality**. After creating product parts in PrintVis, it is possible to create versions and variants and combine these versions on a sheet or create plate changes. 
Typically, a plate change is produced on the machine that is set up on the current sheet. It means the machine is stopped, plates are changed and then the machine proceeds producing the next version based on the plate change.

If plate changes are created, this extension comes into play. It supports to create new job items/sheets and combine plates changes on the sheet, in case it is desired instead of a plate change on the same machine, to move the production for a version to another machine. The idea is that the production can be processed and finished much faster because the versions are produced in parallel on different machine. 

## What this extension includes:

- New actions “Prepare Job for Split Production” and "Split Production" on the Job Card. Description below.
- Table 80180 "PTE Job Shift Split"
- Page 80181 "PTE Job Split"
- Page 80180 "PTE Job Item Combined Variants"
- Codeunit 80182 "PTE Prepare Job"
- Codeunit 80183 "PTE Split Mgt"
- Codeunit 80180 "PTE Split Process"
- Codeunit 80181 "PTE Helperfunction"
- Table extension 80180 "PTE Job Item" extends "PVS Job Item"
- Page extension 80180 "PTE Job Card" extends "PVS Job Card"
- Page extension 80181 "PTE Job Item Listpart" extends "PVS Job Items ListPart"

A new action **Prepare Job for Split Production** is added on Page PVS Job Card (6010334). This action triggers:
- An automated creation of Version/Variants 
- The creation of plate changes for each additional Version/Variants
- The assignment for each Version/Variant on a plate change
A new action ** Split Production** is added on Page PVS Job Card (6010334). This action opens the page PTE Job Split (80181) that displays 1 line per sheet and plate change.

### How to use page **Job Item Split** that open when action "Split Production" is hit?

**Step 1**
For each line it is now possible to enter a new job item no. to add this job item/plate change to. When entering a new (not existing) job item no. a new sheet/job items is created. 

**Step 2** 
It is now possible to change:
- The printing machine (field **Controlling Unit**)
- The **Paper Item No.**
- The finishing type (field **Finishing**)

**Step 3** 
When hitting action **Create Split Job Items** the sheets and job items are created and merge together as set on this page.

**Additional actions**
**Undo changes** is resetting all changes made on this page to the initial settings when opening this page.

**Copy Mode**
This filters for the current line and only shows the other lines for the same sheet. Lines can be multi-select to copy the changes that were made on the current line before running the copy mode by using the action **Copy Settings to Marked Lines**. The Action **Normal Mode** is switching back to the initial view.

### Prerequisites to run the functionality

- The job line to run this code must be of type **Production Order**.
- Product Parts and Sheets/Job Items must be entered/created before running this functionality.

## What you will need to do for this extension to work
 
- Create a PTE and install it on an environment.
- Events are in use that are available from PV23 and ongoing.
