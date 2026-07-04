#include-once
#include "db-globals.au3"
#include "db-lib.au3"
; file: C:\_o\__\os-desk-browsers\db-events.au3

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
            For $p = 9 To 1
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

Func _OnInsertPressed()
    Local $hWnd = $hLastSelectedWin
    If Not $hWnd Or Not _WinAPI_IsWindow($hWnd) Then $hWnd = _GetSelectedBrowserWindow()
    If $hWnd Then 
        Local $hActivePrev = WinGetHandle("[ACTIVE]")
        WinActivate($hWnd)
        Sleep(50)
        Send("^t")
        Sleep(50)
        If $hActivePrev Then WinActivate($hActivePrev)
        GUICtrlSetData($idStatus, "Created new tab on indicated window")
    EndIf
EndFunc

Func _OnMoveTabLeft()
    Local $hWnd = $hLastSelectedWin
    If Not $hWnd Or Not _WinAPI_IsWindow($hWnd) Then $hWnd = _GetSelectedBrowserWindow()
    If $hWnd Then 
        Local $hActivePrev = WinGetHandle("[ACTIVE]")
        WinActivate($hWnd)
        Sleep(50)
        Send("^+{PGUP}")
        Sleep(50)
        If $hActivePrev Then WinActivate($hActivePrev)
        GUICtrlSetData($idStatus, "Moved active tab left on indicated window")
    EndIf
EndFunc

Func _OnMoveTabRight()
    Local $hWnd = $hLastSelectedWin
    If Not $hWnd Or Not _WinAPI_IsWindow($hWnd) Then $hWnd = _GetSelectedBrowserWindow()
    If $hWnd Then 
        Local $hActivePrev = WinGetHandle("[ACTIVE]")
        WinActivate($hWnd)
        Sleep(50)
        Send("^+{PGDN}")
        Sleep(50)
        If $hActivePrev Then WinActivate($hActivePrev)
        GUICtrlSetData($idStatus, "Moved active tab right on indicated window")
    EndIf
EndFunc

Func _OnNewTabWithClipboard()
    Local $hWnd = $hLastSelectedWin
    If Not $hWnd Or Not _WinAPI_IsWindow($hWnd) Then $hWnd = _GetSelectedBrowserWindow()
    If $hWnd Then 
        Local $sUrl = ClipGet()
        If $sUrl <> "" Then
            Local $hActivePrev = WinGetHandle("[ACTIVE]")
            WinActivate($hWnd)
            Sleep(50)
            Send("^t")
            Sleep(150)
            Send("^v")
            Sleep(50)
            Send("{ENTER}")
            Sleep(50)
            If $hActivePrev Then WinActivate($hActivePrev)
            GUICtrlSetData($idStatus, "Opened clipboard URL in new tab")
        Else
            GUICtrlSetData($idStatus, "Clipboard is empty")
        EndIf
    EndIf
EndFunc

Func _OnNewWindowWithCurrentUrl()
    Local $hWnd = $hLastSelectedWin
    If Not $hWnd Or Not _WinAPI_IsWindow($hWnd) Then $hWnd = _GetSelectedBrowserWindow()
    If $hWnd Then
        Local $sOldClip = ClipGet()
        ClipPut("")
        Local $hActivePrev = WinGetHandle("[ACTIVE]")
        WinActivate($hWnd)
        Sleep(50)
        Send("^l")
        Sleep(100)
        Send("^c")
        Sleep(150)
        Local $sUrl = ClipGet()
        If $sUrl <> "" Then
            Send("^n")
            Sleep(250)
            Send("^v")
            Sleep(50)
            Send("{ENTER}")
            Sleep(50)
        Else
            Send("^n")
            Sleep(50)
        EndIf
        If $hActivePrev Then WinActivate($hActivePrev)
        GUICtrlSetData($idStatus, "Created new window with current URL")
    EndIf
EndFunc

Func _OnHelpPressed()
    _ShowHelp()
EndFunc

