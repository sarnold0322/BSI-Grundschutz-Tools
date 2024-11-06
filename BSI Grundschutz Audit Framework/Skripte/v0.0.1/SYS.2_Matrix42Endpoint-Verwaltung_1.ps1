# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH


# Powershell Skript zum Überprüfen, ob der Prozess "Matrix42 Endpoint Manager" läuft
# Das Skript gibt ein JSON-Objekt mit zwei Eigenschaften zurück:
# - Ergebnis: 1 wenn der Prozess läuft, 0 wenn nicht, 2 wenn kein eindeutiges Ergebnis
# - Output: Die Ausgabe des Befehls "tasklist | findstr 'Matrix42 Endpoint Manager'"

$result = 2
$output = ""

$process = tasklist | findstr "Matrix42 Endpoint Manager"
if ($process) {
    $result = 1
    $output = $process
} else {
    $result = 0
    $output = "Prozess 'Matrix42 Endpoint Manager' nicht gefunden"
}

$json = @{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json

Write-Output $json