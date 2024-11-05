# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


<# 
.SYNOPSIS
Erstellt ein PowerShell-Skript, das den GPResult-Bericht generiert und nach der Einstellung für Windows Hello for Business sucht.

.DESCRIPTION
Dieses Skript führt die folgenden Schritte aus:
1. Erstellt einen Pfad zur GPResult-HTML-Datei auf dem Desktop.
2. Generiert den GPResult-Bericht im HTML-Format und speichert ihn an dem zuvor definierten Pfad.
3. Liest den Inhalt der HTML-Datei.
4. Sucht im HTML-Inhalt nach der Einstellung für Windows Hello for Business.
5. Gibt aus, ob Windows Hello for Business aktiviert ist oder nicht, oder ob die Einstellung nicht gefunden wurde.

Das Ergebnis wird als JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output" ausgegeben.

.EXAMPLE
.\GPResultScript.ps1
#>

$gpResultPath = "$env:USERPROFILE\Desktop\GPReport.html"

# GPResult-Report generieren
Get-GPResultantSetOfPolicy -ReportType Html -Path $gpResultPath

# HTML-Inhalt der GPResult-Datei lesen
$htmlContent = Get-Content -Path $gpResultPath -Raw

# Nach der Einstellung für Windows Hello for Business suchen
if ($htmlContent -match "Windows Hello for Business") {
    if ($htmlContent -match "Aktiviert") {
        $result = 1
        $output = "Windows Hello for Business ist aktiviert."
    } else {
        $result = 0
        $output = "Windows Hello for Business ist nicht aktiviert."
    }
} else {
    $result = 2
    $output = "Die Einstellung für Windows Hello for Business wurde nicht gefunden."
}

# Ergebnis als JSON-Objekt ausgeben
@{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json