Func _OnNewTabAtGridHotkey()
    Local $idPressed = @GUI_CtrlId
    Local $iTargetPos = -1
    If $idPressed = $aDummyGridNewTab[0] Then
        $iTargetPos = 0
    Else
        For $i = 1 To 9
            If $idPressed = $aDummyGridNewTab[$i] Then
                $iTargetPos = $i
                ExitLoop
            Endif
        Next
    Endif
    If $iTargetPos = -1 Then Return
    
    Local $hCurrentWin = $hLastSelectedWin
    If Not $hCurrentWin Or Not _WinAPI_IsWindow($hCurrentWin) Then $hCurrentWin = _GetSelectedBrowserWindow()
    If Not $hCurrentWin Then
        GUICtrlSetData($idStatus, "No current browser window to copy URL from")
        Return
    EndIf
    
    Local $hTargetWin = _GetWindowAtGridPosition($iTargetPos)
    If Not $hTargetWin Or Not _WinAPI_IsWindow($hTargetWin) Then
        GUICtrlSetData($idStatus, "No browser window at grid position " & $iTargetPos)
        Return
    EndIf
    
    If $hCurrentWin = $hTargetWin Then
        GUICtrlSetData($idStatus, "Target and current windows are the same")
        Return
    EndIf
    
    Local $sOldClip = ClipGet()
    ClipPut("")
    Local $hActivePrev = WinGetHandle("[ACTIVE]")
    WinActivate($hCurrentWin)
    Sleep(50)
    Send("^l")
    Sleep(100)
    Send("^c")
    Sleep(150)
    Local $sUrl = ClipGet()
    
    If $sUrl <> "" Then
        WinActivate($hTargetWin)
        Sleep(50)
        Send("^t")
        Sleep(150)
        Send("^v")
        Sleep(50)
        Send("{ENTER}")
        Sleep(50)
        GUICtrlSetData($idStatus, "Opened new tab at grid " & $iTargetPos & " with current URL")
    Else
        GUICtrlSetData($idStatus, "Failed to copy URL from current window")
        ClipPut($sOldClip)
    EndIf
    
    If $hActivePrev Then WinActivate($hActivePrev)
EndFunc

Func _OnTabLeft()
    Local $hWnd = $hLastSelectedWin
    If Not $hWnd Or Not _WinAPI_IsWindow($hWnd) Then $hWnd = _GetSelectedBrowserWindow()
    If $hWnd Then 
        Local $hActivePrev = WinGetHandle("[ACTIVE]")
        WinActivate($hWnd)
        Sleep(50)
        Send("^{PGUP}")
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
        Send("^{PGDN}")
        Sleep(50)
        If $hActivePrev Then WinActivate($hActivePrev)
        GUICtrlSetData($idStatus, "Switched to next tab on indicated window")
    EndIf
EndFunc

Func _OnIndicateLeft()
    _IndicateDirection("Left")
EndFunc

Func _OnIndicateRight()
    _IndicateDirection("Right")
EndFunc

Func _OnIndicateUp()
    _IndicateDirection("Up")
EndFunc

Func _OnIndicateDown()
    _IndicateDirection("Down")
EndFunc

Func _OnZoomIn()
    _SendKeysToIndicated("^=", "Zoomed in indicated browser window")
EndFunc

Func _OnZoomOut()
    _SendKeysToIndicated("^-", "Zoomed out indicated browser window")
EndFunc

Func _OnBack()
    _SendKeysToIndicated("!{LEFT}", "Navigated back on indicated browser window")
EndFunc

Func _OnForward()
    _SendKeysToIndicated("!{RIGHT}", "Navigated forward on indicated browser window")
EndFunc

Func _OnCommonKey()
    Local $idPressed = @GUI_CtrlId
    Local $sKeyToSend = ""
    For $i = 0 To 31
        If $idPressed = $aCommonKeys[$i][0] Then
            $sKeyToSend = $aCommonKeys[$i][1]
            ExitLoop
        EndIf
    Next
    If $sKeyToSend = "" Then Return
    
    Local $hWnd = $hLastSelectedWin
    If Not $hWnd Or Not _WinAPI_IsWindow($hWnd) Then $hWnd = _GetSelectedBrowserWindow()
    If Not $hWnd Then Return
    
    Local $hActivePrev = WinGetHandle("[ACTIVE]")
    WinActivate($hWnd)
    Sleep(50)
    Send($sKeyToSend)
    Sleep(50)
    If $hActivePrev Then WinActivate($hActivePrev)
    GUICtrlSetData($idStatus, "Forwarded common browser key: " & $sKeyToSend)
