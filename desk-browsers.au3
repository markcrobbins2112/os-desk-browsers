#NoTrayIcon
#RequireAdmin ; Request administrative rights to manage borderless styles and transparency of all windows
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <GuiListView.au3>
#include <GuiImageList.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <Array.au3>
#include <WinAPISys.au3>
#include <WinAPI.au3>
#include <WinAPIGdi.au3>
#include <TrayConstants.au3>

; ==============================================================================
; Title: AutoIt Browser & Window Tiling Manager (desk-browsers.au3)
; Description: Multi-window advanced window tiling grid manager and browser selector.
; Global Hotkey: Win + ContextMenu Key (Show or Hide the Browser Manager window)
; ==============================================================================

Opt("MustDeclareVars", 1)
Opt("WinTitleMatchMode", 4)
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 3)
Opt("GUIOnEventMode", 1)

; ==============================================================================
; GLOBAL VARIABLE DECLARATIONS
; ==============================================================================
Global $aBrowsers[6][5]
Global $iBrowserCount
Global $bGUI_Visible = True
Global $aLastCounts[6]
Global $hLastSelectedWin = 0
Global $hLastPrevWin = 0
Global $hBorderWin = 0
Global $iLastSelectionIndex = -1

Global $aDummyActivate[6]
Global $aDummyClose[6]
Global $aDummyFocus[6]
Global $aDummyGrid[10] ; 0-9 hotkeys
Global $aDummySwap[9]   ; 1-9 swap hotkeys
Global $aDummyFocusGrid[10] ; Alt + 0-9 focus hotkeys
Global $aIconIndices[6]

Global $idDummyEscape
Global $idDummyInsert
Global $idDummyDelete
Global $idDummyPageUp
Global $idDummyPageDown
Global $idDummySiblingUp
Global $idDummyRight
Global $idDummyLeft
Global $idDummyCycleNext
Global $idDummyCyclePrev
Global $idDummyCopyUrl
Global $idDummySendToBack
Global $idDummyMinimizeToggle
Global $idDummyEnter
Global $bHelpClosed = False
Global $hHelpGUI = 0

Global $idHelpBtn
Global $idListview
Global $hGUI
Global $idStatus
Global $tray_Restore
Global $tray_Exit

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

$aBrowsers[5][0] = "Browser Picker"
$aBrowsers[5][1] = "BrowserPicker"
$aBrowsers[5][2] = "C:\Program Files\BrowserPicker\BrowserPicker.exe"
$aBrowsers[5][3] = "BrowserPicker.exe"
$aBrowsers[5][4] = "P"

$iBrowserCount = UBound($aBrowsers, 1)

; ==============================================================================
; USER INTERFACE SETUP
; ==============================================================================
$hGUI = GUICreate("Browser Manager", 700, 320, -1, -1, BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS), $WS_EX_TOPMOST)
GUISetBkColor(0x2D2D2D, $hGUI) ; Sleek medium grey background

Local $idTitleLabel = GUICtrlCreateLabel("Keys: Letter (Act) | Ctrl+Letter (Close) | Alt+Letter (Focus) | Esc (Min) | - (Min Toggle) | Backspace (To Back)", 10, 12, 580, 20)
GUICtrlSetColor($idTitleLabel, 0xE0E0E0) ; Light gray text
GUICtrlSetBkColor($idTitleLabel, -2) ; Transparent background

; Help Button UI Placement
$idHelpBtn = GUICtrlCreateButton("Help / Shortcuts", 600, 8, 90, 24)
GUICtrlSetBkColor($idHelpBtn, 0x3D3D3D) ; Medium grey button background
GUICtrlSetColor($idHelpBtn, 0xFFFFFF)  ; White text
GUICtrlSetOnEvent($idHelpBtn, "_ShowHelp")

; Create ListView with Positions and Minimized tracking metrics
$idListview = GUICtrlCreateListView("Browser|Status|Shortcut|Instances|Grid Pos|Minimized", 10, 40, 680, 230, BitOR($LVS_REPORT, $LVS_SINGLESEL, $LVS_SHOWSELALWAYS))
GUICtrlSetBkColor($idListview, 0x252526) ; Dark ListView background
GUICtrlSetColor($idListview, 0xF1F1F1)  ; Off-white text
_GUICtrlListView_SetColumnWidth($idListview, 0, 180)
_GUICtrlListView_SetColumnWidth($idListview, 1, 90)
_GUICtrlListView_SetColumnWidth($idListview, 2, 70)
_GUICtrlListView_SetColumnWidth($idListview, 3, 90)
_GUICtrlListView_SetColumnWidth($idListview, 4, 110)
_GUICtrlListView_SetColumnWidth($idListview, 5, 110)
_GUICtrlListView_SetExtendedListViewStyle($idListview, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_SUBITEMIMAGES))

; Load system shell icons matching individual executable instances
Local $hImageList = _GUIImageList_Create(16, 16, 5, 3)
For $i = 0 To $iBrowserCount - 1
    Local $sPath = $aBrowsers[$i][2] ; Target column index 2 (Path)
    Local $iIconIdx = -1
    If FileExists($sPath) Then $iIconIdx = _GUIImageList_AddIcon($hImageList, $sPath, 0, False)
    If $iIconIdx = -1 Then $iIconIdx = _GUIImageList_AddIcon($hImageList, @SystemDir & "\shell32.dll", 14, False)
    $aIconIndices[$i] = $iIconIdx
Next
_GUICtrlListView_SetImageList($idListview, $hImageList, 1)

; Initialize local tracking cache tracking boundaries
For $i = 0 To $iBrowserCount - 1
    $aLastCounts[$i] = -1
Next

$idStatus = GUICtrlCreateLabel("Ready", 10, 280, 680, 20)
GUICtrlSetColor($idStatus, 0x858585) ; Muted gray text
GUICtrlSetBkColor($idStatus, -2) ; Transparent background

; Force system tray parameters active
TraySetState(1)

; ==============================================================================
; DUMMY EVENT REGISTER & SHORTCUT ACCELERATORS
; ==============================================================================
; Initialize browser-specific tracking dummys
For $i = 0 To $iBrowserCount - 1
    $aDummyActivate[$i] = GUICtrlCreateDummy()
    $aDummyClose[$i] = GUICtrlCreateDummy()
    $aDummyFocus[$i] = GUICtrlCreateDummy()
    GUICtrlSetOnEvent($aDummyActivate[$i], "_OnShortcut")
    GUICtrlSetOnEvent($aDummyClose[$i], "_OnShortcut")
    GUICtrlSetOnEvent($aDummyFocus[$i], "_OnShortcut")
Next

; Establish grid layouts dummies
For $i = 0 To 9
    $aDummyGrid[$i] = GUICtrlCreateDummy()
    GUICtrlSetOnEvent($aDummyGrid[$i], "_OnGridHotkey")
    $aDummyFocusGrid[$i] = GUICtrlCreateDummy()
    GUICtrlSetOnEvent($aDummyFocusGrid[$i], "_OnFocusGridHotkey")
