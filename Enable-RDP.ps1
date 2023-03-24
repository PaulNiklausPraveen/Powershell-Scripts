
#This script will enable RDP in Remote system. If you want enable locally, remove  -ComputerName paramerter
 
$RDPSetting = Get-WmiObject -Class Win32_TerminalServiceSetting -Namespace Root\CimV2\TerminalServices -ComputerName REMOTESERVER
$RDPSetting .SetAllowTSConnections(1,1)


#For PowerShell Core(6,7) Versions run below script. As WMI is not supported in .Net core.

$RDPSetting = Get-CimInstance -Class Win32_TerminalServiceSetting -Namespace Root\CimV2\TerminalServices -ComputerName REMOTESERVER
$RDPSetting .SetAllowTSConnections(1,1)
