# Skript erstellt am 2024-11-08
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH

# Dieses PowerShell-Skript prüft, ob Defender nach Schadsoftware suchet, wenn Dateien ausgetauscht oder übertragen werden.
# result = 1 bedeutet, dass alles OK ist. 
# result = 2 bedeutet, dass es zu einem Fehler kam
# result = 0 bedeutet, dass die Anforderung nicht erfüllt ist. 

# Fallback, wenn etwas schief geht. 
$result = 2

# Überprüfen, ob der Echtzeitschutz aktiviert ist
$realTimeProtection = Get-MpPreference | Select-Object -ExpandProperty DisableRealtimeMonitoring

if ($realTimeProtection -eq $false) {
    $output =  "Der Echtzeitschutz ist aktiviert."
    $result = 1
} else {
    $output =  "Der Echtzeitschutz ist deaktiviert."
    $result = 0
}

# Überprüfen, ob der Übertragungs-Scan aktiviert ist
$transferScan = Get-MpPreference | Select-Object -ExpandProperty DisableArchiveScanning

if ($transferScan -eq $false) {
    $output = $output + "\n" + "Der Übertragungs-Scan ist aktiviert."
    if ($result -ne 0) {
        $result = 1
    }
} else {
    $output = $output + "\n" + "Der Übertragungs-Scan ist deaktiviert."
    $result = 0
}

return @{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json
