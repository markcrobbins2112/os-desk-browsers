#include-once
#include "db-globals.au3"
; file: C:\_o\__\os-desk-browsers\db-consts.au3

Local $sIniPath = @ScriptDir & "\desk-browsers.ini"

; Check if the INI file exists. If not, write defaults.
If Not FileExists($sIniPath) Then
    Local $sBraveDefault = "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"
    Local $sChromeDefault = "C:\Program Files\Google\Chrome\Application\chrome.exe"
    Local $sEdgeDefault = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
    Local $sVivaldiDefault = "C:\Program Files\Vivaldi\Application\vivaldi.exe"
    Local $sFirefoxDefault = "C:\Program Files\Mozilla Firefox\firefox.exe"
    
    Local $sOperaDefault = @LocalAppDataDir & "\Programs\Opera\launcher.exe"
    If Not FileExists($sOperaDefault) Then $sOperaDefault = @ProgramFilesDir & "\Opera\launcher.exe"
    
    Local $sPickerDefault = "C:\Program Files\BrowserPicker\BrowserPicker.exe"

    ; Write Browser 0 (Brave)
    IniWrite($sIniPath, "Browser_0", "Name", "Brave")
    IniWrite($sIniPath, "Browser_0", "Match", "Brave")
    IniWrite($sIniPath, "Browser_0", "Path", $sBraveDefault)
    IniWrite($sIniPath, "Browser_0", "Exe", "brave.exe")
    IniWrite($sIniPath, "Browser_0", "Hotkey", "B")

    ; Write Browser 1 (Chrome)
    IniWrite($sIniPath, "Browser_1", "Name", "Google Chrome")
    IniWrite($sIniPath, "Browser_1", "Match", "Google Chrome")
    IniWrite($sIniPath, "Browser_1", "Path", $sChromeDefault)
    IniWrite($sIniPath, "Browser_1", "Exe", "chrome.exe")
    IniWrite($sIniPath, "Browser_1", "Hotkey", "C")

    ; Write Browser 2 (Edge)
    IniWrite($sIniPath, "Browser_2", "Name", "Edge")
    IniWrite($sIniPath, "Browser_2", "Match", "Edge")
    IniWrite($sIniPath, "Browser_2", "Path", $sEdgeDefault)
    IniWrite($sIniPath, "Browser_2", "Exe", "msedge.exe")
    IniWrite($sIniPath, "Browser_2", "Hotkey", "E")

    ; Write Browser 3 (Vivaldi)
    IniWrite($sIniPath, "Browser_3", "Name", "Vivaldi")
    IniWrite($sIniPath, "Browser_3", "Match", "Vivaldi")
    IniWrite($sIniPath, "Browser_3", "Path", $sVivaldiDefault)
    IniWrite($sIniPath, "Browser_3", "Exe", "vivaldi.exe")
    IniWrite($sIniPath, "Browser_3", "Hotkey", "V")

    ; Write Browser 4 (Firefox)
    IniWrite($sIniPath, "Browser_4", "Name", "Mozilla Firefox")
    IniWrite($sIniPath, "Browser_4", "Match", "Mozilla Firefox")
    IniWrite($sIniPath, "Browser_4", "Path", $sFirefoxDefault)
    IniWrite($sIniPath, "Browser_4", "Exe", "firefox.exe")
    IniWrite($sIniPath, "Browser_4", "Hotkey", "F")

    ; Write Browser 5 (Opera)
    IniWrite($sIniPath, "Browser_5", "Name", "Opera")
    IniWrite($sIniPath, "Browser_5", "Match", "Opera")
    IniWrite($sIniPath, "Browser_5", "Path", $sOperaDefault)
    IniWrite($sIniPath, "Browser_5", "Exe", "opera.exe")
    IniWrite($sIniPath, "Browser_5", "Hotkey", "O")

    ; Write Browser 6 (Picker)
    IniWrite($sIniPath, "Browser_6", "Name", "Browser Picker")
    IniWrite($sIniPath, "Browser_6", "Match", "BrowserPicker")
    IniWrite($sIniPath, "Browser_6", "Path", $sPickerDefault)
    IniWrite($sIniPath, "Browser_6", "Exe", "BrowserPicker.exe")
    IniWrite($sIniPath, "Browser_6", "Hotkey", "P")
EndIf

; Populate browsers from INI
For $i = 0 To 6
    Local $sSec = "Browser_" & $i
    $aBrowsers[$i][0] = IniRead($sIniPath, $sSec, "Name", "")
    $aBrowsers[$i][1] = IniRead($sIniPath, $sSec, "Match", "")
    $aBrowsers[$i][2] = IniRead($sIniPath, $sSec, "Path", "")
    $aBrowsers[$i][3] = IniRead($sIniPath, $sSec, "Exe", "")
    $aBrowsers[$i][4] = IniRead($sIniPath, $sSec, "Hotkey", "")
Next

$iBrowserCount = UBound($aBrowsers, 1)

; file: C:\_o\__\os-desk-browsers\db-consts.au3
