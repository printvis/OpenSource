# Automated Job Signatrures

PrintVis is writing the AssemblySection into the Assembly Node of the JDF, which describes how the sections for the PrintVis Job Items are bound together. The Assembly setting must be made manually in the **PrintVis Job Signatures** by the user.
 
This code automates the building of the **PrintVis Job Signatures** and covers the following topics:
- Sheets/Job Items with component type setting _JDF Product Type =Cover_ exists, this will be the first line (Assembly Order =1) in the list. (Only 1 cover is supported).
- Residual sheets with 4 pages on the last job item are moved to be the second last line. 
- Job Signatures are indented based on the CIP3 Binding/Finishing setup on the **PrintVis Cost Center Configuration** or **PrintVis Finishing Types**. The supported settings are, HardCover (Assembly Order=List), SoftCover (Assembly Order=List) and SaddleStitch (Assembly Order=Collecting). 
The code will only build the Job Signatures automatically if no manual changes has been made. To reset the manual settings the user can hit the action **Rebuild Signatures**. 

## What this extension includes:

- An event subscriber (codeunit 88200) that potentially replaces the normal procedure that is building the sorting order of signatures
- A page extension (80200) on the "PVS Job Print Signature" worksheet adding an action to rebuild the sorting orders of signatures.
