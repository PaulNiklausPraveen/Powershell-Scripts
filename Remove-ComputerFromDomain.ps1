#This PS script will remove Computer from domain and restarts it. After restart system will be in Workgroup


#Mention the domain name to join
$DC = "Domain.com" 

#Mention the Computer name
$Computer = "System1.Domain.com"

#Mention the password for domain admin.
$Password = "P@55W0rd@2023" | ConvertTo-SecureString -asPlainText –Force 

#Mention the domain administrator account.
$DomainAdmin = "$DC\Serveradmin" 

$Cred = New-Object System.Management.Automation.PSCredential($usr,$pw)

Remove-Computer -ComputerName $Computer -Credential $creds –Verbose –Restart –Force
