# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH


# PowerShell Skript zum Abrufen der Mitglieder der Administratoren-Gruppe und prüfen ob aktueller User in dieser ist
# und Ausgabe als JSON-Objekt mit Ergebnis und Output

# Funktion zum Ausführen des Befehls und Erstellen des JSON-Objekts

try {
    # Aktuellen Benutzernamen abrufen
    $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()

    # Überprüfen, ob der Benutzer in der Gruppe "Administratoren" ist
    $isAdmin = ( Get-LocalGroup -SID "S-1-5-32-544" | Get-LocalGroupMember | Where-Object { $_.Name -eq $currentUser.Name })

    if ($isAdmin) {
        $output = "Der Benutzer " + $currentUser.Name + " hat lokale Administratorrechte."
        $result = 0
    } else {
        $output = "Der Benutzer " + $currentUser.Name + " hat keine lokalen Administratorrechte."
        $result = 1
    }
}
catch {
    $result = 2 # Ergebnis ist unklar
    $output = $_.Exception.Message
}

# Erstellen des JSON-Objekts
$jsonObject = [PSCustomObject]@{
    Ergebnis = $result
    Output = $output
}

return $jsonObject