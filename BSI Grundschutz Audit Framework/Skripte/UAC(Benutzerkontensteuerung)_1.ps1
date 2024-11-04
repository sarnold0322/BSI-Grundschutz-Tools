# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH


# Powershell-Skript zum Überprüfen des UAC-Status
# Dieses Skript überprüft den UAC-Status (User Account Control) und gibt das Ergebnis als JSON-Objekt aus.
# Das JSON-Objekt besteht aus zwei Teilen: "Ergebnis" und "Output".
# "Ergebnis" ist 1, wenn UAC aktiviert ist, 0, wenn UAC deaktiviert ist, und 2, wenn kein eindeutiges Ergebnis ermittelt werden kann.
# "Output" enthält die Ausgabe des Befehls.

$uac = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA"
if ($uac.EnableLUA -eq 1) {
    $result = 1
    $output = "UAC ist aktiviert."
} elseif ($uac.EnableLUA -eq 0) {
    $result = 0
    $output = "UAC ist deaktiviert."
} else {
    $result = 2
    $output = "Konnte UAC-Status nicht eindeutig ermitteln."
}

$jsonOutput = @{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json

Write-Output $jsonOutput