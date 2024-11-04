# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: WAHR


# Dieses PowerShell-Skript analysiert den Inhalt einer HTML-Datei, die mit dem Befehl "gpresult /H gpresult.html" erstellt wurde.
# Es überprüft, ob verschiedene Einstellungen wie OneDrive, Windows Backup, Windows Update for Business usw. aktiviert oder deaktiviert sind.
# Die Ausgabe des Skripts ist ein JSON-Objekt mit den Eigenschaften "Ergebnis" und "Output".

$htmlFilePath = "$env:USERPROFILE\Desktop\gpresult.html"
$htmlContent = Get-Content -Path $htmlFilePath -Raw

$result = @{
    Ergebnis = 0
    Output = @()
}

# 1. OneDrive
if ($htmlContent -match "OneDrive") {
    if ($htmlContent -match "Aktiviert") {
        $result.Output += "OneDrive ist aktiviert."
        $result.Ergebnis = 1
    } else {
        $result.Output += "OneDrive ist nicht aktiviert."
        $result.Ergebnis = 1
    }
} else {
    $result.Output += "Die Einstellung für OneDrive wurde nicht gefunden."
    $result.Ergebnis = 2
}

# 2. Windows Backup
if ($htmlContent -match "Windows Backup") {
    if ($htmlContent -match "Aktiviert") {
        $result.Output += "Windows Backup ist aktiviert."
        $result.Ergebnis = 1
    } else {
        $result.Output += "Windows Backup ist nicht aktiviert."
        $result.Ergebnis = 1
    }
} else {
    $result.Output += "Die Einstellung für Windows Backup wurde nicht gefunden."
    $result.Ergebnis = 2
}

# 3. Windows Update for Business
if ($htmlContent -match "Windows Update for Business") {
    if ($htmlContent -match "Aktiviert") {
        $result.Output += "Windows Update for Business ist aktiviert."
        $result.Ergebnis = 1
    } else {
        $result.Output += "Windows Update for Business ist nicht aktiviert."
        $result.Ergebnis = 1
    }
} else {
    $result.Output += "Die Einstellung für Windows Update for Business wurde nicht gefunden."
    $result.Ergebnis = 2
}

# 4. Microsoft Store
if ($htmlContent -match "Zugriff auf den Microsoft Store") {
    if ($htmlContent -match "Aktiviert") {
        $result.Output += "Der Zugriff auf den Microsoft Store ist aktiviert."
        $result.Ergebnis = 1
    } else {
        $result.Output += "Der Zugriff auf den Microsoft Store ist nicht aktiviert."
        $result.Ergebnis = 1
    }
} else {
    $result.Output += "Die Einstellung für den Microsoft Store wurde nicht gefunden."
    $result.Ergebnis = 2
}

# 5. Microsoft Intune
if ($htmlContent -match "Mobile Device Management") {
    if ($htmlContent -match "Aktiviert") {
        $result.Output += "Microsoft Intune ist aktiviert."
        $result.Ergebnis = 1
    } else {
        $result.Output += "Microsoft Intune ist nicht aktiviert."
        $result.Ergebnis = 1
    }
} else {
    $result.Output += "Die Einstellung für Microsoft Intune wurde nicht gefunden."
    $result.Ergebnis = 2
}

# 6. Windows Autopilot
if ($htmlContent -match "Windows Autopilot") {
    if ($htmlContent -match "Aktiviert") {
        $result.Output += "Windows Autopilot ist aktiviert."
        $result.Ergebnis = 1
    } else {
        $result.Output += "Windows Autopilot ist nicht aktiviert."
        $result.Ergebnis = 1
    }
} else {
    $result.Output += "Die Einstellung für Windows Autopilot wurde nicht gefunden."