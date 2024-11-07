# Skript erstellt am 2024-11-07
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR

# Powershell Skript zum Überprüfen, ob Auto-Update für Firefox aktiviert ist und der Zyklus auf 1x pro Tag eingestellt ist
# Das Skript gibt ein JSON-Objekt mit zwei Eigenschaften zurück:
# - Ergebnis: 1 wenn Auto-Update aktiviert ist und der Zyklus korrekt ist, 0 wenn nicht, 2 wenn kein eindeutiges Ergebnis


$result = 2
$output = ""

try {
    $firefoxUpdateKey = "HKLM:\SOFTWARE\Policies\Mozilla\Firefox"
    $autoUpdate = Get-ItemProperty -Path $firefoxUpdateKey -Name "DisableAppUpdate" -ErrorAction Stop
    $updateCycleKey = "HKLM:\SOFTWARE\Mozilla\MaintenanceService"
    $updateCycle = Get-ItemProperty -Path $updateCycleKey -Name "UpdateInterval" -ErrorAction Stop

    if ($autoUpdate -eq $null -and $updateCycle.UpdateInterval -eq 86400) {
        $result = 1
        $output = "Auto-Update für Firefox ist aktiviert und der Zyklus ist auf 1x pro Tag eingestellt."
    } elseif ($autoUpdate -eq $null) {
        $result = 0
        $output = "Auto-Update für Firefox ist aktiviert, aber der Zyklus ist nicht auf 1x pro Tag eingestellt."
    } elseif ($autoUpdate.DisableAppUpdate -eq 1) {
        $result = 0
        $output = "Auto-Update für Firefox ist deaktiviert."
    } else {
        $result = 1
        $output = "Auto-Update für Firefox ist aktiviert."
    }
} catch {
    $result = 2
    $output = "Fehler beim Abrufen des Auto-Update-Status: $_"
}

return @{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json