EndFunc

Func _OnIndicatePrevInList()
    Local $iSelected = _GUICtrlListView_GetSelectedIndices($idListview)
    Local $iIdx = 0
    If $iSelected <> "" Then
        $iIdx = Int($iSelected) - 1
        If $iIdx < 0 Then $iIdx = $iBrowserCount - 1
    Else
        $iIdx = $iBrowserCount - 1
    EndIf
    _GUICtrlListView_SetItemSelected($idListview, $iIdx, True, True)
    _GUICtrlListView_EnsureVisible($idListview, $iIdx)
    ControlFocus($hGUI, "", $idListview)
    Local $hWnd = _GetSelectedBrowserWindow()
    If $hWnd Then
        _IndicateBrowserWindow($hWnd, "Indicated " & $aBrowsers[$iIdx][0])
    Else
        _ClearOrangeBorder()
        GUICtrlSetData($idStatus, "Selected " & $aBrowsers[$iIdx][0] & " (no running window)")
    EndIf
EndFunc

Func _OnIndicateNextInList()
    Local $iSelected = _GUICtrlListView_GetSelectedIndices($idListview)
    Local $iIdx = 0
    If $iSelected <> "" Then
        $iIdx = Int($iSelected) + 1
        If $iIdx >= $iBrowserCount Then $iIdx = 0
    Else
        $iIdx = 0
    EndIf
    _GUICtrlListView_SetItemSelected($idListview, $iIdx, True, True)
    _GUICtrlListView_EnsureVisible($idListview, $iIdx)
    ControlFocus($hGUI, "", $idListview)
    Local $hWnd = _GetSelectedBrowserWindow()
    If $hWnd Then
        _IndicateBrowserWindow($hWnd, "Indicated " & $aBrowsers[$iIdx][0])
    Else
        _ClearOrangeBorder()
        GUICtrlSetData($idStatus, "Selected " & $aBrowsers[$iIdx][0] & " (no running window)")
    EndIf
EndFunc

Func _OnCascadeIndicatedType()
    Local $iSelected = _GUICtrlListView_GetSelectedIndices($idListview)
    If $iSelected = "" Then Return
    Local $iIdx = Int($iSelected)
    Local $aWinList = WinList("[REGEXPTITLE:(?i).*" & $aBrowsers[$iIdx][1] & "$]")
    Local $iCount = 0
    Local $iW = Int(@DesktopWidth * 0.6)
    Local $iH = Int(@DesktopHeight * 0.6)
    Local $iX = 50, $iY = 50
    For $i = $aWinList[0][0] To 1 Step -1
        Local $hWnd = $aWinList[$i][1]
        If BitAND(WinGetState($hWnd), 2) And Not BitAND(WinGetState($hWnd), 16) Then
            WinMove($hWnd, "", $iX, $iY, $iW, $iH)
            _WinAPI_SetWindowPos($hWnd, 0, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE))
            $iX += 30
            $iY += 30
            $iCount += 1
        EndIf
    Next
    If $iCount > 0 Then
        GUICtrlSetData($idStatus, "Cascaded " & $iCount & " windows of " & $aBrowsers[$iIdx][0])
        _PopulateList($aIconIndices)
    Else
        GUICtrlSetData($idStatus, "No running windows to cascade")
    EndIf
EndFunc

