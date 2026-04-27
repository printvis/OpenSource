# Filter Order Only

This extension adds a **Show Only Orders** toggle to the PrintVis Case Card that filters the jobs list to display only jobs with a status of **Order**. When the Case Card is opened for a case of type Order, the filter is applied automatically.

## What this extension includes

- Page extension 80196 **"PTE Case Card"** extends **"PVS Case Card"** — adds the **Show Only Orders** toggle field.
- Page extension 80197 **"PTE Job ListPart"** extends **"PVS Job ListPart"** — filters the jobs list based on the toggle value.

## How it works

The page extensions work together to control the jobs list filter:

1. When the Case Card is opened, if the case type is **Order**, the **Show Only Orders** toggle is automatically set to true and the jobs list is filtered to show only Order-status jobs.
2. When the user changes the **Show Only Orders** toggle, the jobs list filter is immediately applied or removed.
3. If the user tries to enable **Show Only Orders** on a case that is not of type Order or higher, an error is raised.

## How to configure

Step 1 Install the extension in your Business Central environment.

Step 2 Open a PrintVis Case Card.

Step 3 Use the **Show Only Orders** toggle to filter the jobs list. The toggle is set automatically when opening an Order-type case.

## Prerequisites to run the functionality

- PrintVis dependency available (minimum version 25.3.0.0).
- Business Central application compatible with version 25.3.0.0.

## What you will need to do for this extension to work

- Install the .app extension in your environment.
- Ensure the PrintVis app is installed and meets the dependency version.
- No additional configuration is required. The filter is applied automatically on Order-type cases.
