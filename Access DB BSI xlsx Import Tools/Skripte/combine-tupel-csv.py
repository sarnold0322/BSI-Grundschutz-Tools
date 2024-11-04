import csv
import glob

# Liste von CSV-Dateien
csv_dateien = glob.glob("tupel/KRT*.csv")

# Ausgabedatei
ausgabe_datei = "tupel_kombiniert.csv"

# Öffne die Ausgabedatei zum Schreiben
with open(ausgabe_datei, "w", newline="") as ausgabe:
    # Schreibe die Inhalte der CSV-Dateien in die Ausgabedatei
    for datei in csv_dateien:
        with open(datei, "r") as csv_datei:
            reader = csv.reader(csv_datei)
            for zeile in reader:
                ausgabe.write(",".join(zeile) + "\n")