Next
For $i = 1 To 9
    $aDummySwap[$i-1] = GUICtrlCreateDummy()
    GUICtrlSetOnEvent($aDummySwap[$i-1], "_OnSwapHotkey")
Next

$idDummyEscape = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyEscape, "_MinimizeToTray")
$idDummyInsert = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyInsert, "_OnNewTab")
$idDummyDelete = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyDelete, "_OnDeletePressed")
$idDummyPageUp = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyPageUp, "_OnTabLeft")
$idDummyPageDown = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyPageDown, "_OnTabRight")
$idDummySiblingUp = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummySiblingUp, "_OnSiblingsToTop")
$idDummyRight = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyRight, "_OnRightPressed")
$idDummyLeft = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyLeft, "_OnLeftPressed")
$idDummyCycleNext = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyCycleNext, "_OnCycleNext")
$idDummyCyclePrev = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyCyclePrev, "_OnCyclePrev")
$idDummyCopyUrl = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyCopyUrl, "_OnCopyUrl")
$idDummySendToBack = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummySendToBack, "_OnSendToBack")
$idDummyMinimizeToggle = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyMinimizeToggle, "_OnMinimizeToggle")
$idDummyEnter = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyEnter, "_OnEnterPressed")

Local $aAccelKeys[150][2]
Local $idx = 0

; 1. Map Browser Launch, Close, and Focus binds (handling both lower & upper case letters to prevent Shift/Capslock issues)
For $i = 0 To $iBrowserCount - 1
    Local $sL = StringLower($aBrowsers[$i][4]) ; Targets the unique character suffix letter
    Local $sU = StringUpper($aBrowsers[$i][4])
    
    $aAccelKeys[$idx][0] = $sL
    $aAccelKeys[$idx][1] = $aDummyActivate[$i]
    $idx += 1
    
    If $sL <> $sU Then
        $aAccelKeys[$idx][0] = $sU
        $aAccelKeys[$idx][1] = $aDummyActivate[$i]
        $idx += 1
    EndIf
    
    $aAccelKeys[$idx][0] = "^" & $sL
    $aAccelKeys[$idx][1] = $aDummyClose[$i]
    $idx += 1
    
    If $sL <> $sU Then
        $aAccelKeys[$idx][0] = "^" & $sU
        $aAccelKeys[$idx][1] = $aDummyClose[$i]
        $idx += 1
    EndIf
    
    $aAccelKeys[$idx][0] = "!" & $sL
    $aAccelKeys[$idx][1] = $aDummyFocus[$i]
    $idx += 1
    
    If $sL <> $sU Then
        $aAccelKeys[$idx][0] = "!" & $sU
        $aAccelKeys[$idx][1] = $aDummyFocus[$i]
        $idx += 1
    EndIf
Next

; 2. Map Window 3x3 Tile Snapping grids (9 frames * 2 variations = 18 slots)
For $i = 1 To 9
    $aAccelKeys[$idx][0] = String($i)
    $aAccelKeys[$idx][1] = $aDummyGrid[$i]
    $idx += 1
    
    $aAccelKeys[$idx][0] = "^" & String($i)
    $aAccelKeys[$idx][1] = $aDummySwap[$i-1]
    $idx += 1
    
    $aAccelKeys[$idx][0] = "!" & String($i)
    $aAccelKeys[$idx][1] = $aDummyFocusGrid[$i]
    $idx += 1
Next

; 3. Map System and Utility hotkey rules (10 slots)
$aAccelKeys[$idx][0] = "0"
$aAccelKeys[$idx][1] = $aDummyGrid[0]
$idx += 1

$aAccelKeys[$idx][0] = "!0"
$aAccelKeys[$idx][1] = $aDummyFocusGrid[0]
$idx += 1

$aAccelKeys[$idx][0] = "{ESC}"
$aAccelKeys[$idx][1] = $idDummyEscape
$idx += 1

$aAccelKeys[$idx][0] = "{INS}"
$aAccelKeys[$idx][1] = $idDummyInsert
$idx += 1

$aAccelKeys[$idx][0] = "{DEL}"
$aAccelKeys[$idx][1] = $idDummyDelete
$idx += 1

$aAccelKeys[$idx][0] = "{PGUP}"
$aAccelKeys[$idx][1] = $idDummyPageUp
$idx += 1

$aAccelKeys[$idx][0] = "{PGDN}"
$aAccelKeys[$idx][1] = $idDummyPageDown
$idx += 1

$aAccelKeys[$idx][0] = "^{PGUP}"
$aAccelKeys[$idx][1] = $idDummyCyclePrev
$idx += 1

$aAccelKeys[$idx][0] = "^{PGDN}"
$aAccelKeys[$idx][1] = $idDummyCycleNext
$idx += 1

$aAccelKeys[$idx][0] = "!{PGUP}"
$aAccelKeys[$idx][1] = $idDummySiblingUp
$idx += 1

$aAccelKeys[$idx][0] = "!{PGDN}"
$aAccelKeys[$idx][1] = $idDummySiblingUp
$idx += 1

$aAccelKeys[$idx][0] = "{RIGHT}"
$aAccelKeys[$idx][1] = $idDummyRight
$idx += 1

$aAccelKeys[$idx][0] = "{LEFT}"
$aAccelKeys[$idx][1] = $idDummyLeft
$idx += 1

$aAccelKeys[$idx][0] = "^c"
$aAccelKeys[$idx][1] = $idDummyCopyUrl
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

; ReDim the array to the exact count of mapped keys to avoid empty/unpopulated trailing rows which fail GUISetAccelerators
ReDim $aAccelKeys[$idx][2]

; Bind the structured 2D accelerator map to our operational main workspace handle
GUISetAccelerators($aAccelKeys, $hGUI)

; Taskbar icon configuration properties
$tray_Restore = TrayCreateItem("Show Manager")
$tray_Exit = TrayCreateItem("Exit")
TraySetOnEvent($TRAY_EVENT_PRIMARYUP, "_ToggleGUI")
TraySetOnEvent($tray_Restore, "_ShowGUI")
TraySetOnEvent($tray_Exit, "_ExitApp")

HotKeySet("#" & "{APPSKEY}", "_ToggleGUI")
GUISetOnEvent($GUI_EVENT_CLOSE, "_HandleClose")

; ==============================================================================
; RUNTIME INITIALIZATION
; ==============================================================================
_InitializeApp()

Local $iTimer = TimerInit()

; Main Background Active Process Refresh Loop
While 1
    Sleep(50)
    _HandleZOrderSelection()
    
    If TimerDiff($iTimer) > 800 Then
        If $bGUI_Visible Then
            Local $bChangesFound = False
            For $i = 0 To $iBrowserCount - 1
                Local $aWinList = WinList("[REGEXPTITLE:(?i).*" & $aBrowsers[$i][1] & "$]") ; Target column index 1 (Suffix)
                If $aWinList[0][0] <> $aLastCounts[$i] Then
                    $bChangesFound = True
                    ExitLoop
                EndIf
            Next
            If $bChangesFound Then _PopulateList($aIconIndices)
        EndIf
        $iTimer = TimerInit()
    EndIf
