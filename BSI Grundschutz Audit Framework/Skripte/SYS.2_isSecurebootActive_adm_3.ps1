# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR

<#
.SYNOPSIS
Führt den Befehl "powershell Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object Caption,SecureBoot" aus und gibt das Ergebnis als JSON-Objekt aus.

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
    $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object Caption, SecureBoot
    $result = 1
    $output = [PSCustomObject]@{
        Caption = $osInfo.Caption
        SecureBoot = $osInfo.SecureBoot
    }
}
catch {
    $result = 2
    $output = $_.Exception.Message
}

if ($osInfo -eq $null -or $osInfo.SecureBoot -eq $null) {
    $result = 2
    $output = "Kein eindeutiges Ergebnis. Kein Admin?"
} elseif ($osInfo.SecureBoot -eq $true) {
    $output.SecureBoot = "Secure Boot ist aktiv."
} else {
    $output.SecureBoot = "Secure Boot ist nicht aktiv."
}

return [PSCustomObject]@{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json