Func _OnSplitAllTabs()
    Local $hWnd = $hLastSelectedWin
    If Not $hWnd Or Not _WinAPI_IsWindow($hWnd) Then $hWnd = _GetSelectedBrowserWindow()
    If Not $hWnd Then
        GUICtrlSetData($idStatus, "No active/indicated browser window to split")
        Return
    EndIf
    
    Local $hActivePrev = WinGetHandle("[ACTIVE]")
    WinActivate($hWnd)
    Sleep(100)
    
    Local $aUrls[20]
    Local $iUrlCount = 0
    Local $sOldClip = ClipGet()
    
    For $i = 1 To 15
        ClipPut("")
        Send("^l")
        Sleep(80)
        Send("^c")
        Sleep(120)
        Local $sUrl = ClipGet()
        If $sUrl = "" Then ExitLoop
        
        Local $bDup = False
        For $u = 0 To $iUrlCount - 1
            If $aUrls[$u] = $sUrl Then
                $bDup = True
                ExitLoop
            EndIf
        Next
        If $bDup Then ExitLoop
        
        $aUrls[$iUrlCount] = $sUrl
        $iUrlCount += 1
        If $iUrlCount >= 20 Then ExitLoop
        
        Send("^{PGDN}")
        Sleep(100)
    Next
    
    If $iUrlCount <= 1 Then
        GUICtrlSetData($idStatus, "Only 1 tab or failed to detect multiple tabs")
        ClipPut($sOldClip)
        If $hActivePrev Then WinActivate($hActivePrev)
        Return
    EndIf
    
    WinClose($hWnd)
    Sleep(300)
    
    Local $iSelected = _GUICtrlListView_GetSelectedIndices($idListview)
    Local $iIdx = ($iSelected <> "") ? Int($iSelected) : 0
    Local $sPath = $aBrowsers[$iIdx][2]
    If FileExists($sPath) Then
        For $u = 0 To $iUrlCount - 1
            Local $sTargetUrl = $aUrls[$u]
            Run('"' & $sPath & '" "' & $sTargetUrl & '"')
            Sleep(400)
        Next
    EndIf
    
    ClipPut($sOldClip)
    If $hActivePrev Then WinActivate($hActivePrev)
    GUICtrlSetData($idStatus, "Split " & $iUrlCount & " tabs into separate windows")
    _PopulateList($aIconIndices)
EndFunc

Func _OnGatherAllTabs()
    Local $iSelected = _GUICtrlListView_GetSelectedIndices($idListview)
    If $iSelected = "" Then Return
    Local $iIdx = Int($iSelected)
    Local $sSuffix = $aBrowsers[$iIdx][1]
    Local $sPath = $aBrowsers[$iIdx][2]
    
    Local $aWinList = WinList("[REGEXPTITLE:(?i).*" & $sSuffix & "$]")
    Local $aUrls[50]
    Local $iUrlCount = 0
    Local $sOldClip = ClipGet()
    
    For $i = 1 To $aWinList[0][0]
        Local $hWnd = $aWinList[$i][1]
        If BitAND(WinGetState($hWnd), 2) And Not BitAND(WinGetState($hWnd), 16) Then
            WinActivate($hWnd)
            Sleep(100)
            ClipPut("")
            Send("^l")
            Sleep(80)
            Send("^c")
            Sleep(120)
            Local $sUrl = ClipGet()
            If $sUrl <> "" Then
                $aUrls[$iUrlCount] = $sUrl
                $iUrlCount += 1
            EndIf
            WinClose($hWnd)
            Sleep(150)
        EndIf
    Next
    
    If $iUrlCount = 0 Then
        GUICtrlSetData($idStatus, "No active browser windows of this type found")
        ClipPut($sOldClip)
        WinActivate($hGUI)
        Return
    EndIf
    
    If FileExists($sPath) Then
        Run('"' & $sPath & '" "' & $aUrls[0] & '"')
        Sleep(1200)
        
        Local $hNewWin = _GetSelectedBrowserWindow()
        If $hNewWin Then
            WinActivate($hNewWin)
            Sleep(200)
            For $u = 1 To $iUrlCount - 1
                Send("^t")
                Sleep(150)
                ClipPut($aUrls[$u])
                Send("^v")
                Sleep(80)
                Send("{ENTER}")
                Sleep(150)
            Next
        EndIf
    EndIf
    
    ClipPut($sOldClip)
    WinActivate($hGUI)
    GUICtrlSetData($idStatus, "Gathered " & $iUrlCount & " windows into one window")
    _PopulateList($aIconIndices)
EndFunc