WEnd

; Setup Execution Initialization Assembly Wrapper
Func _InitializeApp()
    _PopulateList($aIconIndices)
    _ShowGUI()
EndFunc

; ==============================================================================
; CORE ENGINE FUNCTIONS (originally actions_engine.au3)
; ==============================================================================

; Handles Z-Order checking, selections, and updating frame locations
Func _HandleZOrderSelection()
    Local $bDeFocused = False
    If Not $bGUI_Visible Then
        $bDeFocused = True
    Else
        Local $hFocusedCtrl = ControlGetHandle($hGUI, "", ControlGetFocus($hGUI))
        Local $hListviewHandle = GUICtrlGetHandle($idListview)
        If $hFocusedCtrl <> $hListviewHandle Then
            $bDeFocused = True
        EndIf
    EndIf
    
    If Not $bDeFocused Then
        Local $iSelected = _GUICtrlListView_GetSelectedIndices($idListview)
        If $iSelected = "" Then
            $bDeFocused = True
        Endif
    EndIf
    
    If $bDeFocused Then
        _ClearOrangeBorder()
        If $iLastSelectionIndex <> -1 Then
            $iLastSelectionIndex = -1
            Beep(800, 100) ; Defocus beep
        EndIf
        Return
    EndIf
    
    Local $iSelected = _GUICtrlListView_GetSelectedIndices($idListview)
    Local $iIdx = Int($iSelected)
    
    If $iIdx <> $iLastSelectionIndex Then
        $iLastSelectionIndex = $iIdx
        Beep(1000, 100) ; Selection beep
    EndIf
    
    Local $aWinList = WinList("[REGEXPTITLE:(?i).*" & $aBrowsers[$iIdx][1] & "$]")
    If $aWinList[0][0] > 0 Then
        Local $hTargetWin = $aWinList[1][1] ; Highest window frame in Z-Order
        If BitAND(WinGetState($hTargetWin), 2) And Not BitAND(WinGetState($hTargetWin), 16) Then
            _DrawOrangeBorder($hTargetWin)
        Else
            _ClearOrangeBorder()
        EndIf
    Else
        _ClearOrangeBorder()
    EndIf
EndFunc

; Helper to grab the topmost handle matching the selected browser in the row layout favoring highest visible z-index
Func _GetSelectedBrowserWindow()
    Local $iSelected = _GUICtrlListView_GetSelectedIndices($idListview)
    If $iSelected = "" Then Return 0
    Local $iIdx = Int($iSelected)
    Local $aWinList = WinList("[REGEXPTITLE:(?i).*" & $aBrowsers[$iIdx][1] & "$]")
    For $i = 1 To $aWinList[0][0]
        If BitAND(WinGetState($aWinList[$i][1]), 2) Then Return $aWinList[$i][1]
    Next
    Return 0
EndFunc

; Swaps center window (Position 5) with target grid slot window frame
Func _OnSwapHotkey()
    Local $idPressed = @GUI_CtrlId
    Local $iTargetPos = -1
    For $i = 1 To 9
        If $idPressed = $aDummySwap[$i-1] Then
            $iTargetPos = $i
            ExitLoop
        Endif
    Next
    If $iTargetPos = -1 Or $iTargetPos = 5 Then Return
    
    Local $iW = @DesktopWidth, $iH = @DesktopHeight
    Local $cellW = Int($iW / 3), $cellH = Int($iH / 3)
    
    Local $hWinCenter = 0, $hWinTarget = 0
    Local $aWinList = WinList()
    For $i = 1 To $aWinList[0][0]
        Local $hWnd = $aWinList[$i][1]
        If BitAND(WinGetState($hWnd), 2) And Not BitAND(WinGetState($hWnd), 16) Then
            Local $aPos = WinGetPos($hWnd)
            If IsArray($aPos) Then
                If Abs($aPos[2] - $cellW) < 15 And Abs($aPos[3] - $cellH) < 15 Then
                    If Abs($aPos[0] - $cellW) < 15 And Abs($aPos[1] - $cellH) < 15 Then $hWinCenter = $hWnd
                EndIf
                Local $tCol = Mod($iTargetPos - 1, 3), $tRow = Int(($iTargetPos - 1) / 3)
                If Abs($aPos[2] - $cellW) < 15 And Abs($aPos[3] - $cellH) < 15 Then
                    If Abs($aPos[0] - ($tCol * $cellW)) < 15 And Abs($aPos[1] - ($tRow * $cellH)) < 15 Then $hWinTarget = $hWnd
                EndIf
            EndIf
        EndIf
    Next
    
    If $hWinCenter <> 0 Then
        Local $tCol = Mod($iTargetPos - 1, 3), $tRow = Int(($iTargetPos - 1) / 3)
        WinMove($hWinCenter, "", $tCol * $cellW, $tRow * $cellH, $cellW, $cellH)
    EndIf
    If $hWinTarget <> 0 Then
        WinMove($hWinTarget, "", $cellW, $cellH, $cellW, $cellH)
    EndIf
    _PopulateList($aIconIndices)
EndFunc

; Alt + PageUp/PageDown cascade layer stack function
Func _OnSiblingsToTop()
    Local $iSelected = _GUICtrlListView_GetSelectedIndices($idListview)
    If $iSelected = "" Then Return
    Local $iIdx = Int($iSelected)
    Local $aWinList = WinList("[REGEXPTITLE:(?i).*" & $aBrowsers[$iIdx][1] & "$]")
    If $aWinList[0][0] > 0 Then
        For $i = $aWinList[0][0] To 1 Step -1
            _WinAPI_SetWindowPos($aWinList[$i][1], 0, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOACTIVATE))
        Next
        _WinAPI_SetWindowPos($hGUI, 0, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOACTIVATE))
        GUICtrlSetData($idStatus, "Brought all instances of " & $aBrowsers[$iIdx][0] & " to top")
    EndIf
EndFunc

; Automatically focus address text bounds and copy path URL strings
Func _OnCopyUrl()
    Local $hWnd = _GetSelectedBrowserWindow()
    If Not $hWnd Then Return
    Local $sOldClip = ClipGet()
    ClipPut("")
    WinActivate($hWnd)
    Sleep(600)
    ControlSend($hWnd, "", "", "^l") 
    Sleep(200)
    ControlSend($hWnd, "", "", "^c") 
    Sleep(200)
    Local $sNewUrl = ClipGet()
    WinActivate($hGUI)
    If $sNewUrl = "" Then 
        ClipPut($sOldClip) 
        GUICtrlSetData($idStatus, "Failed to copy URL")
    Else
        GUICtrlSetData($idStatus, "Copied URL: " & $sNewUrl)
    EndIf
EndFunc

; Pushes target window down to the absolute bottom of the desktop layout hierarchy
Func _OnSendToBack()
    Local $hWnd = _GetSelectedBrowserWindow()
    If Not $hWnd Then Return
    _WinAPI_SetWindowPos($hWnd, 1, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOACTIVATE)) ; HWND_BOTTOM = 1
    GUICtrlSetData($idStatus, "Sent selected browser window to back")
    _PopulateList($aIconIndices)
