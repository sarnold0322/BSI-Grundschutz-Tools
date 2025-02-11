# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH

<#
.SYNOPSIS
Dieses Skript liest die Werte der Registrierungsschlüssel "AutoAdminLogon" und "DefaultUserName" aus der Registry aus und gibt sie als JSON-Objekt aus.

.DESCRIPTION
Das Skript verwendet den Befehl "Get-ItemProperty" um die Werte der Registrierungsschlüssel "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Winlogon" auszulesen. 
Das Ergebnis wird in einem JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output" zurückgegeben.
Der Wert von "Ergebnis" ist:
- 1, wenn Autologon deaktiviert ist
- 0, wenn Autologon aktiviert ist
- 2, wenn aus dem Befehl kein eindeutiges Ergebnis abgeleitet werden kann

.EXAMPLE
PS> .\Get-RegistryValues.ps1
{
    "Ergebnis":  1,
    "Output":  {
        "AutoAdminLogon":  "1",
        "DefaultUserName":  "MyUser"
    }
}
#>

$ErrorActionPreference = "SilentlyContinue"

try {
    $registryValues = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AutoAdminLogon','DefaultUserName'
    if ($registryValues.AutoAdminLogon -eq 1) {
        $result = 0
    } elseif ($registryValues.AutoAdminLogon -eq 0) {
        $result = 1
    }
    $output = $registryValues | select AutoAdminLogon, DefaultUserName
}
catch {
    $result = 0
    $output = $_.Exception.Message
}

#if ($output -eq $null -or $output.AutoAdminLogon -eq $null -or $output.DefaultUserName -eq $null) {
#    $result = 2
#}

return [PSCustomObject]@{
    Ergebnis = $result
    Output = $output
}