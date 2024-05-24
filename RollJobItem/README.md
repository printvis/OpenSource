# Roll Job Item

This extension can be used at companies that often cut roll stock down before printing and print on sheets. It would require the cutting operator to consume the amount of roll stock that is cut and use release finished goods to release sheets into stock. The press operator would then consume the sheets at the press. Either the sheets or the roll would need to have a 0 price in PrintVis estimating so it does not charge twice for the paper.

## What this extension includes:

- A table extension (80100) on the PVS Job Sheet table to add Roll Item No.
- A page extension (80100) on the PVS Job Items ListPart for the user to enter the Roll Item No.
- A custom calculation formula codeunit (80100) that will calculate the weight/length of the roll paper and add the roll item no. to the calculation detail line.

## What you will need to do for this extension to work

- Create a custom calculation formula with # 80100 that points to Codeunit 80100. Assign this formula on a material line on your cutting machine calculation unit.