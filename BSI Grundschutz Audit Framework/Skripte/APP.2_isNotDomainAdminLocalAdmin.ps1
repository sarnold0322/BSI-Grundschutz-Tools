# Skript erstellt am 2024-11-07
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH

# Das Skript überprüft, ob Mitglieder einer lokalen Gruppe, die aus Active Directory stammen, Teil der Domain-Admins-Gruppe sind, und speichert das Ergebnis sowie den Status der Überprüfung in einem PSObject.


# Importiere die notwendige .NET-Assembly
Add-Type -AssemblyName System.DirectoryServices

# Definiere die SID der Gruppe, die überprüft werden soll
$groupSID = "S-1-5-32-544"  # Beispiel-SID für die Gruppe der Domain-Admins

# Funktion, um zu überprüfen, ob ein Benutzer oder eine Gruppe Mitglied der Domain-Admins-Gruppe ist
function Is-MemberOfDomainAdmins {
    param (
        [string]$objectName
    )

    try {
        # Erstelle ein DirectorySearcher-Objekt, um die Gruppe anhand der SID zu finden
        $searcher = New-Object System.DirectoryServices.DirectorySearcher
        $searcher.Filter = "(objectSid=$groupSID)"
        $searcher.SearchScope = "Subtree"
        $searcher.PropertiesToLoad.Add("member")

        # Finde die Gruppe
        $group = $searcher.FindOne()

        if ($group -ne $null) {
            # Hole die Mitglieder der Gruppe
            $members = $group.Properties["member"]

            # Überprüfe, ob das Objekt Mitglied der Gruppe ist
            foreach ($member in $members) {
                $memberEntry = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$member")
                if ($memberEntry.Name -eq $objectName) {
                    return $true
                }
            }
        }
        return $false
    } catch {
        Write-Error "Fehler beim Überprüfen der Mitgliedschaft: $_"
        return $null
    }
}

# Beispielhafte Verwendung des Befehls, um lokale Gruppenmitglieder zu erhalten
# und zu überprüfen, ob sie aus Active Directory stammen
$output = ""
$result = 1

try {
    $localGroupMembers = Get-LocalGroup -SID "S-1-5-32-544" | Get-LocalGroupMember | Where-Object {$_.PrincipalSource -eq "ActiveDirectory"}

    foreach ($member in $localGroupMembers) {
        $objectName = $member.Name
        $output += "$objectName "
        if (Is-MemberOfDomainAdmins $objectName) {
            $output += "ist Mitglied der Domain-Admins-Gruppe.`n"
            $result = 0
        } else {
            $output += "ist kein Mitglied der Domain-Admins-Gruppe.`n"
        }
    }
} catch {
    $output = "Fehler beim Abrufen der lokalen Gruppenmitglieder: $_"
    $result = 2
}

# Ergebnis in ein PSObject speichern
return [PSCustomObject]@{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json
