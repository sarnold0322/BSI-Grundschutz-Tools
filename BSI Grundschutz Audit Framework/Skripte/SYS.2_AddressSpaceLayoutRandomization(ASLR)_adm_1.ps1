# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


# Dieses PowerShell-Skript überprüft die ASLR-Einstellungen (Address Space Layout Randomization) auf dem System.
# Das Ergebnis wird als JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output" ausgegeben.

$aslrSettings = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -ErrorAction SilentlyContinue

if ($aslrSettings) {
    if ($aslrSettings.EnableRandomizedBaseAddress -eq 1) {
        $result = 1
        $output = "ASLR ist aktiviert."
    } else {
        $result = 0
        $output = "ASLR ist deaktiviert."
    }
} else {
    $result = 2
    $output = "ASLR-Einstellungen konnten nicht gefunden werden."
}

$jsonOutput = @{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json

Write-Output $jsonOutput