# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


# Dieses PowerShell-Skript überprüft, ob Secure Boot aktiviert ist und gibt das Ergebnis als JSON-Objekt aus.

$secureBoot = Confirm-SecureBootUEFI

if ($secureBoot) {
    $result = 1
    $output = "Secure Boot ist aktiviert."
} else {
    $result = 0
    $output = "Secure Boot ist nicht aktiviert."
}

$jsonOutput = @{
    "result" = $result
    "output" = $output
} | ConvertTo-Json

Write-Output $jsonOutput