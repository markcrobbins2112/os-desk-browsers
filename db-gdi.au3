#include-once
#include "db-globals.au3"

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

; #include "db-hdrs.au3"
; file: C:\_o\__\os-desk-browsers\db-gdi.au3
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

; file: C:\_o\__\os-desk-browsers\db-gdi.au3
