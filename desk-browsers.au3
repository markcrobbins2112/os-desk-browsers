; file: C:\_o\__\os-desk-browsers\desk-browsers.au3
#NoTrayIcon
#RequireAdmin ; Request administrative rights to manage borderless styles and transparency of all windows
#pragma compile(RequiredAdmin, true)


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
; SINGLE INSTANCE DETECTOR & NICE TERMINATION ENGINE
; ==============================================================================
; Define a unique system signature name for your specific script mutex
Global Const $sUniqueMutexName = "Local\DeskBrowsersTilingManagerMutex_98723"

; Attempt to open or create the system mutex
Local $hMutex = DllCall("kernel32.dll", "handle", "CreateMutexW", "struct*", 0, "bool", 1, "wstr", $sUniqueMutexName)
Local $iLastError = DllCall("kernel32.dll", "dword", "GetLastError")[0]

; ERROR_ALREADY_EXISTS = 183. If true, a previous instance is already running!
If $iLastError = 183 Then
    ; 1. Politely look for the first instance's window title handle
    Local $hFirstInstanceWin = WinGetHandle("Browser Manager")
    
    If $hFirstInstanceWin <> 0 Then
        ; 2. Send a standard Windows Close command (WM_CLOSE = 0x0010)
        ; This triggers the first instance's "_HandleClose" function nicely!
        DllCall("user32.dll", "bool", "PostMessageW", "hwnd", $hFirstInstanceWin, "uint", 0x0010, "wparam", 0, "lparam", 0)
        
        ; Give the first instance up to 2 seconds to run its GDI cleanups and exit
        WinWaitClose($hFirstInstanceWin, "", 2)
    EndIf
    
    ; 3. Exit this second instance now that the first has been gracefully stopped
    ;Exit
EndIf
; ==============================================================================
_PlayHappyBeeps()


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
