# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


# Dieses PowerShell-Skript liest den Inhalt einer HTML-Datei ein, die von gpresult.exe erstellt wurde,
# und sucht nach Informationen zur Passwortkomplexität. Das Ergebnis wird als JSON-Objekt ausgegeben.

$htmlContent = Get-Content -Path $env:USERPROFILE"\Desktop\gpresult.html" -Raw
$result = 0
$output = ""

# Suche nach Informationen zur Passwortkomplexität
if ($htmlContent -match "Passwortkomplexität") {
    $result = 1
    $output = "Es gibt Richtlinien zur Passwortkomplexität in der gpresult-Datei."
} else {
    $result = 0
    $output = "Es gibt keine Richtlinien zur Passwortkomplexität in der gpresult-Datei."
}

# Ausgabe als JSON-Objekt
@{
    "Ergebnis" = $result
    "Output" = $output
} | ConvertTo-Json