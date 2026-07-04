---
title: VERSIONS
---

# VERSIONS

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
- 🔹 [TESTING.md](TESTING.md)
- 🔸 [VERSIONS.md](VERSIONS.md)

## 🔍 Table of Contents
- [[#🚀 Stable Releases & Milestones]] ^toc-stable
- [[#🏗️ Pre-Release Iterations (Alpha/Beta Sandbox)]] ^toc-prerelease
- [[#🚀 Go to...]] ^toc-goto

## 🚀 Stable Releases & Milestones
[[#^toc-stable|TOC]]

### 🏷️ v1.4.0 (2026-07-04) - External INI Configuration & Copyable Clipboard Cheat Sheet
- **Added / Enhanced:**
  - **Dynamic INI Configuration (`desk-browsers.ini`)**: Externalized all browser names, regex matching titles, executable launch paths, process names, and hotkey letters out of code. If missing, it self-bootstraps with resolved absolute paths, enabling robust end-user customization.
  - **Copy Cheat Sheet Button**: Integrated a brand-orange native button on the Help dialog to copy a condensed plaintext summary of all mapped hotkeys instantly.
  - **Transient ToolTip Status**: Implemented a temporary 2-second ToolTip message overlay upon copying, providing smooth interactive confirmation.

### 🏷️ v1.3.0 (2026-07-04) - Hotkey Conflict Resolution & Fallback Tab Forwarding
- **Added / Enhanced:**
  - **Conflict-Free Accelerator Handling**: Skipped standard `Ctrl+0-9` duplicate accelerator entries in the browser key section of `db-keys.au3` to resolve system mapping collisions.
  - **Dynamic Tab Switching Fallback**: Configured the grid closure event (`Ctrl+0-9`) to dynamically detect if a window is active on that position. If no window is present, it acts as a pass-through, forwarding `Ctrl+0-9` directly to the active browser to trigger standard browser tab switching smoothly.
- **Fixed / Patched:**
  - **Keyboard Bindings Audit**: Verified that all requested keys, including tab movement, splits, cascading, and clipboard integrations, map flawlessly to their intended operational handlers.

### 🏷️ v1.2.0 (2026-06-27) - Z-Order Optimization & Technical Documentation Suite
- **Added / Enhanced:**
  - **Topmost Visible Window Selection**: Modified window selection algorithms to filter out suspended background processes and target standard visible browser windows.
  - **GDI Overlay Optimization**: Formulated non-focus-stealing border highlight overlays wrapping targeted browsers.
  - **Comprehensive Developer Manuals**: Populated complete sets of architectural topologies, keyboard mappings, equations, and testing guidelines.
- **Fixed / Patched:**
  - **Path Lookup Failures**: Consolidated separate components into a unified script structure, resolving cross-link relative path inclusion bugs.
  - **Input Focus Lock**: Solved focus-stealing bugs occurring when drawing active browser highlights.
- **Breaking Changes & Remediations:**
  - Obsolete modular split scripts (`actions_engine.au3`, `actions_gdi.au3`, `actions_ui.au3`, `events.au3`, `shared_globals.au3`) were deleted.
    - *Remediation:* Clean the directory and update your build compiler commands to strictly target the single centralized entry point `desk-browsers.au3`.

### 🏷️ v1.0.0 (2026-06-23) - Baseline Production Launch
- **Summary:** Initial production launch of the browser selector and desktop window tiling manager.
- **Core Capabilities:**
  - Multi-browser quick launch and active process tracking list.
  - Keyboard accelerators for launching, activating, and closing browsers.
  - Standard 3x3 layout coordinate snappers.

---

## 🏗️ Pre-Release Iterations (Alpha/Beta Sandbox)
[[#^toc-prerelease|TOC]]

### 🏷️ v0.1.0-beta (2026-06-15)
- **Milestone:** Baseline development sandbox proving GDI32 layered window border overlay draws and standard Win32 User32 window placement logic.

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
- 🔹 [TESTING.md](TESTING.md)
- 🔸 [VERSIONS.md](VERSIONS.md)
