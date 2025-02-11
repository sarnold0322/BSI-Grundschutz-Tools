# Skript erstellt am 2024-11-04
# Autor: Steffen Arnold
# Benötigt lokale Admin-Rechte: FALSCH


# Dieses PowerShell-Skript überprüft den Zugriff auf Mikrofon und Kamera und gibt das Ergebnis als JSON-Objekt aus.
# Gewünscht ist, dass der Zugriff auf beides eingeschärnkt ist. 

$result = @{}

# Überprüfen, ob der Zugriff auf das Mikrofon aktiviert ist
$microphoneAccess = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" -ErrorAction SilentlyContinue

if ($microphoneAccess -and $microphoneAccess.AllApps -eq "Allow") {
    $result.Microphone = "Der Zugriff auf das Mikrofon ist für alle Apps erlaubt."
    $result.MicrophoneResult = 0
} else {
    $result.Microphone = "Der Zugriff auf das Mikrofon ist eingeschränkt."
    $result.MicrophoneResult = 1
}

# Überprüfen, ob der Zugriff auf die Kamera aktiviert ist
$cameraAccess = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\camera" -ErrorAction SilentlyContinue

if ($cameraAccess -and $cameraAccess.AllApps -eq "Allow") {
    $result.Camera = "Der Zugriff auf die Kamera ist für alle Apps erlaubt."
    $result.CameraResult = 0
} else {
    $result.Camera = "Der Zugriff auf die Kamera ist eingeschränkt."
    $result.CameraResult = 1
}

# Wenn für eines der beiden Geräte kein eindeutiges Ergebnis ermittelt werden konnte, setzen wir den Gesamtergebniscode auf 2
if (($result.MicrophoneResult -eq 1 -and $result.MicrophoneResult -eq 1)) {
    $result.Result = 1
} elseif (($result.MicrophoneResult -eq 0 -or $result.MicrophoneResult -eq 0)) {
} else {
    $result.Result = 2
}


# Ausgabe des Ergebnisses als JSON-Objekt
return $result | ConvertTo-Json