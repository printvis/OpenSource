# Sales Order Integration

This extension can be used 

## What this extension includes:


## What you will need to do for this extension to work

1. Add  Datatransfer App
   a) Upload and install the "PTE Sales Order Integration Temporary DataTransfer" app
   - a temporary app that can be removed later.
2) Moving data from Sales Order Integration and PrintVis to "PTE Sales Order Integration Temporary DataTransfer"
   a) run the codeunit 80108, it can be done by adding at the end of the URL a ?codeunit=80108 or through the page "Run Generic Object"
3) Remove "Sales Order Integration" or "PTE Sales Order Integration"
 a) uninstall and unpublish / remove the App "Sales Order Integration" or "PTE Sales Order Integration"
4) Add Remaining Apps
   a) Upload and install the "PTE Sales Order Integration" app
   b) Upload and install the "PTE Sales Order Integration Move Data" app
   - a temporary app that can be removed later. 
5) Moving data from "PTE Sales Order Integration Temporary DataTransfer" and PrintVis into "PTE Sales Order Integration"
   b) Run the codeunit 80109 it can be done by adding at the end of the URL a ?codeunit=80109 or through the page "Run Generic Object"
6) Remove Apps
  b) uninstall and unpublish / remove the App "PTE Sales Order Integration Move Data"
  c) uninstall and unpublish / remove the App "PTE Sales Order Integration Temporary DataTransfer"
7) Done