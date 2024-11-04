import pandas as pd
import os
from datetime import datetime
from duckduckgo_search import DDGS


# Pfad zur CSV-Datei
csv_file_path = "BSI Grundschutz Audit Framework/241104_BSI- Grundschutz-Befehlsammlung.csv"
# Zielverzeichnis für die Skripte
output_dir = "BSI Grundschutz Audit Framework/Skripte"

# Sicherstellen, dass das Zielverzeichnis existiert
os.makedirs(output_dir, exist_ok=True)

# CSV-Datei einlesen
df = pd.read_csv(csv_file_path, sep=';', encoding='utf-8')

# Aktuelles Datum für die Versionsangabe
current_date = datetime.now().strftime("%Y-%m-%d")

# Durch jede Zeile der DataFrame iterieren
for index, row in df.iterrows():
    if index == 1:  # Überschrift überspringen
        continue
    
    # Werte aus der Zeile extrahieren
    thema = row['Thema']
    befehl = row['Befehl']
    beschreibung = row['Beschreibung']
    admin_rechte = row['Benötigt Admin-Rechte']
    
    print(thema)

    # Bestimmen, ob Admin-Rechte benötigt werden
    admin_suffix = "adm" if admin_rechte == "WAHR" else "noadm"
    
    # Basis-Skriptnamen erstellen
    base_script_name = f"{thema.replace(" ","")}_{admin_suffix}_1.ps1"
    script_path = os.path.join(output_dir, base_script_name)

    # Index erhöhen, falls der Skriptname bereits existiert
    index = 1
    while os.path.exists(script_path):
        index += 1
        base_script_name = f"{thema}_{admin_suffix}_{index}.ps1"
        script_path = os.path.join(output_dir, base_script_name)

    skript = DDGS().chat("Erstelle bitte ein Powershell Skript für diesen Befehl: " + befehl + " . Die Ausgabe des Befehls soll ein JSON-Objekt sein, das aus zwei Teilen besteht. Ergebnis und Output. Ergebnis ist \"1\", wenn der Befehl zurückliefert, dass das Ergebnis positiv war, \"0\" bei negativ und \"2\" wenn aus dem Befehl kein klares Ergebnis möglich ist. Output soll die Ausgabe des Befehls sein. Antworte bitte im Format einer PS1-Datei, d.h. Erläuterungen und Beispiele bitte am Anfang und kommentiert. ", model='claude-3-haiku')
    #print(skript)


    # PowerShell-Skript-Inhalt erstellen
    script_content = f"""
# Skript erstellt am {current_date}
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: {admin_rechte}


{skript}

"""

    # Skript in die Datei schreiben
    with open(script_path, 'w', encoding='utf-8') as script_file:
        script_file.write(script_content.strip())

print("PowerShell-Skripte wurden erfolgreich erstellt.")