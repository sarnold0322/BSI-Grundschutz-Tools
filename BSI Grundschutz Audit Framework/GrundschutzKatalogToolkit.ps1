# Importiere die notwendigen Assemblies für die GUI
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Erstelle das Hauptfenster
$form = New-Object System.Windows.Forms.Form
$form.Text = "Grundschutz Katalog Toolkit"
$form.Size = New-Object System.Drawing.Size(600, 400)
$form.StartPosition = "CenterScreen"

# Erstelle eine Überschrift
#$label = New-Object System.Windows.Forms.Label
#$label.Text = "Grundschutz Katalog Toolkit"
#$label.AutoSize = $true
#$label.Font = New-Object System.Drawing.Font("Arial", 14, [System.Drawing.FontStyle]::Bold)
#$label.Dock = [System.Windows.Forms.DockStyle]::Top
#$form.Controls.Add($label)

# Erstelle ein Panel für die DataGridView
$panel = New-Object System.Windows.Forms.Panel
$panel.Dock = [System.Windows.Forms.DockStyle]::Fill
$form.Controls.Add($panel)

# Erstelle die DataGridView
$dataGridView = New-Object System.Windows.Forms.DataGridView
$dataGridView.Dock = [System.Windows.Forms.DockStyle]::Fill  # DataGridView füllt das Panel
$dataGridView.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::Fill
$dataGridView.ReadOnly = $true  # DataGridView nicht editierbar

# Füge Spalten hinzu
$dataGridView.Columns.Add("Dateiname", "Dateiname")
$dataGridView.Columns.Add("Adminrechte", "Adminrechte")
$dataGridView.Columns.Add("Ergebnis", "Ergebnis")

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

    # Überprüfe, ob die doppelt geklickte Zelle in der Dateiname-Spalte ist
    #if ($e.ColumnIndex -eq 0) {
    #    $scriptName = $dataGridView.Rows[$e.RowIndex].Cells[0].Value
    #    $scriptPath = Join-Path -Path $scriptFolder -ChildPath $scriptName
    #    Execute-Script -scriptPath $scriptPath -rowIndex $e.RowIndex
    #}

    # Überprüfe, ob eine Zeile angeklickt wurde
    if ($e.RowIndex -ge 0) {
        # Hole den Wert der ersten Spalte in der angeklickten Zeile
        $scriptName = $dataGridView.Rows[$e.RowIndex].Cells[0].Value
        #[System.Windows.Forms.MessageBox]::Show("Starte Skript: $scriptName")

        # Führe das Skript aus und speichere das Ergebnis in einer Variablen
        $startSkript = ""
        $startSkript = "$scriptFolder\$scriptName"
        #Write-host $startSkript
        #break
        try {
            $jsonErgebnis = & $startSkript
        } catch {
            # Wenn ein Fehler auftritt, gib eine Fehlermeldung aus
            Write-Host "Ein Fehler ist aufgetreten: $_"
        }

        Write-Host $jsonErgebnis

        # Wandle das JSON-Ergebnis in ein PowerShell-Objekt um
        #$psObjekt = $jsonErgebnis | ConvertFrom-Json

        # Füge das Ergebnis in die DataGridView ein
        $dataGridView.Rows[$e.RowIndex].Cells["Ergebnis"].Value = ($jsonErgebnis | ConvertFrom-Json).Ergebnis

    }

})

# Füge die DataGridView zum Panel hinzu
$panel.Controls.Add($dataGridView)

# Zeige das Fenster an
$form.Add_Shown({$form.Activate()})
[void]$form.ShowDialog()
