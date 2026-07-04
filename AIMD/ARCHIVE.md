---
title: ARCHIVE
---

# ARCHIVE

## 📑 AI Primary Files
- 🔹 [AGENTS.md](../AGENTS.md)
- 🔸 [ARCHIVE.md](ARCHIVE.md)
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
- 🔹 [VERSIONS.md](VERSIONS.md)

## 🔍 Table of Contents
- [[#🚪 Retired Features & Components]] ^toc-retired
- [[#💾 Legacy Code Snippets & Discarded Scripts]] ^toc-snippets
- [[#📑 Obsolete Specifications & Scrapped Ideas]] ^toc-scrapped
- [[#🚀 Go to...]] ^toc-goto

## 🚪 Retired Features & Components
[[#^toc-retired|TOC]]

### ❌ Modular Multi-File Layout
- **Active Lifespan:** `v1.0.0` to `v1.0.1` (Retired on 2026-06-27)
- **Reason for Retirement:** Multi-file relative paths and `#include` statements was causing file lookup collisions, relative path resolving failures, and compilation pipeline overhead.
- **Superseded By:** Consolidated single-file layout in `desk-browsers.au3`, integrating all globals, GDI drawings, UI events, and the core window selection engine in a beautifully structured unified file.

---

## 💾 Legacy Code Snippets & Discarded Scripts
[[#^toc-snippets|TOC]]

### 📜 Discarded File Split Structures
- **Context:** The codebase was previously split into five separate action and event files.
- **Why it was replaced:** To streamline HotKey accelerators, prevent missing variable declarations across files, and avoid Windows API import collisions.
- **Legacy Implementation:**
  - `actions_engine.au3` - Core window activation and tiling handlers.
  - `actions_gdi.au3` - Layered windows and orange borders GDI drawing logic.
  - `actions_ui.au3` - ListView populating and shortcut message dialogs.
  - `events.au3` - Window events and accelerators bindings.
  - `shared_globals.au3` - Global variables and arrays initialization.

---

## 📑 Obsolete Specifications & Scrapped Ideas
[[#^toc-scrapped|TOC]]

### 💡 Multi-File Variable Sharing via #include
- **Proposed on:** 2026-06-25
- **The Concept:** Keep variables declared in `shared_globals.au3` and share them using standard `#include` directives across action files.
- **Why it failed/was dropped:** AutoIt v3 preprocessor translates `#include` sequentially. When functions inside `actions_ui.au3` reference variables declared in `shared_globals.au3`, subtle changes in inclusion order cause "Variable used without being declared" errors, breaking linter checks during compilation.

---
## 🚀 Go to...
[[#^toc-goto|TOC]]
- 🔹 [AGENTS.md](../AGENTS.md)
- 🔸 [ARCHIVE.md](ARCHIVE.md)
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
- 🔹 [VERSIONS.md](VERSIONS.md)
