# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH


# Dieses PowerShell-Skript ruft verschiedene Informationen über das Betriebssystem und die Hardware des Computers ab und gibt sie als JSON-Objekt aus.
# Bei Endoflife.date wird geprüft, ob die Windows Version noch supported wird.
# result = 0 bedeutet, das Windows ist EndofLife
# result = 1 bedeutet, das Windows ist noch im Rahmen

$computerInfo = Get-ComputerInfo -Property OsName, OsVersion, WindowsEditionId, WindowsBuildLabEx, WindowsInstallationType, WindowsInstallDateFromRegistry, BiosBIOSVersion, BiosReleaseDate, CsBootupState, CsDomain

# Überprüfen des Ergebnisses
if ($computerInfo) {
    
    # URL der Webseite
    $url = "https://endoflife.date/windows"

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
            if ($row.Value -match $computerInfo.OsVersion) {
                # Ausgabe der gesamten Zeile
                $rowValue = [regex]::Replace($row.Groups[1].Value, '<.*?>', '') # Entferne HTML-Tags
                $rowValue = $rowValue -replace "`r`n|`n|`r", ""
                $rowValue = $rowValue -replace '\s+', ' '
                $eolErgebnis = $eolErgebnis + $rowValue.Trim()
            }
        }

        # Ergebnis an Variable anfügen
        $computerInfo | Add-Member -Name "EolErgebnis" -Value $eolErgebnis -MemberType NoteProperty

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
    Output = $computerInfo
}

# Ausgabe des JSON-Objekts
return $output | ConvertTo-Json

