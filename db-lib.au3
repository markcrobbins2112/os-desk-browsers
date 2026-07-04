#include-once
; file: C:\_o\__\os-desk-browsers\db-lib.au3
#include "db-globals.au3"
#include "db-engine.au3"
#include "db-gdi.au3"

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

Func _ShowHelp()
    If WinExists($hHelpGUI) Then
        WinActivate($hHelpGUI)
        Return
    EndIf
    
    ; Create a standard, fully visible dialog frame centered on desktop
    ; Width: 610, Height: 896 (60% taller than 560)
    ; 0x00C00000 is $WS_CAPTION, 0x00080000 is $WS_SYSMENU
    $hHelpGUI = GUICreate("Help / Shortcut Guide", 610, 896, -1, -1, BitOR(0x00C00000, 0x00080000), -1, $hGUI)
    GUISetBkColor(0x1E1E1E, $hHelpGUI)
    
    ; Create embedded browser control
    Local $oIE = ObjCreate("Shell.Explorer.2")
    If Not IsObj($oIE) Then
        MsgBox(16, "Error", "Failed to create Internet Explorer object for Web Help.")
        Return
    EndIf
    
    Local $idIE_Ctrl = GUICtrlCreateObj($oIE, 5, 5, 600, 830)
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
        "                <td class='shortcut-key'><kbd>B</kbd> / <kbd>C</kbd> / <kbd>E</kbd> / <kbd>V</kbd> / <kbd>F</kbd> / <kbd>O</kbd> / <kbd>P</kbd></td>" & _
        "                <td class='shortcut-desc'>Activate or Launch browser (Opera is O)</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Ctrl</kbd> + <kbd>BCEVFOP</kbd></td>" & _
        "                <td class='shortcut-desc'>Close nearest browser window of type</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Alt</kbd> + <kbd>BCEVFOP</kbd></td>" & _
        "                <td class='shortcut-desc'>Indicate/focus browser window of type</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Shift</kbd> + <kbd>BCEVFOP</kbd></td>" & _
        "                <td class='shortcut-desc'>New tab in browser type with current URL</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Enter</kbd></td>" & _
        "                <td class='shortcut-desc'>Activate or launch indicated browser</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Esc</kbd></td>" & _
        "                <td class='shortcut-desc'>Minimize Manager to tray / Close Help</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Ctrl</kbd> + <kbd>C</kbd> / <kbd>Insert</kbd></td>" & _
        "                <td class='shortcut-desc'>Copy URL of indicated window</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Ctrl</kbd> + <kbd>V</kbd> / <kbd>Shift</kbd> + <kbd>Insert</kbd></td>" & _
        "                <td class='shortcut-desc'>New tab in indicated with clipboard</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Ctrl</kbd> + <kbd>X</kbd> / <kbd>Shift</kbd> + <kbd>Delete</kbd></td>" & _
        "                <td class='shortcut-desc'>Copy URL of indicated and close tab</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Ctrl</kbd> + <kbd>&larr;</kbd>/<kbd>&rarr;</kbd>/<kbd>&uarr;</kbd>/<kbd>&darr;</kbd></td>" & _
        "                <td class='shortcut-desc'>Indicate browser window in direction</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>&larr;</kbd>/<kbd>&rarr;</kbd>/<kbd>&uarr;</kbd>/<kbd>&darr;</kbd></td>" & _
        "                <td class='shortcut-desc'>Select browser relative to current (wraps)</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Alt</kbd> + <kbd>&uarr;</kbd> / <kbd>&darr;</kbd></td>" & _
        "                <td class='shortcut-desc'>Restore / Minimize indicated window</td>" & _
        "            </tr>" & _
        "        </table>" & _
        "    </div>" & _
        "    " & _
        "    <div class='section'>" & _
        "        <div class='section-title'>List, Tab & Stack Actions</div>" & _
        "        <table class='shortcut-table'>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>[</kbd> / <kbd>]</kbd></td>" & _
        "                <td class='shortcut-desc'>Indicate previous / next browser in list (wraps)</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>\</kbd></td>" & _
        "                <td class='shortcut-desc'>Cascade all windows of indicated type</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Ctrl</kbd> + <kbd>\</kbd></td>" & _
        "                <td class='shortcut-desc'>Split all tabs to new windows</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Shift</kbd> + <kbd>\</kbd></td>" & _
        "                <td class='shortcut-desc'>Gather all windows of type tabs to one window</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Alt</kbd> + <kbd>PageUp</kbd></td>" & _
        "                <td class='shortcut-desc'>Indicated to back of stack, indicate top of type</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Alt</kbd> + <kbd>PageDown</kbd></td>" & _
        "                <td class='shortcut-desc'>Indicate and bring deepest window to top</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Shift</kbd> + <kbd>PageUp/Dn</kbd></td>" & _
        "                <td class='shortcut-desc'>Indicate previous / next sibling of type</td>" & _
        "            </tr>" & _
        "        </table>" & _
        "    </div>" & _
        "    " & _
        "    <div class='section'>" & _
        "        <div class='section-title'>Desktop Grid Controls</div>" & _
        "        <table class='shortcut-table'>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>0-9</kbd></td>" & _
        "                <td class='shortcut-desc'>Select browser on grid (0 is Center)</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Shift</kbd> + <kbd>0-9</kbd></td>" & _
        "                <td class='shortcut-desc'>Place selected browser on grid position</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Ctrl</kbd> + <kbd>0-9</kbd></td>" & _
        "                <td class='shortcut-desc'>Close browser window on grid position</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Alt</kbd> + <kbd>0-9</kbd></td>" & _
        "                <td class='shortcut-desc'>Indicate window on grid position</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>0-9</kbd></td>" & _
        "                <td class='shortcut-desc'>Open new tab at grid position with current URL</td>" & _
        "            </tr>" & _
        "            <tr class='shortcut-row'>" & _
        "                <td class='shortcut-key'><kbd>Alt</kbd> + <kbd>Home/End</kbd></td>" & _
        "                <td class='shortcut-desc'>Indicate first / last window on grid</td>" & _
        "            </tr>" & _
        "        </table>" & _
        "    </div>" & _
        "</body>" & _
        "</html>"
    
    $oIE.document.write($sHTML)
    $oIE.document.body.style.border = "none"
    
    ; Native styled close button at the bottom
    Local $idCloseBtn = GUICtrlCreateButton("Close Help Guide", 205, 850, 200, 32)
    GUICtrlSetBkColor($idCloseBtn, 0x1E1E1E) ; Dark slate button background
    GUICtrlSetColor($idCloseBtn, 0xFFFFFF)
    GUICtrlSetFont($idCloseBtn, 10, 600, 0, "Segoe UI")
    
    ; Setup events for Help GUI
    GUISetOnEvent(-3, "_HelpGUI_Close", $hHelpGUI) ; -3 is $GUI_EVENT_CLOSE
    GUICtrlSetOnEvent($idCloseBtn, "_HelpGUI_Close")
    
    Local $aHelpAccel[1][2] = [["{ESC}", $idCloseBtn]]
    GUISetAccelerators($aHelpAccel, $hHelpGUI)
    
    GUISetState(@SW_SHOW, $hHelpGUI)
