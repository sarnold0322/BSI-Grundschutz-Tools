# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH


# Dieses PowerShell-Skript überprüft, ob die Eingabeaufforderung (CMD) durch Gruppenrichtlinien deaktiviert ist.
# Die Ausgabe erfolgt als JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output".
# "Ergebnis" ist 1, wenn CMD deaktiviert ist, 0 wenn CMD erlaubt ist, und 2 wenn kein klares Ergebnis möglich ist.
# "Output" enthält die Ausgabe des Befehls.

$cmdPolicy = Get-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\System" -ErrorAction SilentlyContinue

if ($cmdPolicy -and $cmdPolicy.DisableCMD -eq 1) {
    $result = 1
    $output = "Die Eingabeaufforderung (CMD) ist durch Gruppenrichtlinien deaktiviert."
} elseif ($cmdPolicy -and $cmdPolicy.DisableCMD -eq 0) {
    $result = 0
    $output = "Die Eingabeaufforderung (CMD) ist erlaubt."
} else {
    $result = 2
    $output = "Konnte nicht eindeutig feststellen, ob die Eingabeaufforderung (CMD) deaktiviert ist."
}

@{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json