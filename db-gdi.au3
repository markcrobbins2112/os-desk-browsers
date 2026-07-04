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
    If Not IsArray($aPos) Then Return ; Guard against invalid window parameters
    
    Local Const $GW_HWNDNEXT = 2
    Local Const $SWP_NOSIZE = 0x0001
    Local Const $SWP_NOMOVE = 0x0002
    Local Const $SWP_NOACTIVATE = 0x0010
    Local Const $RGN_DIFF = 4
    
    ; 1. Fetch physical display monitor layout multipliers
    Local $hDC_Screen = _WinAPI_GetDC(0)
    Local $iDpiX = _WinAPI_GetDeviceCaps($hDC_Screen, 88) 
    Local $iDpiY = _WinAPI_GetDeviceCaps($hDC_Screen, 90) 
    _WinAPI_ReleaseDC(0, $hDC_Screen)
    Local $fScaleX = $iDpiX / 96
    Local $fScaleY = $iDpiY / 96

    ; ==============================================================================
    ; 2. MAINTAIN FLOATING OVERLAY WINDOW CANVAS (UPGRADED BOUNDS PLACEMENT)
    ; ==============================================================================
    ; VISUAL FIX: We slightly pad the width/height (+4) and offset the X/Y (-2)
    ; This makes our frame perfectly hug the exterior shell of your window!
    Local $iCanvasX = $aPos[0] - 2
    Local $iCanvasY = $aPos[1] - 2
    Local $iCanvasW = $aPos[2] + 4
    Local $iCanvasH = $aPos[3] + 4

    If $hBorderWin = 0 Or Not _WinAPI_IsWindow($hBorderWin) Then
        $hBorderWin = GUICreate("", $iCanvasW, $iCanvasH, $iCanvasX, $iCanvasY, 0x80000000, BitOR(0x00080000, 0x00000020, 0x00000008)) 
        GUISetBkColor(0xABCDEF, $hBorderWin) 
        _WinAPI_SetLayeredWindowAttributes($hBorderWin, 0xABCDEF, 255, 1) 
        GUISetState(4, $hBorderWin) 
    Else
        Local $aCurrentBorderPos = WinGetPos($hBorderWin)
        If IsArray($aCurrentBorderPos) Then
            If $aCurrentBorderPos[0] <> $iCanvasX Or $aCurrentBorderPos[1] <> $iCanvasY Or $aCurrentBorderPos[2] <> $iCanvasW Or $aCurrentBorderPos[3] <> $iCanvasH Then
                Local Const $HWND_TOPMOST = -1
                _WinAPI_SetWindowPos($hBorderWin, $HWND_TOPMOST, $iCanvasX, $iCanvasY, $iCanvasW, $iCanvasH, $SWP_NOACTIVATE)
            EndIf
        EndIf
    EndIf

    ; ==============================================================================
    ; 3. THE LIVE SWITCH: HARD UNLINK OLD CHANNELS & FORCE NEW LIVE STREAM
    ; ==============================================================================
    ; Step A: Forcefully kill any lingering window video feeds before making a new one
    If $hDwmThumbnail <> 0 Then
        DllCall("dwmapi.dll", "long", "DwmUnregisterThumbnail", "ptr", $hDwmThumbnail)
        $hDwmThumbnail = 0
    EndIf

    ; Wake up the window if it's sleeping in the taskbar
    If BitAND(WinGetState($hTarget), 16) Then 
        WinSetState($hTarget, "", @SW_RESTORE)
    EndIf
    
    ; Step B: Request a brand new hardware streaming pipeline using the active target handle
    Local $aResult = DllCall("dwmapi.dll", "long", "DwmRegisterThumbnail", "hwnd", $hBorderWin, "hwnd", $hTarget, "ptr*", 0)
    
    ; Extract the correct unique thumbnail ID token from array item [3]
    If Not @error And IsArray($aResult) And $aResult[0] = 0 Then
        $hDwmThumbnail = $aResult[3] 
        
        Local $tProps = DllStructCreate("dword dwFlags;int rcDestLeft;int rcDestTop;int rcDestRight;int rcDestBottom;int rcSrcLeft;int rcSrcTop;int rcSrcRight;int rcSrcBottom;byte opacity;bool fVisible;bool fSourceClientAreaOnly")
        DllStructSetData($tProps, "dwFlags", BitOR(0x1, 0x4, 0x8)) 
        DllStructSetData($tProps, "fVisible", True)
        DllStructSetData($tProps, "opacity", 255) 
        
        ; Adjust the DWM stream to skip our 2px padding on the left/top edges 
        Local $iPhysWidth = Int($aPos[2] * $fScaleX)
        Local $iPhysHeight = Int($aPos[3] * $fScaleY)
        Local $iOffsetX = Int(2 * $fScaleX)
        Local $iOffsetY = Int(2 * $fScaleY)
        
        DllStructSetData($tProps, "rcDestLeft", $iOffsetX)
        DllStructSetData($tProps, "rcDestTop", $iOffsetY)
        DllStructSetData($tProps, "rcDestRight", $iOffsetX + $iPhysWidth)
        DllStructSetData($tProps, "rcDestBottom", $iOffsetY + $iPhysHeight)
        
        DllCall("dwmapi.dll", "long", "DwmUpdateThumbnailProperties", "ptr", $hDwmThumbnail, "ptr", DllStructGetPtr($tProps))
    EndIf
    
    $hLastSelectedWin = $hTarget 
    ; ==============================================================================

    ; ==============================================================================
    ; 4. TRACE OVERLAYING ORANGE HIGHLIGHT BORDER (UPGRADED TO 4PX GLOW CHASSIS)
    ; ==============================================================================
    ; Change this color hex code to whatever color value you prefer!
    Local $iIndicatorColor = 0xFF6600 ; Vibrant Glowing Orange

    Local $hDC = _WinAPI_GetWindowDC($hBorderWin)
    Local $hRect = _WinAPI_CreateRectRgn(0, 0, $iCanvasW, $iCanvasH)
    
    ; INCREASED THICKNESS PARAMETERS: Set inner region bounds cut out to 4px
    Local $hInnerRect = _WinAPI_CreateRectRgn(4, 4, $iCanvasW - 4, $iCanvasH - 4)
    _WinAPI_CombineRgn($hRect, $hRect, $hInnerRect, $RGN_DIFF)

    Local $hBrush = _WinAPI_CreateSolidBrush($iIndicatorColor) 
    _WinAPI_FillRgn($hDC, $hRect, $hBrush)

    _WinAPI_DeleteObject($hBrush)
    _WinAPI_DeleteObject($hInnerRect)
    _WinAPI_DeleteObject($hRect)
    _WinAPI_ReleaseDC($hBorderWin, $hDC)
EndFunc

Func _ClearOrangeBorder()
    If $hDwmThumbnail <> 0 Then
        DllCall("dwmapi.dll", "long", "DwmUnregisterThumbnail", "ptr", $hDwmThumbnail)
        $hDwmThumbnail = 0
    EndIf

    $hLastSelectedWin = 0
    $hLastPrevWin = 0
    
    If $hBorderWin <> 0 Then
        GUIDelete($hBorderWin)
        $hBorderWin = 0
    EndIf
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
