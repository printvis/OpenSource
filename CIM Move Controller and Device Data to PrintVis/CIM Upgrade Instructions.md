PrintVis 26 Feature Release have had some major changes in the PrintVis CIM app, that will prevent existing installation from upgrading directly.
The reason for this - was that 2 tables were moved into the PrintVis App from the PrintVis CIM App(PTE App for Cloud)

To limit the amount of breaking changes - the following has been done:
- *Moved some parts of the Pages into the PrintVis App with the same name, where the remaining parts have been kept as a new PageExtension*
- *The same has been done to the tables "PVS CIM Controller" and "PVS CIM Device".*
  
An upgrade guide has been made, that needs to be followed to get data transferred from a older version into the newer version.

**#!!!WAIT!!!
#!!!This will not move custom fields in "PVS CIM Controller" and "PVS CIM Device"!!!
#!!!Add the custom fields into the 'PTE CIM 1 - upg temp tables' before continuing with the upgrade!!!**

*!!!When moving data on step 3, please verify the tables has data!!!*
*!!!Table 80265 for Cost Center - Device Code data being moved!!!*
*!!!Table 80264 for Controller data being moved!!!*
*!!!Table 80263 for Device data being moved!!!*

Cloud only needs to follow the information outlined above and below, where they can ignore the Powershell script
OnPrem / Container - use the appropriate Powershell script, before running the script - update the input section in the top of the script. 

1. Install App 1 'PTE CIM 1 - upg temp tables'
*- triggers upgrade "move data from PrintVis into App 1"*

2. Uninstall + Unpublish 'PrintVis CIM'

3. Install 'PrintVis' - version 26.1.1.0
4. Install 'PrintVis CIM' - version 26.1.1.0
**- install with mode = Force**

5. Install App 3 'PTE CIM 1 - Move Data into PrintVis'
*- triggers upgrade "Move Data from App 1 into PrintVis CIM"*
6. Uninstall + Remove App 3 
**- Delete Extension Data**

7. Go to the Browser and connect to the Business Central system and check if there exists data in PrintVis CIM Controller.
8. Verify Data exists in CIM Controller + CIM Device + Cost Center.Device Code
9. Uninstall + Remove App 1 - **Delete Extension data** 

10. Done
