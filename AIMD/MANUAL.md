# MANUAL

## 📑 AI Primary Files
- 🔹 [AGENTS.md](../AGENTS.md)
- 🔹 [ARCHIVE.md](ARCHIVE.md)
- 🔹 [BUILD.md](BUILD.md)
- 🔹 [CODE.md](CODE.md)
- 🔹 [DESIGN.md](DESIGN.md)
- 🔹 [FEATURES.md](FEATURES.md)
- 🔹 [LOG.md](LOG.md)
- 🔸 [MANUAL.md](MANUAL.md)
- 🔹 [README.md](../README.md)
- 🔹 [SPEC.md](SPEC.md)
- 🔹 [TASKS.md](TASKS.md)
- 🔹 [TERMS.md](TERMS.md)
- 🔹 [TESTING.md](TESTING.md)
- 🔹 [VERSIONS.md](VERSIONS.md)

## 🔍 Table of Contents
- [[#📥 Installation & Initial Deployment]] ^toc-install
- [[#🏗️ 1. Architecture Overview]] ^toc-architecture
- [[#🧠 2. Core Modules & Systems]] ^toc-modules
- [[#🔎 3. Core Algorithm & Mathematical Formulas]] ^toc-math
- [[#🛰️ 4. Commands, Keybindings & Context Flags]] ^toc-commands
- [[#🔧 5. Workspace Build & Configuration]] ^toc-config
- [[#🔍 Diagnostics & Common Troubleshooting]] ^toc-diagnostics
- [[#Go to...]] ^toc-goto

This guide describes the structural architecture, module layout, internal algorithms, optimization behaviors, and technical specifications of the **OS Desk Browsers** codebase.

---

## 📥 Installation & Initial Deployment
[[#^toc-install|TOC]]

### Setup Sequence
- 1. **Compile/Build Assets:** Run `npm run compile` to invoke Aut2exe and compile `desk-browsers.au3` into `BrowserManager.exe`.
- 2. **Apply Configurations:** Ensure target browsers (Brave, Chrome, Edge, Vivaldi, Firefox) are installed in their standard system locations.
- 3. **Register Components:** Move the compiled `BrowserManager.exe` to your Windows startup directory or register a shortcut on your desktop for continuous usage.

---

## 🏗️ 1. Architecture Overview
[[#^toc-architecture|TOC]]
```text
 +-----------------------------------------------------------------+
 |                     AutoIt Window Manager GUI                   |
 +-------------------------------+---------------------------------+
                                 |
                                 v
 +-------------------------------+---------------------------------+
 |                    Central Event Dispatcher                     |
 |             (Accelerator Array / Dummy Controls)                |
 +-------------------------------+---------------------------------+
                                 |
           +---------------------+---------------------+
           |                                           |
           v                                           v
 +---------+---------------------+           +---------+-----------+
 |     Active Timer Loop         |           |   Windows APIs      |
 |   (Highlight Overlay / Z)     |           | (user32/gdi32/shell)|
 +-------------------------------+           +---------------------+
```
The application executes as a continuous single process. HotKey events trigger standard Accelerator maps bound to hidden Dummy controls inside the GUI, which immediately executes the target tiling, activation, or tab manipulation functions.

---

## 🧠 2. Core Modules & Systems
[[#^toc-modules|TOC]]
- **Variables & Arrays Configurator**: Defines `$aBrowsers` containing regex markers, process names, paths, and letter shortcuts.
- **Graphic Overlays (GDI Border)**: Invokes User32 and GDI32 APIs to draw an orange outline wrapping the selected browser window dynamically, without focus loss.
- **Active Refresh Monitor**: Periodically queries browser instances, Z-order rankings, and minimizes ratios to update the main ListView dashboard.
- **Accelerator Event Handler**: Intercepts local hotkeys when the window manager GUI is focused and redirects them to logical helper routines (`_OnShortcut`, `_OnGridHotkey`, `_OnSwapHotkey`).

---

## 🔎 3. Core Algorithm & Mathematical Formulas
[[#^toc-math|TOC]]
Desktop snapping splits the main monitor into a clean 3x3 layout. The monitor width is $W$ and height is $H$. 

The base grid cells are calculated dynamically as:
$$C_w = \text{Int}\left(\frac{W}{3}\right)$$
$$C_h = \text{Int}\left(\frac{H}{3}\right)$$

For a grid position $P \in \{1, 2, \dots, 9\}$:
$$\text{Column} = \text{Mod}(P - 1, 3)$$
$$\text{Row} = \text{Int}\left(\frac{P - 1}{3}\right)$$
$$X = \text{Column} \times C_w$$
$$Y = \text{Row} \times C_h$$

For the central focal overlay ($P = 0$):
$$\text{NewWidth} = \text{Int}\left(\frac{W \times 5}{9}\right)$$
$$\text{NewHeight} = \text{Int}\left(\frac{H \times 5}{9}\right)$$
$$X = \text{Int}\left(\frac{W - \text{NewWidth}}{2}\right)$$
$$Y = \text{Int}\left(\frac{H - \text{NewHeight}}{2}\right)$$

---

## 🛰️ 4. Commands, Keybindings & Context Flags
[[#^toc-commands|TOC]]
- **Window Activation / Execution**:
  - **Key combinations**: `B`, `C`, `E`, `V`, `F`, `P`
  - **Contextual triggers**: Manager window focused.
  - **Logical callback**: Activates or executes Brave, Chrome, Edge, Vivaldi, Firefox, or Browser Picker respectively, favoring the highest visible window in the Z-order.
- **Safely Close Window**:
  - **Key combinations**: `Ctrl + B`, `Ctrl + C`, `Ctrl + E`, `Ctrl + V`, `Ctrl + F`, `Ctrl + P`
  - **Logical callback**: Sends `WinClose` to the topmost visible window matching the target browser profile.
- **Grid Snapping**:
  - **Key combinations**: `1` to `9` (Numpad grids) and `0` (Center screen snap).
  - **Logical callback**: Moves and resizes the selected browser window to the designated screen segment.
- **Position Swap**:
  - **Key combinations**: `Ctrl + 1` to `Ctrl + 9`
  - **Logical callback**: Swaps the coordinates of the peripheral cell window with the center window.

---

## 🔧 5. Workspace Build & Configuration
[[#^toc-config|TOC]]
- **Environment Variable:** `PATH`
  - **Purpose:** Locates the folder containing `autoit3.exe` and `Aut2exe.exe` to allow compiler scripting.
  - **Expected Format:** `C:\Program Files (x86)\AutoIt3` (No trailing backslash)
- **`desk-browsers.au3`**:
  - **Configuration Section/Field**: `$aBrowsers`
  - **Description**: The 2D initialization array mapping browser records. Users can add or modify index fields to support alternative web browsers.

---

## 🔍 Diagnostics & Common Troubleshooting
[[#^toc-diagnostics|TOC]]

### Known Failure States & Remediations

#### 🚨 Symptom: "Windows cannot be moved or GDI borders do not render."
- **Root Cause:** The target browser is running with Elevated (Administrator) permissions, blocking standard User-level calls from resizing its frame.
- **Remediation:** Compile the utility with `#RequireAdmin` directive enabled and run as Administrator.

#### 🚨 Symptom: "URL copying captures wrong strings."
- **Root Cause:** Slow address-bar rendering times cause the keystrokes `Ctrl+L` and `Ctrl+C` to trigger before the browser finishes focusing.
- **Remediation:** Adjust sleep delays inside the `_OnCopyUrl()` function to accommodate machine speed.

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
- 🔸 [MANUAL.md](MANUAL.md)
- 🔹 [README.md](../README.md)
- 🔹 [SPEC.md](SPEC.md)
- 🔹 [TASKS.md](TASKS.md)
- 🔹 [TERMS.md](TERMS.md)
- 🔹 [TESTING.md](TESTING.md)
- 🔹 [VERSIONS.md](VERSIONS.md)
