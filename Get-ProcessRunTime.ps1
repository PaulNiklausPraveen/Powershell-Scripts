#This Script will give how log a process in running.
# Note: Not all process will display the run time

Function Get-ProcessRunTime{
 
param (
 
  [Parameter(Mandatory,HelpMessage = "Enter the Process Name  `n Example : Notepad")]
  [String]$ProcessName
)
get-process $ProcessName | where starttime | foreach {
    [pscustomobject]@{
        Name=$_.Name
        ID=$_.Id
        Run=((Get-Date)-$_.StartTime)
    }
} | Sort-object Run -descending  
}Get-ProcessRunTime