EndFunc

Func _HelpGUI_Close()
    GUIDelete($hHelpGUI)
    $hHelpGUI = 0
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
    MsgBox(0,"Exit","Exit")
    If $hLastSelectedWin <> 0 And _WinAPI_IsWindow($hLastSelectedWin) Then
        _WinAPI_SetWindowPos($hLastSelectedWin, $hLastPrevWin, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOACTIVATE))
    EndIf
    _ClearOrangeBorder()
    Exit
EndFunc

Func _IndicateDirection($sDir)
    Local $hWnd = $hLastSelectedWin
    If Not $hWnd Or Not _WinAPI_IsWindow($hWnd) Then $hWnd = _GetSelectedBrowserWindow()
    If Not $hWnd Then
        GUICtrlSetData($idStatus, "No active/indicated browser window to navigate from")
        Return
    EndIf
    
    Local $hTarget = _GetNeighborWindow($hWnd, $sDir)
    If $hTarget <> 0 Then
        _IndicateBrowserWindow($hTarget, "Indicated browser window to the " & $sDir)
    Else
        GUICtrlSetData($idStatus, "No browser window found to the " & $sDir)
    EndIf
EndFunc

Func _IndicateBrowserWindow($hWnd, $sMsg)
    If Not $hWnd Or Not _WinAPI_IsWindow($hWnd) Then Return
    Local $sTitle = WinGetTitle($hWnd)
    Local $iMatchIdx = -1
    For $b = 0 To $iBrowserCount - 1
        If StringInStr($sTitle, $aBrowsers[$b][1]) Then
            $iMatchIdx = $b
            ExitLoop
        EndIf
    Next
    
    _WinAPI_SetWindowPos($hWnd, 0, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE)) ; HWND_TOP = 0
    If $bGUI_Visible Then
        WinActivate($hGUI)
    EndIf
    
    If $iMatchIdx <> -1 Then
        _GUICtrlListView_SetItemSelected($idListview, $iMatchIdx, True, True)
        _GUICtrlListView_EnsureVisible($idListview, $iMatchIdx)
        ControlFocus($hGUI, "", $idListview)
    EndIf
    
    _DrawOrangeBorder($hWnd)
    If $sMsg <> "" Then GUICtrlSetData($idStatus, $sMsg)
