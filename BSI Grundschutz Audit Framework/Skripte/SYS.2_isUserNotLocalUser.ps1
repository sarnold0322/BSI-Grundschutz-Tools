# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH

# Powershell Skript zum Überprüfen, ob der aktuelle Benutzer ein lokaler Benutzer ist
# Die Ausgabe wird als JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output" zurückgegeben
# "Ergebnis" ist 1 bei positivem Ergebnis, 0 bei negativem Ergebnis und 2 wenn kein klares Ergebnis möglich ist
# "Output" enthält die Ausgabe des Befehls

$username = [Environment]::UserName
$result = 2
$output = ""

try {
    $localUser = Get-LocalUser -Name $username -ErrorAction Stop
    if ($localUser) {
        $result = 0
        $output = $localUser | Format-List | Out-String
    }
} catch {
    # Wenn der Benutzer nicht gefunden wird, setzen wir das Ergebnis auf 1
    $result = 1
    $output = "Benutzer '$username' ist kein lokaler Benutzer oder existiert nicht."
}

$jsonOutput = [PSCustomObject]@{
    Ergebnis = $result
    Output = $output
}

return $jsonOutput | ConvertTo-Json
