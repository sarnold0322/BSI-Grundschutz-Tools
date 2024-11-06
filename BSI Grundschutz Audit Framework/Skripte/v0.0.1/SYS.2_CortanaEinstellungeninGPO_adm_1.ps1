# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


# Dieses PowerShell-Skript liest den Inhalt einer HTML-Datei, die den Ausgabetext des gpresult-Befehls enthält,
# und sucht nach der Einstellung für Cortana. Das Ergebnis wird als JSON-Objekt ausgegeben.

$htmlContent = Get-Content -Path $env:USERPROFILE"\Desktop\gpresult.html" -Raw

# Überprüfe, ob die Einstellung für Cortana gefunden wurde
if ($htmlContent -match "Cortana aktivieren") {
    # Überprüfe, ob Cortana aktiviert oder deaktiviert ist
    if ($htmlContent -match "Ja") {
        $result = 1
        $output = "Cortana ist aktiviert."
    } else {
        $result = 1
        $output = "Cortana ist deaktiviert."
    }
} else {
    $result = 2
    $output = "Die Einstellung für Cortana wurde nicht gefunden."
}

# Gebe das Ergebnis als JSON-Objekt aus
@{
    "Ergebnis" = $result
    "Output" = $output
} | ConvertTo-Json