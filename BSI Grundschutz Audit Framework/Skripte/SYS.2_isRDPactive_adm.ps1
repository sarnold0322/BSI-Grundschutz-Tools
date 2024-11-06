# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


<# 
Dieses PowerShell-Skript überprüft den Status von RDP (Remote Desktop Protocol) auf einem Windows-System und gibt die Ergebnisse in einem JSON-Format aus.

Das Skript führt folgende Überprüfungen durch:
1. Überprüft, ob RDP aktiviert ist.
2. Überprüft, ob der RDP-Port in der Firewall für jede Zone (Domain, Private, Public) offen ist.

Die Ausgabe des Skripts ist ein JSON-Objekt mit zwei Eigenschaften:
- "Ergebnis": 1 wenn RDP nicht aktiv ist, 0 wenn aktiv, 2 wenn kein klares Ergebnis möglich ist.
- "Output": Die Ausgabe des Befehls.
#>

$result = @{
    Ergebnis = 2
    Output = @()
}

# Überprüfen, ob RDP aktiv ist
$rdpStatus = Get-WmiObject -Class Win32_TerminalServiceSetting -ErrorAction SilentlyContinue
if ($rdpStatus -and $rdpStatus.AllowTSConnections -eq 1) {
    $result.Output += "RDP ist aktiviert."
    $result.Ergebnis = 0
} else {
    $result.Output += "RDP ist deaktiviert."
    $result.Ergebnis = 1
}

# Überprüfen, ob der RDP-Port in der Firewall für jede Zone offen ist
$rdpPort = 3389
$zones = @("Domain", "Private", "Public")

foreach ($zone in $zones) {
    $firewallRule = Get-NetFirewallRule | Where-Object { $_.DisplayName -like "*Remote Desktop*" -and $_.Enabled -eq "True" -and $_.Profile -like "*$zone*" }

    if ($firewallRule) {
        $result.Output += "Der RDP-Port ($rdpPort) ist in der Firewall für die '$zone'-Zone offen."
        $result.Ergebnis = 0
    } else {
        $result.Output += "Der RDP-Port ($rdpPort) ist in der Firewall für die '$zone'-Zone geschlossen."
        $result.Ergebnis = 1
    }
}



return $result | ConvertTo-Json