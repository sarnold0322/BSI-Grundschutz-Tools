# Skript erstellt am 2024-11-08
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH

# Dieses PowerShell-Skript prüft, ob TLS-Reporting im Exchange aktiv ist. 

$domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name
$domain = "stadtwerke-hall.local"
$dnsRecord = "_smtp._tls." + $domain
try {
    $result = Resolve-DnsName -Name $dnsRecord -Type TXT
    if ($result) {
        Write-Output "TLS-Reporting ist aktiviert: $($result.Strings)"
    } else {
        Write-Output "TLS-Reporting ist nicht aktiviert."
    }
} catch {
    Write-Output "Fehler beim Überprüfen des DNS-Eintrags: $_"
}

