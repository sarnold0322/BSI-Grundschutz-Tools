import pandas as pd
import os

# Definieren Sie den Pfad zum Verzeichnis mit den xlsx-Dateien
xlsx_verzeichnis = "xlsx/"

# Definieren Sie den Pfad zum Verzeichnis für die CSV-Dateien
csv_verzeichnis = "csv"

# Durchlaufen Sie das Verzeichnis mit den xlsx-Dateien
for datei in os.listdir(xlsx_verzeichnis):
    if datei.endswith(".xlsx"):
        # Öffnen Sie die xlsx-Datei und lesen Sie die Daten
        df = pd.read_excel(os.path.join(xlsx_verzeichnis, datei), header=None, skiprows=4, engine='openpyxl')

        # Wählen Sie die Spalten "B", "C", "D" und "E"
        df = df.iloc[:, 1:5]

        # Exportieren Sie die Daten in eine CSV-Datei mit ";" als Trennzeichen
        csv_datei = os.path.splitext(datei)[0] + ".csv"
        df.to_csv(os.path.join(csv_verzeichnis, csv_datei), index=False, header=False, sep=";", encoding='utf-8')