# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


# PowerShell Skript für den Befehl "manage-bde -status ."
# Das Skript erstellt ein JSON-Objekt mit zwei Eigenschaften: "Ergebnis" und "Output"
# "Ergebnis" ist 1 bei positivem Ergebnis, 0 bei negativem Ergebnis und 2 wenn kein klares Ergebnis möglich ist
# "Output" enthält die Ausgabe des Befehls "manage-bde -status ."

$result = manage-bde -status .
$exitCode = $LASTEXITCODE

if ($exitCode -eq 0) {
    $resultValue = 1
} elseif ($exitCode -eq 1) {
    $resultValue = 0
} else {
    $resultValue = 2
}

$output = $result

$jsonObject = [PSCustomObject]@{
    Ergebnis = $resultValue
    Output = $output
}

$jsonObject | ConvertTo-Json