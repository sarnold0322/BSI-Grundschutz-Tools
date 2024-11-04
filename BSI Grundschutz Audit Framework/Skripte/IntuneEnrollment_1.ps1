# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH


# Dieses PowerShell-Skript führt den Befehl "reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Enrollments"" aus und gibt das Ergebnis als JSON-Objekt aus.

# Das Skript besteht aus zwei Teilen:
# 1. Ausführen des Befehls und Auswerten des Ergebnisses
# 2. Erstellen des JSON-Objekts mit den Ergebnissen

# Funktion zum Ausführen des Befehls und Auswerten des Ergebnisses
function Invoke-RegistryQuery {
    $result = 0
    $output = ""

    try {
        $output = reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Enrollments"
        if ($?) {
            $result = 1
        } else {
            $result = 0
        }
    } catch {
        $result = 2
        $output = $_.Exception.Message
    }

    return [PSCustomObject]@{
        Result = $result
        Output = $output
    }
}

# Aufruf der Funktion und Ausgabe als JSON-Objekt
$response = Invoke-RegistryQuery
$response | ConvertTo-Json

# Beispielausgabe:
# {
#     "Result":  1,
#     "Output":  "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Enrollments\Enrollment1\EnrollmentData\EnrollmentId    REG_SZ    {GUID}"
# }