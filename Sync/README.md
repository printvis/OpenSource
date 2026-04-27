# PrintVis Sync

This extension provides multi-company data synchronization for PrintVis across Business Central environments. It allows selected PrintVis tables to be kept in sync between a master company and one or more local companies, supporting scenarios where setup data or configuration records need to be shared consistently across multiple Business Central companies or tenants.

## What this extension includes

- Table 80200 **"PVS Sync Table Setup"** — defines which tables are synchronized and their sync direction.
- Table 80201 **"PVS Sync Log Entry"** — logs all synchronization events for auditing and processing.
- Table 80202 **"PVS Sync Field Setup"** — controls per-field sync behavior (force sync, skip, or skip if not empty).
- Table 80203 **"PVS Sync Field Mapping"** — maps field values between companies during sync.
- Page 80200 **"PVS Sync Table Setup"** — administration page for configuring which tables to sync and their direction, with actions to configure fields and field mappings.
- Page 80204 **"PVS Sync Log"** and query **"PVS Sync Log Entries"** — view and monitor sync log entries.
- Codeunit 80200 **"PVS Sync Processing Management"** — processes sync log entries and applies changes to target companies via API calls.
- Codeunit 80204 **"PVS Sync Communication Mgt"** — handles HTTP API communication with target Business Central companies.
- Codeunit 80205 **"PVS Sync Change Management"** — tracks record changes and writes sync log entries.
- Codeunit 80206 **"PVS Sync OAuth Comm. Mgt."** — handles OAuth 2.0 authentication for Business Central Online environments.
- Codeunit 80203 **"PVS Sync Json Exchange"** — handles JSON serialization and deserialization for API communication.
- Report 80200 **"PVS Sync Job Queue Processor"** — can be run via a job queue entry to process the sync log automatically.
- Page extensions on **"PVS Business Group Setup"** and **"PVS Business Group Setup List"** — adds API connection fields and OAuth configuration to the Business Group setup.

## How it works

The extension monitors changes to configured tables and synchronizes those changes to target companies through the Business Central API:

1. When a record in a tracked table is inserted, modified, renamed, or deleted, the change management codeunit writes an entry to the sync log table, recording the affected record and operation type.
2. The sync log is processed either manually or via a scheduled job queue entry. For each log entry, the processing management codeunit determines the target companies based on the sync direction configured for the table.
3. For each target company, the codeunit reads the current record data, serializes it to JSON, and sends it to the target company via the Business Central API using Basic authentication or OAuth 2.0.
4. Processed log entries are marked as complete and are automatically cleaned up after two days.

## How to configure

Step 1 Open **PrintVis Business Group Setup** and configure the API connection settings for each business group (server, port, instance, credentials). For Business Central Online, enable **OAuth 2.0** and provide the Client ID, Client Secret, and Redirect URL. Use the **Verify Connection** action to test connectivity.

Step 2 Open the **PrintVis Sync Table Setup** page and add the tables you want to synchronize. Set the **Sync Direction** for each table (Master to Local, Local to Master, or All Business Groups).

Step 3 For each table, use the **Fields** action to exclude specific fields from sync, and the **Field Mapping** action to configure value transformations between companies.

Step 4 Create a job queue entry pointing to Report 80200 (**PVS Sync Job Queue Processor**) to process the sync log automatically on a schedule.

## Prerequisites to run the functionality

- PrintVis dependency available (minimum version 21.0.0.0).
- Business Central application compatible with version 20.0.0.0 or later.
- API access must be enabled on all target Business Central environments.
- For Business Central Online, an Azure AD app registration with the appropriate API permissions is required for OAuth 2.0 authentication.

## What you will need to do for this extension to work

- Install the .app extension in your environment.
- Ensure the PrintVis app is installed and meets the dependency version.
- Configure Business Group API connection settings and verify connectivity.
- Set up the Sync Table Setup to define which tables to synchronize.
- Create a job queue entry for automated sync processing.