EndFunc

Func _GetNeighborWindow($hWnd, $sDir)
    Local $sPos = _GetGridPosition($hWnd)
    If $sPos = "None" Then
        Return _GetClosestWindowInDirection($hWnd, $sDir)
    EndIf
    
    Local $iPos = Int($sPos)
    Local $iTargetPos = -1
    
    If $iPos = 0 Then ; Center window
        If $sDir = "Left" Then $iTargetPos = 4
        If $sDir = "Right" Then $iTargetPos = 6
        If $sDir = "Up" Then $iTargetPos = 2
        If $sDir = "Down" Then $iTargetPos = 8
        
        Local $hTarget = _GetWindowAtGridPosition($iTargetPos)
        If $hTarget <> 0 Then Return $hTarget
        Return _GetClosestWindowInDirection($hWnd, $sDir)
    EndIf
    
    ; 1-9 grid navigation
    Local $iCol = Mod($iPos - 1, 3)
    Local $iRow = Int(($iPos - 1) / 3)
    
    Local $iStepCol = 0, $iStepRow = 0
    If $sDir = "Left" Then $iStepCol = -1
    If $sDir = "Right" Then $iStepCol = 1
    If $sDir = "Up" Then $iStepRow = -1
    If $sDir = "Down" Then $iStepRow = 1
    
    For $step = 1 To 2
        Local $nCol = Mod($iCol + $iStepCol * $step + 6, 3)
        Local $nRow = Mod($iRow + $iStepRow * $step + 6, 3)
        Local $nPos = $nRow * 3 + $nCol + 1
        Local $hTarget = _GetWindowAtGridPosition($nPos)
        If $hTarget <> 0 Then Return $hTarget
    Next
    
    Return _GetClosestWindowInDirection($hWnd, $sDir)
EndFunc

