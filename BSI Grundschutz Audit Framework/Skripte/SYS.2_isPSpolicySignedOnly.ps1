# Skript erstellt am 2024-11-07
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH

# Dieses PowerShell-Skript überprüft, ob nur signierte Skripte erlaubt sind,
# und gibt das Ergebnis als JSON-Objekt aus.
# 1 bedeutet, dass nur signierte Skripte erlaubt sind, 0 bedeutet, dass dies nicht der Fall ist,
# und 2 bedeutet, dass kein klares Ergebnis vorliegt.

$executionPolicy = Get-ExecutionPolicy

if ($executionPolicy -eq "AllSigned") {
    $result = 1
    $output = "Nur signierte Skripte sind erlaubt."
} else {
    $result = 0
    $output = "Nicht nur signierte Skripte sind erlaubt."
}

if ($executionPolicy -eq $null) {
    $result = 2
    $output = "Aus dem Befehl konnte kein klares Ergebnis ermittelt werden."
}

$jsonOutput = @{
    "Ergebnis" = $result
    "Output" = $output
} | ConvertTo-Json

return $jsonOutput
