# Skript erstellt am 2024-11-07
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH

# Synopsis
# Dieses PowerShell-Skript überprüft, ob Daten aus potenziell unsicheren Quellen automatisch im geschützten Modus in Microsoft Office-Produkten geöffnet werden. 
# Es liest die entsprechenden Einstellungen aus der Windows-Registry aus und gibt das Ergebnis sowie detaillierte Informationen über den Status der geschützten Ansicht zurück.
#
# Funktionen:
# - Registry-Pfad: Das Skript greift auf den Registry-Pfad `HKCU:\Software\Policies\Microsoft\Office\16.0\Common\Security` zu, um die Sicherheitseinstellungen für den geschützten Modus zu überprüfen.
# - Geschützte Ansicht: Es überprüft den Wert des `EnableProtectedViewForFilesFromInternet`-Schlüssels, um festzustellen, ob der geschützte Modus für Dateien aus dem Internet aktiviert ist.
# - Ergebnis: Das Skript gibt ein JSON-Objekt zurück, das den Status der geschützten Ansicht (`Ergebnis`) und eine detaillierte Ausgabe (`Output`) enthält.
#
# Rückgabewerte:
# - Ergebnis: 
#   - `1` - Daten aus potenziell unsicheren Quellen werden im geschützten Modus geöffnet.
#   - `0` - Daten aus potenziell unsicheren Quellen werden nicht im geschützten Modus geöffnet.
#   - `2` - Fehler beim Abrufen der Einstellungen.
# - Output: Detaillierte Informationen über den Wert des `EnableProtectedViewForFilesFromInternet`-Schlüssels.
#
# Beispielausgabe:
# {
#     "Ergebnis": 1,
#     "Output": "EnableProtectedViewForFilesFromInternet: 1"
# }

# Pfad zu den Einstellungen für den geschützten Modus in der Registry
$protectedViewPath = "HKCU:\Software\Policies\Microsoft\Office\16.0\Common\Security"

# Initialisieren der Ergebnisvariable
$result = 2

# Überprüfen, ob der geschützte Modus für potenziell unsichere Quellen aktiviert ist
$protectedView = Get-ItemProperty -Path $protectedViewPath -Name EnableProtectedViewForFilesFromInternet -ErrorAction SilentlyContinue

# Erstellen der Ausgabeinformationen
$output = "EnableProtectedViewForFilesFromInternet: " + $protectedView.EnableProtectedViewForFilesFromInternet

# Überprüfen, ob der geschützte Modus aktiviert ist
if ($protectedView.EnableProtectedViewForFilesFromInternet -eq 1) {
    Write-Output "Daten aus potenziell unsicheren Quellen werden im geschützten Modus geöffnet."
    $result = 1
} else {
    Write-Output "Daten aus potenziell unsicheren Quellen werden nicht im geschützten Modus geöffnet."
    $result = 0
}

# Rückgabe des Ergebnisses und der Ausgabeinformationen als JSON
return [PSCustomObject]@{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json
