# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH


<# 
.SYNOPSIS
Dieses PowerShell-Skript listet die installierten Programme auf und filtert nach typischer Bloatware.
Die Ausgabe erfolgt als JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output".

.DESCRIPTION
Das Skript verwendet den Befehl "Get-Package", um eine Liste der installierten Programme zu erhalten.
Anschließend wird diese Liste mit einer vordefinierten Liste von Bloatware-Namen verglichen.
Je nach Ergebnis wird ein JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output" ausgegeben.

.EXAMPLE
PS> .\bloatware_check.ps1
{
    "Ergebnis": 1,
    "Output": "Folgende Bloatware ist installiert:
    Candy Crush
    Xbox
    Skype
    OneDrive
    Microsoft News
    Microsoft Solitaire
    Get Office
    Get Skype"
}
#>

$result = 2

$installedPrograms = Get-Package | Select-Object Name

$bloatwareList = @(
    "Candy Crush",
    "Xbox",
    "Skype",
    "OneDrive",
    "Microsoft News",
    "Microsoft Solitaire",
    "Get Office",
    "Get Skype"
)

$bloatwareInstalled = $installedPrograms | Where-Object { $bloatwareList -contains $_.Name }

if ($bloatwareInstalled) {
    $result = 0
    $output = "Folgende Bloatware ist installiert:`n" + ($bloatwareInstalled | ForEach-Object { $_.Name }) -join "`n"
} else {
    $result = 1
    $output = "Keine typische Bloatware gefunden."
}

return @{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json

