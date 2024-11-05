# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH


# Powershell Skript zum Ausführen des Befehls "net user %username%"
# Die Ausgabe wird als JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output" zurückgegeben
# "Ergebnis" ist 1 bei positivem Ergebnis, 0 bei negativem Ergebnis und 2 wenn kein klares Ergebnis möglich ist
# "Output" enthält die Ausgabe des Befehls

$username = [Environment]::UserName
$output = net user $username
$result = 0

if ($LASTEXITCODE -eq 0) {
    $result = 1
} elseif ($LASTEXITCODE -eq 2) {
    $result = 2
}

$jsonOutput = [PSCustomObject]@{
    Ergebnis = $result
    Output = $output
}

$jsonOutput | ConvertTo-Json

# Beispiel:
# .\script.ps1
# {
#     "Ergebnis":  1,
#     "Output":  "User name                    %username%\r\nFull Name                    %username%\r\nComment                     \r\nUser's comment              \r\nCountry/region code         000 (System Default)\r\nAccount active              Yes\r\nAccount expires             Never\r\n\r\nPassword last set           2/1/2023 12:00:00 AM\r\nPassword expires           Never\r\nPassword changeable         2/1/2023 12:00:00 AM\r\nPassword required           Yes\r\nUser may change password     Yes\r\n\r\nLogon script                \r\nUser profile                \r\nHome directory              \r\nLast logon                  2/1/2023 12:00:00 AM\r\n\r\nAllowLogon                  Yes\r\nLockedOut                   No\r\nPasswordExpired             No\r\n"
# }