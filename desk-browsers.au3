#NoTrayIcon
#RequireAdmin ; Request administrative rights to manage borderless styles and transparency of all windows
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <GuiListView.au3>
#include <GuiImageList.au3>
#include <WindowsConstants.au3>
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

Global $aDummyActivate[6]
Global $aDummyClose[6]
Global $aDummyFocus[6]
Global $aDummyGrid[10] ; 0-9 hotkeys
Global $aDummySwap[9]   ; 1-9 swap hotkeys
Global $aIconIndices[6]

Global $idDummyEscape
Global $idDummyInsert
Global $idDummyPageUp
Global $idDummyPageDown
Global $idDummySiblingUp
Global $idDummyCopyUrl
Global $idDummySendToBack
Global $idDummyMinimizeToggle

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
$hGUI = GUICreate("Browser Manager", 580, 320, -1, -1, BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS), $WS_EX_TOPMOST)
GUICtrlCreateLabel("Keys: Letter (Act) | Ctrl+Letter (Close) | Alt+Letter (Focus) | Esc (Min) | - (Min Toggle) | Backspace (To Back)", 10, 12, 470, 20)

; Help Button UI Placement
$idHelpBtn = GUICtrlCreateButton("Help / Shortcuts", 480, 8, 90, 24)
GUICtrlSetOnEvent($idHelpBtn, "_ShowHelp")

; Create ListView with Positions and Minimized tracking metrics
$idListview = GUICtrlCreateListView("Browser|Status|Shortcut|Instances|Grid Pos|Minimized", 10, 40, 560, 230, BitOR($LVS_REPORT, $LVS_SINGLESEL, $LVS_SHOWSELALWAYS))
_GUICtrlListView_SetColumnWidth($idListview, 0, 160)
_GUICtrlListView_SetColumnWidth($idListview, 1, 90)
_GUICtrlListView_SetColumnWidth($idListview, 2, 60)
_GUICtrlListView_SetColumnWidth($idListview, 3, 70)
_GUICtrlListView_SetColumnWidth($idListview, 4, 80)
_GUICtrlListView_SetColumnWidth($idListview, 5, 80)
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

$idStatus = GUICtrlCreateLabel("Ready", 10, 280, 560, 20)

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
Next
For $i = 1 To 9
    $aDummySwap[$i-1] = GUICtrlCreateDummy()
    GUICtrlSetOnEvent($aDummySwap[$i-1], "_OnSwapHotkey")
Next

$idDummyEscape = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyEscape, "_MinimizeToTray")
$idDummyInsert = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyInsert, "_OnNewTab")
$idDummyPageUp = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyPageUp, "_OnTabLeft")
$idDummyPageDown = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyPageDown, "_OnTabRight")
$idDummySiblingUp = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummySiblingUp, "_OnSiblingsToTop")
$idDummyCopyUrl = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyCopyUrl, "_OnCopyUrl")
$idDummySendToBack = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummySendToBack, "_OnSendToBack")
$idDummyMinimizeToggle = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyMinimizeToggle, "_OnMinimizeToggle")

Local $aAccelKeys[100][2]
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
Next

; 3. Map System and Utility hotkey rules (10 slots)
$aAccelKeys[$idx][0] = "0"
$aAccelKeys[$idx][1] = $aDummyGrid[0]
$idx += 1

$aAccelKeys[$idx][0] = "{ESC}"
$aAccelKeys[$idx][1] = $idDummyEscape
$idx += 1

$aAccelKeys[$idx][0] = "+{INS}"
$aAccelKeys[$idx][1] = $idDummyInsert
$idx += 1

$aAccelKeys[$idx][0] = "{PGUP}"
$aAccelKeys[$idx][1] = $idDummyPageUp
$idx += 1

$aAccelKeys[$idx][0] = "{PGDN}"
$aAccelKeys[$idx][1] = $idDummyPageDown
$idx += 1

$aAccelKeys[$idx][0] = "!{PGUP}"
$aAccelKeys[$idx][1] = $idDummySiblingUp
$idx += 1