EndFunc

; Redraws entire table column arrays while caching local selection markers
Func _PopulateList($aIcons)
    Local $iSelected = _GUICtrlListView_GetSelectedIndices($idListview)
    _GUICtrlListView_DeleteAllItems($idListview)
    
    For $i = 0 To $iBrowserCount - 1
        Local $aWinList = WinList("[REGEXPTITLE:(?i).*" & $aBrowsers[$i][1] & "$]")
        $aLastCounts[$i] = $aWinList[0][0]
        Local $sStatus = ($aWinList[0][0] > 0) ? "Running" : "Not Running"
        
        Local $sGridPos = "None"
        Local $iMinCount = 0
        If $aWinList[0][0] > 0 Then
            $sGridPos = _GetGridPosition($aWinList[1][1]) ; Match topmost row window frame
            For $j = 1 To $aWinList[0][0]
                If _IsWindowMinimized($aWinList[$j][1]) Then $iMinCount += 1
            Next
        EndIf
        Local $sMinText = ($aWinList[0][0] > 0) ? (String($iMinCount) & " / " & String($aWinList[0][0])) : "0"
        
        _GUICtrlListView_AddItem($idListview, $aBrowsers[$i][0], $aIcons[$i])
        _GUICtrlListView_AddSubItem($idListview, $i, $sStatus, 1)
        _GUICtrlListView_AddSubItem($idListview, $i, $aBrowsers[$i][4], 2)
        _GUICtrlListView_AddSubItem($idListview, $i, String($aWinList[0][0]), 3)
        _GUICtrlListView_AddSubItem($idListview, $i, $sGridPos, 4)
        _GUICtrlListView_AddSubItem($idListview, $i, $sMinText, 5)
    Next
    
    If $iSelected <> "" Then
        _GUICtrlListView_SetItemSelected($idListview, Int($iSelected), True, True)
    EndIf
EndFunc

Func _CheckBrowserRunning($iIndex)
    Local $aWinList = WinList("[REGEXPTITLE:(?i).*" & $aBrowsers[$iIndex][1] & "$]")
    For $i = 1 To $aWinList[0][0]
        If BitAND(WinGetState($aWinList[$i][1]), 2) Then Return True
    Next
    Return False
EndFunc

; Modified action engine to strictly target and close the highest single frame matching the row item array favoring highest visible z-index
Func _HandleAction($iIndex, $bClose)
    Local $sName = $aBrowsers[$iIndex][0]
    Local $sSuffix = $aBrowsers[$iIndex][1]
    Local $sPath = $aBrowsers[$iIndex][2]
    Local $sProc = $aBrowsers[$iIndex][3]
    
    Local $aWinList = WinList("[REGEXPTITLE:(?i).*" & $sSuffix & "$]")
    Local $hTargetWin = 0
    
    ; Find the highest visible window in the stack (by checking standard visible state)
    For $i = 1 To $aWinList[0][0]
        If BitAND(WinGetState($aWinList[$i][1]), 2) Then
            $hTargetWin = $aWinList[$i][1]
            ExitLoop
        EndIf
    Next
    
    If $bClose Then
        If $hTargetWin <> 0 Then
            WinClose($hTargetWin) ; Closes strictly the highest Z-order visible window frame matching the browser
            GUICtrlSetData($idStatus, "Closed top window of: " & $sName)
            WinActivate($hGUI)
            ControlFocus($hGUI, "", $idListview)
        EndIf
    Else
        If $hTargetWin <> 0 Then
            WinActivate($hTargetWin)
            WinSetState($hTargetWin, "", @SW_RESTORE)
            _MinimizeToTray()
        Else
            If FileExists($sPath) Then
                Run($sPath)
                Sleep(400)
                _MinimizeToTray()
            EndIf
        EndIf
    EndIf
    _PopulateList($aIconIndices)
EndFunc

Func _OnMinimizeToggle()
    Local $hWnd = _GetSelectedBrowserWindow()
    If Not $hWnd Then Return
    If _IsWindowMinimized($hWnd) Then
        WinSetState($hWnd, "", @SW_RESTORE)
        GUICtrlSetData($idStatus, "Restored selected browser window")
    Else
        WinSetState($hWnd, "", @SW_MINIMIZE)
        GUICtrlSetData($idStatus, "Minimized selected browser window")
        WinActivate($hGUI)
        ControlFocus($hGUI, "", $idListview)
    EndIf
    _PopulateList($aIconIndices)
EndFunc

; Displays GUI workspace
Func _ShowGUI()
    GUISetState(@SW_SHOW, $hGUI)
    WinActivate($hGUI)
    $bGUI_Visible = True
    TraySetState(1)
    
    Local $iHighestIdx = -1
    Local $aFullWinList = WinList()
    
    For $i = 1 To $aFullWinList[0][0]
        Local $hWnd = $aFullWinList[$i][1]
        If BitAND(WinGetState($hWnd), 2) And Not BitAND(WinGetState($hWnd), 16) Then
            Local $sTitle = $aFullWinList[$i][0]
            For $b = 0 To $iBrowserCount - 1
                If StringInStr($sTitle, $aBrowsers[$b][1]) Then
                    $iHighestIdx = $b
                    ExitLoop 2
                EndIf
            Next
        EndIf
    Next
    
    If $iHighestIdx <> -1 Then
        _GUICtrlListView_SetItemSelected($idListview, $iHighestIdx, True, True)
        _GUICtrlListView_EnsureVisible($idListview, $iHighestIdx)
    EndIf
    ControlFocus($hGUI, "", $idListview)
EndFunc

; ==============================================================================
; GDI WINDOW DRAWING & HELPER FUNCTIONS (originally actions_gdi.au3)
; ==============================================================================

