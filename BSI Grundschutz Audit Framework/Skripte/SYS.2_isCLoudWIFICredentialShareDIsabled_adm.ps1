# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


# Dieses PowerShell-Skript überprüft, ob das Teilen von WLAN-Passwörtern deaktiviert ist.
# Das Ergebnis wird als JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output" ausgegeben.

$policy = Get-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WcmSvc" -ErrorAction SilentlyContinue

if ($policy -and $policy.AllowSharing -eq 0) {
    $result = 1
    $output = "Das Teilen von WLAN-Passwörtern ist deaktiviert."
} else {
    $result = 0
    $output = "Das Teilen von WLAN-Passwörtern ist erlaubt."
}

return @{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json