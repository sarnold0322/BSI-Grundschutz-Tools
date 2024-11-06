# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH
# das SKript fragt ab, ob der PC in einer Domäne ist, oder nicht und liefert den Namen der Domäne zurück
# result = 0 bedeutet, dass das Gerät in keiner Domäne ist
# result = 1 bedeutet, dass es in einer ist und 2 bedeutet, dass ein manueller Eingriff nötig ist. 

$result = 2
$output = ""

try {
    $output = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object Domain, PartOfDomain, Workgroup
    if ($output.PartOfDomain) {
        $result = 1
    } else {
        $result = 0
    }
} catch {
    $result = 2
    $output = $_.Exception.Message
}

return @{
    "Ergebnis" = $result
    "Output" = $output
} | ConvertTo-Json