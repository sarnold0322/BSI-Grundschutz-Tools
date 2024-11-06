# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH


# PowerShell Skript zur Abfrage der lokalen Gruppenmitgliedschaften eines Benutzers
# Das Skript liefert ein JSON-Objekt mit zwei Eigenschaften: "Ergebnis" und "Output"
# "Ergebnis" ist 1, wenn der Befehl erfolgreich war, 0 bei Fehler und 2 wenn kein eindeutiges Ergebnis möglich ist
# "Output" enthält die Ausgabe des Befehls "net user %username% | findstr /i "Local Group Memberships""

$username = [Environment]::UserName
$output = net user $username | findstr /i "Local Group Memberships"

if ($LASTEXITCODE -eq 0) {
    $result = 1
} elseif ($LASTEXITCODE -ne 0 -and $output.Length -gt 0) {
    $result = 0
} else {
    $result = 2
}

$jsonOutput = [PSCustomObject]@{
    Ergebnis = $result
    Output = $output
}

Write-Output ($jsonOutput | ConvertTo-Json)

# Beispiel Ausgabe:
# {
#     "Ergebnis":  1,
#     "Output":  "Local Group Memberships                 *Administrators"
# }