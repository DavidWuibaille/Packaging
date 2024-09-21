$scriptPath = $PSScriptRoot
$devconPath = Join-Path -Path $scriptPath -ChildPath "devcon_x64.exe"
	
$deviceInstanceId       = "USB\VID_2F7C&PID_6008"
$driverInfPathGenerique = "C:\Windows\INF\usbprint.inf"

Write-host "P1200_Drivers_Generique.ps1 = $driverInfPathGenerique"
& $devconPath update "$driverInfPathGenerique" "$DeviceInstanceId"

