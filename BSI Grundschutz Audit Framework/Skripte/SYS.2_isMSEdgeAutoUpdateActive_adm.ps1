# Skript erstellt am 2024-11-07
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR

# Powershell Skript zum Überprüfen, ob Auto-Update für Edge aktiviert ist und der Zyklus auf 1x pro Tag eingestellt ist
# Das Skript gibt ein JSON-Objekt mit zwei Eigenschaften zurück:
# - Ergebnis: 1 wenn Auto-Update aktiviert ist und der Zyklus korrekt ist, 0 wenn nicht, 2 wenn kein eindeutiges Ergebnis


$result = 2
$output = ""

try {
    $edgeUpdateKey = "HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate"
    $autoUpdate = Get-ItemProperty -Path $edgeUpdateKey -Name "AutoUpdateCheckPeriodMinutes" -ErrorAction Stop

    if ($autoUpdate -and $autoUpdate.AutoUpdateCheckPeriodMinutes -eq 1440) {
        $result = 1
        $output = "Auto-Update für Edge ist aktiviert und der Zyklus ist auf 1x pro Tag eingestellt."
    } elseif ($autoUpdate) {
        $result = 0
        $output = "Auto-Update für Edge ist aktiviert, aber der Zyklus ist nicht auf 1x pro Tag eingestellt."
    } else {
        $result = 0
        $output = "Auto-Update für Edge ist nicht aktiviert."
    }
} catch {
    $result = 2
    $output = "Fehler beim Abrufen des Auto-Update-Status: $_"
}

return @{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json