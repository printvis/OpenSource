# Split bind open source app

This extension can be used at companies that want to be able to use product versions to describe different bind types and their quantities. A new action is added to the Job Items section called Split by Version. This action will ask if the selected Sheet is a common text or not and then give a list of the product versions to select for the split process. If you select Common Text = yes, a Common Text boolean will be set to true. There is also a new Additional Version boolean that will be marked true for every sheet created after the first one in the split process. These boolean fields have impact on the creation of the calculation units, how new special formulas are calculated, and how planning is set.

- Common Text boolean = true will only create 1 platemaking calculation unit. It will also only create 1 planning unit with the combined total time for each common text sheet.
- Additional version boolean = true will be used in the new 8199, 8200, and 8201 formulas. 8199 (printing) will use formula 22 for first version and formula 155 for all additional versions, 8200 (paper) will use formula 14 for first version and formula 145 for all additional versions, and 8201 (setup) will return "1" for first version and "0" for additional versions.

## What this extension includes:

- Codeunits (80280) to add 3 new formulas (8199, 8200, and 8201) and codeunit (80281) to build planning units for common text that are combined. 
- Table and page extension (80280) adds 3 fields to the job items table: Additional Version (boolean), Common Text (boolean), Split Version (Text[250]) to show Process Group and table and page extension (80281) adds the Process Group value to the pvs job planning units table/page.
- Page (80280) is a lookup page to the product versions when using the Split by version action.

## What you will need to do for this extension to work

- Create 3 new formulas 8199, 8200, 8201 as a codeunit formulas pointing to codeunit 80280.
- Assign these formulas to the printing machine setup (8201) / printing (8199) processes and the paper (8200) process.