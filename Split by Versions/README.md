# Split by Versions

This extension allows companies to use product versions to describe different bind types and their quantities. A **Split by Version** action is added to the Job Items section. When used, the operator selects whether the current sheet is a common text sheet and then selects the product versions for the split. Special boolean fields and custom calculation formulas control how planning, calculation, and platemaking are handled for each version type.

- A **Common Text** sheet (boolean = true) creates only one platemaking calculation unit and one planning unit with the combined total time for all common text sheets.
- An **Additional Version** sheet (boolean = true) uses special formulas 8199, 8200, and 8201. Formula 8199 (printing) uses formula 22 for the first version and formula 155 for additional versions. Formula 8200 (paper) uses formula 14 for the first version and formula 145 for additional versions. Formula 8201 (setup) returns 1 for the first version and 0 for additional versions.

## What this extension includes

- Codeunit 80280 **"PTE Split Bind Formula"** — adds three new calculation formulas (8199, 8200, and 8201).
- Codeunit 80281 — builds combined planning units for common text sheets.
- Table extension 80280 and page extension 80280 on **"PVS Job Item"** — adds three fields: **Additional Version** (boolean), **Common Text** (boolean), and **Split Version** (text showing Process Group).
- Table extension 80281 and page extension 80281 on **"PVS Job Planning Unit"** — adds the Process Group value to the planning unit.
- Page 80280 — lookup page for product versions used by the **Split by Version** action.

## How it works

When the **Split by Version** action is used on the Job Items section:

1. The operator is asked whether the selected sheet is a common text sheet.
2. A list of product versions is presented. The operator selects the versions to split across.
3. The selected versions are applied to the job items, setting the **Common Text** and **Additional Version** boolean fields accordingly.
4. During calculation, formulas 8199, 8200, and 8201 use the version type flags to apply the correct formula logic for printing, paper, and setup.
5. During planning, common text sheets are combined into a single planning unit with aggregated time.

## How to configure

Step 1 Install the extension in your Business Central environment.

Step 2 Create three new custom calculation formulas with numbers **8199**, **8200**, and **8201**, each pointing to codeunit 80280.

Step 3 Assign formula 8201 to the setup process and formula 8199 to the printing process on the printing machine calculation unit. Assign formula 8200 to the paper process.

## Prerequisites to run the functionality

- PrintVis dependency available (minimum version 25.0.0.0).
- Business Central application compatible with version 26.0.0.0.
- PrintVis System Library dependency available (minimum version 25.0.0.0).

## What you will need to do for this extension to work

- Install the .app extension in your environment.
- Ensure the PrintVis app and PrintVis System Library are installed and meet the dependency versions.
- Create the three custom calculation formulas (8199, 8200, 8201) and assign them to the appropriate calculation units as described above.
