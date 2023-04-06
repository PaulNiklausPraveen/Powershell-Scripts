#PowerShell Script to get newest 100 logs and group

 
Param(
    [Parameter(Mandatory,HelpMessage = "Enter the Log Name  `n Example : Application")]
    [string]$Log,
    [string]$Computername = $env:COMPUTERNAME,
    [int32]$Newest = 100  
)

 
$data = Get-Eventlog -logname $Log -EntryType Error -Newest $newest -ComputerName $Computername |
    Group-object -Property Source -NoElement  

$data |Sort-Object -Property Count, Name -Descending 
 
