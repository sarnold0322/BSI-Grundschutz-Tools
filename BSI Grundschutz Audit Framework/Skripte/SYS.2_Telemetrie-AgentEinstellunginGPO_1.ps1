# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH


# Powershell Skript zum Überprüfen der Telemetrie-Einstellung
# Dieses Skript liest den Inhalt der Datei "gpresult.html" vom Desktop des Benutzers
# und durchsucht den Inhalt nach der Einstellung für die Telemetrie.
# Die Ausgabe erfolgt als JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output".

$htmlContent = Get-Content -Path $env:USERPROFILE"\Desktop\gpresult.html" -Raw

# Nach der Einstellung für die Telemetrie suchen
if ($htmlContent -match "Telemetrie") {
    if ($htmlContent -match "Aktiviert") {
        $result = 1
        $output = "Der Telemetrie-Agent ist aktiviert."
    } else {
        $result = 1
        $output = "Der Telemetrie-Agent ist nicht aktiviert."
    }
} else {
    $result = 2
    $output = "Die Einstellung für den Telemetrie-Agent wurde nicht gefunden."
}

# Ausgabe als JSON-Objekt
@{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json