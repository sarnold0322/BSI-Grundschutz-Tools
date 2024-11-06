# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH


# PowerShell Skript für den Befehl "dsregcmd /status"
# Das Skript liefert ein JSON-Objekt mit zwei Eigenschaften: "Ergebnis" und "Output"
# "Ergebnis" ist 1 bei positivem Ergebnis, 0 bei negativem Ergebnis und 2 wenn kein klares Ergebnis möglich ist
# "Output" enthält die Ausgabe des Befehls "dsregcmd /status"

$result = Invoke-Expression "dsregcmd /status"

if ($result -match "AzureAdJoined : YES") {
    # wenn das explizit im Output des Befehls steht
    $Ergebnis = 1

} elseif ("AzureAdJoined : NO") {
    $Ergebnis = 0
}  else {
    $Ergebnis = 2
}
    


return [PSCustomObject]@{
        Ergebnis = $Ergebnis
        Output = $result
 } | ConvertTo-Json