# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH

<#
.SYNOPSIS
Führt den gpresult Befehl aus und konvertiert die Ausgabe in ein JSON-Objekt.

.DESCRIPTION
Dieses Skript führt den Befehl "gpresult /h "%USERPROFILE%\Desktop\gpresult.html"" aus und konvertiert die Ausgabe in ein JSON-Objekt. 
ACHTUNG: Wenn keine Admin-Rechte vorliegen, wird nur die Benutzer-Gruppenrichtlinie abgefragt. 

Das JSON-Objekt besteht aus zwei Teilen:
- Ergebnis: 1 wenn der Befehl erfolgreich war, 0 wenn der Befehl fehlgeschlagen ist, 2 wenn kein eindeutiges Ergebnis möglich ist.
- Output: Die Ausgabe des gpresult Befehls.

.EXAMPLE
PS> .\gpresult_to_json.ps1
{
    "Ergebnis": 1,
    "Output": "Group Policy Results report for..."
}
#>

$gpresult_output = gpresult /h "$env:USERPROFILE\Desktop\gpresult.html"

if ($LASTEXITCODE -eq 0) {
    $result = 1
} elseif ($LASTEXITCODE -eq 1) {
    $result = 0
} else {
    $result = 2
}

$json_output = @{
    Ergebnis = $result
    Output = $gpresult_output
}

return $json_output | ConvertTo-Json