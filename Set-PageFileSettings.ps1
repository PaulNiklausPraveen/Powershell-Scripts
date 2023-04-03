#Script to set Page File setting 2GB-4GB

$pagefile = GGet-CimInstance Win32_ComputerSystem -EnableAllPrivileges
$pagefile.AutomaticManagedPagefile = $False
$pagefile.put() | Out-Null

$pagefileset = Get-CimInstance Win32_pagefilesetting
$pagefileset.InitialSize = 2048
$pagefileset.MaximumSize = 4096
$pagefileset.Put() | Out-Null

Get-CimInstance win32_Pagefilesetting | Select Name, InitialSize, MaximumSize
