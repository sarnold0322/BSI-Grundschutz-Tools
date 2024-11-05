# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH


# PowerShell Skript zur ÃœberprÃ¼fung der AppLocker-Richtlinien
# Dieses Skript fÃ¼hrt den Befehl ((Get-AppLockerPolicy -Effective).RuleCollections).length -gt 0 aus
# und gibt das Ergebnis als JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output" aus.

# Ergebnis:
# - 1, wenn der Befehl zurÃ¼ckliefert, dass das Ergebnis positiv war
# - 0, wenn der Befehl zurÃ¼ckliefert, dass das Ergebnis negativ war
# - 2, wenn aus dem Befehl kein klares Ergebnis mÃ¶glich ist

# Output:
# - Die Ausgabe des Befehls ((Get-AppLockerPolicy -Effective).RuleCollections).length -gt 0

$result = 2
$output = $null

try {
    $output = Get-AppLockerPolicy -Effective | out-string
    $result = ((Get-AppLockerPolicy -Effective).RuleCollections).length -gt 0
    if ($output) {
        $result = 1
    } else {
        $result = 0
    }
} catch {
    $output = $_.Exception.Message
}

$jsonOutput = [PSCustomObject]@{
    Ergebnis = $result
    Output = $output
}

$jsonOutput | ConvertTo-Json