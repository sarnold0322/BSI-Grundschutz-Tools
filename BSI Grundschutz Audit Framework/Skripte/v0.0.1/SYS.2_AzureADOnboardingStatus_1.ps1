# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH


# PowerShell Skript für den Befehl "dsregcmd /status"
# Das Skript liefert ein JSON-Objekt mit zwei Eigenschaften: "Ergebnis" und "Output"
# "Ergebnis" ist 1 bei positivem Ergebnis, 0 bei negativem Ergebnis und 2 wenn kein klares Ergebnis möglich ist
# "Output" enthält die Ausgabe des Befehls "dsregcmd /status"

$result = Invoke-Expression "dsregcmd /status"

if ($LASTEXITCODE -eq 0) {
    $resultObject = [PSCustomObject]@{
        Ergebnis = 1
        Output = $result
    }
} elseif ($LASTEXITCODE -ne 0) {
    $resultObject = [PSCustomObject]@{
        Ergebnis = 0
        Output = $result
    }
} else {
    $resultObject = [PSCustomObject]@{
        Ergebnis = 2
        Output = $result
    }
}

$resultObject | ConvertTo-Json