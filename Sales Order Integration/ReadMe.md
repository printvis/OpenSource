# Sales Order Integration

For many years, PrintVis has been able to integrate from regular BC sales orders. 

The use-cases would be for example;

    The company sells printed items among other things which are just merchandise from a purchased stock
    The company often takes orders of different printed items and likes how this can be organized on a sales order
    The company sells a lot of re-orders and the customers orders by item numbers

The sales order lines offer a nice way to organize these orders in a way which is easy to understand for the sales staff. Each line can refer to its own production order and have a separate production route through production and status code flow. An alternative (more advanced and with complexity) is to use PrintVis Project Management. 

Over the years we've had many requests for changes to the way the Sales Order integration functions for specific customers with many of these requests conflicting with requests from other customers. This is the reason we have decided to provide this sales order integration as an Open Source app so partners/customers can modify this code directly to meet the exact customer requirements. 

The extension will add some fields to the sales order header and sales order lines. The extra fields can be identified by zooming (CTRL+ALT+F1) while on the header or line, the fields will be numbered in the 80101..80133 range.

## What this extension includes:

If you are new to the sales order integration you only need the **PTE SalesOrder Integration** folder. 

We have included 2 additional folders/apps:
* PTE Sales Order Integration Move Data
* PTE Sales Order Integration Temporary DataTransfer
to be used if migrating from our previous SalesOrder Integration app to this new OpenSource app.

## What you will need to do for this extension to work

If you are new to the sales order integration, you can follow our setup guide to learn how this is setup and used here: <a href="https://learn.printvis.com/Legacy/salesorder/" target="_blank">Sales Order Integration guide</a>

If you are migrating from existing sales order integration to this open source sales order integration, follow these steps:

1. Add DataTransfer extension
   a) Upload and install the "PrintVis_PTE Sales Order Integration Temporary DataTransfer_1.0.0.0.app" extension from the PTE Sales Order Integration Temporary DataTransfer folder.
   - This is a temporary app that can be removed later.
   - Run the codeunit 80108 using the "PrintVis Run Generic Object" page. This will move the data from existing Sales Order Integration into temporary tables.
2) Remove the existing "Sales Order Integration" or "PTE Sales Order Integration" extension.
3) Add Remaining extensions
   a) Upload and install the "PrintVis_PTE Sales Order Integration_1.0.0.0.app" extension from the PTE SalesOrder Integration folder
   b) Upload and install the "PrintVis_PTE Sales Order Integration Move Data_1.0.0.0" extension from the PTE Sales Order Integration Move Data folder
   - The Move Data app is a temporary app that can be removed later. 
   - Run the codeunit 80109 using the "Run Generic Object" page. This will move the data from the temporary tables into the open source sales order integration.
4) Remove Apps
  a) uninstall and unpublish the "PTE Sales Order Integration Move Data" app.
  b) uninstall and unpublish the "PTE Sales Order Integration Temporary DataTransfer" app.
