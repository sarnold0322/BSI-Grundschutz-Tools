# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


# PowerShell Skript zum Ausführen des bcdedit /enum firmware Befehls
# und Ausgabe als JSON-Objekt

<#
.SYNOPSIS
Führt den bcdedit /enum firmware Befehl aus und gibt das Ergebnis als JSON-Objekt aus.

.DESCRIPTION
Das Skript führt den bcdedit /enum firmware Befehl aus und wertet das Ergebnis aus.
Das Ergebnis wird als JSON-Objekt mit zwei Eigenschaften ausgegeben:
- Ergebnis: 1 bei positivem Ergebnis, 0 bei negativem Ergebnis, 2 wenn kein klares Ergebnis möglich ist.
- Output: Die Ausgabe des bcdedit /enum firmware Befehls.

.EXAMPLE
PS> .\bcdedit-enum-firmware.ps1
{
    "Ergebnis": 1,
    "Output": "Windows Boot Manager
    -------- -----
    identifier {bootmgr}
    device partition=C:
    path \Boot\BCD
    description Windows Boot Manager
    locale en-US
    inherit {globalsettings}
    default {current}
    resumeobject {xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}
    displayorder {current}
    toolsdisplayorder {memdiag}
    timeout 30
"
}

#>

$result = bcdedit /enum firmware
$exitCode = $LASTEXITCODE

if ($exitCode -eq 0) {
    $resultObject = [PSCustomObject]@{
        Ergebnis = 1
        Output = $result
    }
} elseif ($exitCode -eq 1) {
    $resultObject = [PSCustomObject]@{
        Ergebnis = 0
        Output = $result
    }
} else {
    $resultObject = [PSCustomObject]@{
        Ergebnis = 2
        Output = $result
    }
}

$resultObject | ConvertTo-Json