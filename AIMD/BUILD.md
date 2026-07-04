---
title: BUILD
---

# BUILD

## 📑 AI Primary Files
- 🔹 [AGENTS.md](../AGENTS.md)
- 🔹 [ARCHIVE.md](ARCHIVE.md)
- 🔸 [BUILD.md](BUILD.md)
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
- [[#📋 Prerequisites & Toolchain Setup]] ^toc-prereq
- [[#🛠️ Build & Packaging Pipeline]] ^toc-pipeline
- [[#🚀 Execution & Packing Commands]] ^toc-commands
- [[#🧪 Post-Build Verification Rules]] ^toc-verify
- [[#🚀 Go to...]] ^toc-goto

## 📋 Prerequisites & Toolchain Setup
[[#^toc-prereq|TOC]]
- **Compiler/Runtime:** AutoIt v3 Suite (AutoIt3 v3.3.16.x or newer, incorporating `au3check.exe` and `Aut2exe.exe`).
- **Global System Variables Required:**
  - `PATH`: Must include the path to the AutoIt3 installation directory (e.g., `C:\Program Files (x86)\AutoIt3` or mapped folder equivalents) to make `autoit3.exe` and `au3check.exe` available.

---

## 🛠️ Build & Packaging Pipeline
[[#^toc-pipeline|TOC]]
The build system utilizes standard Node.js NPM script commands as an automation wrapper to validate, run, and compile the native Windows AutoIt executable.

### 📦 Key Components
- **`desk-browsers.au3`**: The single central entry point and unified script containing the entire application logic, user interface, hotkey bindings, and window tiling algorithms.
- **`package.json`**: Package configuration declaring execution scripts, dependency check parameters, and metadata.
- **`au3check.exe`**: AutoIt syntax validation tool that analyzes code for undeclared variables, syntax errors, and missing functions.
- **`Aut2exe.exe`**: AutoIt script to standalone executable compiler.

---

## 🚀 Execution & Packing Commands
[[#^toc-commands|TOC]]
- **Install Dependencies**:
  ```bash
  npm install
  ```
- **Local Run / Execute Script**:
  ```bash
  npm run start
  ```
- **Verification / Linting**:
  ```bash
  npm run check
  ```
- **Production Package Compilation**:
  ```bash
  npm run compile
  ```

---

## 🧪 Post-Build Verification Rules
[[#^toc-verify|TOC]]
- 1. **Size Checking:** Verify that the output executable `BrowserManager.exe` size is greater than `300 KB` (due to embedded AutoIt runtime bytecode).
- 2. **Path Verification:** Check that the output file `BrowserManager.exe` is located exactly at the project workspace root directory.
- 3. **Smoke Test Command:** Run `BrowserManager.exe` on Windows and verify that the tray icon is registered and the GUI appears without any execution errors.

---
## 🚀 Go to...
[[#^toc-goto|TOC]]
- 🔹 [AGENTS.md](../AGENTS.md)
- 🔹 [ARCHIVE.md](ARCHIVE.md)
- 🔸 [BUILD.md](BUILD.md)
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
