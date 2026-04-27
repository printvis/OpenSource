# Split Production

This extension adds functionality to the PrintVis versioning feature. After creating product parts in PrintVis, it is possible to create versions and variants and combine them on a sheet or create plate changes. Normally, a plate change is produced on the same machine — the machine is stopped, plates are changed, and production continues for the next version.

This extension supports an alternative workflow: instead of a plate change on the same machine, a version can be moved to a different machine so that versions are produced in parallel, completing production faster.

## What this extension includes

- Table 80180 **"PTE Job Shift Split"**
- Page 80181 **"PTE Job Split"** — opened by the **Split Production** action on the Job Card.
- Page 80180 **"PTE Job Item Combined Variants"**
- Codeunit 80182 **"PTE Prepare Job"** — automates creation of versions/variants and plate changes.
- Codeunit 80183 **"PTE Split Mgt"** — manages the split process.
- Codeunit 80180 **"PTE Split Process"** — creates and merges job items as configured on the split page.
- Codeunit 80181 **"PTE Helperfunction"**
- Table extension 80180 **"PTE Job Item"** extends **"PVS Job Item"**
- Page extension 80180 **"PTE Job Card"** extends **"PVS Job Card"** — adds the **Prepare Job for Split Production** and **Split Production** actions.
- Page extension 80181 **"PTE Job Item Listpart"** extends **"PVS Job Items ListPart"**

## How it works

Two new actions are added to the **PVS Job Card**:

1. **Prepare Job for Split Production** — automatically creates versions/variants, creates plate changes for each additional version/variant, and assigns each version/variant to a plate change.
2. **Split Production** — opens the **PTE Job Split** page, which shows one line per sheet and plate change. From here, the operator can assign each plate change to a new or existing job item on a different machine.

On the **PTE Job Split** page, for each line the operator can:
- Enter a new job item number to assign the plate change to a new sheet. If the job item number does not exist, a new sheet is created.
- Change the printing machine (**Controlling Unit**), the **Paper Item No.**, and the finishing type (**Finishing**).

When the **Create Split Job Items** action is run, the sheets and job items are created and merged as configured. The **Undo Changes** action resets all changes to the state when the page was opened. **Copy Mode** lets the operator copy settings from one line to multiple selected lines using **Copy Settings to Marked Lines**.

## How to configure

Step 1 Install the extension in your Business Central environment.

Step 2 Open a PrintVis Job Card for a job line of type **Production Order** that has product parts and sheets/job items already entered.

Step 3 Use the **Prepare Job for Split Production** action to automatically create versions and plate changes, then use **Split Production** to assign versions to different machines.

## Prerequisites to run the functionality

- PrintVis dependency available (minimum version 24.0.0.0). Events used in this extension are available from PV23 and later.
- The job line must be of type **Production Order**.
- Product parts and sheets/job items must be entered before running the split functionality.

## What you will need to do for this extension to work

- Install the .app extension in your environment.
- Ensure the PrintVis app is installed and meets the dependency version.
- Use the **Prepare Job for Split Production** action before using **Split Production**.
