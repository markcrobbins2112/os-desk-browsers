; file: C:\_o\__\os-desk-browsers\desk-browsers.au3
#NoTrayIcon
#RequireAdmin ; Request administrative rights to manage borderless styles and transparency of all windows

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

#include "db-globals.au3"
#include "db-consts.au3"
#include "db-ui.au3"
#include "db-keys.au3"
#include "db-init.au3"
#include "db-engine.au3"
#include "db-gdi.au3"
#include "db-events.au3"
#include "db-lib.au3"


; file: C:\_o\__\os-desk-browsers\desk-browsers.au3
