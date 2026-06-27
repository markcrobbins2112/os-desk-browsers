# DESIGN

## 📑 AI Primary Files
- 🔹 [AGENTS.md](../AGENTS.md)
- 🔹 [ARCHIVE.md](ARCHIVE.md)
- 🔹 [BUILD.md](BUILD.md)
- 🔹 [CODE.md](CODE.md)
- 🔸 [DESIGN.md](DESIGN.md)
- 🔹 [FEATURES.md](FEATURES.md)
- 🔹 [LOG.md](LOG.md)
- 🔹 [MANUAL.md](MANUAL.md)
- 🔹 [README.md](../README.md)
- 🔹 [SPEC.md](SPEC.md)
- 🔹 [TASKS.md](TASKS.md)
- 🔹 [TERMS.md](TERMS.md)
- 🔹 [TESTING.md](TESTING.md)
- 🔹 [VERSIONS.md](VERSIONS.md)

## 🔍 Table of Contents
- [[#🗺️ System Topology & Context Map]] ^toc-topology
- [[#💻 High-Level Components & Communication]] ^toc-components
- [[#💾 Data Architecture & Schema Rules]] ^toc-data
- [[#📂 Core File Structure Layout]] ^toc-layout
- [[#🚦 Design Principles & Guardrails]] ^toc-guardrails
- [[#🚀 Go to...]] ^toc-goto

## 🗺️ System Topology & Context Map
[[#^toc-topology|TOC]]
- **Architecture Style:** Event-driven desktop orchestration wrapper and window tiling engine.
- **Primary Language Stack:** AutoIt v3 Scripting Language.
- **Frameworks & Core Runtimes:** Native Win32 API subsystems (`user32.dll`, `gdi32.dll`, `shell32.dll`) referenced via AutoIt's built-in `WinAPI.au3` library.

## 💻 High-Level Components & Communication
[[#^toc-components|TOC]]
- **Frontend/Client:** A rich AutoIt GUI dashboard containing a main ListView with loaded executable icons. It displays current browser statuses, shortcut key configurations, running instance tallies, active 3x3 grid indices, and minimized ratios in real-time.
- **Backend Core:** A multi-layered control routine consisting of:
  - **Z-Order Checking & Highlight Loop:** Runs on a timer loop to draw active overlays around the chosen browser instance.
  - **Accelerator Key Dispatcher:** Map user keystrokes (such as letter keys, control actions, grid snaps) to hidden `GUICtrlCreateDummy` elements, triggering designated AutoIt functions.
- **External Integration:** Manipulates standard Windows desktop structures. Executes executable files via `Run` and monitors/tiles third-party windows using standard Win32 handle controllers.

---

## 💾 Data Architecture & Schema Rules
[[#^toc-data|TOC]]
- **Storage Type:** Transient local memory arrays. The primary database consists of a 2D array `$aBrowsers[6][5]` defining:
  - Index 0: Browser Name (e.g. `"Brave"`)
  - Index 1: Suffix Matcher (e.g. `"Brave"`)
  - Index 2: Program Path (e.g. `"C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"`)
  - Index 3: Process Executable Name (e.g. `"brave.exe"`)
  - Index 4: HotKey Activation Letter (e.g. `"B"`)
- **State Constraints:** Dynamic detection. Browser execution and window states are determined at runtime via regex title searches (`[REGEXPTITLE:(?i).*<suffix>$]`), keeping the state permanently synchronized without local storage serialization dependencies.

## 📂 Core File Structure Layout
[[#^toc-layout|TOC]]
```text
📂 Project Root/
├── desk-browsers.au3       # Core script incorporating GDI, UI and hotkey bindings
├── package.json            # Packaging configurations and linter definitions
└── 📂 AIMD/                # Structured technical system documentation
```

---

## 🚦 Design Principles & Guardrails
[[#^toc-guardrails|TOC]]
- **Dependency Minimization:** Exclusively uses native AutoIt core libraries (no external third-party DLLs required).
- **Separation of Concerns:** Sections are split into clear logical zones: arrays initialization, interface generation, hotkey mapping, active pooling loop, and event callback structures.
- **Security Constraints:** Elevated privileges (`#RequireAdmin`) are mandatory to ensure that browser windows running with different user permissions can be correctly resized, focused, and wrapped with custom borders.

---
## 🚀 Go to...
[[#^toc-goto|TOC]]
- 🔹 [AGENTS.md](../AGENTS.md)
- 🔹 [ARCHIVE.md](ARCHIVE.md)
- 🔹 [BUILD.md](BUILD.md)
- 🔹 [CODE.md](CODE.md)
- 🔸 [DESIGN.md](DESIGN.md)
- 🔹 [FEATURES.md](FEATURES.md)
- 🔹 [LOG.md](LOG.md)
- 🔹 [MANUAL.md](MANUAL.md)
- 🔹 [README.md](../README.md)
- 🔹 [SPEC.md](SPEC.md)
- 🔹 [TASKS.md](TASKS.md)
- 🔹 [TERMS.md](TERMS.md)
- 🔹 [TESTING.md](TESTING.md)
- 🔹 [VERSIONS.md](VERSIONS.md)
