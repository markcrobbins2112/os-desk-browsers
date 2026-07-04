#include-once
#include "db-globals.au3"
; file: C:\_o\__\os-desk-browsers\db-consts.au3
; Populating our pre-sized table properties
$aBrowsers[0][0] = "Brave"
$aBrowsers[0][1] = "Brave"
$aBrowsers[0][2] = "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"
$aBrowsers[0][3] = "brave.exe"
$aBrowsers[0][4] = "B"

$aBrowsers[1][0] = "Google Chrome"
$aBrowsers[1][1] = "Google Chrome"
$aBrowsers[1][2] = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$aBrowsers[1][3] = "chrome.exe"
$aBrowsers[1][4] = "C"

$aBrowsers[2][0] = "Edge"
$aBrowsers[2][1] = "Edge"
$aBrowsers[2][2] = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$aBrowsers[2][3] = "msedge.exe"
$aBrowsers[2][4] = "E"

$aBrowsers[3][0] = "Vivaldi"
$aBrowsers[3][1] = "Vivaldi"
$aBrowsers[3][2] = "C:\Program Files\Vivaldi\Application\vivaldi.exe"
$aBrowsers[3][3] = "vivaldi.exe"
$aBrowsers[3][4] = "V"

$aBrowsers[4][0] = "Mozilla Firefox"
$aBrowsers[4][1] = "Mozilla Firefox"
$aBrowsers[4][2] = "C:\Program Files\Mozilla Firefox\firefox.exe"
$aBrowsers[4][3] = "firefox.exe"
$aBrowsers[4][4] = "F"

Local $sOperaPath = @LocalAppDataDir & "\Programs\Opera\launcher.exe"
If Not FileExists($sOperaPath) Then $sOperaPath = @ProgramFilesDir & "\Opera\launcher.exe"
$aBrowsers[5][0] = "Opera"
$aBrowsers[5][1] = "Opera"
$aBrowsers[5][2] = $sOperaPath
$aBrowsers[5][3] = "opera.exe"
$aBrowsers[5][4] = "O"

$aBrowsers[6][0] = "Browser Picker"
$aBrowsers[6][1] = "BrowserPicker"
$aBrowsers[6][2] = "C:\Program Files\BrowserPicker\BrowserPicker.exe"
$aBrowsers[6][3] = "BrowserPicker.exe"
$aBrowsers[6][4] = "P"

$iBrowserCount = UBound($aBrowsers, 1)

; file: C:\_o\__\os-desk-browsers\db-consts.au3
