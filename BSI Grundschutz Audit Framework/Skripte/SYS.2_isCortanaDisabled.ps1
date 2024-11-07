# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH


# PowerShell Skript zum Abfragen des Cortana-Status in der Windows-Registry HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search AllowCortana
# Das Skript liefert ein JSON-Objekt mit zwei Eigenschaften: "Ergebnis" und "Output"
# "Ergebnis" ist 1, wenn der Befehl erfolgreich war, 0 bei Fehler und 2 wenn kein eindeutiges Ergebnis möglich ist
# "Output" enthält die Ausgabe des Befehls

$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
$property = "AllowCortana"

try {
    $regvalue = Get-ItemProperty -Path $registryPath | Select-Object -ExpandProperty $property
    if ($regvalue -eq $null) {
        $result = 2
        $output = "Kein eindeutiges Ergebnis möglich"
    } elseif ($regvalue -eq 0) {
        $result = 1
        $output = "$property $regvalue"
    } else {
        $result = 0
        $output = "$property $regvalue"        
    }
} catch {
    $result = 0
    $output = "Fehler beim Abrufen des Registrywerts: $($_.Exception.Message)"
}

return @{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json
