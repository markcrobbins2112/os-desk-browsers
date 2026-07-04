---
title: TASKS
---

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
- [x] Externalize all browser names, match patterns, local execution paths, exe names, and hotkeys to `desk-browsers.ini` and build an dynamic bootstrapper load engine.
- [x] Integrate a high-contrast orange "Copy Cheat Sheet" button onto the Help Guide Dialog.
- [x] Code `_HelpGUI_CopyCheatSheet()` to format and write a beautifully organized plain-text shortcut guide category directly to the clipboard.
- [x] Implement a temporary 2-second tooltip confirmation popup for successful copies.
- [x] Validate and fix browser hotkey mapping conflicts between grid closure commands and tab switching shortcuts (`Ctrl+0-9`).
- [x] Forward `Ctrl+1-9` keys dynamically to standard browser tab selection if target grid slot is unoccupied.
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
- [x] Redesign Help Dialog to be a gorgeous standard dialog with borderless embedded-HTML and professional dark theme styling.
- [x] Refactor all white background elements of the main UI into medium grey.
- [x] Map Alt+0-9 to move focus indicator (orange border) to the window at that grid position and bring it to top.
- [x] Refactor PageUp, PageDown, and Delete to use brief activation and Send keys targeting the indicated window (Page Up and Page Down send Ctrl+Page Up and Ctrl+Page Down under the hood to change tabs).
- [x] Map Esc to close the Help dialog gracefully.
- [x] Remove iframe-like border around the HTML in the embedded Help viewer.
- [x] Map Ctrl+PageUp and Ctrl+PageDown to cycle all windows currently on the grid to adjacent positions.
- [x] Map Ctrl+C to copy URL of the indicated browser window.
- [x] Map Ctrl+Shift+PageUp and Ctrl+Shift+PageDown to move the indicated browser's active tab left and right.
- [x] Map Insert to open a new empty tab on the indicated browser window.
- [x] Map Ctrl+V and Shift+Insert to create a new tab on the indicated browser with the clipboard URL.
- [x] Map Shift+Enter to create a new browser window with the current tab's URL.
- [x] Map F1 to open the Help guide window.
- [x] Map Esc within the Help GUI context to close it instantly.
- [x] Map Ctrl+Shift+0-9 to copy the current window's URL and open it as a new tab on the browser window at that grid position.
- [x] Make the Help guide dialog window 60% taller (from 560 to 896 px height).
- [x] Add Opera support to the list of managed browsers, dynamically detecting install paths.
- [x] Map Ctrl+Left, Ctrl+Right, Ctrl+Up, and Ctrl+Down to indicate/focus the browser window in that physical direction.
- [x] Map Ctrl+= and Ctrl+- to Zoom In and Zoom Out on the indicated browser window.
- [x] Map Alt+Left and Alt+Right to navigate Back and Forward in the history of the indicated browser.

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
