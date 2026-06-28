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
feat: implement grid collision snapping with swaps, dark theme, and focus feedback

- Widen GUI to 700px and implemented a complete professional, low-glare dark visual theme.
- Fixed the ListView focus check to correctly activate focus highlights and orange window borders.
- Implemented a collision-aware grid layout snapping algorithm with back-seeking available slots and 30px offset fail-safes.
- Added dynamic selection change audio beeps (1000Hz) and focus restore on window minimizes/closes.
- Mapped Enter hotkey to launch or activate selected browser window.
```

## 📝 Log Entries
[[#^toc-entries|TOC]]

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
