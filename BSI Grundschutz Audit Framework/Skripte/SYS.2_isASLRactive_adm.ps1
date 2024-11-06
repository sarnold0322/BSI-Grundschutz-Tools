# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


# Dieses PowerShell-Skript überprüft die ASLR-Einstellungen (Address Space Layout Randomization) auf dem System.
# Das Ergebnis wird als JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output" ausgegeben.

# Versuche, die ASLR-Einstellungen abzurufen
$aslrSettings = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -ErrorAction SilentlyContinue

# Überprüfe, ob die Einstellungen erfolgreich abgerufen wurden
if ($aslrSettings -ne $null) {
    # Überprüfe, ob ASLR aktiviert ist
    if ($aslrSettings.EnableRandomizedBaseAddress -eq 1) {
        $result = 1
        $output = "ASLR ist aktiviert."
    } elseif ($aslrSettings.EnableRandomizedBaseAddress -eq 0) {
        $result = 0
        $output = "ASLR ist deaktiviert."
    } else {
        $result = 2
        $output = "Ergebnis unklar."        
    }
} else {
    # Fehlerbehandlung für fehlende Berechtigungen oder andere Probleme
    $errorMessage = $error[0].Exception.Message
    if ($errorMessage -like "*Access Denied*") {
        $result = 3
        $output = "Zugriff verweigert. Bitte führen Sie das Skript mit Administratorrechten aus."
    } else {
        $result = 2
        $output = "ASLR-Einstellungen konnten nicht gefunden werden. Fehler: $errorMessage"
    }
}

# Rückgabe der Ergebnisse als JSON
return @{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json
