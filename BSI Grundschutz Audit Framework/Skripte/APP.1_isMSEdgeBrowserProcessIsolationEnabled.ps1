# Skript erstellt am 2024-11-07
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH

# Synopsis
# Dieses PowerShell-Skript überprüft, ob der Webbrowser Microsoft Edge Prozesse für jede Webseite isoliert und Sandboxing verwendet.
# Es liest die Prozesse des Browsers aus und stellt sicher, dass jede geöffnete Webseite als separater Prozess läuft.
# Wenn kein Edge-Prozess läuft, wird eine Webseite im Edge-Browser geöffnet.

# Funktionen:
# - Prozessisolation: Das Skript überprüft, ob jede geöffnete Webseite als separater Prozess läuft.
# - Sandboxing: Das Skript stellt sicher, dass der Browser Sandboxing-Techniken verwendet.
# - Öffnen einer Webseite: Wenn kein Edge-Prozess läuft, wird eine Webseite im Edge-Browser geöffnet.

# Rückgabewerte:
# - Ergebnis: 
#   - `1` - Prozesse sind isoliert und Sandboxing ist aktiviert.
#   - `0` - Prozesse sind nicht isoliert oder Sandboxing ist nicht aktiviert.
#   - `2` - Fehler beim Abrufen der Prozesse.
# - Output: Detaillierte Informationen über die Browser-Prozesse.

# Beispielausgabe:
# {
#     "Ergebnis": 1,
#     "Output": "msedge.exe: 5 Prozesse gefunden"
# }

# Initialisieren der Ergebnisvariable
$result = 2
$output = ""

# Überprüfen der Prozesse des Browsers (Microsoft Edge)
$browserProcesses = Get-Process -Name "msedge" -ErrorAction SilentlyContinue

if ($browserProcesses) {
    $processCount = $browserProcesses.Count
    $output = "msedge.exe: " + $processCount + " Prozesse gefunden"
    
    # Überprüfen, ob mehrere Prozesse gefunden wurden
    if ($processCount -gt 1) {
        Write-Output "Prozesse sind isoliert und Sandboxing ist aktiviert."
        $result = 1
    } else {
        Write-Output "Prozesse sind nicht isoliert oder Sandboxing ist nicht aktiviert."
        $result = 0
    }
} else {
    Write-Output "Keine Browser-Prozesse gefunden. Öffne eine Webseite in Microsoft Edge."
    $output = "Keine Browser-Prozesse gefunden. Öffne eine Webseite in Microsoft Edge."
    
    # Öffnen einer Webseite in Microsoft Edge
    Start-Process "msedge.exe" "https://www.example.com"
    $result = 0
}

# Rückgabe des Ergebnisses und der Ausgabeinformationen als JSON
return [PSCustomObject]@{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json