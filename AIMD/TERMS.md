---
title: TERMS
---

# TERMS

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
- 🔸 [TERMS.md](TERMS.md)
- 🔹 [TESTING.md](TESTING.md)
- 🔹 [VERSIONS.md](VERSIONS.md)

## 🔍 Table of Contents
- [[#🔤 Core Glossary A-Z]] ^toc-glossary
- [[#🗂️ System Acronym Quick-Reference]] ^toc-acronyms
- [[#Go to...]] ^toc-goto

## 🔤 Core Glossary A-Z
[[#^toc-glossary|TOC]]

### Accelerator Table
- **Definition:** A structured mapping table binding physical keystrokes (such as strings like `^b`, `!c`, `ESC`) to logical control handles.
- **Code Implementation Context:** Configured using standard `GUISetAccelerators()` and loaded with references to Dummy controls.

### Dummy Controls
- **Definition:** Hidden visual components created inside the GUI window to capture programmatic events.
- **Code Implementation Context:** Defined using `GUICtrlCreateDummy()` and triggered via physical HotKeys inside the Accelerator mapping table.

### Indicator Border
- **Definition:** A custom, orange-colored, click-through, non-focus-stealing GDI outline drawn wrapping around the selected window to provide instant active context feedback.
- **Code Implementation Context:** Formulated inside `_DrawOrangeBorder()` using User32 and GDI32 window regional clipping APIs.

### REGEXPTITLE
- **Definition:** AutoIt's advanced window title match mode using Regular Expressions. Allows targeting browsers by dynamic suffixes while ignoring active webpage title variations.
- **Code Implementation Context:** Set using `Opt("WinTitleMatchMode", 4)` and executed with string patterns like `"[REGEXPTITLE:(?i).*<suffix>$]"`.

### Z-Index
- **Definition:** The visual stacking hierarchy of window elements on the Windows desktop, deciding which frames render on top of others.
- **Code Implementation Context:** Monitored via standard `WinList()` query results, which return window lists ordered from top (highest Z-index) to bottom.

---

## 🗂️ System Acronym Quick-Reference
[[#^toc-acronyms|TOC]]

| Acronym / Token | Full Expansion | Technical Scope |
| :--- | :--- | :--- |
| **`UDF`** | User Defined Function | Reusable, structured custom libraries or functions (prefixed with an underscore e.g. `_OnShortcut`). |
| **`GDI`** | Graphics Device Interface | Microsoft Windows subsystem managing graphic object rendering (such as shapes, regions, brushes, and clipping masks). |
| **`GUI`** | Graphical User Interface | The visual interface shell displaying browser lists, statuses, and options. |
| **`API`** | Application Programming Interface | Core Windows endpoints (Win32 user32/gdi32/shell32) called by the script. |

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
- 🔸 [TERMS.md](TERMS.md)
- 🔹 [TESTING.md](TESTING.md)
- 🔹 [VERSIONS.md](VERSIONS.md)
