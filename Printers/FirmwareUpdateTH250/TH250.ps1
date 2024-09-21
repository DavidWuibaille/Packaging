############################################################
# Set Variable
$folder = "C:\TH2xxDownloadService"
$file = "TH2xxDownloadService.log"
$word1 = "New Flash Firmware Version: 180"
$word2 = "New Flash Firmware"
$word3 = " Version: 180"
$logFolder = "C:\exploit\log"
$logFile = "TH250_Update.log"
#
############################################################


# verify if the log folder exist, if not create it
if (!(Test-Path $logFolder)) {
    New-Item -ItemType Directory -Path $logFolder | Out-Null
}

# verify if the log file exist, if not create it
    Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Verify if log folder and log file exist." | Out-File -FilePath "$logFolder\$logFile" -Append -Encoding "UTF8" 
    
 #Verify if the Plug and Play TH250 is present on the device if yes continue the script if not go to exit with return 1
$ErrorActionPreference = "SilentlyContinue"
if (!(Get-PnpDevice -PresentOnly -FriendlyName '*TH250*')) {
    Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - The TH250 device is not connected to the device." | Out-File -FilePath "$logFolder\$logFile" -Append -Encoding "UTF8"
    Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Exiting the script with an error 1." | Out-File -FilePath "$logFolder\$logFile" -Append -Encoding "UTF8"
    exit 1
}
$ErrorActionPreference = "Continue"
# verify if the folder exist
if (Test-Path $folder) {
    Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - The folder '$folder' Exist." | Out-File -FilePath "$logFolder\$logFile" -Append -Encoding "UTF8"
    
    # Verify if the file exist in the folder
    if (Test-Path "$folder\$file") {
        Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - The file '$file' exist in the folder '$folder'." | Out-File -FilePath "$logFolder\$logFile" -Append -Encoding "UTF8"
        
        # Read the file content
        $content = Get-Content "$folder\$file"
        
        # Verify if the line contain "$word2+$word3"
        if ($content -match ($word2 + $word3)) {
            #$env:TH251_Firmware = $match
            Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - The word '$word2$word3' was found in the file. '$file'." | Out-File -FilePath "$logFolder\$logFile" -Append -Encoding "UTF8"
            Write-Host "The word '$word2$word3' was found in the file. '$file'"
        } else {
            # Extract the value of $word3 and log it
            $matches = $content | Select-String -Pattern "New Flash Firmware Version: (\d+)" | ForEach-Object { $_.Matches.Groups[1].Value }
            if ($matches) {
                foreach ($match in $matches) {
                    $logMessage = "the Version of $word1 was not found in the file but there is an entry New Flash Firmware Version: $match"
                    Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $logMessage was found in the file '$file'." | Out-File -FilePath "$logFolder\$logFile" -Append -Encoding "UTF8"
                    Write-Host $logMessage
                }
            } else {
                Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - The word '$word2$word3' was not found in the file. '$file'." | Out-File -FilePath "$logFolder\$logFile" -Append -Encoding "UTF8"
                Write-Host "The word '$word2$word3' was not found in the file. '$file'"
            }
        }
    } else {
        Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - The file '$file' does not exist in the folder '$folder'." | Out-File -FilePath "$logFolder\$logFile" -Append -Encoding "UTF8"
        Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Launch runtest.bat from '$folder'to generate TH2xxDownloadService.log." | Out-File -FilePath "$logFolder\$logFile" -Append -Encoding "UTF8"
        start-process -FilePath runtest.bat -WorkingDirectory $folder -Wait
        if (Test-Path "$folder\$file") {
            Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - The file '$file' still not exist in the folder '$folder'." | Out-File -FilePath "$logFolder\$logFile" -Append -Encoding "UTF8"
            Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Failed to create the $file after running the batch file. Exiting with error code 1." | Out-File -FilePath "$logFolder\$logFile" -Append -Encoding "UTF8"
            Write-Host "Failed to run the PowerShell script after running the batch file. Exiting with error code 1."
            Start-Process -FilePath powershell.exe -ArgumentList "-File `"$PSCommandPath`"" -WorkingDirectory "$folder" -PassThru
            Exit 0
        }
    }
}