Func _OnCopyUrlAndCloseTab()
    Local $hWnd = $hLastSelectedWin
    If Not $hWnd Or Not _WinAPI_IsWindow($hWnd) Then $hWnd = _GetSelectedBrowserWindow()
    If Not $hWnd Then Return
    
    Local $sOldClip = ClipGet()
    ClipPut("")
    Local $hActivePrev = WinGetHandle("[ACTIVE]")
    WinActivate($hWnd)
    Sleep(100)
    Send("^l")
    Sleep(100)
    Send("^c")
    Sleep(150)
    Local $sUrl = ClipGet()
    
    If $sUrl <> "" Then
        Send("^w")
        Sleep(50)
        GUICtrlSetData($idStatus, "Copied URL and closed tab: " & $sUrl)
    Else
        ClipPut($sOldClip)
        GUICtrlSetData($idStatus, "Failed to copy URL")
    EndIf
    
    If $hActivePrev Then WinActivate($hActivePrev)
EndFunc

Func _OnNewTabInBrowserType()
    Local $idPressed = @GUI_CtrlId
    Local $iTargetIdx = -1
    For $i = 0 To $iBrowserCount - 1
        If $idPressed = $aDummyNewTabInBrowser[$i] Then
            $iTargetIdx = $i
            ExitLoop
        EndIf
    Next
    If $iTargetIdx = -1 Then Return
    
    Local $hCurrentWin = $hLastSelectedWin
    If Not $hCurrentWin Or Not _WinAPI_IsWindow($hCurrentWin) Then $hCurrentWin = _GetSelectedBrowserWindow()
    If Not $hCurrentWin Then
        GUICtrlSetData($idStatus, "No current browser window to copy URL from")
        Return
    EndIf
    
    Local $sOldClip = ClipGet()
    ClipPut("")
    Local $hActivePrev = WinGetHandle("[ACTIVE]")
    WinActivate($hCurrentWin)
    Sleep(50)
    Send("^l")
    Sleep(100)
    Send("^c")
    Sleep(150)
    Local $sUrl = ClipGet()
    
    If $sUrl <> "" Then
        Local $sSuffix = $aBrowsers[$iTargetIdx][1]
        Local $sPath = $aBrowsers[$iTargetIdx][2]
        Local $aWinList = WinList("[REGEXPTITLE:(?i).*" & $sSuffix & "$]")
        Local $hTargetWin = 0
        For $w = 1 To $aWinList[0][0]
            If BitAND(WinGetState($aWinList[$w][1]), 2) Then
                $hTargetWin = $aWinList[$w][1]
                ExitLoop
            EndIf
        Next
        
        If $hTargetWin <> 0 Then
            WinActivate($hTargetWin)
            Sleep(50)
            Send("^t")
            Sleep(150)
            ClipPut($sUrl)
            Send("^v")
            Sleep(50)
            Send("{ENTER}")
            Sleep(50)
            GUICtrlSetData($idStatus, "Opened URL in existing " & $aBrowsers[$iTargetIdx][0] & " window")
        Else
            If FileExists($sPath) Then
                Run('"' & $sPath & '" "' & $sUrl & '"')
                Sleep(400)
                GUICtrlSetData($idStatus, "Launched " & $aBrowsers[$iTargetIdx][0] & " with URL")
            EndIf
        EndIf
    Else
        ClipPut($sOldClip)
        GUICtrlSetData($idStatus, "Failed to copy URL from current window")
    EndIf
    
    If $hActivePrev Then WinActivate($hActivePrev)
    _PopulateList($aIconIndices)
EndFunc

Func _OnIndicatedToBackType()
    Local $hWnd = $hLastSelectedWin
    If Not $hWnd Or Not _WinAPI_IsWindow($hWnd) Then $hWnd = _GetSelectedBrowserWindow()
    If Not $hWnd Then Return
    
    Local $sTitle = WinGetTitle($hWnd)
    Local $iMatchIdx = -1
    For $b = 0 To $iBrowserCount - 1
        If StringInStr($sTitle, $aBrowsers[$b][1]) Then
            $iMatchIdx = $b
            ExitLoop
        EndIf
    Next
    If $iMatchIdx = -1 Then Return
    
    Local $sSuffix = $aBrowsers[$iMatchIdx][1]
    Local $aWinList = WinList("[REGEXPTITLE:(?i).*" & $sSuffix & "$]")
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
        Local $hDeepest = $aVisibleWins[$iCount - 1]
        
        _WinAPI_SetWindowPos($hCurrentTop, $hDeepest, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOACTIVATE))
        
        Local $hNewTop = $aVisibleWins[1]
        _IndicateBrowserWindow($hNewTop, "Sent window to back of stack, indicated next of type")
    EndIf