Func _DrawOrangeBorder($hTarget)
    If Not _WinAPI_IsWindow($hTarget) Then Return
    Local $aPos = WinGetPos($hTarget)
    If Not IsArray($aPos) Then Return
    
    ; Promote window to the top of Z-index, saving original position if not already tracked
    If $hLastSelectedWin <> $hTarget Then
        If $hLastSelectedWin <> 0 And _WinAPI_IsWindow($hLastSelectedWin) Then
            Local $hInsertAfter = $hLastPrevWin
            If Not _WinAPI_IsWindow($hInsertAfter) Then $hInsertAfter = 1 ; HWND_BOTTOM if previous sibling is gone
            _WinAPI_SetWindowPos($hLastSelectedWin, $hInsertAfter, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOACTIVATE))
        EndIf
        $hLastSelectedWin = $hTarget
        $hLastPrevWin = _WinAPI_GetWindow($hTarget, 3) ; GW_HWNDPREV = 3
        
        _WinAPI_SetWindowPos($hTarget, 0, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE)) ; HWND_TOP = 0
        If $bGUI_Visible Then
            WinActivate($hGUI)
            _WinAPI_SetWindowPos($hGUI, 0, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOACTIVATE)) ; Keep Manager above it
        EndIf
    EndIf
    
    If $hBorderWin = 0 Then
        $hBorderWin = GUICreate("", $aPos[2], $aPos[3], $aPos[0], $aPos[1], $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TRANSPARENT, $WS_EX_TOPMOST))
        GUISetBkColor(0xABCDEF, $hBorderWin)
        _WinAPI_SetLayeredWindowAttributes($hBorderWin, 0xABCDEF, 255, 1)
        GUISetState(@SW_SHOWNOACTIVATE, $hBorderWin)
    Else
        _WinAPI_SetWindowPos($hBorderWin, 0, $aPos[0], $aPos[1], $aPos[2], $aPos[3], $SWP_NOACTIVATE)
    Endif
    
    Local $hDC = _WinAPI_GetWindowDC($hBorderWin)
    Local $hRect = _WinAPI_CreateRectRgn(0, 0, $aPos[2], $aPos[3])
    Local $hInnerRect = _WinAPI_CreateRectRgn(2, 2, $aPos[2] - 2, $aPos[3] - 2)
    _WinAPI_CombineRgn($hRect, $hRect, $hInnerRect, 4)
    
    Local $hBrush = _WinAPI_CreateSolidBrush(0xFF6600)
    _WinAPI_FillRgn($hDC, $hRect, $hBrush)
    
    _WinAPI_DeleteObject($hBrush)
    _WinAPI_DeleteObject($hRect)
    _WinAPI_DeleteObject($hInnerRect)
    _WinAPI_ReleaseDC($hBorderWin, $hDC)
EndFunc

Func _ClearOrangeBorder()
    If $hLastSelectedWin <> 0 Then
        If _WinAPI_IsWindow($hLastSelectedWin) Then
            Local $hInsertAfter = $hLastPrevWin
            If Not _WinAPI_IsWindow($hInsertAfter) Then $hInsertAfter = 1 ; HWND_BOTTOM if previous sibling is gone
            _WinAPI_SetWindowPos($hLastSelectedWin, $hInsertAfter, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOACTIVATE))
        EndIf
        $hLastSelectedWin = 0
        $hLastPrevWin = 0
    EndIf
    If $hBorderWin <> 0 Then
        GUIDelete($hBorderWin)
        $hBorderWin = 0
    Endif
EndFunc

Func _GetGridPosition($hWnd)
    If Not BitAND(WinGetState($hWnd), 2) Or BitAND(WinGetState($hWnd), 16) Then Return "None"
    Local $aPos = WinGetPos($hWnd)
    If Not IsArray($aPos) Then Return "None"
    
    Local $iW = @DesktopWidth, $iH = @DesktopHeight
    Local $cellW = Int($iW / 3), $cellH = Int($iH / 3)
    
    Local $iCenterW = Int($iW * 5 / 9)
    Local $iCenterH = Int($iH * 5 / 9)
    Local $iCenterX = Int(($iW - $iCenterW) / 2)
    Local $iCenterY = Int(($iH - $iCenterH) / 2)
    If Abs($aPos[2] - $iCenterW) < 15 And Abs($aPos[3] - $iCenterH) < 15 Then
        If Abs($aPos[0] - $iCenterX) < 15 And Abs($aPos[1] - $iCenterY) < 15 Then Return "0"
    EndIf
    
    If Abs($aPos[2] - $cellW) > 15 Or Abs($aPos[3] - $cellH) > 15 Then Return "None"
    
    Local $col = -1, $row = -1
    For $c = 0 To 2
        If Abs($aPos[0] - ($c * $cellW)) < 15 Then $col = $c
    Next
    For $r = 0 To 2
        If Abs($aPos[1] - ($r * $cellH)) < 15 Then $row = $r
    Next
    
    If $col <> -1 And $row <> -1 Then
        Return String(($row * 3) + $col + 1)
    EndIf
    Return "None"
EndFunc

Func _IsWindowMinimized($hWnd)
    Return BitAND(WinGetState($hWnd), 16) ? True : False
EndFunc

; ==============================================================================
; USER INTERFACE & SHORTCUT EVENT ACTIONS (originally actions_ui.au3)
; ==============================================================================

