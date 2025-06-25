
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

$Temp3Name = 'PTE CIM 3 - Move Data into PrintVis'
$Temp3Version = '1.0.0.2'

$Temp3Path = $path + 'PrintVis AS_PTE CIM 3 - Move Data into PrintVis_1.0.0.2.app'
#does not need to be updated


#Steps
#Install temp table app to data that needs to be moved
Publish-BcContainerApp $instance -appFile $Temp1Path -skipVerification -sync -install -upgrade

#Uninstall PrintVis CIM
Unpublish-BcContainerApp $instance -appName $PrintVisCIMName -version $PrintVisVersionCurrent -unInstall

#install PrintVis
Publish-BcContainerApp $instance -appFile $PrintVisLibraryPath -skipVerification -sync
Publish-BcContainerApp $instance -appFile $PrintVisPath -skipVerification -sync
Unpublish-BcContainerApp $instance -appName $PrintVisName -version $PrintVisVersionCurrent -unInstall
Unpublish-BcContainerApp $instance -appName $PrintVisLibraryName -version $PrintVisVersionCurrent -unInstall
Start-NavContainerAppDataUpgrade $instance -appName $PrintVisLibraryName -appVersion $PrintVisVersionNew
Install-NavContainerApp $instance -appName $PrintVisLibraryName -appVersion $PrintVisVersionNew
Start-NavContainerAppDataUpgrade $instance -appName $PrintVisName -appVersion $PrintVisVersionNew
Install-NavContainerApp $instance -appName $PrintVisName -appVersion $PrintVisVersionNew

#Force is needed here to move CIM Controller, CIM Device and cost center field
Publish-BcContainerApp $instance -appFile $PrintVisCIMPath -syncMode ForceSync -skipVerification -sync -install -upgrade

#Now data needs to be moved into PrintVis Tables
Publish-BcContainerApp $instance -appFile $Temp3Path -skipVerification -sync -install

#confirm that PrintVis CIM Controller is not empty
#Upgrade to temp tables done
UnPublish-BcContainerApp $instance -name $Temp3Name -version $Temp3Version -unInstall -doNotSaveData
UnPublish-BcContainerApp $instance -name $Temp1Name -version $Temp1Version -unInstall -doNotSaveData

