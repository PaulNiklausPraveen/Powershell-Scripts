#This PS Script will get CPU Temperature in Celcius

$WMIObject = Get-WmiObject -Query "SELECT * FROM Win32_PerfFormattedData_Counters_ThermalZoneInformation" -Namespace "root/CIMV2"
		foreach ($Obj in $WMIObject) {
			$HiPrecision = $Obj.HighPrecisionTemperature
			$Temperature = [math]::round($HiPrecision  / 100.0, 1)
            Return $Temp;
		}
