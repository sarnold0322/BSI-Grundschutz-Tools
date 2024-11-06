# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


<# 
.SYNOPSIS
Überprüft den Status der Windows-Firewall und gibt die Ergebnisse als JSON-Objekt aus.

.DESCRIPTION
Dieses PowerShell-Skript überprüft, ob die Windows-Firewall aktiviert ist und listet die aktiven eingehenden und ausgehenden Regeln auf. Die Ausgabe erfolgt als JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output".

.EXAMPLE
PS C:\> .\firewall_status.ps1
{
    "Ergebnis": 1,
    "Output": "Die Windows-Firewall ist aktiviert.\r\nEs sind aktive eingehende Regeln vorhanden:\r\nRule1\r\nRule2\r\nEs sind aktive ausgehende Regeln vorhanden:\r\nRule3\r\nRule4"
}

.NOTES
Dieses Skript erfordert PowerShell 3.0 oder höher.
#>

try { 
    $firewallStatus = Get-NetFirewallProfile | Where-Object { $_.Enabled -eq 'True' }

    if ($firewallStatus) {
        $result = 1
        $output = "Die Windows-Firewall ist aktiviert.`r`n"

        $inboundRules = Get-NetFirewallRule | Where-Object { $_.Direction -eq 'Inbound' -and $_.Enabled -eq 'True' }
        if ($inboundRules) {
            $output += "Es sind aktive eingehende Regeln vorhanden:`r`n"
            $inboundRules | ForEach-Object { $output += $_.DisplayName + "`r`n" }
        } else {
            $output += "Es sind keine aktiven eingehenden Regeln vorhanden.`r`n"
        }

        $outboundRules = Get-NetFirewallRule | Where-Object { $_.Direction -eq 'Outbound' -and $_.Enabled -eq 'True' }
        if ($outboundRules) {
            $output += "Es sind aktive ausgehende Regeln vorhanden:`r`n"
            $outboundRules | ForEach-Object { $output += $_.DisplayName + "`r`n" }
        } else {
            $output += "Es sind keine aktiven ausgehenden Regeln vorhanden."
        }
    } else {
        $result = 0
        $output = "Die Windows-Firewall ist deaktiviert."
    }
} catch {
    $result = 2
    $output = $_.Exception.Message
}

return @{
    Ergebnis = $result
    Output = $output
}| ConvertTo-Json