import pandas as pd
import pyodbc

# Definieren Sie die Quell- und Ziel-Dateien
quelle = "C:\\Pfad\\zur\\Grundschutz-Checkliste.xlsx"
ziel = "C:\\Pfad\\zur\\Access-Datenbank.accdb"

# Definieren Sie die Spalten, die exportiert werden sollen
spalten = ["B", "C", "D", "E"]

# Öffnen Sie die Excel-Datei und lesen Sie die Daten
df = pd.read_excel(quelle, header=None, skiprows=4, usecols=spalten)

# Exportieren Sie die Daten in eine CSV-Datei
df.to_csv("temp.csv", index=False, header=False)

# Importieren Sie die CSV-Datei in die Access-Tabelle
cnxn = pyodbc.connect("DRIVER={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=" + ziel)
cursor = cnxn.cursor()
cursor.execute("SELECT * FROM Grundschutz-Checkliste")
if cursor.fetchone() is None:
    cursor.execute("CREATE TABLE Grundschutz-Checkliste (Spalte1 TEXT, Spalte2 TEXT, Spalte3 TEXT, Spalte4 TEXT)")
cursor.execute("DELETE * FROM Grundschutz-Checkliste")
with open("temp.csv", "r") as f:
    for line in f:
        cursor.execute("INSERT INTO Grundschutz-Checkliste VALUES (?, ?, ?, ?)", line.strip().split(","))
cnxn.commit()
cnxn.close()
