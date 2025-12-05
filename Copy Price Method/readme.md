# Copy Price Method

PrintVis Copy-To and Copy-From functionality makes an exact copy of the case / job being copied.
 
This code adjusts this functionality so that the job line price method is automatically set back to Calculated when the copy is completed.

## What this extension includes:

- An event subscriber (codeunit 80279) that extends the normal procedure by changing the price method to calculated after the copy is complete.
