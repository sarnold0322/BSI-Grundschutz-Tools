# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


# Dieses PowerShell-Skript überprüft, ob NTLM in den Sicherheitsoptionen deaktiviert ist.
# Das Ergebnis wird als JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output" ausgegeben.

$policy = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -ErrorAction SilentlyContinue

if ($policy -and $policy.Lsa) {
    if ($policy.Lsa -eq 1) {
        $result = 1
        $output = "Die Verwendung von NTLM ist deaktiviert."
    } else {
        $result = 0
        $output = "Die Verwendung von NTLM ist erlaubt."
    }
} else {
    $result = 2
    $output = "Die NTLM-Richtlinie wurde nicht gefunden."
}

$jsonOutput = @{
    Ergebnis = $result
    Output = $output
}

ConvertTo-Json $jsonOutput