# Skript erstellt am 2024-11-07
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH

<#
.SYNOPSIS
Prüfen auf Office Macros


.DESCRIPTION
Dieses PowerShell-Skript überprüft, ob aktive Inhalte (Makros) in Microsoft Office-Produkten deaktiviert sind. Es liest die entsprechenden Einstellungen aus der Windows-Registry aus und gibt das Ergebnis sowie detaillierte Informationen über den Status der Makro-Einstellungen zurück.

Funktionen:
Registry-Pfad: Das Skript greift auf den Registry-Pfad HKCU:\Software\Policies\Microsoft\Office zu, um die Office-Richtlinieneinstellungen zu überprüfen.
Makro-Status: Es überprüft den Wert des VBAWarnings-Schlüssels, um festzustellen, ob Makros deaktiviert sind.
Ergebnis: Das Skript gibt ein JSON-Objekt zurück, das den Status der Makro-Einstellungen (Ergebnis) und eine detaillierte Ausgabe (Output) enthält.
Rückgabewerte:
Ergebnis:
1 - Makros sind deaktiviert.
0 - Makros sind nicht deaktiviert.
2 - Fehler beim Abrufen der Einstellungen.
Output: Detaillierte Informationen über den Wert des VBAWarnings-Schlüssels.


.EXAMPLE
Beispielausgabe:
JSON

{
    "Ergebnis": 1,
    "Output": ""VBAWarnings: 3 - Makros sind deaktiviert.""
}

#>

# Pfad zu den Office-Einstellungen in der Registry
$officePath = "HKCU:\SOFTWARE\Policies\Microsoft\office\16.0\excel\security"

# Überprüfen, ob Makros in Office-Produkten deaktiviert sind
$macrosDisabled = Get-ItemProperty -Path $officePath -Name VBAWarnings -ErrorAction SilentlyContinue

# Initialisieren der Ergebnisvariable
$result = 2

# Erstellen der Ausgabeinformationen
$output = "VBAWarnings: " + $macrosDisabled.VBAWarnings

# Überprüfen, ob Makros deaktiviert sind
if ($macrosDisabled.VBAWarnings -eq 3) {
    $output += " - Makros sind deaktiviert."
    $result = 1
} else {
    $output += " - Makros sind nicht deaktiviert."
    $result = 0
}

# Rückgabe des Ergebnisses und der Ausgabeinformationen als JSON
return [PSCustomObject]@{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json
