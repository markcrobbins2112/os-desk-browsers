# LOG

## 📑 AI Primary Files
- 🔹 [AGENTS.md](../AGENTS.md)
- 🔹 [ARCHIVE.md](ARCHIVE.md)
- 🔹 [BUILD.md](BUILD.md)
- 🔹 [CODE.md](CODE.md)
- 🔹 [DESIGN.md](DESIGN.md)
- 🔹 [FEATURES.md](FEATURES.md)
- 🔸 [LOG.md](LOG.md)
- 🔹 [MANUAL.md](MANUAL.md)
- 🔹 [README.md](../README.md)
- 🔹 [SPEC.md](SPEC.md)
- 🔹 [TASKS.md](TASKS.md)
- 🔹 [TERMS.md](TERMS.md)
- 🔹 [TESTING.md](TESTING.md)
- 🔹 [VERSIONS.md](VERSIONS.md)

## 🔍 Table of Contents
- [[#💾 Commit Message]] ^toc-commit
- [[#📝 Log Entries]] ^toc-entries
- [[#🏛️ Permanent Decision Record Archive]] ^toc-adr
- [[#🚀 Go to...]] ^toc-goto

## 💾 Commit Message
[[#^toc-commit|TOC]]
```text
docs: reverse engineer codebase and populate complete technical documentation

- Completed detailed architectural specifications in SPEC.md and DESIGN.md
- Documented full keyboard commands, mathematical formulas, and GDI indicators in MANUAL.md
- Configured automated NPM run guidelines in BUILD.md
- Formulated testing scenarios in TESTING.md and glossary definitions in TERMS.md
- Resolved all template placeholders to establish high-fidelity developer handbooks
```

## 📝 Log Entries
[[#^toc-entries|TOC]]

### 📅 [2026-06-27T16:16:00-07:00]
#### 🎯 Primary Goals & Requirements
- Complete a comprehensive review of all markdown files and reverse engineer the active AutoIt codebase.
- Populate technical, design, and structural guidelines, removing all template placeholders.

#### 🛠️ Completed Changes in this Session
- Formulated precise design contexts, components layouts, and topology maps inside `DESIGN.md`.
- Documented keyboard shortcuts, math formulas, diagnostics, and troubleshooting procedures in `MANUAL.md`.
- Described tiling grids, layout swaps, active tab scrolling, clipboard loading, and tray management in `FEATURES.md`.
- Specified compilation, syntax linter checking, and build size verification benchmarks in `BUILD.md`.
- Detailed testing checklists and scenario outlines in `TESTING.md`.
- Populated glossary terms and system acronyms in `TERMS.md`.
- Completed operational agent guidelines inside `AGENTS.md` and version milestone histories inside `VERSIONS.md`.

#### 🔸 Affected Files
- `/AGENTS.md`
- `/AIMD/ARCHIVE.md`
- `/AIMD/BUILD.md`
- `/AIMD/CODE.md`
- `/AIMD/DESIGN.md`
- `/AIMD/FEATURES.md`
- `/AIMD/LOG.md`
- `/AIMD/MANUAL.md`
- `/AIMD/SPEC.md`
- `/AIMD/TASKS.md`
- `/AIMD/TERMS.md`
- `/AIMD/TESTING.md`
- `/AIMD/VERSIONS.md`

---

### 📅 [2026-06-27T16:05:00-07:00]
#### 🎯 Primary Goals & Requirements
- Update window selectors to favor highest visible Z-index when multiple windows match a browser profile.

#### 🛠️ Completed Changes in this Session
- Modified `_GetSelectedBrowserWindow`, `_CheckBrowserRunning`, and `_HandleAction` inside `desk-browsers.au3` to check `BitAND(WinGetState($hWnd), 2)`.
- Ensured window activation and close actions target the topmost visible browser instance.

#### 🔸 Affected Files
- `/desk-browsers.au3`

---

### 📅 [2026-06-27T15:30:00-07:00]
#### 🎯 Primary Goals & Requirements
- Consolidate split scripts (`actions_engine.au3`, `actions_gdi.au3`, `actions_ui.au3`, etc.) into a single file to eliminate relative import paths and build failures.

#### 🛠️ Completed Changes in this Session
- Created single `desk-browsers.au3` combining variables, UI creation, hotkey accelerator array, GDI border drawer, and timer loop.
- Deleted obsolete modular split files.

#### 🔸 Affected Files
- `/desk-browsers.au3`
- `/actions_engine.au3` (deleted)
- `/actions_gdi.au3` (deleted)
- `/actions_ui.au3` (deleted)
- `/events.au3` (deleted)
- `/shared_globals.au3` (deleted)

---

## 🏛️ Permanent Decision Record Archive
[[#^toc-adr|TOC]]

### 🏷️ [ADR-001] - Single Script Architecture Selection
- **Date Approved:** 2026-06-27
- **Context:** Relative paths inside AutoIt scripts are evaluated based on the current working directory at run time, which differs depending on whether it is launched from VS Code, cmd.exe, or Windows Explorer, leading to file inclusion collisions.
- **Decision:** Consolidate all functions, globals, and wrappers into a single unified entry file `desk-browsers.au3`.
- **Consequences:** Eliminates include resolution bugs. Makes compilation using Aut2exe fast and deterministic. Simplifies hotkey accelerator table definitions.

---
## 🚀 Go to...
[[#^toc-goto|TOC]]
- 🔹 [AGENTS.md](../AGENTS.md)
- 🔹 [ARCHIVE.md](ARCHIVE.md)
- 🔹 [BUILD.md](BUILD.md)
- 🔹 [CODE.md](CODE.md)
- 🔹 [DESIGN.md](DESIGN.md)
- 🔹 [FEATURES.md](FEATURES.md)
- 🔸 [LOG.md](LOG.md)
- 🔹 [MANUAL.md](MANUAL.md)
- 🔹 [README.md](../README.md)
- 🔹 [SPEC.md](SPEC.md)
- 🔹 [TASKS.md](TASKS.md)
- 🔹 [TERMS.md](TERMS.md)
- 🔹 [TESTING.md](TESTING.md)
- 🔹 [VERSIONS.md](VERSIONS.md)
