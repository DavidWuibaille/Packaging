[xml]$xmlContent = Get-Content -Path "c:\windows\temp\P1200_Firmware_00.54\GetFirmwareVersion.xml"
$firmwareVersion = $xmlContent.Utility.FirmwareVersion.Firmware | Where-Object { $_.Firmware } | Select-Object -ExpandProperty Firmware
$firmwareVersion