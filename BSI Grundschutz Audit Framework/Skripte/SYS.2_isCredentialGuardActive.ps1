# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH

<#
.SYNOPSIS
Führt den Befehl "computerinfo" aus und prüft, ob CredentialGuard darin vorkommt und gibt das Ergebnis als JSON-Objekt aus.

.DESCRIPTION
Das Skript führt den angegebenen Befehl aus und wertet das Ergebnis aus. Es gibt ein JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output" zurück.
- "Ergebnis" ist 1, wenn der Befehl erfolgreich war, 0, wenn der Befehl fehlgeschlagen ist, und 2, wenn das Ergebnis nicht eindeutig ist.
- "Output" enthält die Ausgabe des Befehls.

.EXAMPLE
PS> .\Get-OSInfo.ps1
{
    "Ergebnis": 1,
    "Output": {
        "Caption": "Microsoft Windows 10 Pro",
        "SecureBoot": true
    }
}
#>

$result = 2
$output = $null

try {
    $output = (Get-ComputerInfo).DeviceGuardSecurityServicesConfigured

    if ($output -contains "CredentialGuard") {
        $result = 1
    } else {
        $result = 0
    }

    $outputString = $output | Out-String
}
catch {
    $result = 2
    $outputString = $_.Exception.Message
}


return [PSCustomObject]@{
    Ergebnis = $result
    Output = $outputString 
} | ConvertTo-Json