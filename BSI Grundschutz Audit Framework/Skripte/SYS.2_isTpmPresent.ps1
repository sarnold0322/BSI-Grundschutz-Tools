# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


# PowerShell Skript für den Befehl "Get-TPM" aus und prüft, ob ein TP-Modul vorhanden ist. 
# Das Skript liefert ein JSON-Objekt mit zwei Teilen: "Ergebnis" und "Output"
# "Ergebnis" ist "1" bei positivem Ergebnis, "0" bei negativem Ergebnis und "2" wenn kein klares Ergebnis möglich ist
# "Output" enthält die Ausgabe des Befehls "Get-TPM"

$tpmInfo = Get-TPM
$result = 0

if ($tpmInfo.TpmPresent) {
    $result = 1
} elseif ($tpmInfo.TpmPresent -eq $false) {
    $result = 0
} else {
    $result = 2
}

$output = $tpmInfo | ConvertTo-Json

return [PSCustomObject]@{
    Ergebnis = $result
    Output = $output
}  | ConvertTo-Json
