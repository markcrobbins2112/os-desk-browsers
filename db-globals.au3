#include-once
; file: C:\_o\__\os-desk-browsers\db-globals.au3
; ==============================================================================
; GLOBAL VARIABLE DECLARATIONS
; ==============================================================================
Global $aBrowsers[7][5]
Global $iBrowserCount
Global $bGUI_Visible = True
Global $aLastCounts[7]
Global $hLastSelectedWin = 0
Global $hLastPrevWin = 0
Global $hBorderWin = 0
Global $iLastSelectionIndex = -1

Global $aDummyActivate[7]
Global $aDummyClose[7]
Global $aDummyFocus[7]
Global $aDummyGrid[10] ; 0-9 hotkeys
Global $aDummySwap[9]   ; 1-9 swap hotkeys
Global $aDummyFocusGrid[10] ; Alt + 0-9 focus hotkeys
Global $aDummyCloseGrid[10] ; ctrl+0-9 close grid hotkeys
Global $aDummyIndicateGrid[10] ; alt+0-9 indicate grid hotkeys
Global $aDummyNewTabInBrowser[7] ; shift+BCEVFOP hotkeys
Global $aCommonKeys[32][2] ; common browser key forwarding map
Global $aIconIndices[7]

Global $idDummyEscape
Global $idDummyInsert
Global $idDummyDelete
Global $idDummyPageUp
Global $idDummyPageDown
Global $idDummySiblingUp
Global $idDummyRight
Global $idDummyLeft
Global $idDummyUp
Global $idDummyDown
Global $idDummyCycleNext
Global $idDummyCyclePrev
Global $idDummyCopyUrl
Global $idDummySendToBack
Global $idDummyMinimizeToggle
Global $idDummyEnter
Global $idDummyPrevInList
Global $idDummyNextInList
Global $idDummyCascadeType
Global $idDummySplitTabs
Global $idDummyGatherTabs
Global $idDummyCopyUrlAndCloseTab
Global $idDummyIndicatedToBackType
Global $idDummyDeepestToTopType
Global $idDummyPrevSibling
Global $idDummyNextSibling
Global $idDummyAltDown
Global $idDummyAltUp
Global $idDummyIndicateLastOnGrid
Global $idDummyIndicateFirstOnGrid
Global $bHelpClosed = False
Global $hHelpGUI = 0

Global $idDummyMoveTabLeft
Global $idDummyMoveTabRight
Global $idDummyNewTabWithClipboard
Global $idDummyNewWindowWithCurrentUrl
Global $idDummyHelp
Global $aDummyGridNewTab[10]

Global $idDummyIndicateLeft
Global $idDummyIndicateRight
Global $idDummyIndicateUp
Global $idDummyIndicateDown
Global $idDummyZoomIn
Global $idDummyZoomOut
Global $idDummyBack
Global $idDummyForward

Global $idHelpBtn
Global $idListview
Global $hGUI
Global $idStatus
Global $tray_Restore
Global $tray_Exit

; file: C:\_o\__\os-desk-browsers\db-globals.au3
