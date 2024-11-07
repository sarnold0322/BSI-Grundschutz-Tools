# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH


# Dieses PowerShell-Skript überprüft, ob der aktuelle Benutzer Berechtigungen für den Ordner "C:\Windows" hat.
# Das Ergebnis wird als JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output" ausgegeben.

$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$acl = Get-Acl "C:\Windows"
$hasAccess = $acl.Access | Where-Object { $_.IdentityReference -eq $currentUser }

if ($hasAccess) {
    $result = 1
    $output = "Der aktuelle Benutzer '$currentUser' hat Berechtigungen für 'C:\Windows'."
} else {
    $result = 0
    $output = "Der aktuelle Benutzer '$currentUser' hat keine Berechtigungen für 'C:\Windows'."
}

return @{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json
