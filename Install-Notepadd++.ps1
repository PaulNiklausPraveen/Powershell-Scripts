<#
This Script will Download and install Notepadd++ setup file  
#>
 

$DestinationFolder="C:\Temp"
$ServerName = "$Env:ComputerName"
$SoftwareList=@()
#Create new temp directory if not already exits to save the setup file
If(-not(Test-Path -Path $DestinationFolder)) {
     Try {
        New-Item -Path $DestinationFolder  -ItemType Directory -Force -ErrorAction Stop
         Write-Host "`nThe Folder $DestinationFolder  has been created." -ForegroundColor Green
     }
     Catch {
         Throw $_.Exception.Message
     }}
Else {
Write-Host "`nCannot create $DestinationFolder because a Folder with that name already exists. `n"
} 

#Source path of the setup file in remote location.Changed to respective Network Path.
$SourcePath="https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.5/npp.8.5.Installer.x64.exe"
#Destination path to save the setup file
$DestinationPath ="C:\Temp\Notepad++_x64_8.4.7.exe"
#Download the setup file from Internet to local system
Invoke-WebRequest $SourcePath -OutFile $DestinationPath -PassThru

IF(Test-Path $DestinationPath -PathType Leaf)
{
Write-Host "`nInstalling NotePad++ on $ServerName " -ForegroundColor Yellow
#Initiate the installation in silent mode.
Start-Process -FilePath $DestinationPath -ArgumentList "/S" -NoNewWindow -PassThru
Start-Sleep 15
#Verify the software is installed/updated by querying the registry
$SoftwareList = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object @{N="ComputerName";E={$ServerName}},  DisplayName, DisplayVersion, Publisher, InstallDate;
$SoftwareList += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object @{N="ComputerName";E={$ServerName}} , DisplayName, DisplayVersion, Publisher, InstallDate; 
$SoftwareList | Where-Object { $_.DisplayName -ne $ull } | Sort-Object -Property DisplayName -Unique 
[String]$APPName='Notepad+'
$ApplicationData=$SoftwareList | Where-Object {$_.DisplayName -match $($AppName)} | Select-Object ComputerName,DisplayName, DisplayVersion, Publisher, InstallDate 
If($ApplicationData)
{
$ApplicationData | Format-Table -AutoSize
}
Else
{
Write-Host "Notepad ++ Application Failed to Install/Update in $ServerName " -ForegroundColor Red
 }
}
Else{
Write-Host "Installation of Notepad++ skips because File $DestinationPath is missing" -ForegroundColor Red
}



