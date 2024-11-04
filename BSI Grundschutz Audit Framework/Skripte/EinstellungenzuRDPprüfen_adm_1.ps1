# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


<# 
Dieses PowerShell-Skript überprüft den Status von RDP (Remote Desktop Protocol) auf einem Windows-System und gibt die Ergebnisse in einem JSON-Format aus.

Das Skript führt folgende Überprüfungen durch:
1. Überprüft, ob RDP aktiviert ist.
2. Überprüft, ob der RDP-Port in der Firewall für jede Zone (Domain, Private, Public) offen ist.
3. Überprüft, welche Benutzer in der Gruppe "Remotedesktopbenutzer" sind.

Die Ausgabe des Skripts ist ein JSON-Objekt mit zwei Eigenschaften:
- "Ergebnis": 1 für positiv, 0 für negativ, 2 wenn kein klares Ergebnis möglich ist.
- "Output": Die Ausgabe des Befehls.
#>

$result = @{
    Ergebnis = 0
    Output = @()
}

# Überprüfen, ob RDP aktiv ist
$rdpStatus = Get-WmiObject -Class Win32_TerminalServiceSetting -ErrorAction SilentlyContinue
if ($rdpStatus -and $rdpStatus.AllowTSConnections -eq 1) {
    $result.Output += "RDP ist aktiviert."
    $result.Ergebnis = 1
} else {
    $result.Output += "RDP ist deaktiviert."
    $result.Ergebnis = 0
}

# Überprüfen, ob der RDP-Port in der Firewall für jede Zone offen ist
$rdpPort = 3389
$zones = @("Domain", "Private", "Public")

foreach ($zone in $zones) {
    $firewallRule = Get-NetFirewallRule | Where-Object { $_.DisplayName -like "*Remote Desktop*" -and $_.Enabled -eq "True" -and $_.Profile -like "*$zone*" }

    if ($firewallRule) {
        $result.Output += "Der RDP-Port ($rdpPort) ist in der Firewall für die '$zone'-Zone offen."
        $result.Ergebnis = 1
    } else {
        $result.Output += "Der RDP-Port ($rdpPort) ist in der Firewall für die '$zone'-Zone geschlossen."
        $result.Ergebnis = 0
    }
}

# Überprüfen, welche Benutzer in der Gruppe Remotedesktopbenutzer sind
$rdpGroup = "Remote Desktop Users"
$rdpUsers = Get-LocalGroupMember -Group $rdpGroup -ErrorAction SilentlyContinue

if ($rdpUsers) {
    $result.Output += "Benutzer in der Gruppe '$rdpGroup':"
    $rdpUsers | ForEach-Object { $result.Output += $_.Name }
    $result.Ergebnis = 1
} else {
    $result.Output += "Es sind keine Benutzer in der Gruppe '$rdpGroup' oder die Gruppe existiert nicht."
    $result.Ergebnis = 2
}

$result | ConvertTo-Json