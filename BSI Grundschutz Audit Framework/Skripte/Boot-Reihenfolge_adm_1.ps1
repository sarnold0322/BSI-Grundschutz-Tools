# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


# PowerShell Skript für den bcdedit Befehl
# Dieses Skript führt den bcdedit Befehl aus und gibt das Ergebnis als JSON-Objekt aus.
# Das JSON-Objekt besteht aus zwei Teilen: "Ergebnis" und "Output".
# "Ergebnis" ist eine Zahl, die den Status des Befehls angibt:
#   1 = Positiv
#   0 = Negativ
#   2 = Kein klares Ergebnis
# "Output" ist die Ausgabe des bcdedit Befehls.

$bcdeditOutput = bcdedit

$result = 0
if ($LASTEXITCODE -eq 0) {
    $result = 1
} elseif ($LASTEXITCODE -ne 0) {
    $result = 2
}

$jsonOutput = @{
    Ergebnis = $result
    Output = $bcdeditOutput
} | ConvertTo-Json

Write-Output $jsonOutput