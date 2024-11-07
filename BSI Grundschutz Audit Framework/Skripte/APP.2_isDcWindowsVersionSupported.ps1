# Skript erstellt am 2024-11-07
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH

# Dieses PowerShell-Skript ruft Informationen über die Windows-Version von Domain-Controllern ab und prüft, ob sie noch unterstützt wird.

$result = 2

# Abrufen der Domain-Controller-Informationen aus dem AD
$ad_data = Get-WmiObject -Namespace "root\directory\ldap" -Class ds_computer -Filter "DS_distinguishedName LIKE '%OU=Domain Controllers%'" | Select-Object ds_cn, ds_operatingsystem, ds_operatingsystemversion, DS_distinguishedName

# URL der Webseite
$url = "https://endoflife.date/windows-server"

# HTML-Inhalt der Webseite abrufen
$response = Invoke-WebRequest -Uri $url

# Den Inhalt der Webseite parsen
$html = $response.Content

# Die Tabelle aus dem HTML extrahieren
$tablePattern = '<table class="lifecycle">(.*?)</table>'
$tableMatch = [regex]::Match($html, $tablePattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)

if ($tableMatch.Success) {
    $tableHtml = $tableMatch.Groups[1].Value

    # Durch die Zeilen der Tabelle iterieren
    $rowPattern = '<tr.*?>(.*?)</tr>'
    $rows = [regex]::Matches($tableHtml, $rowPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)

    foreach ($dc in $ad_data) {
        $eolErgebnis = ""
        # Extrahiere den Wert innerhalb der Klammern
        $osVersion = [regex]::Match($dc.ds_operatingsystemversion, '\((.*?)\)').Groups[1].Value
        foreach ($row in $rows) {
            # Überprüfen, ob die Zeile die extrahierte Windows-Version enthält
            if ($row.Value -match $osVersion) {
                # Ausgabe der gesamten Zeile
                $rowValue = [regex]::Replace($row.Groups[1].Value, '<.*?>', '') # Entferne HTML-Tags
                $rowValue = $rowValue -replace "`r`n|`n|`r", ""
                $rowValue = $rowValue -replace '\s+', ' '
                $eolErgebnis = $eolErgebnis + $rowValue.Trim()
            }
        }

        # Ergebnis an Variable anfügen
        $dc | Add-Member -Name "EolErgebnis" -Value $eolErgebnis -MemberType NoteProperty

        # Verarbeitung des Ergebnisses
        
        if ($eolErgebnis -match "Ended") {
            $dc | Add-Member -Name "SupportStatus" -Value 0 -MemberType NoteProperty
            if ($result -gt 0) {
                $result = 0
            }
        } else {
            $dc | Add-Member -Name "SupportStatus" -Value 1 -MemberType NoteProperty
            if ($result -ne 0) {
                $result = 1
            }
            
        }
    }

    # Erstellen des JSON-Objekts
    $output = $ad_data | ConvertTo-Json

} else {
    Write-Host "Tabelle nicht gefunden."
    $output = "Fehler!"
}

# Erstellen des JSON-Objekts
return [PSCustomObject]@{
    Ergebnis = $result
    Output = $output
}

