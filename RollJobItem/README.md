# Roll Job Item

This extension is intended for companies that cut roll stock down before printing and print on sheets. The cutting operator consumes roll stock and uses Release Finished Goods to release cut sheets into inventory. The press operator then consumes those sheets at the press. To avoid double-charging for paper, either the sheet item or the roll item should have a price of zero in PrintVis estimating.

## What this extension includes

- Table extension 80100 **"PTE Sheet Roll"** extends **"PVS Job Sheet"** — adds the **Roll Item No.** field.
- Page extension 80100 extends **"PVS Job Items ListPart"** — allows the user to enter the Roll Item No. on each job item.
- Codeunit 80100 **"PTE Roll Custom Formula"** — custom calculation formula that calculates the weight, area, or length of the roll paper and assigns the roll item number to the calculation detail line.

## How it works

The custom formula codeunit is triggered during PrintVis calculation when formula 80100 is evaluated:

1. It retrieves the Roll Item No. from the job sheet and looks up the item record.
2. It sets the item number on the calculation detail line to the roll item, replacing the standard sheet paper item.
3. It calls standard formula 16 to get the base quantity of paper (sheets with scrap).
4. Based on the roll item's price unit, the quantity is converted: weight (price unit 2), area (price unit 3), or length (price unit 4).
5. The converted quantity and the roll item's price unit are written back to the calculation detail line.

## How to configure

Step 1 Install the extension in your Business Central environment.

Step 2 Create a custom calculation formula with number **80100** pointing to Codeunit 80100.

Step 3 Assign this formula to a material line on your cutting machine calculation unit.

Step 4 On the Job Items ListPart, enter the Roll Item No. on each job sheet that uses roll stock.

## Prerequisites to run the functionality

- PrintVis dependency available (minimum version 24.0.0.0).
- Business Central application compatible with version 24.0.0.0.
- A roll stock item must exist in Business Central with the appropriate price unit (weight, area, or length).

## What you will need to do for this extension to work

- Install the .app extension in your environment.
- Ensure the PrintVis app is installed and meets the dependency version.
- Create the custom calculation formula 80100 and assign it to the cutting machine calculation unit as described above.
