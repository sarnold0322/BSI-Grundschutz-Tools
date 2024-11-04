# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


# PowerShell Skript zum Abfragen der BootSequence über WMIC
# Das Skript liefert ein JSON-Objekt mit zwei Eigenschaften zurück:
# - Ergebnis: 1 für positiv, 0 für negativ, 2 wenn kein eindeutiges Ergebnis
# - Output: Die Ausgabe des WMIC-Befehls

$wmic_output = wmic bootconfig get BootSequence

# Überprüfen des Ergebnisses
if ($wmic_output -match "BootSequence") {
    $result = 1
} elseif ($wmic_output -match "No instances available") {
    $result = 0
} else {
    $result = 2
}

# Erstellen des JSON-Objekts
$output = @{
    Ergebnis = $result
    Output = $wmic_output
} | ConvertTo-Json

# Ausgabe des JSON-Objekts
$output