# Importiere die notwendigen Assemblies für die GUI
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Erstelle das Hauptfenster
$form = New-Object System.Windows.Forms.Form
$form.Text = "Grundschutz Katalog Toolkit"
$form.Size = New-Object System.Drawing.Size(600, 400)
$form.StartPosition = "CenterScreen"

# Erstelle eine Menüleiste
$menuStrip = New-Object System.Windows.Forms.MenuStrip

# Erstelle das "Datei"-Menü
$dateiMenu = New-Object System.Windows.Forms.ToolStripMenuItem("Datei")

# Erstelle die Untermenüpunkte
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

# Füge die Menüleiste zum Formular hinzu
$form.MainMenuStrip = $menuStrip

# Erstelle ein TableLayoutPanel
$tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
$tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
$tableLayoutPanel.RowCount = 2
$tableLayoutPanel.ColumnCount = 1
$tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize)))
$tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))
$form.Controls.Add($tableLayoutPanel)

# Füge die Menüleiste zum TableLayoutPanel hinzu
$tableLayoutPanel.Controls.Add($menuStrip, 0, 0)

# Erstelle die DataGridView
$dataGridView = New-Object System.Windows.Forms.DataGridView
$dataGridView.Dock = [System.Windows.Forms.DockStyle]::Fill
$dataGridView.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::Fill
$dataGridView.ReadOnly = $true

# Füge Spalten hinzu
$dataGridView.Columns.Add("Dateiname", "Dateiname")
$dataGridView.Columns.Add("Adminrechte", "Adminrechte")
$dataGridView.Columns.Add("Ergebnis", "Ergebnis")

# Füge die DataGridView zum TableLayoutPanel hinzu
$tableLayoutPanel.Controls.Add($dataGridView, 0, 1)

# Finde den Ordner dieses Skripts
$myScriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Definiere den Pfad zum Skripte-Ordner
$scriptFolder = "$myScriptDirectory\Skripte"

# Überprüfe, ob der Ordner existiert
if (Test-Path $scriptFolder) {
    # Hole alle .ps1 Dateien im Skripte-Ordner
    $ps1Files = Get-ChildItem -Path $scriptFolder -Filter "*.ps1"

    # Füge die Dateien zur DataGridView hinzu
    foreach ($file in $ps1Files) {
        $row = @()
        $row += $file.Name
        $row += if ($file.Name -like "*_adm_*") { "X" } else { "" }
        $row += ""  # Platz für das Ergebnis
        $dataGridView.Rows.Add($row)
    }
} else {
    [System.Windows.Forms.MessageBox]::Show("Der Ordner 'Skripte' existiert nicht.", "Fehler", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
}

# Ereignisbehandlung für Doppelklick auf die Zelle
$dataGridView.Add_CellDoubleClick({
    param($sender, $e)

    # Überprüfe, ob eine Zeile angeklickt wurde
    if ($e.RowIndex -ge 0) {
        # Hole den Wert der ersten Spalte in der angeklickten Zeile
        $scriptName = $dataGridView.Rows[$e.RowIndex].Cells[0].Value
        $startSkript = "$scriptFolder\$scriptName"
        try {
            $jsonErgebnis = & $startSkript
        } catch {
            Write-Host "Ein Fehler ist aufgetreten: $_"
        }

        Write-Host $jsonErgebnis

        # Füge das Ergebnis in die DataGridView ein
        $dataGridView.Rows[$e.RowIndex].Cells["Ergebnis"].Value = ($jsonErgebnis | ConvertFrom-Json).Ergebnis
    }
})

# Zeige das Fenster an
$form.Add_Shown({$form.Activate()})
[void]$form.ShowDialog()
