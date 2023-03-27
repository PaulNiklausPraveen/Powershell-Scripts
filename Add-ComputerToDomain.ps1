#This PowerShell Script will add computer to Domain and restart it

# Mention the domain name to join
$DC = "Domain.com" 

#Mention the password for domain admin.
$Password = "P@55W0rd@2023" | ConvertTo-SecureString -asPlainText –Force 

#Mention the domain administrator account.
$DomainAdmin = "$DC\Serveradmin" 

$Cred = New-Object System.Management.Automation.PSCredential($usr,$pw)

Add-Computer -DomainName $DC -Credential $Cred -Restart -Force -Verbose
