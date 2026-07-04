#include-once
#include "db-globals.au3"
#include "db-engine.au3"
; file: C:\_o\__\os-desk-browsers\db-keys.au3
Local $aAccelKeys[250][2]
Local $idx = 0

; 1. Map Browser Launch, Close, Focus, and New Tab binds (handling lower & upper case letters)
For $i = 0 To $iBrowserCount - 1
    Local $sL = StringLower($aBrowsers[$i][4])
    Local $sU = StringUpper($aBrowsers[$i][4])
    
    ; activate or launch indicated: BCEVFOP
    $aAccelKeys[$idx][0] = $sL
    $aAccelKeys[$idx][1] = $aDummyActivate[$i]
    $idx += 1
    If $sL <> $sU Then
        $aAccelKeys[$idx][0] = $sU
        $aAccelKeys[$idx][1] = $aDummyActivate[$i]
        $idx += 1
    EndIf
    
    ; close nearest z-index window: ctrl+BCEVFOP
    $aAccelKeys[$idx][0] = "^" & $sL
    $aAccelKeys[$idx][1] = $aDummyClose[$i]
    $idx += 1
    If $sL <> $sU Then
        $aAccelKeys[$idx][0] = "^" & $sU
        $aAccelKeys[$idx][1] = $aDummyClose[$i]
        $idx += 1
    EndIf
    
    ; indicate window: alt+BCEVFOP
    $aAccelKeys[$idx][0] = "!" & $sL
    $aAccelKeys[$idx][1] = $aDummyFocus[$i]
    $idx += 1
    If $sL <> $sU Then
        $aAccelKeys[$idx][0] = "!" & $sU
        $aAccelKeys[$idx][1] = $aDummyFocus[$i]
        $idx += 1
    EndIf

    ; new tab in destination with url of current: shift+BCEVFOP
    $aAccelKeys[$idx][0] = "+" & $sL
    $aAccelKeys[$idx][1] = $aDummyNewTabInBrowser[$i]
    $idx += 1
    If $sL <> $sU Then
        $aAccelKeys[$idx][0] = "+" & $sU
        $aAccelKeys[$idx][1] = $aDummyNewTabInBrowser[$i]
        $idx += 1
    EndIf
Next

; 2. Map Window 3x3 Grid Controls (0-9 keys)
For $i = 0 To 9
    Local $sKey = String($i)
    
    ; select browser on grid: 0-9
    $aAccelKeys[$idx][0] = $sKey
    $aAccelKeys[$idx][1] = $aDummyFocusGrid[$i]
    $idx += 1
    
    ; place selected browser on grid: shift+0-9
    $aAccelKeys[$idx][0] = "+" & $sKey
    $aAccelKeys[$idx][1] = $aDummyGrid[$i]
    $idx += 1
    
    ; close browser on grid: ctrl+0-9
    $aAccelKeys[$idx][0] = "^" & $sKey
    $aAccelKeys[$idx][1] = $aDummyCloseGrid[$i]
    $idx += 1
    
    ; indicate window on grid: alt+0-9
    $aAccelKeys[$idx][0] = "!" & $sKey
    $aAccelKeys[$idx][1] = $aDummyIndicateGrid[$i]
    $idx += 1
    
    ; new tab in destination on grid with url of current: ctrl+shift+0-9
    $aAccelKeys[$idx][0] = "^+" & $sKey
    $aAccelKeys[$idx][1] = $aDummyGridNewTab[$i]
    $idx += 1
Next

; 3. Map Common Browser Key Forwarding Shortcuts
For $i = 0 To 31
    $aAccelKeys[$idx][0] = $aCommonKeys[$i][1]
    $aAccelKeys[$idx][1] = $aCommonKeys[$i][0]
    $idx += 1
Next

; 4. Map Utility and List navigation hotkeys
$aAccelKeys[$idx][0] = "{ESC}"
$aAccelKeys[$idx][1] = $idDummyEscape
$idx += 1

$aAccelKeys[$idx][0] = "{INS}"
$aAccelKeys[$idx][1] = $idDummyInsert
$idx += 1

$aAccelKeys[$idx][0] = "{DEL}"
$aAccelKeys[$idx][1] = $idDummyDelete
$idx += 1

$aAccelKeys[$idx][0] = "^c"
$aAccelKeys[$idx][1] = $idDummyCopyUrl
$idx += 1

$aAccelKeys[$idx][0] = "^{INS}"
$aAccelKeys[$idx][1] = $idDummyCopyUrl
$idx += 1

$aAccelKeys[$idx][0] = "^v"
$aAccelKeys[$idx][1] = $idDummyNewTabWithClipboard
$idx += 1

$aAccelKeys[$idx][0] = "+{INS}"
$aAccelKeys[$idx][1] = $idDummyNewTabWithClipboard
$idx += 1

$aAccelKeys[$idx][0] = "^x"
$aAccelKeys[$idx][1] = $idDummyCopyUrlAndCloseTab
$idx += 1

$aAccelKeys[$idx][0] = "+{DEL}"
$aAccelKeys[$idx][1] = $idDummyCopyUrlAndCloseTab
$idx += 1

$aAccelKeys[$idx][0] = "-"
$aAccelKeys[$idx][1] = $idDummyMinimizeToggle
$idx += 1

