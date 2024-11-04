# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


# PowerShell Skript für Get-BitLockerVolume
# Dieses Skript führt den Befehl Get-BitLockerVolume aus und gibt das Ergebnis als JSON-Objekt aus.
# Das JSON-Objekt besteht aus zwei Teilen: "Ergebnis" und "Output".
# "Ergebnis" ist "1" wenn der Befehl erfolgreich war, "0" wenn der Befehl fehlgeschlagen ist und "2" wenn kein eindeutiges Ergebnis möglich ist.
# "Output" enthält die Ausgabe des Befehls Get-BitLockerVolume.

try {
    $output = Get-BitLockerVolume
    $result = 1
} catch {
    $output = $_.Exception.Message
    $result = 0
}

if ($output -eq $null) {
    $result = 2
}

$jsonOutput = [PSCustomObject]@{
    Ergebnis = $result
    Output = $output
}

$jsonOutput | ConvertTo-Json

# Beispiel:
# .\Get-BitLockerVolume.ps1
# {
#     "Ergebnis":  1,
#     "Output":  [
#                   {
#                       "MountPoint":  "C:",
#                       "VolumeStatus":  "FullyEncrypted",
#                       "VolumeType":  "OperatingSystem",
#                       "EncryptionMethod":  "AES256"
#                   }
#               ]
# }