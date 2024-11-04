# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


<# 
.SYNOPSIS
Dieses PowerShell-Skript liest den Inhalt eines HTML-Berichts von gpresult aus und sucht nach den Einstellungen für die Verwendung von Wechselmedien und Netzwerklaufwerken in Remotedesktop-Sitzungen.

.DESCRIPTION
Das Skript liest den Inhalt des HTML-Berichts von gpresult aus, der sich standardmäßig auf dem Desktop des Benutzers befindet. Es durchsucht den Inhalt nach den Einstellungen für die Verwendung von Wechselmedien und Netzwerklaufwerken in Remotedesktop-Sitzungen und gibt das Ergebnis aus.

Das Ergebnis wird als JSON-Objekt mit zwei Eigenschaften zurückgegeben:
- "Ergebnis": 1 für positiv, 0 für negativ, 2 wenn kein klares Ergebnis möglich ist
- "Output": Die Ausgabe des Befehls

.EXAMPLE
$result = .\get-rdpSettings.ps1
$result | ConvertTo-Json

Ausgabe:
{
    "Ergebnis": 1,
    "Output": "Die Verwendung von Wechselmedien in RDP ist aktiviert.`nDie Verwendung von Netzwerklaufwerken in RDP ist aktiviert."
}

#>

$htmlContent = Get-Content -Path $env:USERPROFILE"\Desktop\gpresult.html" -Raw

# Nach der Einstellung für Wechselmedien in RDP suchen
if ($htmlContent -match "Zulassen, dass Wechselmedien in Remotedesktop-Sitzungen verwendet werden") {
    if ($htmlContent -match "Aktiviert") {
        $wechselmedienRDP = "Die Verwendung von Wechselmedien in RDP ist aktiviert."
        $ergebnis = 1
    } else {
        $wechselmedienRDP = "Die Verwendung von Wechselmedien in RDP ist deaktiviert."
        $ergebnis = 0
    }
} else {
    $wechselmedienRDP = "Die Einstellung für die Verwendung von Wechselmedien in RDP wurde nicht gefunden."
    $ergebnis = 2
}

# Nach der Einstellung für Netzwerklaufwerke in RDP suchen
if ($htmlContent -match "Zulassen, dass Netzwerklaufwerke in Remotedesktop-Sitzungen verwendet werden") {
    if ($htmlContent -match "Aktiviert") {
        $netzwerklaufwerkeRDP = "Die Verwendung von Netzwerklaufwerken in RDP ist aktiviert."
    } else {
        $netzwerklaufwerkeRDP = "Die Verwendung von Netzwerklaufwerken in RDP ist deaktiviert."
    }
} else {
    $netzwerklaufwerkeRDP = "Die Einstellung für die Verwendung von Netzwerklaufwerken in RDP wurde nicht gefunden."
    if ($ergebnis -eq 2) {
        $ergebnis = 2
    } else {
        $ergebnis = 0
    }
}

$output = "$wechselmedienRDP`n$netzwerklaufwerkeRDP"

[PSCustomObject]@{
    Ergebnis = $ergebnis
    Output = $output
}