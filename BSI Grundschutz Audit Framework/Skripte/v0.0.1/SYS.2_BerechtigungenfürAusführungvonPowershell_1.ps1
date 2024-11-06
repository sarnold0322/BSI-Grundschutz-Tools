# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH


<# 
.SYNOPSIS
Überprüft die Ausführungsrichtlinie und die Berechtigungen für PowerShell.

.DESCRIPTION
Dieses PowerShell-Skript führt zwei Aufgaben aus:
1. Überprüft die Ausführungsrichtlinie für PowerShell.
2. Überprüft die Berechtigungen für die PowerShell-Anwendung.

Die Ausgabe des Skripts wird als JSON-Objekt mit zwei Eigenschaften zurückgegeben:
- "Ergebnis": 1 für positiv, 0 für negativ, 2 wenn kein klares Ergebnis möglich ist.
- "Output": Die Ausgabe der beiden Befehle.

.EXAMPLE
$result = .\check-powershell.ps1
$result | ConvertFrom-Json

Ergebnis:
{
    "Ergebnis": 1,
    "Output": [
        "Execution Policy: Unrestricted",
        "IdentityReference   FileSystemRights AccessControlType",
        "----------------   ----------------- ------------------",
        "BUILTIN\\Administrators FullControl Allow",
        "NT AUTHORITY\\SYSTEM    FullControl Allow",
        "BUILTIN\\Users          ReadAndExecute Allow"
    ]
}

#>

$result = [PSCustomObject]@{
    Ergebnis = 0
    Output = @()
}

# Überprüfen der Ausführungsrichtlinie
try {
    $executionPolicy = Get-ExecutionPolicy -List
    $result.Output += "Execution Policy: $($executionPolicy.CurrentExecutionPolicy)"
    $result.Ergebnis = 1
}
catch {
    $result.Output += "Error: $($_.Exception.Message)"
    $result.Ergebnis = 2
}

# Überprüfen der Berechtigungen für PowerShell
try {
    $powerShellPath = "$env:windir\System32\WindowsPowerShell\v1.0\powershell.exe"
    $acl = Get-Acl -Path $powerShellPath
    $result.Output += ($acl.Access | Select-Object IdentityReference, FileSystemRights, AccessControlType | Out-String)
    $result.Ergebnis = 1
}
catch {
    $result.Output += "Error: $($_.Exception.Message)"
    $result.Ergebnis = 2
}

$result | ConvertTo-Json