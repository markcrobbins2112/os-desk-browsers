#include-once
; #include "db-hdrs.au3"
#include "db-globals.au3"
#include "db-gdi.au3"
#include "db-lib.au3"
; file: C:\_o\__\os-desk-browsers\db-engine.au3
; ==============================================================================
; CORE ENGINE FUNCTIONS (originally actions_engine.au3)
; ==============================================================================

; Handles Z-Order checking, selections, and updating frame locations
Func _HandleZOrderSelection()
    ; If the manager isn't open or visible, clear everything out safely
    If Not $bGUI_Visible Then
        _ClearOrangeBorder()
        Return
    EndIf
    
    ; 1. Grab the currently selected browser window from your ListView index pointer
    Local $hTargetWin = $hLastSelectedWin
    
    ; Fallback: If our register is empty, get whatever row the user has highlighted
    If Not $hTargetWin Or Not _WinAPI_IsWindow($hTargetWin) Then
        $hTargetWin = _GetSelectedBrowserWindow()
    EndIf
    
    ; 2. BULLETPROOF DRAW: If we have a valid visible window, keep drawing the border around it!
    If $hTargetWin <> 0 And _WinAPI_IsWindow($hTargetWin) Then
        Local $iState = WinGetState($hTargetWin)
        If BitAND($iState, 2) And Not BitAND($iState, 16) Then
            _DrawOrangeBorder($hTargetWin) ; Draw border smoothly via the main thread
        Else
            _ClearOrangeBorder()
        Endif
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
    Local $hWnd = $hLastSelectedWin
    If Not $hWnd Or Not _WinAPI_IsWindow($hWnd) Then $hWnd = _GetSelectedBrowserWindow()
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
        ; FIX: Swapped regex end-anchor from "$" to "\z" to ensure proper array parsing
        Local $aWinList = WinList("[REGEXPTITLE:(?i).*" & $aBrowsers[$i][1] & "\z]")
        $aLastCounts[$i] = $aWinList[0][0]
        
        Local $sStatus = "Not Running"
        If $aWinList[0][0] > 0 Then $sStatus = "Running"
        
        Local $sGridPos = "None"
        Local $iMinCount = 0
        If $aWinList[0][0] > 0 Then
            $sGridPos = _GetGridPosition($aWinList[1][1])
            
            ; FIX: Changed "$aWinList" to "$aWinList[0][0]" so the loop can safely terminate!
            For $j = 1 To $aWinList[0][0]
                If _IsWindowMinimized($aWinList[$j][1]) Then $iMinCount += 1
            Next
        EndIf
        
        Local $sMinText = "0"
        If $aWinList[0][0] > 0 Then $sMinText = String($iMinCount) & " / " & String($aWinList[0][0])
        
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
    Local $aWinList = WinList("[REGEXPTITLE:(?i).*" & $aBrowsers[$iIndex][1] & "\z]")
    ; FIX: Added [0][0] loop boundaries
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
    
    ; FIX: Change "$i = 1 To $aFullWinList" to strictly target the row count element!
    For $i = 1 To $aFullWinList[0][0]
        Local $hWnd = $aFullWinList[$i][1] ; FIX: Added index [1] to pull window handle
        If BitAND(WinGetState($hWnd), 2) And Not BitAND(WinGetState($hWnd), 16) Then
            Local $sTitle = $aFullWinList[$i][0] ; FIX: Added index [0] to pull window title
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

; file: C:\_o\__\os-desk-browsers\db-engine.au3
