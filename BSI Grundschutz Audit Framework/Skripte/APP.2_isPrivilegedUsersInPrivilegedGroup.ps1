# Skript erstellt am 2024-11-07
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH

# Dieses PowerShell-Skript ruft die Mitglieder der AD-Gruppe "Protected Users" ab und gibt die samAccountNames aus.


# Importiere das System.DirectoryServices Namespace
Add-Type -AssemblyName System.DirectoryServices


# Erhalte den aktuellen Domänennamen
$domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name

# Erstelle ein DirectorySearcher-Objekt
$searcher = New-Object System.DirectoryServices.DirectorySearcher


# Setze den Filter für die Suche
$searcher.Filter = "(&(objectClass=user)(memberOf=CN=Protected Users,CN=Users,DC=$($domain.Replace('.', ',DC='))))"
# Füge die Attribute hinzu, die du abrufen möchtest
$searcher.PropertiesToLoad.Add("samAccountName")
#$searcher.PropertiesToLoad.Add("displayName")

# Führe die Suche aus
$results = $searcher.FindAll()

# Durchlaufe die Ergebnisse und gebe die gewünschten Informationen aus
$output = $results.Properties.samaccountname
$result = $results.count

if ($result -eq 0) {
    $output = "Keine Mitglieder in der Gruppe 'Protected Users' gefunden."
}

# Erstellen des JSON-Objekts
return [PSCustomObject]@{
    Ergebnis = $result
    Output = $output
}
