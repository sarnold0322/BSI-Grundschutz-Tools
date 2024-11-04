# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH


# PowerShell Skript zum Abrufen der Mitglieder der Administratoren-Gruppe
# und Ausgabe als JSON-Objekt mit Ergebnis und Output

# Funktion zum Ausführen des Befehls und Erstellen des JSON-Objekts
function Get-AdminGroupMembers {
    try {
        $members = Get-LocalGroupMember -Group "Administratoren"
        $result = 1 # Ergebnis ist positiv
        $output = $members | ConvertTo-Json
    }
    catch {
        $result = 0 # Ergebnis ist negativ
        $output = $_.Exception.Message
    }
    
    # Erstellen des JSON-Objekts
    $jsonObject = [PSCustomObject]@{
        Ergebnis = $result
        Output = $output
    }
    
    return $jsonObject
}

# Beispielaufruf
$jsonResult = Get-AdminGroupMembers
$jsonResult | ConvertTo-Json

# Das Skript kann wie folgt ausgeführt werden:
# .\Get-AdminGroupMembers.ps1