# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH
# result = 0 bedeutet, dass das Gerät in nicht in Intune ist
# result = 1 bedeutet, dass es in Intune ist und 2 bedeutet, dass ein manueller Eingriff nötig ist. 

# Dieses PowerShell-Skript führt den Befehl "reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Enrollments"" aus und gibt das Ergebnis als JSON-Objekt aus.

$result = 2
$output = ""

# Pfad zur Registry
$regPath = "HKLM:\SOFTWARE\Microsoft\Enrollments"

# Überprüfen, ob der Pfad existiert
if (Test-Path $regPath) {
    # Alle Unterschlüssel abrufen
    $enrollmentKeys = Get-ChildItem -Path $regPath

    if ($enrollmentKeys) {
        Write-Host "Intune Enrollment ist vorhanden. Anzahl der Einträge: $($enrollmentKeys.Count)"
        $output = "Intune Enrollment ist vorhanden. Anzahl der Einträge: $($enrollmentKeys.Count)"
        $result = 1
        foreach ($key in $enrollmentKeys) {
            Write-Host "Enrollment Key: $($key.PSChildName)"
            $output = $output + "\n" + "Enrollment Key: $($key.PSChildName)"
        }
    } else {
        Write-Host "Kein Intune Enrollment gefunden."
        $result = 0
    }
} else {
    Write-Host "Der Registry-Pfad existiert nicht."
    $result = 2
}

return @{
    "Ergebnis" = $result
    "Output" = $output
} | ConvertTo-Json