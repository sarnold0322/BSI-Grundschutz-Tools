# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH

<#
.SYNOPSIS
Führt den Befehl "wmic computersystem get Domain,PartOfDomain,Workgroup" aus und gibt das Ergebnis als JSON-Objekt aus.

.DESCRIPTION
Dieses Skript führt den Befehl "wmic computersystem get Domain,PartOfDomain,Workgroup" aus und erstellt ein JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output". 
Der Wert von "Ergebnis" ist:
- 1, wenn der Befehl erfolgreich ausgeführt wurde
- 0, wenn der Befehl fehlgeschlagen ist
- 2, wenn aus dem Befehl kein eindeutiges Ergebnis abgeleitet werden kann

Der Wert von "Output" enthält die Ausgabe des Befehls.

.EXAMPLE
PS> .\get-computerinfo.ps1
{
    "Ergebnis": 1,
    "Output": "Domain                PartOfDomain  Workgroup
CONTOSO                True        WORKGROUP"
}
#>

$result = 0
$output = ""

try {
    $output = (wmic computersystem get Domain,PartOfDomain,Workgroup)
    if ($output) {
        $result = 1
    } else {
        $result = 2
    }
} catch {
    $result = 0
    $output = $_.Exception.Message
}

@{
    "Ergebnis" = $result
    "Output" = $output.Trim()
} | ConvertTo-Json