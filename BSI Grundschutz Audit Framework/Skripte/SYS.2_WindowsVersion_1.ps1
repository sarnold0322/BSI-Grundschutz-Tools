# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH


# Dieses PowerShell-Skript ruft verschiedene Informationen über das Betriebssystem und die Hardware des Computers ab und gibt sie als JSON-Objekt aus.

$computerInfo = Get-ComputerInfo -Property OsName, OsVersion, WindowsEditionId, WindowsBuildLabEx, WindowsInstallationType, WindowsInstallDateFromRegistry, BiosBIOSVersion, BiosReleaseDate, CsBootupState, CsDomain

# Überprüfen des Ergebnisses
if ($?) {
    $result = 1
} else {
    $result = 0
}

# Erstellen des JSON-Objekts
$output = [PSCustomObject]@{
    Ergebnis = $result
    Output = $computerInfo
}

# Ausgabe des JSON-Objekts
ConvertTo-Json $output