Func _ShowHelp()
    If WinExists($hHelpGUI) Then
        WinActivate($hHelpGUI)
        Return
    EndIf
    
    ; Create a standard, fully visible dialog frame centered on desktop
    ; Width: 610, Height: 560
    ; 0x00C00000 is $WS_CAPTION, 0x00080000 is $WS_SYSMENU
    $hHelpGUI = GUICreate("Help / Shortcut Guide", 610, 560, -1, -1, BitOR(0x00C00000, 0x00080000), -1, $hGUI)
    GUISetBkColor(0x1E1E1E, $hHelpGUI)
    
    ; Create embedded browser control
    Local $oIE = ObjCreate("Shell.Explorer.2")
    If Not IsObj($oIE) Then
        MsgBox(16, "Error", "Failed to create Internet Explorer object for Web Help.")
        Return
    EndIf
    
    Local $idIE_Ctrl = GUICtrlCreateObj($oIE, 5, 5, 600, 500)
    _WinAPI_SetWindowLong(GUICtrlGetHandle($idIE_Ctrl), -20, BitAND(_WinAPI_GetWindowLong(GUICtrlGetHandle($idIE_Ctrl), -20), BitNOT(0x00000200)))
    
    ; Navigate to empty page and write the beautiful HTML
    $oIE.navigate("about:blank")
    While $oIE.ReadyState <> 4
        Sleep(10)
    WEnd
    
    Local $sHTML = _
        "<!DOCTYPE html>" & _
        "<html>" & _
        "<head>" & _
        '    <meta http-equiv="X-UA-Compatible" content="IE=edge">' & _
        "    <style>" & _
        "        html {" & _
        "            border: 0px none !important;" & _
        "            margin: 0;" & _
        "            padding: 0;" & _
        "            overflow: auto;" & _
        "        }" & _
        "        body {" & _
        "            background-color: #1E1E1E;" & _
        "            color: #E0E0E0;" & _
        "            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;" & _
        "            margin: 0;" & _
        "            padding: 24px;" & _
        "            font-size: 13px;" & _
        "            user-select: none;" & _
        "            cursor: default;" & _
        "            border: 0px none !important;" & _
        "        }" & _
        "        h1 {" & _
        "            color: #FF6600;" & _
        "            font-size: 18px;" & _
        "            font-weight: 800;" & _
        "            margin: 0 0 4px 0;" & _
        "            text-transform: uppercase;" & _
        "            letter-spacing: 1px;" & _
        "        }" & _
        "        .subtitle {" & _
        "            color: #858585;" & _
        "            font-size: 11px;" & _
        "            margin-bottom: 24px;" & _
        "            font-style: italic;" & _
        "        }" & _
        "        .section {" & _
        "            margin-bottom: 20px;" & _
        "        }" & _
        "        .section-title {" & _
        "            color: #FF6600;" & _
        "            font-size: 12px;" & _
        "            font-weight: bold;" & _
        "            border-bottom: 1px solid #333;" & _
        "            padding-bottom: 4px;" & _
        "            margin-bottom: 12px;" & _
        "            text-transform: uppercase;" & _
        "            letter-spacing: 0.5px;" & _
        "        }" & _
        "        .shortcut-table {" & _
        "            width: 100%;" & _
        "            border-collapse: collapse;" & _
        "        }" & _
        "        .shortcut-row {" & _
        "            border-bottom: 1px solid #252525;" & _
        "        }" & _
        "        .shortcut-key {" & _
        "            width: 170px;" & _
        "            padding: 6px 0;" & _
        "            vertical-align: middle;" & _
        "        }" & _
        "        .shortcut-desc {" & _
        "            padding: 6px 0;" & _
        "            color: #CCCCCC;" & _
        "            vertical-align: middle;" & _
        "        }" & _
        "        kbd {" & _
        "            background-color: #2D2D2D;" & _
        "            color: #FFFFFF;" & _
        "            border: 1px solid #444;" & _
        "            border-bottom: 3px solid #444;" & _
        "            border-radius: 4px;" & _
        "            padding: 2px 6px;" & _
        "            font-family: 'Consolas', monospace;" & _
        "            font-size: 11px;" & _
        "            display: inline-block;" & _
        "            box-shadow: 0 1px 1px rgba(0,0,0,0.2);" & _
        "        }" & _
        "        .highlight {" & _
        "            color: #FF6600;" & _
        "            font-weight: bold;" & _
        "        }" & _
        "    </style>" & _
        "</head>" & _
        "<body>" & _
        "    <h1>Browser Manager Shortcuts</h1>" & _
        "    <div class='subtitle'>Master your desktop workspace with these key combinations.</div>" & _
        "    " & _
        "    <div class='section'>" & _
        "        <div class='section-title'>Global Hotkeys</div>" & _
        "        <table class='shortcut-table'>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Win</kbd> + <kbd>AppsKey</kbd></td>" & _
        "                <td class='shortcut-desc'>Toggle Browser Manager GUI visibility</td>" & _
        "            </tr>" & _
        "        </table>" & _
        "    </div>" & _
        "    " & _
        "    <div class='section'>" & _
        "        <div class='section-title'>Workspace Navigation</div>" & _
        "        <table class='shortcut-table'>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>B</kbd> / <kbd>C</kbd> / <kbd>E</kbd> / <kbd>V</kbd> / <kbd>F</kbd> / <kbd>P</kbd></td>" & _
        "                <td class='shortcut-desc'>Activate or Launch targeted browser</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Ctrl</kbd> + <kbd>Letter</kbd></td>" & _
        "                <td class='shortcut-desc'>Safely close the top window of that browser</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Alt</kbd> + <kbd>Letter</kbd></td>" & _
        "                <td class='shortcut-desc'>Select and focus that browser item in list</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Enter</kbd></td>" & _
        "                <td class='shortcut-desc'>Activate, restore, or launch selected browser</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Esc</kbd></td>" & _
        "                <td class='shortcut-desc'>Minimize Manager window to system tray</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Ctrl</kbd> + <kbd>C</kbd></td>" & _
        "                <td class='shortcut-desc'>Copy current tab URL to Clipboard</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>-</kbd> (Minus)</td>" & _
        "                <td class='shortcut-desc'>Toggle minimize/restore on selected browser</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Backspace</kbd></td>" & _
        "                <td class='shortcut-desc'>Send selected window to back of Z-order</td>" & _
        "            </tr>" & _
        "        </table>" & _
        "    </div>" & _
        "    " & _
        "    <div class='section'>" & _
        "        <div class='section-title'>Tab & Sibling Window Navigation</div>" & _
        "        <table class='shortcut-table'>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Page Up</kbd></td>" & _
        "                <td class='shortcut-desc'>Go to <span class='highlight'>PREVIOUS</span> tab of selected window</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Page Down</kbd></td>" & _
        "                <td class='shortcut-desc'>Go to <span class='highlight'>NEXT</span> tab of selected window</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Delete</kbd></td>" & _
        "                <td class='shortcut-desc'>Close current tab of selected window (<kbd>Ctrl</kbd>+<kbd>W</kbd>)</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Insert</kbd></td>" & _
        "                <td class='shortcut-desc'>Create a new tab (<kbd>Ctrl</kbd>+<kbd>T</kbd>) / clipboard launch</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>&rarr;</kbd> (Right Arrow)</td>" & _
        "                <td class='shortcut-desc'>Bring deepest sibling of selected window to top</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>&larr;</kbd> (Left Arrow)</td>" & _
        "                <td class='shortcut-desc'>Send current top window to bottom, bring next to top</td>" & _
        "            </tr>" & _
        "        </table>" & _
        "    </div>" & _
        "    " & _
        "    <div class='section'>" & _
        "        <div class='section-title'>Desktop Grid Controls</div>" & _
        "        <table class='shortcut-table'>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>1</kbd> to <kbd>9</kbd></td>" & _
        "                <td class='shortcut-desc'>Snap window to 3x3 layout (1=top-left, 9=bottom-right)</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>0</kbd></td>" & _
        "                <td class='shortcut-desc'>Center window (occupies 5/9th screen area)</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Ctrl</kbd> + <kbd>1</kbd> to <kbd>9</kbd></td>" & _
        "                <td class='shortcut-desc'>Swap current center slot (5) window with target slot</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Alt</kbd> + <kbd>PageUp/Dn</kbd></td>" & _
        "                <td class='shortcut-desc'>Bring ALL instances of selected browser to front</td>" & _
        "            </tr>" & _
        "        </table>" & _
        "    </div>" & _
        "</body>" & _
        "</html>"
    
    $oIE.document.write($sHTML)
    
    ; Native styled close button at the bottom
    Local $idCloseBtn = GUICtrlCreateButton("Close Help Guide", 205, 515, 200, 32)
    GUICtrlSetBkColor($idCloseBtn, 0x1E1E1E) ; Dark slate button background
    GUICtrlSetColor($idCloseBtn, 0xFFFFFF)
    GUICtrlSetFont($idCloseBtn, 10, 600, 0, "Segoe UI")
    
    ; Setup events for Help GUI
    GUISetOnEvent(-3, "_HelpGUI_Close", $hHelpGUI) ; -3 is $GUI_EVENT_CLOSE
    GUICtrlSetOnEvent($idCloseBtn, "_HelpGUI_Close")
    
    GUISetState(@SW_SHOW, $hHelpGUI)
EndFunc

Func _HelpGUI_Close()
    GUIDelete($hHelpGUI)
    $hHelpGUI = 0
EndFunc

Func _OnShortcut()
    Local $idPressed = @GUI_CtrlId
    For $i = 0 To $iBrowserCount - 1
        If $idPressed = $aDummyActivate[$i] Then
            _HandleAction($i, False)
            ExitLoop
        ElseIf $idPressed = $aDummyClose[$i] Then
            _HandleAction($i, True)
            ExitLoop
        ElseIf $idPressed = $aDummyFocus[$i] Then
            _GUICtrlListView_SetItemSelected($idListview, $i, True, True)
            _GUICtrlListView_EnsureVisible($idListview, $i)
            ControlFocus($hGUI, "", $idListview)
            ExitLoop
        EndIf
    Next
