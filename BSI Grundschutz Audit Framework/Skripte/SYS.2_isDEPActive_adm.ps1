# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


# Dieses PowerShell-Skript überprüft die DEP-Einstellungen (Data Execution Prevention) auf in der Registry unter HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management
# und gibt das Ergebnis als JSON-Objekt aus.

$depSettings = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -ErrorAction SilentlyContinue

if ($depSettings) {
    if ($depSettings.NoExecute -eq 1) {
        $result = 0
        $output = "DEP/NX ist deaktiviert."
    } else {
        $result = 1
        $output = "DEP/NX ist aktiviert."
    }
} else {
    $result = 2
    $output = "DEP-Einstellungen konnten nicht gefunden werden."
}

return @{
    "Ergebnis" = $result
    "Output" = $output
} | ConvertTo-Json