EndFunc

Func _OnDeepestToTopType()
    Local $iSelected = _GUICtrlListView_GetSelectedIndices($idListview)
    If $iSelected = "" Then Return
    Local $iIdx = Int($iSelected)
    Local $sSuffix = $aBrowsers[$iIdx][1]
    Local $aWinList = WinList("[REGEXPTITLE:(?i).*" & $sSuffix & "$]")
    Local $aVisibleWins[100]
    Local $iCount = 0
    For $i = 1 To $aWinList[0][0]
        If BitAND(WinGetState($aWinList[$i][1]), 2) And Not BitAND(WinGetState($aWinList[$i][1]), 16) Then
            $aVisibleWins[$iCount] = $aWinList[$i][1]
            $iCount += 1
        EndIf
    Next
    
    If $iCount > 0 Then
        Local $hDeepest = $aVisibleWins[$iCount - 1]
        _WinAPI_SetWindowPos($hDeepest, 0, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE))
        _IndicateBrowserWindow($hDeepest, "Brought deepest " & $aBrowsers[$iIdx][0] & " window to top")
    EndIf
EndFunc

Func _OnPrevSiblingOfType()
    Local $hWnd = $hLastSelectedWin
    If Not $hWnd Or Not _WinAPI_IsWindow($hWnd) Then $hWnd = _GetSelectedBrowserWindow()
    If Not $hWnd Then Return
    
    Local $sTitle = WinGetTitle($hWnd)
    Local $iMatchIdx = -1
    For $b = 0 To $iBrowserCount - 1
        If StringInStr($sTitle, $aBrowsers[$b][1]) Then
            $iMatchIdx = $b
            ExitLoop
        EndIf
    Next
    If $iMatchIdx = -1 Then Return
    
    Local $sSuffix = $aBrowsers[$iMatchIdx][1]
    Local $aWinList = WinList("[REGEXPTITLE:(?i).*" & $sSuffix & "$]")
    Local $aVisibleWins[100]
    Local $iCount = 0
    Local $iCurrentIdx = -1
    For $i = 1 To $aWinList[0][0]
        Local $hW = $aWinList[$i][1]
        If BitAND(WinGetState($hW), 2) And Not BitAND(WinGetState($hW), 16) Then
            $aVisibleWins[$iCount] = $hW
            If $hW = $hWnd Then $iCurrentIdx = $iCount
            $iCount += 1
        EndIf
    Next
    
    If $iCount > 1 And $iCurrentIdx <> -1 Then
        Local $iTarget = $iCurrentIdx - 1
        If $iTarget < 0 Then $iTarget = $iCount - 1
        Local $hTargetWin = $aVisibleWins[$iTarget]
        _IndicateBrowserWindow($hTargetWin, "Indicated previous sibling window of " & $aBrowsers[$iMatchIdx][0])
    EndIf
EndFunc

Func _OnNextSiblingOfType()
    Local $hWnd = $hLastSelectedWin
    If Not $hWnd Or Not _WinAPI_IsWindow($hWnd) Then $hWnd = _GetSelectedBrowserWindow()
    If Not $hWnd Then Return
    
    Local $sTitle = WinGetTitle($hWnd)
    Local $iMatchIdx = -1
    For $b = 0 To $iBrowserCount - 1
        If StringInStr($sTitle, $aBrowsers[$b][1]) Then
            $iMatchIdx = $b
            ExitLoop
        EndIf
    Next
    If $iMatchIdx = -1 Then Return
    
    Local $sSuffix = $aBrowsers[$iMatchIdx][1]
    Local $aWinList = WinList("[REGEXPTITLE:(?i).*" & $sSuffix & "$]")
    Local $aVisibleWins[100]
    Local $iCount = 0
    Local $iCurrentIdx = -1
    For $i = 1 To $aWinList[0][0]
        Local $hW = $aWinList[$i][1]
        If BitAND(WinGetState($hW), 2) And Not BitAND(WinGetState($hW), 16) Then
            $aVisibleWins[$iCount] = $hW
            If $hW = $hWnd Then $iCurrentIdx = $iCount
            $iCount += 1
        EndIf
    Next
    
    If $iCount > 1 And $iCurrentIdx <> -1 Then
        Local $iTarget = $iCurrentIdx + 1
        If $iTarget >= $iCount Then $iTarget = 0
        Local $hTargetWin = $aVisibleWins[$iTarget]
        _IndicateBrowserWindow($hTargetWin, "Indicated next sibling window of " & $aBrowsers[$iMatchIdx][0])
    EndIf
