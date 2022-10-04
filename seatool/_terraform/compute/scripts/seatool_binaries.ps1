<powershell>

###########################################################################################################################
# This script enables/installs/configures the tools required for the SEA TOOL application. 
# !!!!!!Before deploying to any environment, ensure to update the referenced S3 bucket for the intended environmentt!!!!!!

# Steps completed during this script
# 1. Upload Application and Server binaries to C:\temp\binaries
# 2. Mount Microsoft Office ISO
# 3. Install/Enable IIS, .net, ASP.NET, MS word
# 4. Merge Reg files required for New Relic. Move License yml file to correct location
# 5. Once everything is installed: Unmount disk, delete Folder; Fix the server time



# Manual Steps that are required post script
# 1. Join cms.local domain
# 2. Install New Relic - Once going through this process, move -Path "C:\Temp\binaries\newrelic.config" -Destination "C:\Program Files\New Relic\.Net Agent\newrelic.config"

###########################################################################################################################

#Call Powershell Scripts Binaries and Application files S3 Bucket
aws s3 cp s3://seatooliispowershellscript C:\temp\binaries --recursive
aws s3 cp s3://seatoolapplicationfiles C:\SEATOOL\ --recursive


#Sleep for 30 seconds - takes time for the Windows 2016 ISO to download
Write-Output "Start Sleep for 30 seconds.."
Start-Sleep -seconds 30

###Mount ISO
Mount-DiskImage -ImagePath "c:\temp\binaries\SW_DVD9_Win_Server_STD_CORE_2016_64Bit_English_-4_DC_STD_MLF_X21-70526.ISO"

#Sleep for 15 seconds - Takes time fore the Windows 2016 ISO to mount
Write-Output "Start Sleep for 15 seconds.."
Start-Sleep -seconds 15

# Windows Install IIS with all features
Install-WindowsFeature -name Web-Server -IncludeManagementTools
Install-WindowsFeature -name Web-Server -IncludeManagementTools
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationDevelopment
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationInit
Enable-WindowsOptionalFeature -Online -FeatureName IIS-NetFxExtensibility45 -All
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ISAPIExtensions
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ISAPIFilter
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASPNET45 -All
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASP
#Enable .NetFramework
Dism /online /enable-feature /featurename:NetFx3 /All /Source:D:\sources\sxs /LimitAccess

##Install ASPNet MVC 3
Start-Process -FilePath "C:\temp\binaries\AspNetMVC3Setup.exe" /q


###Install MS Office: Note - Install can take + 10 minutes 
Start-Process -FilePath "C:\temp\binaries\install_seatool.bat"


# Import registry files neccessary for New Relic to communicate. Without TLS, communication fails
reg import C:\temp\binaries\Enable_TLS.reg
reg import C:\temp\binaries\SchUseStrongCrypto.reg

# This command will configure the application in IIS Manager
# You will need to uncomment the line that aligns with the environment you're deploying too
# The manual step that is still required is to select the cert for the https binding

# cmd.exe /c %systemroot%\system32\inetsrv\APPCMD add site /name:seatooldev /bindings:"http/*:80:seadev.cms.gov","https/*:443:seadev.cms.gov" /physicalPath:"C:\SEATOOL\Webcontent"
# cmd.exe /c %systemroot%\system32\inetsrv\APPCMD add site /name:seatoolimpl /bindings:"http/*:80:seaval.cms.gov","https/*:443:seaval.cms.gov" /physicalPath:"C:\SEATOOL\Webcontent"
# cmd.exe /c %systemroot%\system32\inetsrv\APPCMD add site /name:seaprod /bindings:"http/*:80:sea.cms.gov","https/*:443:sea.cms.gov" /physicalPath:"C:\SEATOOL\Webcontent" 

# Move New Relic yml files to required locations
move-item -Path "C:\Temp\binaries\newrelic-infra.yml" -Destination "C:\Program Files\New Relic\newrelic-infra\newrelic-infra.yml" -force
# move-item -Path "C:\Temp\binaries\newrelic.config" -Destination "C:\Program Files\New Relic\.Net Agent\newrelic.config" -force

#Sleep for 360 seconds - Allow MS Office to install
Write-Output "Start Sleep for 360 seconds.."
Start-Sleep -seconds 360


#Unmount ISO image
Dismount-DiskImage -ImagePath C:\Temp\binaries\SW_DVD9_Win_Server_STD_CORE_2016_64Bit_English_-4_DC_STD_MLF_X21-70526.ISO

#Delete Binaries Folder
Remove-Item 'C:\temp\binaries' -Recurse

#Fix the Server Time

tzutil /s 'Eastern Standard Time'
w32tm /config /manualpeerlist:169.254.169.123 /syncfromflags:manual /update
w32tm /resync
Restart-Service AmazonSSMAgent -Force

#Sleep for 30 seconds
Write-Output "Start Sleep for 30 seconds.."
Start-Sleep -seconds 30

</powershell>