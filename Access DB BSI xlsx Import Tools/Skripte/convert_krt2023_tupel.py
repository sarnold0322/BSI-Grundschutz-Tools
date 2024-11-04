import pandas as pd
import openpyxl

# Öffne die Excel-Datei
wb = openpyxl.load_workbook('xlsx/krt2023_Excel.xlsx')

# Durchlaufe alle Mappen in der Excel-Datei
for sheet_name in wb.sheetnames:
    # Öffne die aktuelle Mappe
    sheet = wb[sheet_name]
    
    # Lese die Daten aus der Mappe in ein pandas-DataFrame
    df = pd.DataFrame(sheet.values)
    
    # Setze die Spaltennamen aus der ersten Zeile
    df.columns = df.iloc[0]
    df = df.iloc[1:]
    
    # Erstelle eine Liste von Tupeln, die die Werte in der ersten Spalte und den Spalten G 0.14 bis G 0.46 enthält
    tuples = []
    for index, row in df.iterrows():
        for i in range(3, len(row)):
            if row[i] == 'X':
                tuples.append((row[0], df.columns[i]))
    
    # Erstelle eine CSV-Datei für die aktuelle Mappe
    with open(f'tupel/{sheet_name}.csv', 'w') as f:
        for tupel in tuples:
            f.write(';'.join(map(str, tupel)) + '\n')