import csv
import glob

# Liste von CSV-Dateien
csv_dateien = glob.glob("checkliste_csv/Checkliste_*.csv")

# Ausgabedatei
ausgabe_datei = "Checkliste_kombiniert.csv"

# Öffne die Ausgabedatei zum Schreiben
with open(ausgabe_datei, "w", newline="") as ausgabe:
    # Schreibe die Headerzeile aus der ersten Datei
    with open(csv_dateien[0], "r") as erste_datei:
        reader = csv.reader(erste_datei)
        header = next(reader)
        ausgabe.write(",".join(header) + "\n")

    # Schreibe die Inhalte der CSV-Dateien in die Ausgabedatei
    for datei in csv_dateien:
        with open(datei, "r") as csv_datei:
            reader = csv.reader(csv_datei)
            next(reader)  # Überspringe die Headerzeile
            for zeile in reader:
                ausgabe.write(",".join(zeile) + "\n")
