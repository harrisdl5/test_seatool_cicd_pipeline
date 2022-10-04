<powershell>
# This will initalize and Formate the secondary disk
Start-Transcript -Path "C:\Temp\startup.log" -Append -IncludeInvocationHeader
get-disk | where-object partitionstyle -eq 'raw' | Initialize-Disk -PartitionStyle MBR -PassThru | New-Partition -AssignDriveLetter -UseMaximumSize | Format-Volume -FileSystem NTFS -Confirm:$false
tzutil /s 'Eastern Standard Time'
w32tm /config /manualpeerlist:169.254.169.123 /syncfromflags:manual /update
w32tm /resync
Restart-Service AmazonSSMAgent -Force
Stop-Transcript
</powershell>