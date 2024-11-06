# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH


# PowerShell Skript für Get-MpPreference
# Dieses Skript führt den Befehl Get-MpPreference aus und gibt das Ergebnis als JSON-Objekt aus.
# Das JSON-Objekt besteht aus zwei Teilen: "Ergebnis" und "Output".
# "Ergebnis" ist 1, wenn der Befehl erfolgreich war, 0 wenn der Befehl fehlgeschlagen ist, und 2 wenn das Ergebnis nicht eindeutig ist.
# "Output" enthält die Ausgabe des Befehls Get-MpPreference.

$result = 0
try {
    $output = Get-MpPreference
    $result = 1
} catch {
    $output = $_.Exception.Message
    $result = 0
}

$jsonOutput = @{
    "Ergebnis" = $result
    "Output" = $output
} | ConvertTo-Json

Write-Output $jsonOutput