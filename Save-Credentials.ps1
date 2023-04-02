#This script will use Windows Credential manager to store credentials. It can be used to avoid password prompts in scripts.

Install-Module -Name CredentialManager
New-StoredCredential -Target AzureCloud -UserName username@domain.com -Password P@55W0rd@2023 -Type Generic -Persist LocalMachine

Get-StoredCredential -Target Azurecloud

$Cred=Get-StoredCredential -Target AzureCloud

#Connect to Azure using saved credentials
Connect-AzAccount -Credential $cred

 