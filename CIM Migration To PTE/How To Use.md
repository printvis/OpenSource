# CIM App Migration

### This Project is for migration of the Old CIM OnPrem App the the new PTE App
This is a 3 part process

Part 1 - Move the CIM Data to the Migration App
Part 2 - Remove dependency for the old version
Part 3 - Move data to the new PTE App

You will need to compile a app foreach of the above parts.
Each part have a folder called Upgrade Part x that contains the Code and app.json that is necessary for that part of the migration.

To compile each app you need to comment/uncomment each codeunit in each corresponding folder and move / update the app.json to the "root" directory.
