resource "aws_ssm_document" "rcm_adjoin" {
  name            = "rcm_adjoin"
  document_format = "YAML"
  document_type   = "Command"
  target_type     = "/AWS::EC2::Instance"

  tags = {
      Terraform = true
      Name      = "rcm_adjoin"
  }

  content = <<DOC
  schemaVersion: "2.2"
  description: "Join to cms.local"
  mainSteps:
  - action: "aws:runPowerShellScript"
    name: "RunCommands"
    inputs:
      runCommand:
      - $domain = "cms.local"
      - $awsdomain = "awscloud.cms.local"
      - $username = (Get-SSMParameter -Name /domain/username -WithDecryption $true).Value
      - $password = (Get-SSMParameter -Name /domain/password -WithDecryption $true).Value | ConvertTo-SecureString -asPlainText -Force
      - $awspassword = (Get-SSMParameter -Name /domain/svc-leidospacker -WithDecryption $true).Value | ConvertTo-SecureString -asPlainText -Force
      - $domainusername = "$domain\$username"
      - $awsdomainusername = "$awsdomain\svc-leidospacker"
      - $hostname = hostname
      - $credential = New-Object System.Management.Automation.PSCredential($domainusername,$password)
      - (Get-WmiObject -Class Win32_ComputerSystem).Domain
      - $awscredential = New-Object System.Management.Automation.PSCredential($awsdomainusername,$awspassword)
      - Remove-Computer -UnjoinDomainCredential $awscredential -WorkgroupName "WORKGROUP" -PassThru -Verbose -Force
      - Add-Computer -DomainName $domain -ComputerName $hostname -OUPath "OU=App,OU=Dev,OU=2016,OU=Servers,OU=CO,DC=cms,DC=local" -Credential $credential -PassThru -Verbose -Force
      - (Get-WmiObject -Class Win32_ComputerSystem).Domain
      - $InstanceId=Get-EC2InstanceMetadata -Category InstanceId
      - $tag = New-Object Amazon.EC2.Model.Tag
      - $tag.Key = "launch_runbooks"
      - $tag.Value = "true"
      - New-EC2Tag -Resource $InstanceId -Tag $tag
      - Restart-Computer -Force
      - exit $LastExitCode
DOC
}