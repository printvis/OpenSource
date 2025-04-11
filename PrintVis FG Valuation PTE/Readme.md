# Finished Goods Valuation

This extension provide a way to keep proper value for finished good outputed with a printvis Case. 
Currently this extention assume that there is only one finished goods item per case.  

## What this extension includes:

- Table (75200 "PTE PVS FG Valuation") wich keep the summarize of an printvis output.  
- Page (75200 "PTE PVS FG Valuation List") that contains the summarize of all printvis output with following actions: creating an output entries (for already existing output), current output adjustement and general adjustements.
- A codeunit that manage the whole logic of valuation. This codeunit can be run with a job queue entries if we want to keep the valuation automatically.
- An event subscriber (codeunit 75201) to automatically mark a output line to be reevaluate. 

## What you will need to do for this extension to work

- Install the extention in BC 23 or ealier with printvis.