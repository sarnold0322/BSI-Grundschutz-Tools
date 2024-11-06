# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH

# Powershell Skript zum Überprüfen, ob der Prozess "Matrix42 Endpoint Manager" läuft
# Das Skript gibt ein JSON-Objekt mit zwei Eigenschaften zurück:
# - Ergebnis: 1 wenn der Prozess läuft, 0 wenn nicht, 2 wenn kein eindeutiges Ergebnis

$result = 2
$output = ""

try {
    $process = Get-Process -Name "Matrix42.Platform.Service.Host" -ErrorAction Stop
    if ($process) {
        $result = 1
        $output = $process | Select-Object -Property Id, ProcessName | ConvertTo-Json
    }
} catch {
    if ($_.Exception.Message -like "*not running*") {
        $result = 0
        $output = "Prozess 'Matrix42 Endpoint Manager' nicht gefunden"
    } else {
        $result = 2
        $output = "Fehler beim Abrufen des Prozesses: $_"
    }
}

return @{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json