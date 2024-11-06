# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH


# Dieses PowerShell-Skript überprüft, ob im Forwarded Events-Protokoll Einträge vorhanden sind.
# Das Ergebnis wird als JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output" ausgegeben.

$forwardedEventsLog = "Microsoft-Windows-Forwarding/Operational"

try {
    $events = Get-WinEvent -LogName $forwardedEventsLog -ErrorAction Stop
    $result = 1
    $output = "Es sind Ereignisse im Protokoll '$forwardedEventsLog' vorhanden. Anzahl der Ereignisse: $($events.Count)"
}
catch {
    if ($_.Exception.Message -like "*No events were found that match the specified selection criteria.*") {
        $result = 0
        $output = "Es sind keine Ereignisse im Protokoll '$forwardedEventsLog' vorhanden."
    }
    else {
        $result = 2
        $output = "Fehler beim Abrufen der Ereignisse aus dem Protokoll '$forwardedEventsLog': $($_.Exception.Message)"
    }
}

return @{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json