import mdbtools
import os
import csv

# Verbindung zur Access-Datenbank herstellen
db = mdbtools.MDB('BSI-Anforderungen-DB.accdb')

# CSV-Datei einlesen und in die Tabelle einfügen
def import_csv(file_name):
    with open(file_name, 'r') as file:
        reader = csv.reader(file)
        for row in reader:
            db.execute("INSERT INTO BSI-Kreuzreferenz-GefährdungAnforderung VALUES (?, ?, ?, ?)", row)

# CSV-Dateien einlesen und in die Tabelle einfügen
csv_dir = 'tupel/'
for file in os.listdir(csv_dir):
    if file.startswith('KRT') and file.endswith('.csv'):
        import_csv(os.path.join(csv_dir, file))

# Verbindung zur Datenbank schließen
db.close()