Func _GetClosestWindowInDirection($hWndSource, $sDir)
    Local $aPosSource = WinGetPos($hWndSource)
    If Not IsArray($aPosSource) Then Return 0
    Local $cX0 = $aPosSource[0] + Int($aPosSource[2] / 2)
    Local $cY0 = $aPosSource[1] + Int($aPosSource[3] / 2)
    
    Local $aWins = _GetAllVisibleBrowserWindows()
    Local $hBestWin = 0
    Local $iBestDist = 9999999
    Local $iPenalty = 2
    
    For $i = 0 To UBound($aWins) - 1
        Local $hWnd = $aWins[$i]
        If $hWnd = $hWndSource Then ContinueLoop
        
        Local $aPos = WinGetPos($hWnd)
        If Not IsArray($aPos) Then ContinueLoop
        Local $cX = $aPos[0] + Int($aPos[2] / 2)
        Local $cY = $aPos[1] + Int($aPos[3] / 2)
        
        Local $iDist = 0
        Local $bValid = False
        
        If $sDir = "Left" Then
            If $cX < $cX0 - 10 Then
                $iDist = ($cX0 - $cX) + $iPenalty * Abs($cY0 - $cY)
                $bValid = True
            EndIf
        ElseIf $sDir = "Right" Then
            If $cX > $cX0 + 10 Then
                $iDist = ($cX - $cX0) + $iPenalty * Abs($cY0 - $cY)
                $bValid = True
            EndIf
        ElseIf $sDir = "Up" Then
            If $cY < $cY0 - 10 Then
                $iDist = ($cY0 - $cY) + $iPenalty * Abs($cX0 - $cX)
                $bValid = True
            EndIf
        ElseIf $sDir = "Down" Then
            If $cY > $cY0 + 10 Then
                $iDist = ($cY - $cY0) + $iPenalty * Abs($cX0 - $cX)
                $bValid = True
            EndIf
        EndIf
        
        If $bValid And $iDist < $iBestDist Then
            $iBestDist = $iDist
            $hBestWin = $hWnd
        EndIf
    Next
    
    If $hBestWin = 0 Then
        $iBestDist = 9999999
        For $i = 0 To UBound($aWins) - 1
            Local $hWnd = $aWins[$i]
            If $hWnd = $hWndSource Then ContinueLoop
            Local $aPos = WinGetPos($hWnd)
            If Not IsArray($aPos) Then ContinueLoop
            Local $cX = $aPos[0] + Int($aPos[2] / 2)
            Local $cY = $aPos[1] + Int($aPos[3] / 2)
            
            Local $iDist = 0
            Local $bValid = False
            
            If $sDir = "Left" Then
                If $cX > $cX0 + 10 Then
                    $iDist = $cX + $iPenalty * Abs($cY0 - $cY)
                    $bValid = True
                EndIf
            ElseIf $sDir = "Right" Then
                If $cX < $cX0 - 10 Then
                    $iDist = (0 - $cX) + $iPenalty * Abs($cY0 - $cY)
                    $bValid = True
                EndIf
            ElseIf $sDir = "Up" Then
                If $cY > $cY0 + 10 Then
                    $iDist = $cY + $iPenalty * Abs($cX0 - $cX)
                    $bValid = True
                EndIf
            ElseIf $sDir = "Down" Then
                If $cY < $cY0 - 10 Then
                    $iDist = (0 - $cY) + $iPenalty * Abs($cX0 - $cX)
                    $bValid = True
                EndIf
            EndIf
            
            If $bValid And $iDist < $iBestDist Then
                $iBestDist = $iDist
                $hBestWin = $hWnd
            EndIf
        Next
    EndIf
    
    Return $hBestWin
EndFunc

Func _SendKeysToIndicated($sKeys, $sStatusMsg)
    Local $hWnd = $hLastSelectedWin
    If Not $hWnd Or Not _WinAPI_IsWindow($hWnd) Then $hWnd = _GetSelectedBrowserWindow()
    If $hWnd Then 
        Local $hActivePrev = WinGetHandle("[ACTIVE]")
        WinActivate($hWnd)
        Sleep(50)
        Send($sKeys)
        Sleep(50)
        If $hActivePrev Then WinActivate($hActivePrev)
        If $sStatusMsg <> "" Then GUICtrlSetData($idStatus, $sStatusMsg)
    EndIf
EndFunc
; file: C:\_o\__\os-desk-browsers\db-lib.au3
