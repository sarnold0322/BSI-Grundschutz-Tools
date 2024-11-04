# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


# Dieses PowerShell-Skript überprüft, ob alle internen Festplatten mit BitLocker verschlüsselt sind.
# Das Ergebnis wird als JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output" ausgegeben.

$drives = Get-BitLockerVolume

$allEncrypted = $true
$output = ""

foreach ($drive in $drives) {
    if ($drive.ProtectionStatus -eq 'Off') {
        $output += "Das Laufwerk $($drive.MountPoint) ist nicht mit BitLocker verschlüsselt.`n"
        $allEncrypted = $false
    } else {
        $output += "Das Laufwerk $($drive.MountPoint) ist mit BitLocker verschlüsselt.`n"
    }
}

if ($allEncrypted) {
    $result = 1
    $output += "Alle internen Festplatten sind mit BitLocker verschlüsselt."
} else {
    $result = 0
    $output += "Nicht alle internen Festplatten sind mit BitLocker verschlüsselt."
}

$jsonOutput = @{
    Ergebnis = $result
    Output = $output
}

$jsonOutput | ConvertTo-Json