$aAccelKeys[$idx][0] = "!{PGDN}"
$aAccelKeys[$idx][1] = $idDummySiblingUp
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
        Local $hFocusedCtrl = ControlGetFocus($hGUI)
        Local $hListviewHandle = GUICtrlGetHandle($idListview)
        If Int($hFocusedCtrl) <> Int($hListviewHandle) Then
            $bDeFocused = True
        EndIf
    EndIf
    
    If Not $bDeFocused Then
        Local $iSelected = _GUICtrlListView_GetSelectedIndices($idListview)
        If $iSelected = "" Then
            $bDeFocused = True
        EndIf
    EndIf
    
    If $bDeFocused Then
        If $hLastSelectedWin <> 0 Then
            If _WinAPI_IsWindow($hLastSelectedWin) Then
                _WinAPI_SetWindowPos($hLastSelectedWin, $hLastPrevWin, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOACTIVATE))
            EndIf
            $hLastSelectedWin = 0
            $hLastPrevWin = 0
            _ClearOrangeBorder()
        EndIf
        Return
    EndIf
    
    Local $iSelected = _GUICtrlListView_GetSelectedIndices($idListview)
    Local $iIdx = Int($iSelected)
    Local $aWinList = WinList("[REGEXPTITLE:(?i).*" & $aBrowsers[$iIdx][1] & "$]")
    If $aWinList[0][0] > 0 Then
        Local $hTargetWin = $aWinList[1][1] ; Highest window frame in Z-Order
        If $hTargetWin <> $hLastSelectedWin Then
            If $hLastSelectedWin <> 0 And _WinAPI_IsWindow($hLastSelectedWin) Then
                _WinAPI_SetWindowPos($hLastSelectedWin, $hLastPrevWin, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOACTIVATE))
            EndIf
            $hLastSelectedWin = $hTargetWin
            $hLastPrevWin = _WinAPI_GetWindow($hTargetWin, 3) ; GW_HWNDPREV (3)
            
            _WinAPI_SetWindowPos($hTargetWin, 0, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOACTIVATE)) ; HWND_TOP = 0
            _WinAPI_SetWindowPos($hGUI, 0, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOACTIVATE)) ; Keep Manager above it
        EndIf
        
        If BitAND(WinGetState($hTargetWin), 2) And Not BitAND(WinGetState($hTargetWin), 16) Then
            _DrawOrangeBorder($hTargetWin)
        Else
            _ClearOrangeBorder()
        EndIf
    Else
        If $hLastSelectedWin <> 0 Then
            If _WinAPI_IsWindow($hLastSelectedWin) Then
                _WinAPI_SetWindowPos($hLastSelectedWin, $hLastPrevWin, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOACTIVATE))
            EndIf
            $hLastSelectedWin = 0
            $hLastPrevWin = 0
        EndIf
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
    Local $aPos = WinGetPos($hTarget)
    If Not IsArray($aPos) Then Return
    
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
    Local $sHelpText = _
        "Global Hotkeys (Works anywhere):" & @CRLF & _
        "  • Win + ContextMenu Key : Show or Hide the Browser Manager window" & @CRLF & @CRLF & _
        "Local Hotkeys (Works when Browser Manager is active):" & @CRLF & _
        "  • Letter Key (B, C, E, V, F, P) : Activate or Launch targeted browser" & @CRLF & _
        "  • Ctrl + Letter Key : Safely close highest open window of that browser" & @CRLF & _
        "  • Alt + Letter Key : Highlight and focus that browser item in the list" & @CRLF & _
        "  • Escape (Esc) : Instantly minimize Manager window to system tray" & @CRLF & _
        "  • Ctrl + C : Copy active tab URL from selected browser to Clipboard" & @CRLF & _
        "  • Minus (-) : Toggle minimize state on selected browser windows" & @CRLF & _
        "  • Backspace : Send selected window frame to the back of the desktop" & @CRLF & @CRLF & _
        "Window Grid Controls (Target must be selected in the list):" & @CRLF & _
        "  • Keys 1 to 9 : Snap targeted browser window to a 3x3 desktop grid layout" & @CRLF & _
        "  • Key 0 : Snap window to center (Makes it exactly 5/9 of screen width & height)" & @CRLF & _
        "  • Ctrl + 1 to 9 : Swap position of center grid window with the specified slot window" & @CRLF & _
        "  • Alt + PageUp/PageDown : Move ALL instances of selected browser to front" & @CRLF & @CRLF & _
        "Tab Navigation (Target must be selected in the list):" & @CRLF & _
        "  • Shift + Insert : Read text from Clipboard and open as a new web tab" & @CRLF & _
        "  • PageUp / PageDown : Quickly scroll to the previous or next browser tab"

    MsgBox(BitOR($MB_ICONINFORMATION, $MB_TOPMOST), "Keyboard Shortcut Guide", $sHelpText, 0, $hGUI)
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

Func _OnGridHotkey()
    Local $idPressed = @GUI_CtrlId
    Local $hWnd = _GetSelectedBrowserWindow()
    If Not $hWnd Then Return
    
    Local $iPos = -1
    If $idPressed = $aDummyGrid[0] Then
        $iPos = 0
    Else
        For $i = 1 To 9
            If $idPressed = $aDummyGrid[$i] Then
                $iPos = $i
                ExitLoop
            EndIf
        Next
    EndIf
    If $iPos = -1 Then Return
    
    Local $iW = @DesktopWidth, $iH = @DesktopHeight
    If $iPos = 0 Then
        Local $iNewW = Int($iW * 5 / 9)
        Local $iNewH = Int($iH * 5 / 9)
        Local $iNewX = Int(($iW - $iNewW) / 2)
        Local $iNewY = Int(($iH - $iNewH) / 2)
        WinMove($hWnd, "", $iNewX, $iNewY, $iNewW, $iNewH)
        _DrawOrangeBorder($hWnd)
        Return
    EndIf
    
    Local $col = Mod($iPos - 1, 3)
    Local $row = Int(($iPos - 1) / 3)
    Local $cellW = Int($iW / 3)
    Local $cellH = Int($iH / 3)
    WinMove($hWnd, "", $col * $cellW, $row * $cellH, $cellW, $cellH)
    _DrawOrangeBorder($hWnd)
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
    Local $hWnd = _GetSelectedBrowserWindow()
    If $hWnd Then 
        WinActivate($hWnd)
        ControlSend($hWnd, "", "", "^+{TAB}")
        WinActivate($hGUI)
    EndIf
EndFunc

Func _OnTabRight()
    Local $hWnd = _GetSelectedBrowserWindow()
    If $hWnd Then 
        WinActivate($hWnd)
        ControlSend($hWnd, "", "", "^{TAB}")
        WinActivate($hGUI)
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
