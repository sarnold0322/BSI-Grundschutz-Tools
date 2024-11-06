# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


# Dieses PowerShell-Skript überprüft, ob die Synchronisierung von Benutzerdaten mit Microsoft Cloud-Diensten deaktiviert ist.
# Das Ergebnis wird als JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output" ausgegeben.

$syncSettings = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SettingSync" -ErrorAction SilentlyContinue

if ($syncSettings -and $syncSettings.SyncEnabled -eq 0) {
    $output = "Die Synchronisierung von Benutzerdaten mit Microsoft Cloud-Diensten ist deaktiviert."
    $result = 1
} else {
    $output = "Die Synchronisierung von Benutzerdaten mit Microsoft Cloud-Diensten ist aktiviert."
    $result = 0
}

$jsonOutput = @{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json

Write-Output $jsonOutput