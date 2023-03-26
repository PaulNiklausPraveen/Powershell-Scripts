Add-WindowsFeature Web-Server;
New-Item -Path "C:\inetpub\wwwroot\" -Name index.html -Value "Welcome to $($env:computername) Web Server"  
 
