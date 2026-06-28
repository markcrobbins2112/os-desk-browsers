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
feat: implement dynamic z-order restoration, tab/sibling navigation hotkeys, rich-text custom help GUI, and medium grey theme

- Encapsulated Z-index promotion and precise previous sibling restoration inside _DrawOrangeBorder and _ClearOrangeBorder.
- Mapped PageUp and PageDown keys to select next and previous browser tabs.
- Mapped Delete to close the current tab of the selected browser window.
- Mapped Insert to create a new tab for the selected browser window.
- Mapped Right Arrow to bring the deepest sibling window of the selected browser to the top.
- Mapped Left Arrow to push the current top browser window to the bottom of sibling Z-order and bring the next sibling to top.
- Replaced the simple MsgBox help with a custom-designed, styled, and media-rich dark themed help GUI.
- Refactored the main UI background and header controls to a highly professional, low-glare medium grey theme (0x2D2D2D/0x3D3D3D).
```

## 📝 Log Entries
[[#^toc-entries|TOC]]

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
- Declared the new Dummy variables `$idDummyDelete`, `$idDummyRight`, and `$idDummyLeft` globally at the top of the file to fix the "Variable used without being declared" startup crash.
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
