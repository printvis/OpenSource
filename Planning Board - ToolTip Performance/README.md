# Performance when reloading planning board

When loading the planning board, most performance is used by generating Toolstips based on the setup.
By using an event, we can the the tools tip by code - and thus bypassing the setup, which can improve performace a lot.

 
This code is using the normal setup rules when opening the planning board, but saves the tool tip on the planning unit, and reuses this text when reloading the planing board - only generating new ttol tips for planning units not used before.

## What this extension includes:

- A table extension (80800) on the "PVS Job Planning Unit"  adding two extra fields to hold the tool text and search text.

- An event subscriber (codeunit 80800) that saves the generated tooltip/searchtext on the planning unit, and reuses it later insted of rebuilding again
