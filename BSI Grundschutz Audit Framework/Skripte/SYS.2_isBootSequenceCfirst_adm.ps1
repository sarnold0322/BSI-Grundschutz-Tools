# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR

# PowerShell Skript zum Abfragen der BootSequence über WMIC
# Das Skript liefert ein JSON-Objekt mit zwei Eigenschaften zurück:
# - Ergebnis: 1 für positiv, 0 für negativ, 2 wenn kein eindeutiges Ergebnis
# - Output: Die Ausgabe des WMIC-Befehls

$wmic_output = wmic bootconfig get BootSequence

# Überprüfen des Ergebnisses
if ($wmic_output -match "C:" -and $wmic_output -match "BootSequence") {
    $result = 1
} elseif ($wmic_output -match "No instances available") {
    $result = 0
} else {
    $result = 2
}

# Überprüfen, ob die Windows-Festplatte in der Bootsequenz ganz oben steht
if ($result -eq 1) {
    $bootsequence = $wmic_output.Split([Environment]::NewLine)
    $firstBootDevice = $bootsequence[0].Trim()
    if ($firstBootDevice -match "C:") {
        $result = 1
        $output = "Die Windows-Festplatte steht in der Bootsequenz ganz oben."
    } else {
        $result = 0
        $output = "Die Windows-Festplatte steht nicht in der Bootsequenz ganz oben."
    }
} else {
    $output = $wmic_output
}

# Erstellen des JSON-Objekts
$output_json = @{
    Ergebnis = $result
    Output = $output
} | ConvertTo-Json

# Ausgabe des JSON-Objekts
$output_json
