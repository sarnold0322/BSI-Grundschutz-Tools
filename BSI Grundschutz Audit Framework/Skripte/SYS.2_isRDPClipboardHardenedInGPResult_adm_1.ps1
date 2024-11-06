# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


# Dieses PowerShell-Skript liest den Inhalt einer HTML-Datei, die den Ausgabetext des gpresult-Befehls enthält.
# Es sucht dann nach einer bestimmten Einstellung in diesem Inhalt und gibt das Ergebnis als JSON-Objekt aus.

$htmlContent = Get-Content -Path $env:USERPROFILE"\Desktop\gpresult.html" -Raw

# Nach der Einstellung für die Zwischenablage in RDP suchen
if ($htmlContent -match "Zulassen, dass die Zwischenablage in Remotedesktop-Sitzungen verwendet wird") {
    if ($htmlContent -match "Aktiviert") {
        $result = 1
        $output = "Die Verwendung der Zwischenablage in RDP ist aktiviert."
    } else {
        $result = 1
        $output = "Die Verwendung der Zwischenablage in RDP ist deaktiviert."
    }
} else {
    $result = 2
    $output = "Die Einstellung für die Verwendung der Zwischenablage in RDP wurde nicht gefunden."
}

# Ausgabe als JSON-Objekt
return @{
    "Ergebnis" = $result
    "Output" = $output
} | ConvertTo-Json