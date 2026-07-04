#include-once
#include "db-hdrs.au3"
#include "db-events.au3"
#include "db-engine.au3"
#include "db-lib.au3"
; file: C:\_o\__\os-desk-browsers\db-ui.au3

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


; ==============================================================================
; USER INTERFACE SETUP
; ==============================================================================
$hGUI = GUICreate("Browser Manager", 700, 320, -1, -1, BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS), $WS_EX_TOPMOST)
GUISetBkColor(0x2D2D2D, $hGUI) ; Sleek medium grey background


GUISetOnEvent($GUI_EVENT_CLOSE, "_HandleClose", $hGUI)

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
; Initialize browser-specific tracking dummys and shift-launch dummys
For $i = 0 To $iBrowserCount - 1
    $aDummyActivate[$i] = GUICtrlCreateDummy()
    $aDummyClose[$i] = GUICtrlCreateDummy()
    $aDummyFocus[$i] = GUICtrlCreateDummy()
    $aDummyNewTabInBrowser[$i] = GUICtrlCreateDummy()
    GUICtrlSetOnEvent($aDummyActivate[$i], "_OnShortcut")
    GUICtrlSetOnEvent($aDummyClose[$i], "_OnShortcut")
    GUICtrlSetOnEvent($aDummyFocus[$i], "_OnShortcut")
    GUICtrlSetOnEvent($aDummyNewTabInBrowser[$i], "_OnNewTabInBrowserType")
Next

; Establish grid layouts dummies
For $i = 0 To 9
    $aDummyGrid[$i] = GUICtrlCreateDummy()
    GUICtrlSetOnEvent($aDummyGrid[$i], "_OnGridHotkey")
    $aDummyFocusGrid[$i] = GUICtrlCreateDummy()
    GUICtrlSetOnEvent($aDummyFocusGrid[$i], "_OnFocusGridHotkey")
    $aDummyGridNewTab[$i] = GUICtrlCreateDummy()
    GUICtrlSetOnEvent($aDummyGridNewTab[$i], "_OnNewTabAtGridHotkey")
    $aDummyCloseGrid[$i] = GUICtrlCreateDummy()
    GUICtrlSetOnEvent($aDummyCloseGrid[$i], "_OnCloseGridHotkey")
    $aDummyIndicateGrid[$i] = GUICtrlCreateDummy()
    GUICtrlSetOnEvent($aDummyIndicateGrid[$i], "_OnIndicateGridHotkey")
Next

; Setup Common Browser Keys Forwarding Map
Local $aKeysToMap[32] = [ _
    "^t", "^+t", "^{F4}", "^{TAB}", "^+{TAB}", "^{PGUP}", "^{PGDN}", "^+{PGUP}", "^+{PGDN}", _
    "^0", "^=", "^-", "^n", "^+n", "^d", "{PGDN}", "{PGUP}", "{BACKSPACE}", "+{BACKSPACE}", _
    "!{LEFT}", "!{RIGHT}", "{HOME}", "{END}", "^1", "^2", "^3", "^4", "^5", "^6", "^7", "^8", "^9" _
]
For $i = 0 To 31
    $aCommonKeys[$i][0] = GUICtrlCreateDummy()
    $aCommonKeys[$i][1] = $aKeysToMap[$i]
    GUICtrlSetOnEvent($aCommonKeys[$i][0], "_OnCommonKey")
Next

$idDummyEscape = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyEscape, "_MinimizeToTray")
$idDummyInsert = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyInsert, "_OnInsertPressed")
$idDummyDelete = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyDelete, "_OnDeletePressed")
$idDummyUp = GUICtrlCreateDummy()
$idDummyDown = GUICtrlCreateDummy()
$idDummyLeft = GUICtrlCreateDummy()
$idDummyRight = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyLeft, "_OnNavigateSpatialLeft")
GUICtrlSetOnEvent($idDummyRight, "_OnNavigateSpatialRight")
GUICtrlSetOnEvent($idDummyUp, "_OnNavigateSpatialUp")
GUICtrlSetOnEvent($idDummyDown, "_OnNavigateSpatialDown")

; GUICtrlSetOnEvent($idDummyUp, "_OnIndicatePrevInList")
; GUICtrlSetOnEvent($idDummyDown, "_OnIndicateNextInList")
; GUICtrlSetOnEvent($idDummyLeft, "_OnIndicatePrevInList")
; GUICtrlSetOnEvent($idDummyRight, "_OnIndicateNextInList")
$idDummyCopyUrl = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyCopyUrl, "_OnCopyUrl")
$idDummySendToBack = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummySendToBack, "_OnSendToBack")
$idDummyMinimizeToggle = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyMinimizeToggle, "_OnMinimizeToggle")
$idDummyEnter = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyEnter, "_OnEnterPressed")

$idDummyPrevInList = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyPrevInList, "_OnIndicatePrevInList")
$idDummyNextInList = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyNextInList, "_OnIndicateNextInList")
$idDummyCascadeType = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyCascadeType, "_OnCascadeIndicatedType")
$idDummySplitTabs = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummySplitTabs, "_OnSplitAllTabs")
$idDummyGatherTabs = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyGatherTabs, "_OnGatherAllTabs")
$idDummyCopyUrlAndCloseTab = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyCopyUrlAndCloseTab, "_OnCopyUrlAndCloseTab")
$idDummyIndicatedToBackType = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyIndicatedToBackType, "_OnIndicatedToBackType")
$idDummyDeepestToTopType = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyDeepestToTopType, "_OnDeepestToTopType")
$idDummyPrevSibling = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyPrevSibling, "_OnPrevSiblingOfType")
$idDummyNextSibling = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyNextSibling, "_OnNextSiblingOfType")
$idDummyAltDown = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyAltDown, "_OnAltDownPressed")
$idDummyAltUp = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyAltUp, "_OnAltUpPressed")
$idDummyIndicateLastOnGrid = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyIndicateLastOnGrid, "_OnIndicateLastOnGrid")
$idDummyIndicateFirstOnGrid = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyIndicateFirstOnGrid, "_OnIndicateFirstOnGrid")

$idDummyNewTabWithClipboard = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyNewTabWithClipboard, "_OnNewTabWithClipboard")
$idDummyNewWindowWithCurrentUrl = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyNewWindowWithCurrentUrl, "_OnNewWindowWithCurrentUrl")
$idDummyHelp = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyHelp, "_OnHelpPressed")

$idDummyIndicateLeft = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyIndicateLeft, "_OnIndicateLeft")
$idDummyIndicateRight = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyIndicateRight, "_OnIndicateRight")
$idDummyIndicateUp = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyIndicateUp, "_OnIndicateUp")
$idDummyIndicateDown = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyIndicateDown, "_OnIndicateDown")

$idDummyZoomIn = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyZoomIn, "_OnZoomIn")
$idDummyZoomOut = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyZoomOut, "_OnZoomOut")

$idDummyBack = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyBack, "_OnBack")
$idDummyForward = GUICtrlCreateDummy()
GUICtrlSetOnEvent($idDummyForward, "_OnForward")

; file: C:\_o\__\os-desk-browsers\db-ui.au3
