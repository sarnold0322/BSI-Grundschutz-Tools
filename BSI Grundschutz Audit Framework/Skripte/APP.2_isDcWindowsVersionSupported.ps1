# Skript erstellt am 2024-11-07
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH

# Dieses PowerShell-Skript ruft Informationen über die Windows-Version von Domain-Controllern ab und prüft, ob sie noch unterstützt wird.

$result = 2

# Abrufen der Domain-Controller-Informationen aus dem AD
# $ad_data = Get-WmiObject -Namespace "root\directory\ldap" -Class ds_computer -Filter "DS_distinguishedName LIKE '%OU=Domain Controllers%'" | Select-Object ds_cn, ds_operatingsystem, ds_operatingsystemversion, DS_distinguishedName

# Abrufen der Domain-Controller Namen aus dem DNS ist schneller als aus dem AD
$results = Resolve-DnsName -Name "_ldap._tcp.stadtwerke-hall.local" -Type SRV
$dcNames = $results | Where-Object { $_.QueryType -eq "SRV" } | Select-Object -ExpandProperty NameTarget


# Entferne die Domain aus jedem Namen in der Liste
$domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name
$shortNames = $dcNames | ForEach-Object {
    $_ -replace "\.$domain$", ""
}

# Abrufen der Daten aus dem AD
Add-Type -AssemblyName System.DirectoryServices

# Erstelle ein DirectorySearcher-Objekt
$searcher = New-Object System.DirectoryServices.DirectorySearcher

# Erstelle den Filter
$filter = "(&(objectClass=computer)(|"
foreach ($name in $shortNames) {
    $filter += "(cn=$name)"
}
$filter += "))"


$searcher.Filter = $filter

$searcher.PropertiesToLoad.Add("Name")
$searcher.PropertiesToLoad.Add("distinguishedName")
$searcher.PropertiesToLoad.Add("operatingSystem")
$searcher.PropertiesToLoad.Add("operatingSystemVersion")

# Führe die Suche aus
$results = $searcher.FindAll()

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

    # Konvertiere das Array in ein PSCustomObject
    $ad_data = foreach ($item in $results.Properties) {
        [PSCustomObject]@{
            name                    = $item.name
            distinguishedname       = $item.distinguishedname
            operatingsystem         = $item.operatingsystem
            operatingsystemversion  = $item.operatingsystemversion
        }
    }


    foreach ($server in $ad_data) {
        #$server = $result.Properties
        $eolErgebnis = ""
        # Extrahiere den Wert innerhalb der Klammern
        $osVersion = [regex]::Match($server.operatingsystemversion[0], '\((.*?)\)').Groups[1].Value
        foreach ($row in $rows) {
            # Überprüfen, ob die Zeile die extrahierte Windows-Version enthält
            if ($row.Value -match $osVersion) {
                Write-Host $row
                # Ausgabe der gesamten Zeile
                $rowValue = [regex]::Replace($row.Groups[1].Value, '<.*?>', '') # Entferne HTML-Tags
                $rowValue = $rowValue -replace "`r`n|`n|`r", ""
                $rowValue = $rowValue -replace '\s+', ' '
                #$eolErgebnis = $eolErgebnis + "\n" + $rowValue.Trim()
                $eolErgebnis = $rowValue.Trim()
            }
        }

        # Ergebnis an Variable anfügen
        $server | Add-Member -Name "EolErgebnis" -Value $eolErgebnis -MemberType NoteProperty

        # Verarbeitung des Ergebnisses
        if ($eolErgebnis -match "Ended") {
            $server | Add-Member -Name "SupportStatus" -Value 0 -MemberType NoteProperty
            $ergebnis = 0
        } else {
            $server | Add-Member -Name "SupportStatus" -Value 1 -MemberType NoteProperty
            if ($ergebnis -ne 0) {
                $ergebnis = 1
            }
        }
    }


} else {
    Write-Host "Tabelle nicht gefunden."
    $ad_data = "Fehler!"
}

# Erstellen des JSON-Objekts
return [PSCustomObject]@{
    Ergebnis = $ergebnis
    Output = $ad_data
} | convertTo-Json