EndFunc

Func _OnAltDownPressed()
    Local $hWnd = $hLastSelectedWin
    If Not $hWnd Or Not _WinAPI_IsWindow($hWnd) Then $hWnd = _GetSelectedBrowserWindow()
    If $hWnd Then
        WinSetState($hWnd, "", @SW_MINIMIZE)
        GUICtrlSetData($idStatus, "Minimized indicated browser window")
        WinActivate($hGUI)
        ControlFocus($hGUI, "", $idListview)
    EndIf
EndFunc

Func _OnAltUpPressed()
    Local $hWnd = $hLastSelectedWin
    If Not $hWnd Or Not _WinAPI_IsWindow($hWnd) Then $hWnd = _GetSelectedBrowserWindow()
    If $hWnd Then
        WinSetState($hWnd, "", @SW_RESTORE)
        _WinAPI_SetWindowPos($hWnd, 0, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE))
        _IndicateBrowserWindow($hWnd, "Restored indicated browser window")
    EndIf
EndFunc

Func _OnIndicateLastOnGrid()
    For $p = 9 To 1 Step -1
        Local $hWnd = _GetWindowAtGridPosition($p)
        If $hWnd <> 0 Then
            _IndicateBrowserWindow($hWnd, "Indicated last window on grid (position " & $p & ")")
            Return
        EndIf
    Next
    Local $hWndCenter = _GetWindowAtGridPosition(0)
    If $hWndCenter <> 0 Then
        _IndicateBrowserWindow($hWndCenter, "Indicated center window on grid")
        Return
    EndIf
    GUICtrlSetData($idStatus, "No windows found on grid")
EndFunc

Func _OnIndicateFirstOnGrid()
    Local $hWndCenter = _GetWindowAtGridPosition(0)
    If $hWndCenter <> 0 Then
        _IndicateBrowserWindow($hWndCenter, "Indicated center window on grid")
        Return
    EndIf
    For $p = 1 To 9
        Local $hWnd = _GetWindowAtGridPosition($p)
        If $hWnd <> 0 Then
            _IndicateBrowserWindow($hWnd, "Indicated first window on grid (position " & $p & ")")
            Return
        EndIf
    Next
    GUICtrlSetData($idStatus, "No windows found on grid")
EndFunc

Func _OnCloseGridHotkey()
    Local $idPressed = @GUI_CtrlId
    Local $iTargetPos = -1
    For $i = 0 To 9
        If $idPressed = $aDummyCloseGrid[$i] Then
            $iTargetPos = $i
            ExitLoop
        EndIf
    Next
    If $iTargetPos = -1 Then Return
    
    Local $hWnd = _GetWindowAtGridPosition($iTargetPos)
    If $hWnd <> 0 Then
        WinClose($hWnd)
        GUICtrlSetData($idStatus, "Closed window at grid position " & $iTargetPos)
        _PopulateList($aIconIndices)
    Else
        GUICtrlSetData($idStatus, "No window at grid position " & $iTargetPos)
    EndIf
EndFunc

Func _OnIndicateGridHotkey()
    Local $idPressed = @GUI_CtrlId
    Local $iTargetPos = -1
    For $i = 0 To 9
        If $idPressed = $aDummyIndicateGrid[$i] Then
            $iTargetPos = $i
            ExitLoop
        EndIf
    Next
    If $iTargetPos = -1 Then Return
    
    Local $hWnd = _GetWindowAtGridPosition($iTargetPos)
    If $hWnd <> 0 Then
        _IndicateBrowserWindow($hWnd, "Indicated window at grid position " & $iTargetPos)
    Else
        GUICtrlSetData($idStatus, "No window at grid position " & $iTargetPos)
    EndIf
EndFunc

; file: C:\_o\__\os-desk-browsers\db-events.au3