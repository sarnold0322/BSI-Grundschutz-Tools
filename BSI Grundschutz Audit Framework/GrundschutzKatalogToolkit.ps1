# Skript erstellt am 2024-11-07
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH
# Das Srkipt erwartet den Ordner "Skripte" im gleichen Verzeichnis

# ENTWURF einer einfachen GUI um die Skripte zu starten
# Fehlende Funktionen:
# - Erstellen von Berichten
# - Farbliches Feedback
# - Eklärungen 
# --> Ganz, ganz frühe Beta!!!

# Importiere die notwendigen Assemblies für die GUI
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Erstelle das Hauptfenster für die GUI
$form = New-Object System.Windows.Forms.Form
$form.Text = "Grundschutz Katalog Toolkit"  # Titel des Fensters
$form.Size = New-Object System.Drawing.Size(600, 400)  # Größe des Fensters
$form.StartPosition = "CenterScreen"  # Startposition des Fensters

# Erstelle eine Menüleiste für die Anwendung
$menuStrip = New-Object System.Windows.Forms.MenuStrip

# Erstelle das "Datei"-Menü
$dateiMenu = New-Object System.Windows.Forms.ToolStripMenuItem("Datei")

# Erstelle die Untermenüpunkte für das "Datei"-Menü
$neuMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem("&Neu")
$oeffnenMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem("&Oeffnen")
$speichernUnterMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem("Speichern &unter")
$schliessenMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem("&Schliessen")

# Füge die Untermenüpunkte zum "Datei"-Menü hinzu
$dateiMenu.DropDownItems.Add($neuMenuItem)
$dateiMenu.DropDownItems.Add($oeffnenMenuItem)
$dateiMenu.DropDownItems.Add($speichernUnterMenuItem)
$dateiMenu.DropDownItems.Add($schliessenMenuItem)

# Füge das "Datei"-Menü zur Menüleiste hinzu
$menuStrip.Items.Add($dateiMenu)

# Setze die Menüleiste im Formular
$form.MainMenuStrip = $menuStrip

# Erstelle ein TableLayoutPanel für die Anordnung von Steuerelementen
$tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
$tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill  # Fülle den verfügbaren Platz
$tableLayoutPanel.RowCount = 2  # Anzahl der Zeilen
$tableLayoutPanel.ColumnCount = 1  # Anzahl der Spalten
$tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize)))  # Erste Zeile passt sich dem Inhalt an
$tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))  # Zweite Zeile nimmt den Rest des Platzes ein
$form.Controls.Add($tableLayoutPanel)  # Füge das TableLayoutPanel zum Formular hinzu
# Füge die Menüleiste zum TableLayoutPanel hinzu
$tableLayoutPanel.Controls.Add($menuStrip, 0, 0)

# Erstelle die DataGridView zur Anzeige von Skripten
$dataGridView = New-Object System.Windows.Forms.DataGridView
$dataGridView.Dock = [System.Windows.Forms.DockStyle]::Fill  # Fülle den verfügbaren Platz
$dataGridView.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::Fill  # Spalten füllen den verfügbaren Platz
$dataGridView.ReadOnly = $true  # DataGridView ist schreibgeschützt

# Füge Spalten zur DataGridView hinzu
$dataGridView.Columns.Add("Dateiname", "Dateiname")  # Spalte für Dateinamen
$dataGridView.Columns.Add("Adminrechte", "Adminrechte")  # Spalte für Adminrechte
$dataGridView.Columns.Add("Ergebnis", "Ergebnis")  # Spalte für das Ergebnis der Skriptausführung
# Füge die DataGridView zum TableLayoutPanel hinzu
$tableLayoutPanel.Controls.Add($dataGridView, 0, 1)

# Finde den Ordner dieses Skripts
$myScriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Definiere den Pfad zum Skripte-Ordner
$scriptFolder = Join-Path -Path $myScriptDirectory -ChildPath "Skripte"

# Überprüfe, ob der Skripte-Ordner existiert
if (Test-Path $scriptFolder) {
    # Hole alle .ps1 Dateien im Skripte-Ordner
    $ps1Files = Get-ChildItem -Path $scriptFolder -Filter "*.ps1"

    # Füge die Skripte zur DataGridView hinzu
    foreach ($file in $ps1Files) {
        $row = @()  # Erstelle ein leeres Array für die Zeilendaten
        $row += $file.Name  # Füge den Dateinamen hinzu
        $row += if ($file.Name -like "*_adm_*") { "X" } else { "" }  # Überprüfe auf Adminrechte
        $row += ""  # Platz für das Ergebnis
        $dataGridView.Rows.Add($row)  # Füge die Zeile zur DataGridView hinzu
    }
} else {
    [System.Windows.Forms.MessageBox]::Show("Der Ordner 'Skripte' existiert nicht.", "Fehler", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
}

# Ereignisbehandlung für Doppelklick auf eine Zelle
$dataGridView.Add_CellDoubleClick({
    param($sender, $e)

    # Überprüfe, ob eine gültige Zeile angeklickt wurde
    if ($e.RowIndex -ge 0) {
        # Hole den Skriptnamen aus der angeklickten Zeile
        $scriptName = $dataGridView.Rows[$e.RowIndex].Cells[0].Value
        $startSkript = Join-Path -Path $scriptFolder -ChildPath $scriptName  # Vollständiger Pfad zum Skript
        try {
            $jsonErgebnis = & $startSkript  # Führe das Skript aus
        } catch {
            Write-Host "Ein Fehler ist aufgetreten: $_"  # Fehlerbehandlung
        }

        Write-Host $jsonErgebnis  # Ausgabe des Ergebnisses im Konsolenfenster
        # Füge das Ergebnis in die DataGridView ein
        $dataGridView.Rows[$e.RowIndex].Cells["Ergebnis"].Value = ($jsonErgebnis | ConvertFrom-Json).Ergebnis
    }
})

# Zeige das Fenster an
$form.Add_Shown({$form.Activate()})  # Aktiviere das Fenster
[void]$form.ShowDialog()  # Zeige das Fenster im Dialogmodus an
