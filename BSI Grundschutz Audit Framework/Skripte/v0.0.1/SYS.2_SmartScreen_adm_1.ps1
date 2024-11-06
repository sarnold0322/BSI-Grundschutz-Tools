# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


# PowerShell Skript zum Abfragen des SmartScreenEnabled-Werts aus der Windows-Registry
# Das Skript gibt ein JSON-Objekt mit zwei Eigenschaften zurück:
# - "Ergebnis": 1 (positiv), 0 (negativ) oder 2 (kein klares Ergebnis)
# - "Output": die Ausgabe des Get-ItemProperty-Befehls

$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
$propertyName = "SmartScreenEnabled"

try {
    $result = Get-ItemProperty -Path $registryPath -Name $propertyName -ErrorAction Stop
    if ($result.$propertyName -eq 1) {
        $resultCode = 1
    } else {
        $resultCode = 0
    }
    $output = $result.$propertyName
} catch {
    $resultCode = 2
    $output = $null
}

$jsonOutput = @{
    "Ergebnis" = $resultCode
    "Output" = $output
} | ConvertTo-Json

Write-Output $jsonOutput