$aAccelKeys[$idx][0] = "{BACKSPACE}"
$aAccelKeys[$idx][1] = $idDummySendToBack
$idx += 1

$aAccelKeys[$idx][0] = "{ENTER}"
$aAccelKeys[$idx][1] = $idDummyEnter
$idx += 1

$aAccelKeys[$idx][0] = "+{ENTER}"
$aAccelKeys[$idx][1] = $idDummyNewWindowWithCurrentUrl
$idx += 1

$aAccelKeys[$idx][0] = "{F1}"
$aAccelKeys[$idx][1] = $idDummyHelp
$idx += 1

; select browser relative to currently selected (wraps): up down right left
$aAccelKeys[$idx][0] = "{UP}"
$aAccelKeys[$idx][1] = $idDummyUp
$idx += 1

$aAccelKeys[$idx][0] = "{DOWN}"
$aAccelKeys[$idx][1] = $idDummyDown
$idx += 1

$aAccelKeys[$idx][0] = "{LEFT}"
$aAccelKeys[$idx][1] = $idDummyLeft
$idx += 1

$aAccelKeys[$idx][0] = "{RIGHT}"
$aAccelKeys[$idx][1] = $idDummyRight
$idx += 1

; Additional keys: [, ], \, ctrl+\, shift+\
$aAccelKeys[$idx][0] = "["
$aAccelKeys[$idx][1] = $idDummyPrevInList
$idx += 1

$aAccelKeys[$idx][0] = "]"
$aAccelKeys[$idx][1] = $idDummyNextInList
$idx += 1

$aAccelKeys[$idx][0] = "\"
$aAccelKeys[$idx][1] = $idDummyCascadeType
$idx += 1

$aAccelKeys[$idx][0] = "^\"
$aAccelKeys[$idx][1] = $idDummySplitTabs
$idx += 1

$aAccelKeys[$idx][0] = "+\"
$aAccelKeys[$idx][1] = $idDummyGatherTabs
$idx += 1

; indicated to back of (types) zindex, indicate top zindex of type: alt+pageup
$aAccelKeys[$idx][0] = "!{PGUP}"
$aAccelKeys[$idx][1] = $idDummyIndicatedToBackType
$idx += 1

; indicate and bring to top zindex the types deepest zindex: alt+pagedown
$aAccelKeys[$idx][0] = "!{PGDN}"
$aAccelKeys[$idx][1] = $idDummyDeepestToTopType
$idx += 1

; indicate prev sibling of indicated type: shift+pageup
$aAccelKeys[$idx][0] = "+{PGUP}"
$aAccelKeys[$idx][1] = $idDummyPrevSibling
$idx += 1

; indicate next sibling of indicated type: shift+pagedown
$aAccelKeys[$idx][0] = "+{PGDN}"
$aAccelKeys[$idx][1] = $idDummyNextSibling
$idx += 1

; minimize: alt+down
$aAccelKeys[$idx][0] = "!{DOWN}"
$aAccelKeys[$idx][1] = $idDummyAltDown
$idx += 1

; restore: alt+up
$aAccelKeys[$idx][0] = "!{UP}"
$aAccelKeys[$idx][1] = $idDummyAltUp
$idx += 1

; indicate last on grid: alt+end
$aAccelKeys[$idx][0] = "!{END}"
$aAccelKeys[$idx][1] = $idDummyIndicateLastOnGrid
$idx += 1

; indicate first on grid: alt+home
$aAccelKeys[$idx][0] = "!{HOME}"
$aAccelKeys[$idx][1] = $idDummyIndicateFirstOnGrid
$idx += 1

; Spatial focus navigation (Ctrl+Arrows)
$aAccelKeys[$idx][0] = "^{LEFT}"
$aAccelKeys[$idx][1] = $idDummyIndicateLeft
$idx += 1

$aAccelKeys[$idx][0] = "^{RIGHT}"
$aAccelKeys[$idx][1] = $idDummyIndicateRight
$idx += 1

$aAccelKeys[$idx][0] = "^{UP}"
$aAccelKeys[$idx][1] = $idDummyIndicateUp
$idx += 1

$aAccelKeys[$idx][0] = "^{DOWN}"
$aAccelKeys[$idx][1] = $idDummyIndicateDown
$idx += 1

; ReDim the array to the exact count of mapped keys to avoid empty/unpopulated trailing rows which fail GUISetAccelerators
ReDim $aAccelKeys[$idx][2]

; Bind the structured 2D accelerator map to our operational main workspace handle
GUISetAccelerators($aAccelKeys, $hGUI)

; Taskbar icon configuration properties
$tray_Restore = TrayCreateItem("Show Manager")
$tray_Exit = TrayCreateItem("Exit")
TraySetOnEvent($TRAY_EVENT_PRIMARYUP, "_ToggleGUI")
TrayItemSetOnEvent($tray_Restore, "_ShowGUI")
TrayItemSetOnEvent($tray_Exit, "_ExitApp")

HotKeySet("#" & "{APPSKEY}", "_ToggleGUI")
; GUISetOnEvent($GUI_EVENT_CLOSE, "_HandleClose")

; file: C:\_o\__\os-desk-browsers\db-keys.au3
