#This Script will get size of the Shared drives in each server.

$Servers = Import-CSV  ("C:\Temp\ServersList.csv").Name
Foreach($Server in $Servers)
{
$shares= Get-CimInstance -class Win32_Share -ComputerName $Server  | Select-Object -ExpandProperty Name 

Foreach($share in $shares)
{
 $Directory = Get-Item \\$Server\$share 
 $directory| Get-ChildItem | Measure-Object -Sum Length | select-object  @{Name="Server"; Expression={$servers}},@{Name=”Path”; Expression={$directory.FullName}},@{Name=”Size(GB)”; Expression={$_.Sum/1GB}}  
 | Export-CSV C:Temp\Shares.CSV -NoType -Append
}
 }
 
 
