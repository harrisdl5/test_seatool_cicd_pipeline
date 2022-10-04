# <b>RCM MGN Post Launch Cutover Scripts</b>
</br>

<h2>*** Prerequisites ***</h2>
</br>

### <u>Powershell 7 should be on all boxes migrated from on-prem by default</u>
</br>

You can validate your version by running
</br>

```powershell
PS C:\> $PSVersionTable

Name                           Value
----                           -----
PSVersion                      5.1.14393.4583
PSEdition                      Desktop
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}
BuildVersion                   10.0.14393.4583
CLRVersion                     4.0.30319.42000
WSManStackVersion              3.0
PSRemotingProtocolVersion      2.3
SerializationVersion           1.1.0.1
```
</br>

You could have both version installed, you can elevate using the below:

```powershell
PS C:\Windows\system32> pwsh
PowerShell 7.2.1
Copyright (c) Microsoft Corporation.

https://aka.ms/powershell
Type 'help' to get help.
```
</br>
</br>
</br>



### <u>Needed in Launch Template user_data when the instance launches</u>
</br>

The below comes in to affect after the box is sysprepped. Without the below there are issues with the SSM agent starting properly which removes the ability to run the rest of the automation playbook calling the additonal playbooks

```Powershell
<powershell>
tzutil /s 'Eastern Standard Time'
w32tm /config /manualpeerlist:169.254.169.123 /syncfromflags:manual /update
w32tm /resync
Restart-Service AmazonSSMAgent -Force
</powershell>
<persist>true</persist>
```
</br>
</br>
</br>

### <u>Create Three Parameter store objects</u>
</br>

1. This is the username of the account that will remove from and add to the domain

```
/domain/username
```
</br>

2.  This is the password of the username joining the machine to the domain
```
/domain/password
```
</br>
3. This is the  launch config template that will be used when the box is sysprepped.
</br>

```json
{
  "setComputerName": false,
  "setMonitorAlwaysOn": true,
  "setWallpaper": true,
  "addDnsSuffixList": true,
  "extendBootVolumeSize": false,
  "handleUserData": true,
  "adminPasswordType": "Specify",
  "adminPassword":  "<putapasswordhere>"
}
```
</br>
</br>
</br>

### <u>IAM Role (This is included in the launch template at cutover)</u>
</br>

The base IAM role for EC2 instances (either ITOPs or Ledios) should suffice.
</br>
</br>
</br>

### <u>Security Groups (These are included in the launch template at cutover)</u>
</br>

By default there are security groups that should already exist within the AWS Account. The launch template should include:

- data_sg

> <b> Note: SGs should not allow full access outbound at this point. If access is allowed to reach the cms.local domain controllers this will cause a collusion of SIDs, access will be granted as a final step in the automation playbook, and only after the machine has been sysprepped. </b>

</br>
</br>
</br>

## *** Automation using SSM ***
</br>

The rcm_post_runbook.yaml is an automation SSM document that calls a series of SSM Run Command documents. The SSM agent needs to be running to kick off execution.

Create all the SSM Command Documents and give the document name the name of the file as it is referenced in the compliaton automation runbook.

Create an RCM Automation document and import the yaml code for the rcm_post_runbook. Execute only this script to run the full automation -- if testing you can run the individual run documents imported earlier to test each taks individually.