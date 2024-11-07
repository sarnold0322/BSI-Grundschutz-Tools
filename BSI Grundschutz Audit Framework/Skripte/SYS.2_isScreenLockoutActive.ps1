# Skript erstellt am 2024-11-07
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH

# Pfad zu den Bildschirmschoner-Einstellungen in der Registry
$screensaverPath = "HKCU:\Software\Policies\Microsoft\Windows\Control Panel\Desktop"

# Überprüfen, ob der Bildschirmschoner aktiviert ist
$screensaverActive = Get-ItemProperty -Path $screensaverPath -Name ScreenSaveActive -ErrorAction SilentlyContinue

# Initialisieren der Ergebnisvariable
$result = 2

# Überprüfen, ob der Passwortschutz aktiviert ist
$screensaverSecure = Get-ItemProperty -Path $screensaverPath -Name ScreenSaverIsSecure -ErrorAction SilentlyContinue

# Überprüfen, wie lange es dauert, bis der Bildschirm gesperrt wird (Timeout in Sekunden)
$screensaverTimeout = Get-ItemProperty -Path $screensaverPath -Name ScreenSaveTimeOut -ErrorAction SilentlyContinue

# Erstellen der Ausgabeinformationen
$output = "ScreenSaveActive: " + $screensaverActive.ScreenSaveActive + " "
$output += "ScreenSaverIsSecure: " + $screensaverSecure.ScreenSaverIsSecure + " "
$output += "ScreenSaveTimeOut: " + $screensaverTimeout.ScreenSaveTimeOut + " Sekunden"

# Überprüfen, ob der Bildschirmschoner und der Passwortschutz aktiviert sind
if ($screensaverActive.ScreenSaveActive -eq "1" -and $screensaverSecure.ScreenSaverIsSecure -eq "1") {
    Write-Output "Der Bildschirmschoner ist aktiviert und ein Passwort ist erforderlich."
    $result = 1
} else {
    Write-Output "Der Bildschirmschoner ist nicht aktiviert oder ein Passwort ist nicht erforderlich."
    $result = 0
}

# Rückgabe des Ergebnisses und der Ausgabeinformationen als JSON
return [PSCustomObject]@{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json
