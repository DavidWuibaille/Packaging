param (
    [string]$InfFilePath
)

Write-host "P1200_Drivers_Specifique.ps1 = $InfFilePath"
$scriptPath = $PSScriptRoot
$devconPath = Join-Path -Path $scriptPath -ChildPath "devcon_x64.exe"
$deviceInstanceId = "USB\VID_2F7C&PID_6008"

# Utiliser le paramètre InfFilePath pour mettre à jour le périphérique avec devcon
& $devconPath update "$InfFilePath" "$deviceInstanceId"