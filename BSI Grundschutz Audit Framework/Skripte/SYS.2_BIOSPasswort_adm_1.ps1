# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR

<#
.SYNOPSIS
Holt BIOS-Informationen und gibt sie als JSON-Objekt aus.

.DESCRIPTION
Dieses Skript führt den Befehl "wmic bios get BIOSVersion, BIOSReleaseDate, BIOSManufacturer, BIOSPassword" aus und gibt die Ergebnisse als JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output" aus.

.EXAMPLE
$result = Get-BIOSInfo
$result | ConvertTo-Json

Ausgabe:
{
    "Ergebnis": "1",
    "Output": {
        "BIOSVersion": "BIOS Version 1.2.3",
        "BIOSReleaseDate": "2023-04-01",
        "BIOSManufacturer": "Acme Corporation",
        "BIOSPassword": "P@ssw0rd"
    }
}
#>
function Get-BIOSInfo {
    $wmiResult = wmic bios get BIOSVersion, BIOSReleaseDate, BIOSManufacturer, BIOSPassword
    if ($LASTEXITCODE -eq 0) {
        $output = @{}
        $wmiResult.Trim().Split("`n") | ForEach-Object {
            $parts = $_.Split(",")
            $output[$parts[0].Trim()] = $parts[1].Trim()
        }
        return @{
            Ergebnis = "1"
            Output = $output
        }
    } elseif ($LASTEXITCODE -eq 1) {
        return @{
            Ergebnis = "0"
            Output = $null
        }
    } else {
        return @{
            Ergebnis = "2"
            Output = $null
        }
    }
}