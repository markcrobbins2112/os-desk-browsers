# TASKS

## 📑 AI Primary Files
- 🔹 [AGENTS.md](../AGENTS.md)
- 🔹 [ARCHIVE.md](ARCHIVE.md)
- 🔹 [BUILD.md](BUILD.md)
- 🔹 [CODE.md](CODE.md)
- 🔹 [DESIGN.md](DESIGN.md)
- 🔹 [FEATURES.md](FEATURES.md)
- 🔹 [LOG.md](LOG.md)
- 🔹 [MANUAL.md](MANUAL.md)
- 🔹 [README.md](../README.md)
- 🔹 [SPEC.md](SPEC.md)
- 🔸 [TASKS.md](TASKS.md)
- 🔹 [TERMS.md](TERMS.md)
- 🔹 [TESTING.md](TESTING.md)
- 🔹 [VERSIONS.md](VERSIONS.md)

## 🔍 Table of Contents
- [[#💬 Incoming tasks from chat]] ^toc-chat
- [[#🔄 New Changes]] ^toc-changes
- [[#⚙️ New Settings]] ^toc-new-settings
- [[#🕹️ New Commands]] ^toc-new-commands
- [[#⌨️ New Bindings]] ^toc-new-bindings
- [[#🚀 New Features]] ^toc-new-features
- [[#🛑 Blocked Items & Impediments]] ^toc-blocked
- [[#🗃️ Completed Backlog (Archive)]] ^toc-backlog
- [[#🛠️ Settings]] ^toc-arch-settings
- [[#💻 Commands]] ^toc-arch-commands
- [[#🔗 Bindings]] ^toc-arch-bindings
- [[#📦 Features]] ^toc-arch-features
- [[#🚀 Go to...]] ^toc-goto

## 💬 Incoming tasks from chat
[[#^toc-chat|TOC]]
- [x] Consolidate split script files into a single unified workspace to fix compile inclusion path bugs.
- [x] Update active window selectors to target topmost visible browser matching Highest Z-Index.
- [x] Review, reverse engineer, and fully document all markdown developer files.
- [x] Fix completely broken accelerator keys in the window manager GUI.
- [x] Implement dynamic Z-order browser promotion on focus/selection and restoration on defocus/unselection.
- [x] Play a selection beep sound (1000Hz) when list focus indicator changes.
- [x] Fix the ListView focus check bug so focus highlighting and orange window border drawing activates immediately.
- [x] Map Enter hotkey to launch or activate selected browser window.
- [x] Return focus to the manager UI upon closing or minimizing a browser window.
- [x] Design a wider (700px) layout with a sleek low-glare dark visual theme.
- [x] Implement collision-aware grid placement algorithm (swaps on occupied, backward scans 9 down to 1, or offset overlays by 30px).
- [x] Ensure window comes to the top of the Z-order when orange border is applied, and returns to its original Z-index when border is removed.
- [x] Map Page Down and Page Up to select next and previous tabs of selected window.
- [x] Map Delete to close the selected window's current tab.
- [x] Map Insert to create a new tab of selected window.
- [x] Map Right Arrow to bring deepest sibling window to the top.
- [x] Map Left Arrow to push top window to bottom of sibling Z-order and bring next sibling to top.
- [x] Redesign Help Dialog to be a gorgeous borderless embedded-HTML window with professional dark theme styling.
- [x] Refactor all white background elements of the main UI into medium grey.

## 🔄 New Changes
[[#^toc-changes|TOC]]
- [x] Merge modular components to `desk-browsers.au3`.
- [x] Clean up and delete obsolete split structures.
- [x] Redimension accelerator array to exact mapped bounds to resolve `GUISetAccelerators` registration errors.
- [x] Redesign `_HandleZOrderSelection` to support focus promotion and exact defocus restoration.
- [x] Configure carbon theme colors on main window and listview controls.
- [x] Implement the `_OnEnterPressed` callback handler.
- [x] Implement the `_GetAllVisibleBrowserWindows`, `_GetWindowAtGridPosition`, `_GetGridCoordinates`, and `_MoveWindowToGridPosition` collision handling helpers.

## ⚙️ New Settings
[[#^toc-new-settings|TOC]]
- [x] Add `$aBrowsers` configuration metrics inside the centralized layout script.

## 🕹️ New Commands
[[#^toc-new-commands|TOC]]
- [x] Command: `_HandleAction`
  - Targets, focuses, and launches browsers favoring active, visible windows.

## ⌨️ New Bindings
[[#^toc-new-bindings|TOC]]
- [x] Binding: `Win + AppsKey` (ContextMenu Key)
  - Toggles manager visibility from anywhere.
- [x] Dual-case letter hotkeys (lowercase/uppercase browser mapping) to prevent Shift/CapsLock lockouts.

## 🚀 New Features
[[#^toc-new-features|TOC]]
- [x] Feature Name: Visible Window Z-Order Filtering
  - Isolate active user-facing windows and ignore hidden background process elements.

---

## 🛑 Blocked Items & Impediments
[[#^toc-blocked|TOC]]
- None.

---

## 🗃️ Completed Backlog (Archive)
[[#^toc-backlog|TOC]]
- [x] **Consolidate Codebase and Fix Include Compilation Errors** (Completed on 2026-06-27)
- [x] **Implement Topmost Visible Window Z-Index Logic** (Completed on 2026-06-27)
- [x] **Complete Structured Markdown Documentation Suite** (Completed on 2026-06-27)

### 🛠️ Settings
[[#^toc-arch-settings|TOC]]
- [x] Mapped standard array declarations `$aBrowsers`.

### 💻 Commands
[[#^toc-arch-commands|TOC]]
- [x] Mapped `_ToggleGUI`, `_OnShortcut`, `_OnGridHotkey`, and `_OnSwapHotkey`.

### 🔗 Bindings
[[#^toc-arch-bindings|TOC]]
- [x] Connected letter keys, ctrl keys, numerical snaps, and shift loaders to Dummy controls.

### 📦 Features
[[#^toc-arch-features|TOC]]
- [x] Overlaid orange highlighted borders, active layout snap calculations, and browser process listings.

---
## 🚀 Go to...
[[#^toc-goto|TOC]]
- 🔹 [AGENTS.md](../AGENTS.md)
- 🔹 [ARCHIVE.md](ARCHIVE.md)
- 🔹 [BUILD.md](BUILD.md)
- 🔹 [CODE.md](CODE.md)
- 🔹 [DESIGN.md](DESIGN.md)
- 🔹 [FEATURES.md](FEATURES.md)
- 🔹 [LOG.md](LOG.md)
- 🔹 [MANUAL.md](MANUAL.md)
- 🔹 [README.md](../README.md)
- 🔹 [SPEC.md](SPEC.md)
- 🔸 [TASKS.md](TASKS.md)
- 🔹 [TERMS.md](TERMS.md)
- 🔹 [TESTING.md](TESTING.md)
- 🔹 [VERSIONS.md](VERSIONS.md)
