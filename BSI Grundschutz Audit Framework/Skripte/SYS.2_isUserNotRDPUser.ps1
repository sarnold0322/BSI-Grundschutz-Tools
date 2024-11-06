# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH

# das Skript prüft, ob der aktuelle User in der RDP Gruppe ist

$result = @{
    Ergebnis = 2
    Output = @()
}

# Überprüfen, welche Benutzer in der Gruppe Remotedesktopbenutzer sind
$rdpGroup = "S-1-5-32-555"
$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$rdpUsers = Get-LocalGroupMember -Group $rdpGroup -ErrorAction SilentlyContinue

if ($rdpUsers) {
    $result.Output += "Benutzer in der Gruppe '$rdpGroup':"
    $rdpUsers | ForEach-Object { $result.Output += $_.Name }

    # Überprüfen, ob der aktuelle Benutzer in der Gruppe ist
    if ($rdpUsers.Name -contains $currentUser) {
        $result.Output += "Der aktuelle Benutzer '$currentUser' ist in der Gruppe '$rdpGroup'."
        $result.Ergebnis = 0
    } else {
        $result.Output += "Der aktuelle Benutzer '$currentUser' ist NICHT in der Gruppe '$rdpGroup'."
        $result.Ergebnis = 1
    }
} else {
    $result.Output += "Es sind keine Benutzer in der Gruppe '$rdpGroup' oder die Gruppe existiert nicht."
    $result.Ergebnis = 1
}

return $result | ConvertTo-Json
