# Définir l'ID de l'instance du périphérique
$deviceInstanceId = "USB\VID_2F7C&PID_6008"

# Obtenir les informations sur les pilotes pour le périphérique spécifié
$driver = Get-WmiObject Win32_PnPSignedDriver | Where-Object { $_.DeviceID -like "*$deviceInstanceId*" }

if ($driver) {
    # Retourner le nom du fichier INF
    $driver.InfName
} else {
    # Retourner un message d'erreur
    Write-Output "No drivers found for device instance ID: $deviceInstanceId"
    $null
}