EndFunc

Func _OnEnterPressed()
    Local $iSelected = _GUICtrlListView_GetSelectedIndices($idListview)
    If $iSelected <> "" Then
        _HandleAction(Int($iSelected), False)
    EndIf
EndFunc

Func _OnDeletePressed()
    Local $hWnd = $hLastSelectedWin
    If Not $hWnd Or Not _WinAPI_IsWindow($hWnd) Then $hWnd = _GetSelectedBrowserWindow()
    If $hWnd Then
        Local $hActivePrev = WinGetHandle("[ACTIVE]")
        WinActivate($hWnd)
        Sleep(50)
        Send("^w")
        Sleep(50)
        If $hActivePrev Then WinActivate($hActivePrev)
        GUICtrlSetData($idStatus, "Closed active tab of indicated window")
    EndIf
EndFunc

Func _OnRightPressed()
    Local $iSelected = _GUICtrlListView_GetSelectedIndices($idListview)
    If $iSelected = "" Then Return
    Local $iIdx = Int($iSelected)
    Local $aWinList = WinList("[REGEXPTITLE:(?i).*" & $aBrowsers[$iIdx][1] & "$]")
    Local $aVisibleWins[100]
    Local $iCount = 0
    For $i = 1 To $aWinList[0][0]
        If BitAND(WinGetState($aWinList[$i][1]), 2) And Not BitAND(WinGetState($aWinList[$i][1]), 16) Then
            $aVisibleWins[$iCount] = $aWinList[$i][1]
            $iCount += 1
        EndIf
    Next
    If $iCount > 1 Then
        Local $hDeepestWin = $aVisibleWins[$iCount - 1]
        _WinAPI_SetWindowPos($hDeepestWin, 0, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOACTIVATE)) ; HWND_TOP = 0
        _WinAPI_SetWindowPos($hGUI, 0, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOACTIVATE)) ; Keep Manager above it
        _DrawOrangeBorder($hDeepestWin)
        GUICtrlSetData($idStatus, "Brought deepest sibling window to top")
    EndIf
EndFunc

Func _OnLeftPressed()
    Local $iSelected = _GUICtrlListView_GetSelectedIndices($idListview)
    If $iSelected = "" Then Return
    Local $iIdx = Int($iSelected)
    Local $aWinList = WinList("[REGEXPTITLE:(?i).*" & $aBrowsers[$iIdx][1] & "$]")
    Local $aVisibleWins[100]
    Local $iCount = 0
    For $i = 1 To $aWinList[0][0]
        If BitAND(WinGetState($aWinList[$i][1]), 2) And Not BitAND(WinGetState($aWinList[$i][1]), 16) Then
            $aVisibleWins[$iCount] = $aWinList[$i][1]
            $iCount += 1
        EndIf
    Next
    If $iCount > 1 Then
        Local $hCurrentTop = $aVisibleWins[0]
        Local $hNextTop = $aVisibleWins[1]
        Local $hDeepest = $aVisibleWins[$iCount - 1]
        
        ; Put current top window after the deepest window in Z-order
        _WinAPI_SetWindowPos($hCurrentTop, $hDeepest, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOACTIVATE))
        
        ; Bring the next top window to HWND_TOP = 0
        _WinAPI_SetWindowPos($hNextTop, 0, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOACTIVATE))
        _WinAPI_SetWindowPos($hGUI, 0, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOACTIVATE)) ; Keep Manager above it
        
        _DrawOrangeBorder($hNextTop)
        GUICtrlSetData($idStatus, "Pushed top window behind deepest sibling, brought next to top")
    EndIf
EndFunc

Func _OnGridHotkey()
    Local $idPressed = @GUI_CtrlId
    Local $hWndIn = _GetSelectedBrowserWindow()
    If Not $hWndIn Then Return
    
    Local $iTargetPos = -1
    If $idPressed = $aDummyGrid[0] Then
        $iTargetPos = 0
    Else
        For $i = 1 To 9
            If $idPressed = $aDummyGrid[$i] Then
                $iTargetPos = $i
                ExitLoop
            EndIf
        Next
    EndIf
    If $iTargetPos = -1 Then Return
    
    Local $hWndOcc = _GetWindowAtGridPosition($iTargetPos)
    If $hWndOcc <> 0 And $hWndOcc <> $hWndIn Then
        Local $sPosIn = _GetGridPosition($hWndIn)
        If $sPosIn <> "None" Then
            ; Swap positions!
            Local $iPosIn = Int($sPosIn)
            _MoveWindowToGridPosition($hWndIn, $iTargetPos)
            _MoveWindowToGridPosition($hWndOcc, $iPosIn)
            GUICtrlSetData($idStatus, "Swapped positions of " & StringLeft(WinGetTitle($hWndIn), 20) & " and " & StringLeft(WinGetTitle($hWndOcc), 20))
        Else
            ; Find first available position starting from 9 and going backwards
            Local $iAvailablePos = -1
            For $p = 9 DownTo 1
                If _GetWindowAtGridPosition($p) = 0 Then
                    $iAvailablePos = $p
                    ExitLoop
                EndIf
            Next
            ; Check position 0 (center) as well
            If $iAvailablePos = -1 And _GetWindowAtGridPosition(0) = 0 Then
                $iAvailablePos = 0
            EndIf
            
            If $iAvailablePos <> -1 Then
                _MoveWindowToGridPosition($hWndOcc, $iAvailablePos)
                _MoveWindowToGridPosition($hWndIn, $iTargetPos)
                GUICtrlSetData($idStatus, "Moved occupying window to grid " & $iAvailablePos & " and incoming to " & $iTargetPos)
            Else
                ; Re-use position but offset by 30px
                _MoveWindowToGridPosition($hWndOcc, $iTargetPos, 30)
                _MoveWindowToGridPosition($hWndIn, $iTargetPos)
                GUICtrlSetData($idStatus, "Occupied! Offset occupying window at grid " & $iTargetPos & " by 30px")
            EndIf
        EndIf
    Else
        _MoveWindowToGridPosition($hWndIn, $iTargetPos)
        GUICtrlSetData($idStatus, "Moved window to grid " & $iTargetPos)
    EndIf
    
    _DrawOrangeBorder($hWndIn)
    _PopulateList($aIconIndices)
EndFunc

Func _OnFocusGridHotkey()
    Local $idPressed = @GUI_CtrlId
    Local $iTargetPos = -1
    If $idPressed = $aDummyFocusGrid[0] Then
        $iTargetPos = 0
    Else
        For $i = 1 To 9
            If $idPressed = $aDummyFocusGrid[$i] Then
                $iTargetPos = $i
                ExitLoop
            EndIf
        Next
    Endif
    If $iTargetPos = -1 Then Return
    
    Local $hWnd = _GetWindowAtGridPosition($iTargetPos)
    If $hWnd <> 0 Then
        Local $sTitle = WinGetTitle($hWnd)
        Local $iMatchIdx = -1
        For $b = 0 To $iBrowserCount - 1
            If StringInStr($sTitle, $aBrowsers[$b][1]) Then
                $iMatchIdx = $b
                ExitLoop
            EndIf
        Next
        
        If $iMatchIdx <> -1 Then
            _WinAPI_SetWindowPos($hWnd, 0, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE)) ; HWND_TOP = 0
            If $bGUI_Visible Then
                WinActivate($hGUI)
            EndIf
            
            _GUICtrlListView_SetItemSelected($idListview, $iMatchIdx, True, True)
            _GUICtrlListView_EnsureVisible($idListview, $iMatchIdx)
            ControlFocus($hGUI, "", $idListview)
            
            _DrawOrangeBorder($hWnd)
            GUICtrlSetData($idStatus, "Focused window at grid position " & $iTargetPos)
        EndIf
    EndIf
