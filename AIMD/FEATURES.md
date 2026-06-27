# FEATURES

## 📑 AI Primary Files
- 🔹 [AGENTS.md](../AGENTS.md)
- 🔹 [ARCHIVE.md](ARCHIVE.md)
- 🔹 [BUILD.md](BUILD.md)
- 🔹 [CODE.md](CODE.md)
- 🔹 [DESIGN.md](DESIGN.md)
- 🔸 [FEATURES.md](FEATURES.md)
- 🔹 [LOG.md](LOG.md)
- 🔹 [MANUAL.md](MANUAL.md)
- 🔹 [README.md](../README.md)
- 🔹 [SPEC.md](SPEC.md)
- 🔹 [TASKS.md](TASKS.md)
- 🔹 [TERMS.md](TERMS.md)
- 🔹 [TESTING.md](TESTING.md)
- 🔹 [VERSIONS.md](VERSIONS.md)

## 🔍 Table of Contents
- [[#📦 Feature Groups]] ^toc-groups
- [[#🗄️ All Features]] ^toc-all-features
- [[#📉 Deprecated / Removed Features]] ^toc-deprecated
- [[#🚀 Go to...]] ^toc-goto

Welcome to OS Desk Browsers! A high-performance keyboard-driven utility that turns standard browser frames into a beautifully controlled tiled window environment, allowing instant snapping, tab operations, and rapid layout swaps.

## 📦 Feature Groups
[[#^toc-groups|TOC]]

### 🖥️ 1. Automated Layout Management ^z1
Manages coordinates, sizes, and positioning structures of browser frames on your desktop.
- **[Window Grid Tiling](#[window-grid-tiling])** - Snap browser windows instantly to a precise 3x3 desktop layout or a custom center frame.
- **[Center Position Exchange](#[center-position-exchange])** - Swap active coordinates of the center screen window with any peripheral cell window.

### 🕹️ 2. Context Navigation & Shortcut Handlers ^z2
Provides keyboard-driven commands to launch, activate, control, and manipulate browser windows.
- **[Multi-Browser Selector](#[multi-browser-selector])** - Activate or run specific browsers using simple letter hotkeys, featuring process status monitoring.
- **[Active Tab Scrolling](#[active-tab-scrolling])** - Cycle tabs backwards and forwards without manually activating the target browser.
- **[Clipboard Tab Loader](#[clipboard-tab-loader])** - Read text urls from clipboard and execute new browser tabs instantly.
- **[Active URL Capture](#[active-url-capture])** - Send input requests to copy URLs directly into the clipboard.
- **[Orange Border Indicator](#[orange-border-indicator])** - Overlays a custom GDI border highlighting the target window in real-time.
- **[Tray Minimization](#[tray-minimization])** - Hides the manager window to the system tray using system-wide hotkeys.

---

## 🗄️ All Features
[[#^toc-all-features|TOC]]

### Window Grid Tiling
- **Group:** [[#^z1|Automated Layout Management]]
Allows snapping the active browser window into a clean 3x3 layout. Keys `1` to `9` correspond to the standard numpad grids, while key `0` snaps the window to the center with a proportional 5/9 desktop ratio, enabling multi-pane development.

### Center Position Exchange
- **Group:** [[#^z1|Automated Layout Management]]
Swaps the center workspace window (snapped at grid position 5) with any surrounding cell window. Pressing `Ctrl + 1` to `Ctrl + 9` automatically moves the selected outer window to the center while shifting the old center window to the outer coordinate space.

### Multi-Browser Selector
- **Group:** [[#^z2|Context Navigation & Shortcut Handlers]]
Instantly launches or brings to front Brave (`B`), Chrome (`C`), Edge (`E`), Vivaldi (`V`), Firefox (`F`), or Browser Picker (`P`). If multiple instances are open, it activates the topmost window prioritizing the highest Z-index.

### Active Tab Scrolling
- **Group:** [[#^z2|Context Navigation & Shortcut Handlers]]
Enables keyboard scroll switching. Pressing `PageUp` or `PageDown` automatically relays a `Ctrl+Shift+Tab` or `Ctrl+Tab` to the selected browser, cycling tabs quickly.

### Clipboard Tab Loader
- **Group:** [[#^z2|Context Navigation & Shortcut Handlers]]
Extracts URLs stored on the user clipboard. Pressing `Shift+Insert` parses the clipboard string and automatically launches it inside the selected browser using standard ShellExecute parameters.

### Active URL Capture
- **Group:** [[#^z2|Context Navigation & Shortcut Handlers]]
Copies the current URL from the browser. Pressing `Ctrl+C` sends standard input focuses (`Ctrl+L` followed by `Ctrl+C`) to the target browser and captures the active tab's web address silently.

### Orange Border Indicator
- **Group:** [[#^z2|Context Navigation & Shortcut Handlers]]
Draws an orange-colored visual indicator around the selected browser window frame using GDI API overlays, helping users quickly identify the active control context.

### Tray Minimization
- **Group:** [[#^z2|Context Navigation & Shortcut Handlers]]
Hides the window. Users can press `Escape` to minimize the manager window to the system tray. Pressing the global hotkey `Win + AppsKey` instantly toggles visibility from anywhere.

---

## 📉 Deprecated / Removed Features
[[#^toc-deprecated|TOC]]
- **[!] Independent Script Process Monitoring:** Background polling script was previously used to check process states independently.
  - **Replacement Pattern:** Merged into the main Timer check refresh loop inside `desk-browsers.au3`, which reads process and window lists directly via standard `WinList()` title filtering.

---
## 🚀 Go to...
[[#^toc-goto|TOC]]
- 🔹 [AGENTS.md](../AGENTS.md)
- 🔹 [ARCHIVE.md](ARCHIVE.md)
- 🔹 [BUILD.md](BUILD.md)
- 🔹 [CODE.md](CODE.md)
- 🔹 [DESIGN.md](DESIGN.md)
- 🔸 [FEATURES.md](FEATURES.md)
- 🔹 [LOG.md](LOG.md)
- 🔹 [MANUAL.md](MANUAL.md)
- 🔹 [README.md](../README.md)
- 🔹 [SPEC.md](SPEC.md)
- 🔹 [TASKS.md](TASKS.md)
- 🔹 [TERMS.md](TERMS.md)
- 🔹 [TESTING.md](TESTING.md)
- 🔹 [VERSIONS.md](VERSIONS.md)
