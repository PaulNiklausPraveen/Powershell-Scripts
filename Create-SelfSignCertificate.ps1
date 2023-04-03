#Create a self-Signed Certificate through PowerShell

$DNSNAME="Company.local"
$FriendlyName = "Company"
$ExpireDate="04/04/2024"

New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -DnsName $DNSName  -FriendlyName $FriendlyName `
   -NotAfter $ExpireDate -Verbose
