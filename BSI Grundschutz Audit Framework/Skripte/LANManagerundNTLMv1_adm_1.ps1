# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


# Dieses PowerShell-Skript überprüft, ob LAN Manager und NTLMv1 deaktiviert sind.
# Das Ergebnis wird als JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output" ausgegeben.

$result = @{
    Ergebnis = 0
    Output = ""
}

# Überprüfen der LAN Manager-Einstellungen
$lmPolicy = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -ErrorAction SilentlyContinue

if ($lmPolicy -and $lmPolicy.LmCompatibilityLevel -eq 0) {
    $result.Ergebnis = 1
    $result.Output = "Die Verwendung von LAN Manager ist deaktiviert."
} else {
    $result.Ergebnis = 0
    $result.Output = "Die Verwendung von LAN Manager ist aktiviert."
}

# Überprüfen der NTLMv1-Einstellungen
$ntlmPolicy = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -ErrorAction SilentlyContinue

if ($ntlmPolicy -and $ntlmPolicy.LmCompatibilityLevel -ge 2) {
    $result.Ergebnis = 1
    $result.Output += "`nDie Verwendung von NTLMv1 ist deaktiviert."
} else {
    $result.Ergebnis = 0
    $result.Output += "`nDie Verwendung von NTLMv1 ist aktiviert."
}

# Ausgabe des Ergebnisses als JSON-Objekt
$result | ConvertTo-Json