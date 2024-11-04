# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH


<# 
.SYNOPSIS
Überprüft, ob ein geplanter Vollscan in Windows Defender vorhanden ist.

.DESCRIPTION
Dieses PowerShell-Skript überprüft, ob ein geplanter Vollscan in Windows Defender konfiguriert ist. Es gibt Informationen darüber aus, ob die Aufgabe aktiviert ist und wann der nächste Scan geplant ist.

Die Ausgabe des Skripts ist ein JSON-Objekt mit zwei Eigenschaften:
- "Ergebnis": 1 wenn der Scan geplant und aktiviert ist, 0 wenn der Scan geplant aber nicht aktiviert ist, 2 wenn kein Scan geplant ist.
- "Output": Die Ausgabe des PowerShell-Befehls.

.EXAMPLE
PS C:\> .\check_defender_scan.ps1
{
    "Ergebnis": 1,
    "Output": "Ein regelmäßiger Vollscan ist geplant und die Aufgabe ist aktiviert.`nNächster geplanter Vollscan: 01.05.2023 00:00:00"
}
#>

$taskName = "Microsoft\Windows\Windows Defender\Scheduled Scan"

# Abrufen der geplanten Aufgaben
$task = Get-ScheduledTask | Where-Object { $_.TaskName -eq $taskName }

if ($task) {
    # Überprüfen, ob die Aufgabe aktiviert ist
    if ($task.State -eq 'Ready') {
        $output = "Ein regelmäßiger Vollscan ist geplant und die Aufgabe ist aktiviert.`n"
        
        # Weitere Details zur geplanten Aufgabe abrufen
        $taskDetails = Get-ScheduledTaskInfo -TaskName $taskName
        $output += "Nächster geplanter Vollscan: $($taskDetails.NextRunTime)"
        $result = 1
    } else {
        $output = "Ein regelmäßiger Vollscan ist geplant, aber die Aufgabe ist nicht aktiviert."
        $result = 0
    }
} else {
    $output = "Es ist kein geplanter Vollscan in Windows Defender vorhanden."
    $result = 2
}

$jsonOutput = @{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json

Write-Output $jsonOutput