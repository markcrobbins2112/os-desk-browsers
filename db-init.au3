#include-once
#include "db-lib.au3"
; file: C:\_o\__\os-desk-browsers\db-init.au3
; ==============================================================================
; RUNTIME INITIALIZATION
; ==============================================================================
_InitializeApp()

Local $iTimer = TimerInit()

; Main Background Active Process Refresh Loop
; Main Background Active Process Refresh Loop
; Main Background Active Process Refresh Loop
While 1
    Sleep(50)
    
    ; 1. Check our spatial navigation lock flag right away
    If Not $bIsNavigatingSpatial Then
        _HandleZOrderSelection()
        
        If TimerDiff($iTimer) > 800 Then
            If $bGUI_Visible Then
                Local $bChangesFound = False
                For $i = 0 To $iBrowserCount - 1
                    Local $aWinList = WinList("[REGEXPTITLE:(?i).*" & $aBrowsers[$i][1] & "\z]")
                    If $aWinList[0][0] <> $aLastCounts[$i] Then
                        $bChangesFound = True
                        ExitLoop
                    EndIf
                Next
                ; Only rebuild the ListView if window instance counts actually changed!
                If $bChangesFound Then _PopulateList($aIconIndices)
            EndIf
            $iTimer = TimerInit()
        EndIf
    EndIf
WEnd

; Setup Execution Initialization Assembly Wrapper
Func _InitializeApp()
    _PopulateList($aIconIndices)
    _ShowGUI()
EndFunc

; file: C:\_o\__\os-desk-browsers\db-init.au3
