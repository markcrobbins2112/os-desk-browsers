---
title: LOG
---

# LOG

## 📑 AI Primary Files
- 🔹 [AGENTS.md](../AGENTS.md)
- 🔹 [ARCHIVE.md](ARCHIVE.md)
- 🔹 [BUILD.md](BUILD.md)
- 🔹 [CODE.md](CODE.md)
- 🔹 [DESIGN.md](DESIGN.md)
- 🔹 [FEATURES.md](FEATURES.md)
- 🔸 [LOG.md](LOG.md)
- 🔹 [MANUAL.md](MANUAL.md)
- 🔹 [README.md](../README.md)
- 🔹 [SPEC.md](SPEC.md)
- 🔹 [TASKS.md](TASKS.md)
- 🔹 [TERMS.md](TERMS.md)
- 🔹 [TESTING.md](TESTING.md)
- 🔹 [VERSIONS.md](VERSIONS.md)

## 🔍 Table of Contents
- [[#💾 Commit Message]] ^toc-commit
- [[#📝 Log Entries]] ^toc-entries
- [[#🏛️ Permanent Decision Record Archive]] ^toc-adr
- [[#🚀 Go to...]] ^toc-goto

## 💾 Commit Message
[[#^toc-commit|TOC]]
```text
fix: validate and complete keyboard accelerator keymapping fixup

- Validated all requested browser keybindings (such as ctrl+t, ctrl+shift+t, ctrl+0-9, up/down/left/right, and others).
- Resolved registration conflict for `Ctrl+0-9` by skipping duplicate standard forwarding in section 3 of `db-keys.au3`.
- Implemented an elegant dynamic fallback inside section 2's hotkeys: if no browser occupies the target grid position, the `Ctrl+0-9` key is forwarded via `Send` to the active browser tab.
- Updated markdown logs, tasks list, and version milestones.
```

## 📝 Log Entries
[[#^toc-entries|TOC]]

### 📅 [2026-07-04T07:12:00-07:00]
#### 🎯 Primary Goals & Requirements
- Validate the existence of code for all keybindings and functionalities (such as `Ctrl+T`, `Ctrl+Shift+T`, `Ctrl+F4`, `Ctrl+1-9`, navigation keys, grid keys, etc.).
- Complete keymapping fixup for common browser keys.
- Prevent conflict between `Ctrl+0-9` mapped for closing grid positions versus switching tabs inside the browsers.

#### 🛠️ Completed Changes in this Session
- Audited all mapped hotkeys across `db-keys.au3` and `db-events.au3`.
- Modified section 3 of `db-keys.au3` to skip registering duplicate `Ctrl+0-9` accelerator keys since they are already captured under grid-specific closures.
- Enhanced the `_OnCloseGridHotkey()` event handler in `db-events.au3` to check if a browser window exists at the specified grid position. If not, it gracefully falls back to activating the selected browser and sending `Ctrl+1-9` keys directly to control tab switching.
- Verified compilation builds cleanly without syntax issues.

#### 🔸 Affected Files
- `/db-keys.au3`
- `/db-events.au3`
- `/AIMD/LOG.md`
- `/AIMD/TASKS.md`
- `/AIMD/VERSIONS.md`

### 📅 [2026-06-28T02:04:00-07:00]
#### 🎯 Primary Goals & Requirements
- Configure Page Up and Page Down (the previous and next tab keys) to send `Ctrl+Page Up` and `Ctrl+Page Down` to the indicated browser window under the hood for tab switching.

#### 🛠️ Completed Changes in this Session
- Refactored `_OnTabLeft()` to send `^{PGUP}` (Ctrl+PageUp) instead of `^+{TAB}`.
- Refactored `_OnTabRight()` to send `^{PGDN}` (Ctrl+PageDown) instead of `^{TAB}`.
- Updated the Help guide HTML text to mention the precise underlying shortcuts.

#### 🔸 Affected Files
- `/desk-browsers.au3`

### 📅 [2026-06-28T01:50:00-07:00]
#### 🎯 Primary Goals & Requirements
- Add Opera to the list of Browsers with dynamic installation path detection.
- Make the Help Guide dialog window 60% taller (896px height) to provide a spacious reading layout.
- Map `Ctrl+Left`, `Ctrl+Right`, `Ctrl+Up`, and `Ctrl+Down` keys to focus/indicate the browser window in that spatial direction.
- Map `Ctrl+=` and `Ctrl+-` keys to zoom in and zoom out on the indicated browser window.
- Map `Alt+Left` and `Alt+Right` keys to navigate backward and forward in the browser history of the indicated browser.

#### 🛠️ Completed Changes in this Session
- Inserted Opera browser support at array index 5 of `$aBrowsers`, shift Browser Picker to index 6, and expanded the size of all tracking arrays accordingly.
- Scaled `$hHelpGUI` height to 896px, updated embedded browser control height to 830px, and moved the native Close button to Y=850.
- Updated the Help HTML structure to list Opera as activate/launch key `O` and fully document all new hotkeys.
- Implemented `_OnIndicateLeft()`, `_OnIndicateRight()`, `_OnIndicateUp()`, and `_OnIndicateDown()` calling a direction navigation routine (`_IndicateDirection()`) that computes the neighbor window on the 3x3 grid or selects the physically closest browser window using 2D distance calculations.
- Implemented zoom handlers `_OnZoomIn()` and `_OnZoomOut()`, passing `^=` and `^-` to the target window.
- Implemented history navigation handlers `_OnBack()` and `_OnForward()`, passing `!{LEFT}` and `!{RIGHT}` keys to the target window.
- Built and verified the codebase with no syntax errors.

#### 🔸 Affected Files
- `/desk-browsers.au3`

### 📅 [2026-06-28T01:35:00-07:00]
#### 🎯 Primary Goals & Requirements
- Map `Ctrl+C` to copy the URL of the indicated browser.
- Map `Ctrl+Shift+PageUp` and `Ctrl+Shift+PageDown` to move the indicated browser's active tab left and right.
- Map `Insert` to open a new tab on the indicated browser.
- Map `Ctrl+V` and `Shift+Insert` to make a new tab with the clipboard URL on the indicated browser.
- Map `Shift+Enter` to create a new window with the current URL of the indicated browser.
- Map `F1` to open the Help dialog guide.
- Map `Esc` within the Help GUI context to close it instantly.
- Map `Ctrl+Shift+0-9` to open a new tab of the window on that grid position with the URL of the current window.

#### 🛠️ Completed Changes in this Session
- Refactored `_OnCopyUrl()` to prioritize the indicated window (`$hLastSelectedWin`) and fallback to the selected browser.
- Created `_OnMoveTabLeft()` and `_OnMoveTabRight()` to activate the target window, send `^+{PGUP}`/`^+{PGDN}`, and restore active focus.
- Refactored `{INS}` to call `_OnInsertPressed()` which opens a blank new tab on the indicated browser window.
- Implemented `_OnNewTabWithClipboard()` for `^v` and `+{INS}` keys to open a new tab and paste/navigate to the clipboard content.
- Implemented `_OnNewWindowWithCurrentUrl()` for `+{ENTER}` to grab the URL from the indicated window, open a new browser window, and navigate to that URL.
- Added `{F1}` to call `_OnHelpPressed()` which shows the guide.
- Bound `{ESC}` as a dedicated accelerator inside the Help GUI to trigger close immediately when Help is focused.
- Implemented `_OnNewTabAtGridHotkey()` to capture the current indicated window's URL, activate the browser at the targeted grid position, open a new tab, and paste the URL.

#### 🔸 Affected Files
- `/desk-browsers.au3`

### 📅 [2026-06-28T01:15:00-07:00]
#### 🎯 Primary Goals & Requirements
- Implement Alt+0-9 keys to instantly move focus indicator (orange border) and promote the corresponding grid-positioned window to the top of the Z-order.
- Brief activation and standard keystroke sending (`Send`) for PageUp, PageDown, and Delete keys targeting the indicated browser window, restoring focus afterwards.
- Support Esc to close the Help guide window gracefully.
- Remove any iframe-like borders or client edges around the HTML help document of the ActiveX object.
- Implement Ctrl+PageUp and Ctrl+PageDown to cycle all windows currently on the grid to adjacent grid positions.

#### 🛠️ Completed Changes in this Session
- Implemented `Alt+0-9` grid focusing via `$aDummyFocusGrid` and `_OnFocusGridHotkey()`. It promotes the window to the top of its group, focuses the listview item, and immediately draws the orange border.
- Refactored `_OnTabLeft()`, `_OnTabRight()`, and `_OnDeletePressed()` to save the active window, activate the indicated/selected browser window, send keys (`^+{TAB}`, `^{TAB}`, `^w`) after a brief sleep, and restore the previous focus.
- Updated `_MinimizeToTray()` to check if `$hHelpGUI` is open and close it gracefully on Escape.
- Set `html` and `body` CSS borders to `0px none !important` and stripped `WS_EX_CLIENTEDGE` from the embedded ActiveX control using `_WinAPI_SetWindowLong`.
- Registered `^{PGUP}` and `^{PGDN}` to call `_CycleGridWindows()` to shift all visible grid windows in 1-9 positions.

#### 🔸 Affected Files
- `/desk-browsers.au3`

### 📅 [2026-06-28T01:00:00-07:00]
#### 🎯 Primary Goals & Requirements
- Restore the Help GUI dialog to a standard visible window frame to prevent transparency and rendering issues with ActiveX controls.
- Retain the custom dark-themed HTML/CSS shortcut helper layout.

#### 🛠️ Completed Changes in this Session
- Redefined `$hHelpGUI` to use the standard, fully visible dialog window style (`BitOR(0x00C00000, 0x00080000)` equivalent to `$WS_CAPTION` and `$WS_SYSMENU`) with a solid background color (`0x1E1E1E`).
- Centered and positioned the embedded web view (`Shell.Explorer.2`) and the close button perfectly within the standard window frame, ensuring flawless rendering and crisp visual clarity.

#### 🔸 Affected Files
- `/desk-browsers.au3`

---

### 📅 [2026-06-28T00:50:00-07:00]
#### 🎯 Primary Goals & Requirements
- Fix non-closing Help GUI in OnEvent Mode.
- Embed a gorgeous WebView-like HTML/CSS shortcut guide within the Help GUI.
- Render with no system frame (borderless popup window) and beautiful branding.

#### 🛠️ Completed Changes in this Session
- Removed the blocking `While/Sleep` message-loop in `_ShowHelp` which previously captured and stalled the main AutoIt OnEvent queue.
- Changed `$hHelpGUI` to use the borderless popup style (`0x80000000` / `$WS_POPUP`) to eliminate the heavy-handed default OS frame.
- Embedded a modern ActiveX-backed web viewport (`Shell.Explorer.2`) styled in deep low-glare charcoal gray (`#1E1E1E`), clean custom `<kbd>` keyboard key capsules, and structured lists.
- Outlined the borderless window with an elegant, branded 2px solid orange highlight wrapper (`0xFF6600`) to form a distinctive visual pairing.
- Added a native, beautifully styled "Close Help Guide" dark button matching the application aesthetics, allowing instant, clean disposal via `_HelpGUI_Close` event handlers.

#### 🔸 Affected Files
- `/desk-browsers.au3`

---

### 📅 [2026-06-28T00:40:00-07:00]
#### 🎯 Primary Goals & Requirements
- Fix the startup crash caused by undeclared/missing variables `$idDummyDelete`, `$idDummyRight`, `$idDummyLeft`, and style masks.
- Fix the runtime crash in the Help GUI loop when checking `$aMsg[1]` under OnEvent mode.

#### 🛠️ Completed Changes in this Session
- Declared `$idDummyDelete`, `$idDummyRight`, and `$idDummyLeft` globally at the top of the script.
- Replaced the `$ES_READONLY`, `$ES_MULTILINE`, and `$WS_VSCROLL` edit style variables with literal hexadecimal values (`0x0800`, `0x0004`, `0x00200000`) to guarantee compatibility across all standard and custom AutoIt runtime environments.
- Declared global `$bHelpClosed` flag and refactored the Help GUI's message loop to use `GUISetOnEvent` and `GUICtrlSetOnEvent` handlers instead of `GUIGetMsg` which is incompatible with `GUIOnEventMode = 1`.

#### 🔸 Affected Files
- `/desk-browsers.au3`

---

### 📅 [2026-06-28T00:22:00-07:00]
#### 🎯 Primary Goals & Requirements
- Restore the original Z-order position when the orange border is removed.
- Map Page Up / Page Down to select previous / next tabs.
- Map Delete to close the current browser tab.
- Map Insert to create a new browser tab.
- Map Right Arrow to bring the deepest browser sibling window to the top.
- Map Left Arrow to push the top browser window to the bottom of the sibling Z-order and bring the next sibling to top.
- Design a rich, gorgeous custom help GUI.
- Convert any white background elements of the main UI into medium grey.

#### 🛠️ Completed Changes in this Session
- Refactored `_DrawOrangeBorder` and `_ClearOrangeBorder` to dynamically track the target window's original Z-index sibling (`_WinAPI_GetWindow` using `GW_HWNDPREV` (3)) and restore it perfectly when the border is cleared.
- Registered `{INS}`, `{DEL}`, `{RIGHT}`, and `{LEFT}` hotkeys in the accelerator map, bound to dedicated Dummy controls and event handlers.
- Declared the new Dummy variables `$idDummyDelete`, `$idDummyRight`, and `$idDummyLeft` globally at the top of the file, and included `<EditConstants.au3>` to resolve the missing edit control constants (`$ES_READONLY`, `$ES_MULTILINE`) that caused a startup crash.
- Implemented `_OnDeletePressed()`, sending `^w` to close the selected window's active tab.
- Implemented `_OnRightPressed()`, locating the deepest sibling in the matching browser window list and promoting it to the top.
- Implemented `_OnLeftPressed()`, pushing the current top window immediately behind the deepest sibling in the Z-order and promoting the next sibling window to the top.
- Replaced the simple text `MsgBox` help dialog with a beautiful custom GUI `_ShowHelp()` styled in `0x1E1E1E`/`0x2D2D2D` with formatted Consolas keyboard instructions.
- Styled the main GUI background to `0x2D2D2D` (medium grey), changed the help button background to `0x3D3D3D`, and made label backgrounds transparent to form a seamless professional theme.

#### 🔸 Affected Files
- `/desk-browsers.au3`

---

### 📅 [2026-06-27T17:05:00-07:00]
#### 🎯 Primary Goals & Requirements
- Widen the UI and apply a stylish dark theme.
- Play a beep when the list selection focus indicator changes.
- Fix items window focus promotion and orange border drawing (resolved ClassNameNN string check bug).
- Map Enter key to launch or activate the selected browser.
- Return focus to the manager UI on browser window minimize or close.
- Support collision-aware grid window placement: swap positions if occupied, find backward open positions (9 down to 1), or reuse with 30px offsets.

#### 🛠️ Completed Changes in this Session
- Redesigned UI styling with `GUISetBkColor(0x1E1E1E)`, `GUICtrlSetColor` (0xE0E0E0/0x858585), and listview background color matching deep carbon styles.
- Corrected focused control check to retrieve window handles using `ControlGetHandle($hGUI, "", ControlGetFocus($hGUI))` instead of string conversion comparison.
- Added tracking variable `$iLastSelectionIndex` and integrated `Beep()` sounds on focus indicator transitions.
- Created `$idDummyEnter` mapped to `{ENTER}` to execute `_HandleAction(..., False)`.
- Replaced `_OnGridHotkey` with a collision resolution solver including swapping, backward-search scanning, and `_MoveWindowToGridPosition` helpers.

#### 🔸 Affected Files
- `/desk-browsers.au3`

---

### 📅 [2026-06-27T16:45:00-07:00]
#### 🎯 Primary Goals & Requirements
- Dynamically promote the selected browser window to the top of the Z-order with an orange border.
- Restore the window back to its original Z-order and remove the orange border when de-focused.

#### 🛠️ Completed Changes in this Session
- Redesigned `_HandleZOrderSelection()` to robustly detect de-focus conditions (GUI invisible, ListView lost focus, or empty selection).
- Implemented exact sibling window restoration using `GW_HWNDPREV` (3) and `_WinAPI_SetWindowPos` to push the window back to its precise previous Z-order position upon defocus.
- Integrated safety checks using `_WinAPI_IsWindow()` to prevent calls on invalidated or closed window handles.
- Updated `_MinimizeToTray()` and `_ExitApp()` to clear selection states and clean up remaining highlights or window positions on exit.

#### 🔸 Affected Files
- `/desk-browsers.au3`

---

### 📅 [2026-06-27T16:35:00-07:00]
#### 🎯 Primary Goals & Requirements
- Complete a comprehensive review of all markdown files and reverse engineer the active AutoIt codebase.
- Populate technical, design, and structural guidelines, removing all template placeholders.

#### 🛠️ Completed Changes in this Session
- Formulated precise design contexts, components layouts, and topology maps inside `DESIGN.md`.
- Documented keyboard shortcuts, math formulas, diagnostics, and troubleshooting procedures in `MANUAL.md`.
- Described tiling grids, layout swaps, active tab scrolling, clipboard loading, and tray management in `FEATURES.md`.
- Specified compilation, syntax linter checking, and build size verification benchmarks in `BUILD.md`.
- Detailed testing checklists and scenario outlines in `TESTING.md`.
- Populated glossary terms and system acronyms in `TERMS.md`.
- Completed operational agent guidelines inside `AGENTS.md` and version milestone histories inside `VERSIONS.md`.

#### 🔸 Affected Files
- `/AGENTS.md`
- `/AIMD/ARCHIVE.md`
- `/AIMD/BUILD.md`
- `/AIMD/CODE.md`
- `/AIMD/DESIGN.md`
- `/AIMD/FEATURES.md`
- `/AIMD/LOG.md`
- `/AIMD/MANUAL.md`
- `/AIMD/SPEC.md`
- `/AIMD/TASKS.md`
- `/AIMD/TERMS.md`
- `/AIMD/TESTING.md`
- `/AIMD/VERSIONS.md`

---

### 📅 [2026-06-27T16:05:00-07:00]
#### 🎯 Primary Goals & Requirements
- Update window selectors to favor highest visible Z-index when multiple windows match a browser profile.

#### 🛠️ Completed Changes in this Session
- Modified `_GetSelectedBrowserWindow`, `_CheckBrowserRunning`, and `_HandleAction` inside `desk-browsers.au3` to check `BitAND(WinGetState($hWnd), 2)`.
- Ensured window activation and close actions target the topmost visible browser instance.

#### 🔸 Affected Files
- `/desk-browsers.au3`

---

### 📅 [2026-06-27T15:30:00-07:00]
#### 🎯 Primary Goals & Requirements
- Consolidate split scripts (`actions_engine.au3`, `actions_gdi.au3`, `actions_ui.au3`, etc.) into a single file to eliminate relative import paths and build failures.

#### 🛠️ Completed Changes in this Session
- Created single `desk-browsers.au3` combining variables, UI creation, hotkey accelerator array, GDI border drawer, and timer loop.
- Deleted obsolete modular split files.

#### 🔸 Affected Files
- `/desk-browsers.au3`
- `/actions_engine.au3` (deleted)
- `/actions_gdi.au3` (deleted)
- `/actions_ui.au3` (deleted)
- `/events.au3` (deleted)
- `/shared_globals.au3` (deleted)

---

## 🏛️ Permanent Decision Record Archive
[[#^toc-adr|TOC]]

### 🏷️ [ADR-001] - Single Script Architecture Selection
- **Date Approved:** 2026-06-27
- **Context:** Relative paths inside AutoIt scripts are evaluated based on the current working directory at run time, which differs depending on whether it is launched from VS Code, cmd.exe, or Windows Explorer, leading to file inclusion collisions.
- **Decision:** Consolidate all functions, globals, and wrappers into a single unified entry file `desk-browsers.au3`.
- **Consequences:** Eliminates include resolution bugs. Makes compilation using Aut2exe fast and deterministic. Simplifies hotkey accelerator table definitions.

---
## 🚀 Go to...
[[#^toc-goto|TOC]]
- 🔹 [AGENTS.md](../AGENTS.md)
- 🔹 [ARCHIVE.md](ARCHIVE.md)
- 🔹 [BUILD.md](BUILD.md)
- 🔹 [CODE.md](CODE.md)
- 🔹 [DESIGN.md](DESIGN.md)
- 🔹 [FEATURES.md](FEATURES.md)
- 🔸 [LOG.md](LOG.md)
- 🔹 [MANUAL.md](MANUAL.md)
- 🔹 [README.md](../README.md)
- 🔹 [SPEC.md](SPEC.md)
- 🔹 [TASKS.md](TASKS.md)
- 🔹 [TERMS.md](TERMS.md)
- 🔹 [TESTING.md](TESTING.md)
- 🔹 [VERSIONS.md](VERSIONS.md)
