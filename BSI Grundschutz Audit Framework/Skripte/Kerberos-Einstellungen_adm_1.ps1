# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


# Dieses PowerShell-Skript überprüft, ob Kerberos als Anmeldeprotokoll verwendet wird.
# Das Ergebnis wird als JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output" ausgegeben.

$policy = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -ErrorAction SilentlyContinue

if ($policy -and $policy.LsaKerberos) {
    $result = 1
    $output = "Kerberos ist als Anmeldeprotokoll konfiguriert."
} else {
    $result = 0
    $output = "Kerberos ist nicht als Anmeldeprotokoll konfiguriert."
}

$jsonOutput = [PSCustomObject]@{
    Ergebnis = $result
    Output = $output
}

$jsonOutput | ConvertTo-Json