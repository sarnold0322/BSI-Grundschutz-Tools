# Skript erstellt am 2024-11-07
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH

# Das Skript prüft, ob Trusted Locations gesetzt sind und welche dies sind. 

# Pfad zu den sicheren Speicherorten in der Registry
$trustCenterPath = "HKCU:\Software\Policies\Microsoft\Office\16.0\Excel\Security\Trusted Locations"

# Initialisieren der Ergebnisvariable
$result = @()

# Überprüfen, ob sichere Speicherorte festgelegt sind
$trustedLocations = Get-ChildItem -Path $trustCenterPath -ErrorAction SilentlyContinue

# Erstellen der Ausgabeinformationen
if ($trustedLocations) {
    foreach ($location in $trustedLocations) {
        $path = Get-ItemProperty -Path $location.PSPath -Name Path -ErrorAction SilentlyContinue
        $description = Get-ItemProperty -Path $location.PSPath -Name Description -ErrorAction SilentlyContinue
        $result += [PSCustomObject]@{
            Speicherort = $path.Path
            Beschreibung = $description.Description
        }
    }
    $output = "Sichere Speicherorte gefunden."
} else {
    $output = "Keine sicheren Speicherorte gefunden."
}

# Rückgabe der sicheren Speicherorte als JSON
return [PSCustomObject]@{
    Ergebnis =  | Out-String
    Output = $output
} | ConvertTo-Json
