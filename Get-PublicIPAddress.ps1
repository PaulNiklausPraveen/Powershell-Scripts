
#This PowerShell script will fetch public IP address of the system.

Function Get-PublicIPAddress{ 	
Invoke-RestMethod -Uri "http://ipinfo.io"
}
Get-PublicIPAddress