EndFunc

Func _OnCycleNext()
    _CycleGridWindows(True)
EndFunc

Func _OnCyclePrev()
    _CycleGridWindows(False)
EndFunc

Func _CycleGridWindows($bNext)
    Local $aWins = _GetAllVisibleBrowserWindows()
    Local $aMoveList[100][2]
    Local $iMoveCount = 0
    
    For $i = 0 To UBound($aWins) - 1
        Local $hWnd = $aWins[$i]
        Local $sPos = _GetGridPosition($hWnd)
        If $sPos <> "None" And $sPos <> "0" Then
            Local $iPos = Int($sPos)
            If $iPos >= 1 And $iPos <= 9 Then
                Local $iNewPos
                If $bNext Then
                    $iNewPos = $iPos + 1
                    If $iNewPos > 9 Then $iNewPos = 1
                Else
                    $iNewPos = $iPos - 1
                    If $iNewPos < 1 Then $iNewPos = 9
                EndIf
                $aMoveList[$iMoveCount][0] = $hWnd
                $aMoveList[$iMoveCount][1] = $iNewPos
                $iMoveCount += 1
                If $iMoveCount >= 100 Then ExitLoop
            EndIf
        EndIf
    Next
    
    For $i = 0 To $iMoveCount - 1
        _MoveWindowToGridPosition($aMoveList[$i][0], $aMoveList[$i][1])
    Next
    
    _PopulateList($aIconIndices)
    GUICtrlSetData($idStatus, "Cycled grid windows " & ($bNext ? "forward" : "backward"))
EndFunc

Func _GetAllVisibleBrowserWindows()
    Local $aResult[100]
    Local $iCount = 0
    For $b = 0 To $iBrowserCount - 1
        Local $aWinList = WinList("[REGEXPTITLE:(?i).*" & $aBrowsers[$b][1] & "$]")
        For $w = 1 To $aWinList[0][0]
            Local $hWnd = $aWinList[$w][1]
            If BitAND(WinGetState($hWnd), 2) And Not BitAND(WinGetState($hWnd), 16) Then
                $aResult[$iCount] = $hWnd
                $iCount += 1
            EndIf
        Next
    Next
    ReDim $aResult[$iCount]
    Return $aResult
EndFunc

Func _GetWindowAtGridPosition($iPos)
    Local $aWins = _GetAllVisibleBrowserWindows()
    For $i = 0 To UBound($aWins) - 1
        If _GetGridPosition($aWins[$i]) = String($iPos) Then
            Return $aWins[$i]
        EndIf
    Next
    Return 0
EndFunc

Func _GetGridCoordinates($iPos, ByRef $iX, ByRef $iY, ByRef $iW, ByRef $iH)
    Local $iDeskW = @DesktopWidth, $iDeskH = @DesktopHeight
    If $iPos = 0 Then
        $iW = Int($iDeskW * 5 / 9)
        $iH = Int($iDeskH * 5 / 9)
        $iX = Int(($iDeskW - $iW) / 2)
        $iY = Int(($iDeskH - $iH) / 2)
    Else
        Local $col = Mod($iPos - 1, 3)
        Local $row = Int(($iPos - 1) / 3)
        $iW = Int($iDeskW / 3)
        $iH = Int($iDeskH / 3)
        $iX = $col * $iW
        $iY = $row * $iH
    EndIf
EndFunc

Func _MoveWindowToGridPosition($hWnd, $iPos, $iOffset = 0)
    Local $iX, $iY, $iW, $iH
    _GetGridCoordinates($iPos, $iX, $iY, $iW, $iH)
    WinMove($hWnd, "", $iX + $iOffset, $iY + $iOffset, $iW, $iH)
EndFunc

Func _OnNewTab()
    Local $iSelected = _GUICtrlListView_GetSelectedIndices($idListview)
    If $iSelected = "" Then Return
    Local $sPath = $aBrowsers[Int($iSelected)][2]
    Local $sUrl = ClipGet()
    If StringLeft($sUrl, 4) = "http" Or StringInStr($sUrl, ".") > 0 Then
        ShellExecute($sPath, $sUrl)
        GUICtrlSetData($idStatus, "Opened URL tab from Clipboard")
    EndIf
EndFunc

Func _OnTabLeft()
    Local $hWnd = $hLastSelectedWin
    If Not $hWnd Or Not _WinAPI_IsWindow($hWnd) Then $hWnd = _GetSelectedBrowserWindow()
    If $hWnd Then 
        Local $hActivePrev = WinGetHandle("[ACTIVE]")
        WinActivate($hWnd)
        Sleep(50)
        Send("^+{TAB}")
        Sleep(50)
        If $hActivePrev Then WinActivate($hActivePrev)
        GUICtrlSetData($idStatus, "Switched to previous tab on indicated window")
    EndIf
EndFunc

Func _OnTabRight()
    Local $hWnd = $hLastSelectedWin
    If Not $hWnd Or Not _WinAPI_IsWindow($hWnd) Then $hWnd = _GetSelectedBrowserWindow()
    If $hWnd Then 
        Local $hActivePrev = WinGetHandle("[ACTIVE]")
        WinActivate($hWnd)
        Sleep(50)
        Send("^{TAB}")
        Sleep(50)
        If $hActivePrev Then WinActivate($hActivePrev)
        GUICtrlSetData($idStatus, "Switched to next tab on indicated window")
    EndIf
EndFunc

Func _ToggleGUI()
    If $bGUI_Visible Then
        _MinimizeToTray()
    Else
        _ShowGUI()
    EndIf
EndFunc

Func _MinimizeToTray()
    If $hHelpGUI <> 0 And WinExists($hHelpGUI) Then
        _HelpGUI_Close()
        Return
    EndIf
    GUISetState(@SW_HIDE, $hGUI)
    $bGUI_Visible = False
    TraySetState(1)
    _ClearOrangeBorder()
    $hLastSelectedWin = 0
    $hLastPrevWin = 0
EndFunc

Func _HandleClose()
    _ExitApp()
EndFunc

Func _ExitApp()
    If $hLastSelectedWin <> 0 And _WinAPI_IsWindow($hLastSelectedWin) Then
        _WinAPI_SetWindowPos($hLastSelectedWin, $hLastPrevWin, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOACTIVATE))
    EndIf
    _ClearOrangeBorder()
    Exit
EndFunc
