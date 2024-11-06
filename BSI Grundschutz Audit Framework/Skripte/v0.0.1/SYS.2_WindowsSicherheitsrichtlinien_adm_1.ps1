# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


<# 
.SYNOPSIS
Dieses PowerShell-Skript exportiert die Sicherheitsrichtlinien des Systems in eine Konfigurationsdatei und gibt die Ergebnisse als JSON-Objekt aus.

.DESCRIPTION
Das Skript führt den Befehl "secedit /export /areas SECURITYPOLICY /cfg env:USERPROFILE"\Desktop\secpol.cfg" aus, um die Sicherheitsrichtlinien in eine Konfigurationsdatei zu exportieren. Anschließend wird der Inhalt der Datei mit "Get-Content" gelesen und als JSON-Objekt ausgegeben.

Das Ergebnis-Feld im JSON-Objekt enthält einen Wert, der den Status des Befehls angibt:
- 1: Der Befehl wurde erfolgreich ausgeführt.
- 0: Der Befehl ist fehlgeschlagen.
- 2: Es konnte kein eindeutiges Ergebnis ermittelt werden.

Das Output-Feld enthält die Ausgabe des Befehls.

.EXAMPLE
$result = .\Get-SecurityPolicy.ps1
$result | ConvertFrom-Json

Ergebnis:
{
    "Result": 1,
    "Output": "..."
}
#>

$secpolicyFile = Join-Path -Path $env:USERPROFILE -ChildPath "Desktop\secpol.cfg"

try {
    # Sicherheitsrichtlinien exportieren
    secedit /export /areas SECURITYPOLICY /cfg $secpolicyFile | Out-Null

    # Inhalt der Konfigurationsdatei lesen
    $output = Get-Content -Path $secpolicyFile -Raw

    # Ergebnis-Status festlegen
    $result = 1
}
catch {
    # Fehlerbehandlung
    $output = $_.Exception.Message
    $result = 0
}
finally {
    # Prüfen, ob das Ergebnis eindeutig ist
    if ([string]::IsNullOrEmpty($output)) {
        $result = 2
    }

    # JSON-Objekt erstellen und ausgeben
    [PSCustomObject]@{
        Result = $result
        Output = $output
    } | ConvertTo-Json
}