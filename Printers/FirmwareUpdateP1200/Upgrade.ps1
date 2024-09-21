$url                    = "https://ivanh0cms03.dkcorp.net/Lan_Retaildecathlon/DN_Printer-Update-Firmare_0.054_MUI_E100_x64/rundeck.zip"
$zipFilePath            = "C:\Windows\Temp\rubdeck.zip"
$extractPath            = "C:\Windows\Temp\DN_Printer-Update-Firmare_0.054_MUI_E100_x64"
$deviceInstanceId       = "USB\VID_2F7C&PID_6008"
$logFile                = "C:\Systools\OptLog\UpdateP1200Firmware.log"
$devconPath             = Join-Path -Path $extractPath  -ChildPath "devcon_x64.exe"
$driverInfPathGenerique = "C:\Windows\INF\usbprint.inf"
$Debug                  = 1

# Ignore SSL/TLS errors
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }

function Log-Message {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $message"
    Add-Content -Path $logFile -Value $logEntry
    Write-Host $logEntry
}

Log-Message "========================"
Log-Message "Script Started"
Log-Message "========================"

try {
    Log-Message "Download of the ZIP file."
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($url, $zipFilePath)

    if (Test-Path $extractPath) {
        Log-Message "Deleting extracted folder."
        Remove-Item -Recurse -Force $extractPath
    }    
    Log-Message "Extract ZIP file."
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipFilePath, $extractPath)


    #$batchFilePath = "C:\Windows\Temp\DN_Printer-Update-Firmare_0.054_MUI_E100_x64\runGUItools.bat"
    #$process = Start-Process -FilePath $batchFilePath -Wait -PassThru
    #$exitCode = $process.ExitCode
    #Log-Message "GUI mode : $exitCode"  
    #Get-Process | Where-Object { $_.ProcessName -like '*CmnInterfaceService*' } | Stop-Process -Force -ErrorAction SilentlyContinue | Out-File -FilePath $logFile -Append

    # Get device ID
    $driver = Get-WmiObject Win32_PnPSignedDriver | Where-Object { $_.DeviceID -like "*$deviceInstanceId*" }

    # Vérifier si un pilote a été trouvé et obtenir le chemin complet du fichier INF
    if ($driver) {
        $infFile = $driver.InfName
        $fullInfPath = "C:\Windows\INF\$infFile"
        Log-Message "Drivers inf : $fullInfPath"  

        # force generic drivers
        Log-Message "Updating driver using: $driverInfPathGenerique"
        & $devconPath update "$driverInfPathGenerique" "$deviceInstanceId" | Out-File -FilePath $logFile -Append

        # read firmware version
        $batchFilePath = "C:\Windows\Temp\DN_Printer-Update-Firmare_0.054_MUI_E100_x64\GetFirmwareVersion.bat"
        $process = Start-Process -FilePath $batchFilePath -Wait -PassThru
        $exitCode = $process.ExitCode
        Log-Message "Get exe : $exitCode"  
        [xml]$xmlContent = Get-Content -Path "c:\windows\temp\P1200_Firmware_00.54\GetFirmwareVersion.xml"
        $firmwareVersion = $xmlContent.Utility.FirmwareVersion.Firmware | Where-Object { $_.Firmware } | Select-Object -ExpandProperty Firmware
        Log-Message "Firmware Version: $firmwareVersion"
        Get-Process | Where-Object { $_.ProcessName -like '*CmnInterfaceService*' } | Stop-Process -Force -ErrorAction SilentlyContinue | Out-File -FilePath $logFile -Append

        # update firmware
        Write-Host "Running firmware update utility..."
        $batchFilePath = "C:\Windows\Temp\DN_Printer-Update-Firmare_0.054_MUI_E100_x64\SetFirmwareVersion.bat"
        #$process = Start-Process -FilePath $batchFilePath -Wait -PassThru
        $exitCode = $process.ExitCode
        Log-Message "Set exe : $exitCode"  
        Get-Process | Where-Object { $_.ProcessName -like '*CmnInterfaceService*' } | Stop-Process -Force -ErrorAction SilentlyContinue | Out-File -FilePath $logFile -Append

        # read firmware version
        $batchFilePath = "C:\Windows\Temp\DN_Printer-Update-Firmare_0.054_MUI_E100_x64\GetFirmwareVersion.bat"
        $process = Start-Process -FilePath $batchFilePath -Wait -PassThru
        $exitCode = $process.ExitCode
        Log-Message "Get exe : $exitCode"  
        [xml]$xmlContent = Get-Content -Path "c:\windows\temp\P1200_Firmware_00.54\GetFirmwareVersion.xml"
        $firmwareVersion = $xmlContent.Utility.FirmwareVersion.Firmware | Where-Object { $_.Firmware } | Select-Object -ExpandProperty Firmware
        Log-Message "Firmware Version: $firmwareVersion"
        Get-Process | Where-Object { $_.ProcessName -like '*CmnInterfaceService*' } | Stop-Process -Force -ErrorAction SilentlyContinue | Out-File -FilePath $logFile -Append

        # rollback drivers
        & $devconPath update "$fullInfPath" "$deviceInstanceId" | Out-File -FilePath $logFile -Append
        Log-Message "Driver rollback completed using specific driver."

    } else {
        Log-Message "No drivers found for device instance ID: $deviceInstanceId"
    }

    # cleanup
    if ($Debug -eq 0) {
        if (Test-Path $extractPath) {
            Log-Message "Deleting extracted folder."
            Remove-Item -Recurse -Force $extractPath
        }
        if (Test-Path $zipFilePath) {
            Log-Message "Deleting downloaded ZIP file."
            Remove-Item -Force $zipFilePath
        }
    }

    Log-Message "Script execution completed. See log file for details: $logFile"
} catch {
    Log-Message "An error occurred: $_"
}
