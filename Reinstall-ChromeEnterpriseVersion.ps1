#This PowerShell Script will reinstall latest Google Chrome Enterprise Version



#Creates a Log File
If (!(Get-Item C:\logs -ErrorAction SilentlyContinue))
{
New-Item -Path C:\ -Name "Logs" -ItemType Directory -Force -ErrorAction SilentlyContinue
$logfilelocation = 'c:\logs' 
}
else { 
$logfilelocation='c:\logs'
 }
Set-Location "C:\Logs"
$AppName = 'Google_Chrome'
$Logfile="$logfilelocation\$appname"+"_install.log"
$MSIlogfile="$logfilelocation\MSI"+"$appname"+"_install.log"

$TodayDate= Get-Date -format "dd-MMM-yyyy HH:mm tt"
"`n`nTimeStamp:$TodayDate"  | out-file $logfile -Append


$ChromeDownloadURL="https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B92BDBBF7-E3EE-EE29-C76A-01B221521269%7D%26lang%3Den%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dtrue%26ap%3Dx64-stable-statsdef_0%26brand%3DGCEA/dl/chrome/install/googlechromestandaloneenterprise64.msi"
Function Install-GoogleChrome{

#Chrome set up path
Invoke-WebRequest -Uri $ChromeDownloadURL -OutFile googlechromestandaloneenterprise64.msi
$chromeSetupPath ="C:\Logs\googlechromestandaloneenterprise64.msi"

If( Test-Path $chromeSetupPath)
{
"TimeStamp: $TodayDate Installing Google Chrome Enterprise version" | out-file $logfile -Append

Start-Process msiexec.exe  -ArgumentList  "/i $($chromeSetupPath) /quiet /norestart /L*V $msilogfile"  -Wait -PassThru | out-file $logfile -Append
}
Else{
"Installation failed.Chrome Setup file not found"  | out-file $Logfile -Append
}

"TimeStamp: $TodayDate  Installation function completed" | out-file $logfile -Append
 

}

Function Uninstall-GoogleChrome
{  
 
# Close any running Chrome instances before proceeding
Stop-Process -Name chrome -Force -PassThru -ErrorAction SilentlyContinue

[string] $SoftwareName='*chrome*'
$uninstallX86RegPath="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
$uninstallX64RegPath="HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"

$uninstallString=""

$uninstall32 = gci $($uninstallX64RegPath) | foreach { gp $_.PSPath } | ? { $_ -like $SoftwareName } | select UninstallString
$uninstall64 = gci $($uninstallX86RegPath) | foreach { gp $_.PSPath } | ? { $_ -like $SoftwareName } | select UninstallString

if($uninstall64) {$uninstallString=$uninstall64;}
if($uninstall32) {$uninstallString=$uninstall32;}

"Uninstall String: $uninstallString"  | Out-file $Logfile -Append
If(!$UninstallString) 
{
    Write-Error "Failed to get uninstall String of Google Chrome Application"  | Out-file $Logfile -Append
    return "Script failed to fetch uninstall String"
}

$uninstallString = $uninstallString.UninstallString -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X",""
$uninstallString = $uninstallString.Trim()
Write-host "`nUninstall string:  $uninstallString" -ForegroundColor Yellow
"$TodayDate : Uninstallation  of Google Chrome Application starts" | out-file $logfile -Append
start-process "msiexec.exe" -ArgumentList "/X $uninstallString /qn /Norestart" -Wait -NoNewWindow 

Sleep 10

"$TodayDate : Unregistering Google Chrome Scheduled Tasks"  | out-file $Logfile -Append

#Removing chrome tasks in Task Scheduler
$TaskNames = "GoogleUpdateTask*"

Get-ScheduledTask -TaskName  $TaskNames | FT Taskname,state | out-file $Logfile -Append

ForEach($TaskName in $TaskNames){
# Unregister the scheduled task
Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
}

"TimeStamp: $TodayDate Removing Google chrome Leftover files" | out-file $Logfile -Append

# Remove Chrome user profile data
$chromeProfilePath = "$env:LOCALAPPDATA\Google\Chrome"


# Remove Chrome installation folder
$chromeInstallFolder = "C:\Program Files\Google\Chrome"
$chromeInstallFolder_x86 = "C:\Program Files (x86)\Google\Chrome"

# Remove Chrome data from the user's AppData\Local folder
$ChromeAppDataLocal = "$env:LOCALAPPDATA\Google\Chrome"

# Remove Chrome data from the user's AppData\Roaming folder
$ChromeAppDataRoaming = "$env:APPDATA\Google\Chrome"

If( Test-Path $chromeProfilePath)
{
"TimeStamp: $TodayDate Removing ChromeProfilePath - $($ChromeProfilePath)"  | out-file $logfile -Append
Remove-Item -Path $chromeProfilePath -Recurse -Force
}
ElseIf(Test-Path $chromeInstallFolder)
{
"TimeStamp: $TodayDate Removing ChromeInstallFolder-x64bit - $($chromeInstallFolder)"  | out-file $logfile -Append
Remove-Item -Path $chromeInstallFolder -Recurse -Force

}
ElseIf(Test-Path $chromeInstallFolder_x86)
{
"TimeStamp: $TodayDate Removing ChromeInstallFolder-x86bit - $($chromeInstallFolder_x86)"  | out-file $logfile -Append
Remove-Item -Path $chromeInstallFolder -Recurse -Force

}Elseif(Test-Path $chromeAppDataLocal)
{
"TimeStamp: $TodayDate Removing ChromeAppDataLocal - $($chromeAppDataLocal)"  | out-file $logfile -Append
Remove-Item -Path $chromeAppDataLocal -Recurse -Force
}
Elseif(Test-Path $chromeAppDataRoaming)
{
"TimeStamp: $TodayDate Removing ChromeAppDataRoaming - $($chromeAppDataRoaming)"  | out-file $logfile -Append
Remove-Item -Path $chromeAppDataRoaming -Recurse -Force
}Else{
"TimeStamp: $TodayDate No leftover files available" | out-file $logfile -Append
}


"$TodayDate : Uninstallation Function Complete. Calling 'Install-GoogleChrome Function'" | out-file $logfile -Append

Install-GoogleChrome
} 



$ChromeApplication=@()
$ChromeApplication+=Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" | select *
$ChromeApplication+= Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"  | select *
 
If(($ChromeApplication.Displayname -match "chrome") -and ($ChromeApplication.DisplayVersion -le 115.0.5790.171) )
{
"Application Details:" | out-file $logfile -Append
$ChromeApplication | Where-Object {$_.Displayname -match "chrome"} | Select *  | out-file $logfile -Append
Write-output "$TodayDate : Google Chrome $(($ChromeApplication).DisplayVersion) is installed in $Env:ComputerName ,calling uninstall function"  | out-file $logfile -Append
sleep 5
Uninstall-GoogleChrome
}
ElseIF(!($ChromeApplication.Displayname -match "chrome")){
Install-GoogleChrome
}
Else{
"$TodayDate : Google Chrome Application is either Equal or above $(($ChromeApplication).DisplayVersion).Exiting the script " | Out-file $logfile -Append
 
}
 
