# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


# Dieses PowerShell-Skript überprüft den geschützten Modus für den Local Credential Store (LSA)
# und gibt das Ergebnis als JSON-Objekt aus.

$lsaRegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$protectedModeValue = Get-ItemProperty -Path $lsaRegistryPath -Name "RunAsPPL" -ErrorAction SilentlyContinue

if ($protectedModeValue -eq 1) {
    $result = 1
    $output = "Der geschützte Modus für den Local Credential Store (LSA) ist aktiviert."
} else {
    $result = 0
    $output = "Der geschützte Modus für den Local Credential Store (LSA) ist nicht aktiviert."
}

if ($protectedModeValue -eq $null) {
    $result = 2
    $output = "Aus dem Befehl konnte kein klares Ergebnis ermittelt werden."
}

$jsonOutput = @{
    "Ergebnis" = $result
    "Output" = $output
} | ConvertTo-Json

Write-Output $jsonOutput