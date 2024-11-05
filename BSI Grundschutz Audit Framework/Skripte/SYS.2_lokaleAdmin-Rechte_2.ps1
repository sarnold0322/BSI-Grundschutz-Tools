# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH


# PowerShell Skript zum Abrufen der Mitglieder der Administratoren-Gruppe
# und Ausgabe als JSON-Objekt mit Ergebnis und Output

# Funktion zum Ausführen des Befehls und Erstellen des JSON-Objekts

try {
    # Aktuellen Benutzernamen abrufen
    $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()

    # Überprüfen, ob der Benutzer in der Gruppe "Administratoren" ist
    $isAdmin = (Get-LocalGroupMember -Group "Administratoren" | Where-Object { $_.Name -eq $currentUser.Name })

    if ($isAdmin) {
        $output = "Der Benutzer hat lokale Administratorrechte."
        $result = 0
    } else {
        $output = "Der Benutzer hat keine lokalen Administratorrechte."
        $result = 1
    }
}
catch {
    $result = 2 # Ergebnis ist negativ
    $output = $_.Exception.Message
}

# Erstellen des JSON-Objekts
$jsonObject = [PSCustomObject]@{
    Ergebnis = $result
    Output = $output
}

return $jsonObject