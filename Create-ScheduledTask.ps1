#Script to create a scheduled task

$TaskName="RebootServer"
$Taskaction = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument 'C:\Temp\RebootComputer.ps1'
$UserAccount= "NT AUTHORITY\SYSTEM"
$Tasktrigger = New-ScheduledTaskTrigger -At 5:30AM -Daily

Register-ScheduledTask -TaskName $TaskName -User $UserAccount -Action $Taskaction -Trigger $Tasktrigger  `
  -RunLevel Highest -Force
