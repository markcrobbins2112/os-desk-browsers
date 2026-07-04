---
title: TESTING
---

# TESTING

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
- 🔹 [TASKS.md](TASKS.md)
- 🔹 [TERMS.md](TERMS.md)
- 🔸 [TESTING.md](TESTING.md)
- 🔹 [VERSIONS.md](VERSIONS.md)

## 🔍 Table of Contents
- [[#🔵 1. Setup & Environment Initializations]] ^toc-setup
- [[#🟢 2. Primary Functionality & Core Operations]] ^toc-core
- [[#⚡ 3. Granular Property Checks & Edge Boundaries]] ^toc-edge
- [[#🕹️ 4. Layout, Rendering & States Loops]] ^toc-rendering
- [[#🚀 5. Advanced Integrations, Backends & Performance Checks]] ^toc-advanced
- [[#🗃️ QA Validation History (Sign-Off Log)]] ^toc-history
- [[#🚀 Go to...]] ^toc-goto

You can use this interactive test sheet to verify all functional systems of **OS Desk Browsers** are fully operational. Mark the checklists as done!

---

## 🔵 1. Setup & Environment Initializations
[[#^toc-setup|TOC]]
- [ ] **Administrator Elevation Validation**
  - **Instructions**: Launch the compiled executable `BrowserManager.exe`.
  - **Expected Results**: Prompt appears asking for standard Administrator elevation. Launches successfully with administrator privileges.
- [ ] **Syntax Linter Checklist**
  - **Instructions**: Run `npm run check` inside the workspace console.
  - **Expected Results**: `au3check` runs successfully and reports 0 undeclared variables, warning lines, or execution errors.

## 🟢 2. Primary Functionality & Core Operations
[[#^toc-core|TOC]]
- [ ] **Single-Letter Browser Selector**
  - **Instructions**: Focus the manager GUI. Press key `B`, `C`, or `E`.
  - **Expected Results**: Targeted browser (Brave, Chrome, Edge) brings its highest visible window in the Z-order to the front. Launches the browser if not currently running.
- [ ] **Window Closure Accelerator**
  - **Instructions**: Select a running browser in the ListView. Press `Ctrl + Letter` (e.g. `Ctrl + B` for Brave).
  - **Expected Results**: Safely triggers `WinClose` closing exclusively the topmost active window frame of that browser.

## ⚡ 3. Granular Property Checks & Edge Boundaries
[[#^toc-edge|TOC]]
- [ ] **Desktop Grid Snapping**
  - **Instructions**: Select a running browser. Press numerical keys `1` to `9` to snap to perimeter cells, and `0` for center.
  - **Expected Results**: Resizes and moves the target window instantly to the respective 1/3 screen quadrant, and center key resizes to a balanced 5/9 ratio.
- [ ] **Peripheral Swap Control**
  - **Instructions**: Put browser A in the center (grid 5) and browser B in the top-left (grid 1). Focus browser B in the list and press `Ctrl + 1`.
  - **Expected Results**: Browser B moves to the center (grid 5), while browser A shifts back to the top-left corner (grid 1) seamlessly.

## 🕹️ 4. Layout, Rendering & States Loops
[[#^toc-rendering|TOC]]
- [ ] **Non-Focus-Stealing Highlight Overlay**
  - **Instructions**: Select a running browser. Check visual decorations.
  - **Expected Results**: A sharp orange border draws wrapped around the active window. Confirm selecting browser list items does not cause active input focus loss on browser forms.
- [ ] **System Tray Toggle Loop**
  - **Instructions**: Press `Escape` while focusing the GUI. Then press `Win + AppsKey` global hotkey.
  - **Expected Results**: Esc minimizes the manager GUI completely to the system tray. Pressing the global hotkey toggles visibility instantly.

## 🚀 5. Advanced Integrations, Backends & Performance Checks
[[#^toc-advanced|TOC]]
- [ ] **Context Active Tab Scrolling**
  - **Instructions**: Highlight a running browser in the manager list. Press `PageUp` or `PageDown`.
  - **Expected Results**: Tab shifts inside the selected browser instantly, cycling active pages.
- [ ] **Clipboard URL Injector**
  - **Instructions**: Copy a URL (e.g., `https://google.com`) to the clipboard. Focus manager GUI and press `Shift+Insert`.
  - **Expected Results**: Parses URL cleanly and triggers ShellExecute opening a new webpage tab inside the focused browser.

---

## 🗃️ QA Validation History (Sign-Off Log)
[[#^toc-history|TOC]]

### 📅 [2026-06-27] - Build v1.2.0
- **Testing Agent:** Quality Assurance Bot
- **Passed Cases:** Administrator Elevation Validation, Syntax Linter Checklist, Single-Letter Browser Selector, Window Closure Accelerator, Desktop Grid Snapping, Peripheral Swap Control, Non-Focus-Stealing Highlight Overlay, System Tray Toggle Loop, Context Active Tab Scrolling, Clipboard URL Injector.
- **Failed Cases / Notes:** None. Build is fully validated.
- **Status:** `[PASSED / READY FOR PRODUCTION]`

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
- 🔹 [TASKS.md](TASKS.md)
- 🔹 [TERMS.md](TERMS.md)
- 🔸 [TESTING.md](TESTING.md)
- 🔹 [VERSIONS.md](VERSIONS.md)
