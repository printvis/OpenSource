# Sales Order Integration

PrintVis has long supported integration with standard Business Central sales orders. This allows companies that sell printed items alongside other merchandise, or that prefer to organize orders on a sales order, to use BC sales orders as the entry point for PrintVis production orders.

Each sales order line can refer to its own production order and have a separate production route and status code flow. Because requirements vary greatly between customers, this integration is provided as open source so partners and customers can modify it directly to meet their exact needs.

The extension adds fields to the sales order header and lines. These extra fields are numbered in the 80101..80133 range and can be identified by using the field inspection shortcut (CTRL+ALT+F1) while on the header or line.

## What this extension includes

If you are new to the sales order integration, you only need the **PTE SalesOrder Integration** folder.

Two additional apps are included for customers migrating from the previous Sales Order Integration app:

- **PTE Sales Order Integration Move Data** — moves data from temporary tables into the open source app after migration.
- **PTE Sales Order Integration Temporary DataTransfer** — a temporary app that moves data from the existing app into temporary tables before migration.

## How it works

The extension subscribes to Business Central sales order events to create and manage linked PrintVis production orders:

1. When a sales order line is created or modified with a PrintVis item, the extension creates or updates the corresponding PrintVis case and job.
2. The sales order header and line carry additional fields that track the linked PrintVis case, job, and production status.
3. Status changes on the PrintVis case are reflected back on the sales order line, allowing sales staff to track production progress directly from the sales order.

## How to configure

Step 1 Install the **PTE SalesOrder Integration** app in your Business Central environment.

Step 2 Follow the setup guide at [learn.printvis.com/Legacy/salesorder/](https://learn.printvis.com/Legacy/salesorder/) to configure the integration.

Step 3 If migrating from the previous Sales Order Integration app, follow the migration steps described below.

## Migration from previous Sales Order Integration

If you are migrating from the existing Sales Order Integration app, follow these steps:

1. Install **PTE Sales Order Integration Temporary DataTransfer** and run codeunit 80108 using the **PrintVis Run Generic Object** page to move existing data into temporary tables.
2. Uninstall and unpublish the existing Sales Order Integration or PTE Sales Order Integration extension.
3. Install **PTE SalesOrder Integration**, then install **PTE Sales Order Integration Move Data** and run codeunit 80109 using the **Run Generic Object** page to move data from temporary tables into the new app.
4. Uninstall and unpublish both the **PTE Sales Order Integration Move Data** and **PTE Sales Order Integration Temporary DataTransfer** apps.

## Prerequisites to run the functionality

- PrintVis installed and configured in Business Central.
- Sales order integration setup completed as described in the setup guide.

## What you will need to do for this extension to work

- Install the **PTE SalesOrder Integration** .app extension in your environment.
- Ensure the PrintVis app is installed.
- Complete the setup following the guide at [learn.printvis.com/Legacy/salesorder/](https://learn.printvis.com/Legacy/salesorder/).
