
#input
$instance = ''
#needs to end with a \
$path = '' 
#Current version of PrintVis
$PrintVisVersionCurrent = '26.0.0.3' 
$PrintVisVersionNew = '26.1.1.0'
$PrintVisPath = $path + 'NovaVision Software AS_PrintVis_26.1.1.0.app'
$PrintVisLibraryPath = $path + 'NovaVision Software AS_PrintVis System Library_26.1.1.0.app'
$PrintVisCIMPath = $path + 'NovaVision Software AS_PrintVis CIM_26.1.1.0.app'
#input

#does not need to be updated
$PrintVisLibraryName = 'PrintVis System Library'
$PrintVisName = 'PrintVis'
$PrintVisCIMName = 'PrintVis CIM'

$Temp1Name = 'PTE CIM 1 - upg temp tables'
$Temp1Version = '1.0.0.12'
$Temp1Path = $path + 'PrintVis AS_PTE CIM 1 - upg temp tables_1.0.0.12.app'

$Temp3Name = 'PTE CIM 1 - Move Data into PrintVis'
$Temp3Version = '1.0.0.2'

$Temp3Path = $path + 'PrintVis AS_PTE CIM 1 - Move Data into PrintVis_1.0.0.2.app'
#does not need to be updated

#Steps
#Install temp table app to data that needs to be moved
Publish-NAVApp $instance -Path $Temp1Path -SkipVerification
Sync-NAVApp $instance -Name $Temp1Name
Install-NAVApp $instance -Name $Temp1Name

#install PrintVis

#install PrintVis Library
Uninstall-NAVApp $instance -Name $PrintVisLibraryName -Force
Publish-NAVApp $instance -Path $PrintVisLibraryName -SkipVerification
Unpublish-NAVApp $instance -Name $PrintVisLibraryName -Version $PrintVisCurrentInstalledVersion
Sync-NAVApp $instance -Name $PrintVisLibraryName 
Start-NAVAppDataUpgrade $instance -Name $PrintVisLibraryName
Install-NAVApp $instance -Name $PrintVisLibraryName -Version $PrintVisVersionNew

#install PrintVis
Publish-NAVApp $instance -Path $PrintVisPath -SkipVerification
Unpublish-NAVApp $instance -Name $PrintVisName -Version $PrintVisCurrentInstalledVersion
Sync-NAVApp $instance -Name $PrintVisName 
Start-NAVAppDataUpgrade $instance -Name $PrintVisName
Install-NAVApp $instance -Name $PrintVisName -Version $PrintVisVersionNew

#install PrintVis CIM
Publish-NAVApp $instance -Path $PrintVisCIMPath -SkipVerification
Unpublish-NAVApp $instance -Name $PrintVisCIMName -Version $PrintVisCIMCurrentInstalledVersion
Sync-NAVApp $instance -Name $PrintVisCIMName -Mode ForceSync -force
Start-NAVAppDataUpgrade $instance -Name $PrintVisCIMName
Install-NAVApp $instance -Name $PrintVisCIMName -Version $PrintVisVersionNew


#Now data needs to be moved into PrintVis Tables
Publish-NAVApp $instance -Path $Temp3Path -SkipVerification
Sync-NAVApp $instance -Name $Temp3Name
Install-NAVApp $instance -Name $Temp3Name -Force
Uninstall-NAVApp $instance -Name $Temp3Name
Unpublish-NAVApp $instance -Name $Temp3Name
#!!!confirm that PrintVis CIM Controller is not empty!!!
#Upgrade to temp tables done
Unpublish-NAVApp $instance -Name $Temp3Name
Uninstall-NAVApp $instance -Name $Temp1Name
Unpublish-NAVApp $instance -Name $Temp1Name
