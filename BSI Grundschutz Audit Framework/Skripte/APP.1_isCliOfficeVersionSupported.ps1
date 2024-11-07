# Skript erstellt am 2024-11-07
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH

# Synopsis
# Dieses PowerShell-Skript ruft Informationen über die installierte Microsoft Office-Version ab und überprüft, ob diese Version noch unterstützt wird.
# Es verwendet die Webseite endoflife.date, um den Support-Status der Office-Version zu überprüfen.
# result = 0 bedeutet, dass Office nicht mehr unterstützt wird.
# result = 1 bedeutet, dass Office noch unterstützt wird.

# Informationen über die installierte Office-Version abrufen
$officeInfo = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Office\ClickToRun\Configuration" -Name VersionToReport, ProductReleaseIds

# Überprüfen des Ergebnisses
if ($officeInfo) {
    
    # URL der Webseite
    $url = "https://endoflife.date/office"

    # HTML-Inhalt der Webseite abrufen
    $response = Invoke-WebRequest -Uri $url

    # Den Inhalt der Webseite parsen
    $html = $response.Content

    $eolErgebnis = ""

    # Die Tabelle aus dem HTML extrahieren
    # Hier wird die Tabelle mit der Klasse "lifecycle" gesucht
    $tablePattern = '<table class="lifecycle">(.*?)</table>'
    $tableMatch = [regex]::Match($html, $tablePattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)

    if ($tableMatch.Success) {
        $tableHtml = $tableMatch.Groups[1].Value

        # Durch die Zeilen der Tabelle iterieren
        $rowPattern = '<tr.*?>(.*?)</tr>'
        $rows = [regex]::Matches($tableHtml, $rowPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)

        foreach ($row in $rows) {
            # Überprüfen, ob die Zeile den gesuchten Text enthält
            if ($row.Value -match $officeInfo.VersionToReport) {
                # Ausgabe der gesamten Zeile
                $rowValue = [regex]::Replace($row.Groups[1].Value, '<.*?>', '') # Entferne HTML-Tags
                $rowValue = $rowValue -replace "`r`n|`n|`r", ""
                $rowValue = $rowValue -replace '\s+', ' '
                $eolErgebnis = $eolErgebnis + $rowValue.Trim()
            }
        }

        # Ergebnis an Variable anfügen
        $officeInfo | Add-Member -Name "EolErgebnis" -Value $eolErgebnis -MemberType NoteProperty

        # Verarbeitung des Ergebnisses
        Write-Host $eolErgebnis
        if ($eolErgebnis -match "Ended") {
            $result = 0
        } else {
            $result = 1
        }

    } else {
        Write-Host "Tabelle nicht gefunden."
    }

} else {
    # wenn die Prüfung scheitert, muss manuell geprüft werden
    $result = 2
}

# Erstellen des JSON-Objekts
$output = [PSCustomObject]@{
    Ergebnis = $result
    Output = $officeInfo
}

# Ausgabe des JSON-Objekts
return $output | ConvertTo-Json
