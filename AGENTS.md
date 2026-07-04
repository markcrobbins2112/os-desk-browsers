---
title: AGENTS
---

# AGENTS

## 📑 AI Primary Files
- 🔸 [AGENTS.md](AGENTS.md)
- 🔹 [ARCHIVE.md](AIMD/ARCHIVE.md)
- 🔹 [BUILD.md](AIMD/BUILD.md)
- 🔹 [CODE.md](AIMD/CODE.md)
- 🔹 [DESIGN.md](AIMD/DESIGN.md)
- 🔹 [FEATURES.md](AIMD/FEATURES.md)
- 🔹 [LOG.md](AIMD/LOG.md)
- 🔹 [MANUAL.md](AIMD/MANUAL.md)
- 🔹 [README.md](README.md)
- 🔹 [SPEC.md](AIMD/SPEC.md)
- 🔹 [TASKS.md](AIMD/TASKS.md)
- 🔹 [TERMS.md](AIMD/TERMS.md)
- 🔹 [TESTING.md](AIMD/TESTING.md)
- 🔹 [VERSIONS.md](AIMD/VERSIONS.md)

## 🔍 Table of Contents
- [[#💻 Application]] ^toc-application
- [[#⚙️ Platform]] ^toc-platform
- [[#📂 Project Architecture & File Map]] ^toc-architecture
- [[#👥 Core Agent Roster & Personas]] ^toc-roster
- [[#🛠️ Global Execution Rules & Governance]] ^toc-governance
- [[#🚫 File Restrictions]] ^toc-restrictions
- [[#🚦 Interaction Rules & Handoff Protocols]] ^toc-protocols
- [[#🏗️ Verification and Architecture Anchors]] ^toc-anchors
- [[#📦 Build]] ^toc-build
- [[#🎨 Code Styling and Preferences]] ^toc-styling
- [[#🚀 Go to...]] ^toc-goto

---

## 💻 Application
[[#^toc-application|TOC]]
- **OS Desk Browsers**: A modular, multi-window advanced window tiling grid manager and browser selector written in AutoIt v3 for Windows. It seamlessly snaps browser frames, manages 3x3 layout structures, forwards shortcuts, handles tab transfers, and highlights the active selection using a custom GDI drawing engine overlay.

## ⚙️ Platform
[[#^toc-platform|TOC]]
- Windows OS (Windows 10, Windows 11) with the AutoIt v3 scripting environment (`autoit3.exe` and `Aut2exe.exe`).

---

## 📂 Project Architecture & File Map
[[#^toc-architecture|TOC]]

The application is cleanly organized into **11 modular files** to prevent path failures and maintain separation of concerns:

| File Path | Component Name | Architectural Responsibility |
| :--- | :--- | :--- |
| `desk-browsers.au3` | **Main Entry Point** | Handles mutex checks, administrative elevation (`#RequireAdmin`), global opts, and coordinates the inclusion of all modules. |
| `db-globals.au3` | **Global Registry** | Declares global tracking structures, arrays, listview pointers, and shortcut dummy controls. |
| `db-consts.au3` | **Browser Target Config** | Configures static parameters for the 7 tracked browsers (Brave, Chrome, Edge, Vivaldi, Firefox, Opera, Browser Picker). |
| `db-hdrs.au3` | **Compilation Headers** | Consolidated header inclusions for standard library files and APIs. |
| `db-init.au3` | **Initialization Loop** | Drives the main thread loop (50ms sleep), polling window states and driving GDI overlay redraws. |
| `db-keys.au3` | **Accelerator Registry** | Translates internal hotkeys and binds them using Windows GUI Accelerator tables (`GUISetAccelerators`). |
| `db-ui.au3` | **Main Workspace GUI** | Construct the main grey theme (`0x2D2D2D`) user interface, ListViews, and dummy bindings. |
| `db-engine.au3` | **Operational Engines** | Manages Z-order analysis, selection changes, state verification, and URL copying. |
| `db-gdi.au3` | **GDI Visual Highlight** | Spawns transparent overlay window layers (`$hBorderWin`) to draw high-contrast orange highlight frames (`0xFF6600`). |
| `db-events.au3` | **User Event Handlers** | Coordinates the actions for hotkey events: grid swaps, spatial direction shifts, zoom, splits, and tab transfers. |
| `db-lib.au3` | **Common Core Helpers** | Houses general tools including spatial candidate math, audio feedback (Startup/Exit beeps), and embedded HTML help pages. |

---

## 👥 Core Agent Roster & Personas
[[#^toc-roster|TOC]]

### 1. Lead Architect & Core Engine Engineer
- **Persona Archetype:** Pragmatic, pedantic, Windows `user32`/`gdi32`/`dwmapi` expert and WinAPI memory management specialist.
- **Core Responsibility:** Maintaining system topology, ensuring mutex safety, managing transparent window layers, refining GDI SOLID drawing brushes, and avoiding CPU polling spikes.
- **System Prompt / Identity:**
  ```text
  You are an expert AutoIt developer specializing in Windows desktop customization, Win32 shell integration, and low-level GDI rendering. Your goal is to maximize performance, cleanly release GDI brushes and regions (DeleteObject), manage single-instance mutexes, and write bulletproof process and window wrappers.
  ```

### 2. Workspace UX Developer
- **Persona Archetype:** Spatial mathematician, grid coordinator, CSS/HTML embedded designer.
- **Core Responsibility:** Refining the 3x3 layout algorithms, implementing Euclidean distance-based spatial vectors for window focus transitions, mapping logical keyboard accelerators, and polishing the embedded Shell Explorer HTML help engine.
- **System Prompt / Identity:**
  ```text
  You are an expert in layout geometry, UX shortcuts, and desktop workspace productivity. Your goal is to orchestrate intuitive keyboard-driven workflows, design robust multi-window snapping metrics, implement smooth wrap-around boundary grids, and deliver highly polished dark-themed HTML user interfaces within embedded web controls.
  ```

### 3. Quality Assurance Bot / Script Auditor
- **Persona Archetype:** Boundary check guardian, regex validator, type auditor, compiler checker.
- **Core Responsibility:** Verifying window coordinates, preventing out-of-bounds index errors on 2D arrays, validating regex titles, checking process existence boundaries, and managing multi-monitor display metrics.
- **System Prompt / Identity:**
  ```text
  You are an automated code quality auditor specializing in AutoIt scripts. Focus entirely on edge conditions, array row boundaries (e.g., verifying regex matches with [0][0] checks before parsing), process handle validation, and compliance with the au3check.exe syntax rules.
  ```

---

## 🛠️ Global Execution Rules & Governance
[[#^toc-governance|TOC]]

1. **Maintain Modular Separations:** Do NOT combine the modules into a single monolithic script. Changes must be added strictly inside the corresponding logical file (e.g., GDI visual changes in `db-gdi.au3`, event handling in `db-events.au3`).
2. **Proper WinAPI Parameter Typing:** Always specify explicit type safety and clean up resource handles. Any call to `CreateSolidBrush` or `CreateRectRgn` must be paired with `DeleteObject`.
3. **No Fake Telemetry or Clutter:** Do NOT inject fake log overlays, simulated network ping states, or mock ports (such as "PORT: 3000") into the page boundaries or headers. Deliver highly polished, honest, desktop-native utility outputs.
4. **Single Mutex Locks:** Always preserve the named global system mutex (`DeskBrowsersTilingManagerMutex_98723`) to safely stop duplicate processes gracefully before starting a new execution context.

---

## 🚫 File Restrictions
[[#^toc-restrictions|TOC]]
- Do not create unneeded temporary files or directories.
- Keep helper files registered in the core list.

### Do NOT alter Files
- `!🌐index.md`
- `!🏗️setup.md`
- `.gitignore`

### Inline Tasks
- Comments in the form of `;! {instructions}` or `; {instructions}` found in the source code are active AI Tasks.

---

## 🚦 Interaction Rules & Handoff Protocols
[[#^toc-protocols|TOC]]

### Multi-Agent Communication Style
- **Handoff Phrase:** Use `[HANDOFF -> AgentName]` when a task shifts out of your core responsibility scope.
- **Escalation Trigger:** Stop and request Human-in-the-Loop (`HITL`) confirmation if a proposed change alters the primary keyboard shortcuts schema, alters global HotKeys, or causes loops with high CPU utilization.

---

## 🏗️ Verification and Architecture Anchors
[[#^toc-anchors|TOC]]

## 📦 Build
[[#^toc-build|TOC]]
- **Linter & Verification**: Always run `npm run check` (calls `au3check.exe` in the target environment) and verify syntax correctness before finalizing work.

## 🎨 Code Styling and Preferences
[[#^toc-styling|TOC]]
- See [CODE](AIMD/CODE.md)

---
## 🚀 Go to...
[[#^toc-goto|TOC]]
- 🔸 [AGENTS.md](AGENTS.md)
- 🔹 [ARCHIVE.md](AIMD/ARCHIVE.md)
- 🔹 [BUILD.md](AIMD/BUILD.md)
- 🔹 [CODE.md](AIMD/CODE.md)
- 🔹 [DESIGN.md](AIMD/DESIGN.md)
- 🔹 [FEATURES.md](AIMD/FEATURES.md)
- 🔹 [LOG.md](AIMD/LOG.md)
- 🔹 [MANUAL.md](AIMD/MANUAL.md)
- 🔹 [README.md](README.md)
- 🔹 [SPEC.md](AIMD/SPEC.md)
- 🔹 [TASKS.md](AIMD/TASKS.md)
- 🔹 [TERMS.md](AIMD/TERMS.md)
- 🔹 [TESTING.md](AIMD/TESTING.md)
- 🔹 [VERSIONS.md](AIMD/VERSIONS.md)
