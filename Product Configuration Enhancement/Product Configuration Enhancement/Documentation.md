# Product Configuration Enhancement – End-User Documentation

## Overview

**Product Configuration Enhancement** is an add-on for PrintVis that lets you define
detailed, reusable **Job Item templates** directly on the Product Card. When a product is
applied to a Job, these templates are automatically copied onto the Job's Job Items,
saving time on repetitive manual setup for multi-component products (for example, a book
with a cover and inner pages, or an envelope with several sub-parts).

It also exposes the PrintVis **Job User Fields** setup on the Product Card, so User Field
values can be prepared once on the product and automatically carried over to every Job
that uses it.

## Where to find it

Everything is added to the standard **PrintVis Product Card** page:

- A new **Product Job Items** section (below the "Inks and Consumables" area).
- A **User Fields** action group (next to the "Additional Info" actions).

No new menu items or role center entries are required — open any Product Card as usual.

## Product Job Items

The **Product Job Items** part on the Product Card lets you build one or more template
lines describing the components of the product (e.g. "Cover", "Text pages", "Insert").
Each line is a full template for one Job Item, including size, paper, colors, tools,
finishing and more.

### Fields on a Product Job Item line

| Field | Description |
|---|---|
| Job Item No. | Sequential number identifying the line. Assigned automatically for new lines. |
| Component Type | Classifies how this job item is treated in production calculation (e.g. Cover, Text). |
| No. of Pages | Total number of pages for this component. Must be an even number. |
| Pages with Print | Number of pages that carry print. |
| Format Code | Optional standard format (paper/substrate/plate size) to apply. When set, it fills in Format1/Format2 automatically according to the general Format Entry setup. |
| Format1 / Format2 | Manual size values, used when no Format Code is selected. |
| Weight | Paper/substrate weight. |
| Imposition Code | Links a specific imposition type; also used to derive Format1/Format2 automatically for pages-on-sheet layouts. |
| Paper No. | The paper/substrate item. Selecting an item automatically pulls its weight (if defined). |
| Paper Description | Read-only description of the selected paper item. |
| Finishing | Finishing type to add to estimations for this component. |
| Colors Front / Colors Back | Number of print colors on the front and back side. |
| Tool 1–4 | Tools required when re-running this component. |
| Media Type | Optional media classification (e.g. Envelope, Envelope Plain, Envelope Window). |
| List of Units | The calculation unit (cost center/machine) this component is produced on. |
| Configuration | The Cost Center Configuration to use for the List of Units. Resolved automatically when only one configuration matches the component's size/weight; if several match, you are prompted to choose. |
| Envelope Window Shape Type / Size X / Size Y | Envelope window details, relevant only for envelope media types. |
| Opacity / Opacity Level | Opacity classification and level of the substrate. |

### Working with Product Job Item lines

- **New Job Item** – adds a blank template line to the product. Header values (format,
  paper, colors, tools, etc.) already set on the Product itself are copied in as a
  starting point.
- **Copy Job Item** – duplicates the currently selected line as a new line, useful when
  several components are very similar.
- **Colors / Materials** – opens the ink/consumable lines (colors, coverage, washups,
  plates, etc.) for the selected job item. You can also drill down directly from the
  **Colors Front** or **Colors Back** fields to open the same list.
- Deleting a line removes that component's template; it does not affect Job Items already
  created on existing Jobs.

### Colors / Materials

Each Product Job Item can have its own set of ink/consumable lines, matching the standard
PrintVis "Inks and Consumables" concept but scoped per component:

| Field | Description |
|---|---|
| Item Quality Code | Quality of the ink/consumable. |
| Item No. | The ink/consumable item. Lookup is restricted to items matching the selected Item Quality Code, if any. |
| Text / Text 2 | Description(s), pulled from the item and editable. |
| F/B | Whether the color prints on the Front, Back, or Both sides. |
| Type | Base Color, Spot Color, or Other. |
| Coverage Pct. | Percentage of the sheet covered at 100% coverage. |
| Area Per Weight | Area covered per unit of ink at 100% coverage. |
| No. of Washups | Number of color changes/washups to count. |

New lines automatically inherit the Product Code and Job Item No. of the component you
opened them from.

## User Fields on the Product Card

Three new actions, **User Fields 1**, **User Fields 2**, and **User Fields 3**, are added
next to the standard Additional Info actions. Each opens the combined user field editor
for the product, using the same field/option definitions configured for **Job User
Fields** in PrintVis General Setup.

- Each action is only visible if the corresponding Job User Fields group (1, 2, or 3) is
  enabled in **General Setup**.
- Shortcut keys: Shift+Ctrl+F1, Shift+Ctrl+F2, Shift+Ctrl+F3.
- Values entered here are stored against the product and are automatically copied to the
  Job's user fields the next time this product is applied to a Job (see below).

## What happens when a product is applied to a Job

When you set/change the **Product Code** on a PVS Job, the following happens
automatically, without any extra steps:

1. **Header fields** – if the product has a Format Code and/or Colors Front/Back set,
   these are copied onto the Job header.
2. **User Fields** – any values entered via User Fields 1/2/3 on the product are copied
   onto the Job's user fields.
3. **Job Items** – every Product Job Item line on the product is matched to a Job Item on
   the Job (by Job Item No.):
   - If a matching Job Item does not yet exist, a new sheet and Job Item are created.
   - If it exists, its fields are updated wherever the template line has a value set
     (component type, page counts, size, paper, colors, tools, media/envelope/opacity
     settings, list of units/configuration).
   - Fields left blank on the template are not overwritten, so manual adjustments already
     made on the Job are preserved where the template doesn't specify a value.
   - Any extra Job Items on the Job that don't correspond to a template line are left
     untouched.

This means the recommended workflow is:

1. Build out the product's components once, on the Product Card, using **Product Job
   Items**.
2. Set up User Fields on the product if applicable.
3. Apply the product to any Job as usual — sizes, paper, colors, tools and user fields for
   every component are filled in automatically.

## Tips

- Set up **Format Code** or **Imposition Code** on a template line instead of manual
  Format1/Format2 where possible, so sizes stay consistent if the underlying master data
  changes.
- Use **Copy Job Item** to quickly create near-identical components (e.g. multiple insert
  types) and then adjust only the differing fields.
- If **Configuration** shows blank after choosing a **List of Units**, either no
  configuration matches the current size/weight, or more than one does — in the latter
  case, drill down into **Configuration** to pick the correct one manually.
