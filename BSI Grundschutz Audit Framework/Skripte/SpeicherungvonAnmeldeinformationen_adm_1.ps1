# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


# Dieses PowerShell-Skript überprüft, ob die Speicherung von Anmeldeinformationen deaktiviert ist.
# Das Ergebnis wird als JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output" ausgegeben.

$policy = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Credentials" -ErrorAction SilentlyContinue

if ($policy -and $policy.DisablePasswordCaching -eq 1) {
    $result = 1
    $output = "Die Speicherung von Kennwörtern zur automatischen Anmeldung ist deaktiviert."
} elseif ($policy -and $policy.DisablePasswordCaching -eq 0) {
    $result = 0
    $output = "Die Speicherung von Kennwörtern zur automatischen Anmeldung ist erlaubt."
} else {
    $result = 2
    $output = "Konnte den Status der Speicherung von Anmeldeinformationen nicht ermitteln."
}

$jsonOutput = @{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json

Write-Output $jsonOutput