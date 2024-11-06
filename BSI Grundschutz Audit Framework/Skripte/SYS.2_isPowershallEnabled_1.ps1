# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH


<# 
.SYNOPSIS
Überprüft, ob PowerShell durch Gruppenrichtlinien deaktiviert ist.

.DESCRIPTION
Dieses PowerShell-Skript überprüft, ob PowerShell durch Gruppenrichtlinien deaktiviert ist. 
Die Ausgabe erfolgt als JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output".

.EXAMPLE
PS> .\Check-PowerShellDisabled.ps1
{
    "Ergebnis": "1",
    "Output": "PowerShell ist erlaubt."
}

.EXAMPLE 
PS> .\Check-PowerShellDisabled.ps1
{
    "Ergebnis": "0", 
    "Output": "PowerShell ist durch Gruppenrichtlinien deaktiviert."
}
#>

$policy = Get-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\PowerShell" -ErrorAction SilentlyContinue
$result = 2

if ($policy -and $policy.EnableScripts -eq 0) {
    $result = "0"
    $output = "PowerShell ist durch Gruppenrichtlinien deaktiviert."
} else {
    $result = "1" 
    $output = "PowerShell ist erlaubt."
}

$jsonOutput = [PSCustomObject]@{
    Ergebnis = $result
    Output = $output
}

return $jsonOutput | ConvertTo-Json