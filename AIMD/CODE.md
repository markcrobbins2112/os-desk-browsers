---
title: CODE
---

# CODE

## 📑 AI Primary Files
- 🔹 [AGENTS.md](../AGENTS.md)
- 🔹 [ARCHIVE.md](ARCHIVE.md)
- 🔹 [BUILD.md](BUILD.md)
- 🔸 [CODE.md](CODE.md)
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
- [[#Implementation Guidelines]] ^toc-guidelines
- [[#Markdown Guidelines]] ^toc-markdown
- [[#Formatting & Syntax Style]] ^toc-syntax
- [[#🛡️ Robustness & Error-Handling Frameworks]] ^toc-errors
- [[#Regions Division Style]] ^toc-regions
- [[#🚀 Go to...]] ^toc-goto

## 🛠️ Implementation Guidelines
[[#^toc-guidelines|TOC]]
- **Encoding Safety**: All source files must be preserved in UTF-8 or UTF-8 with BOM format to ensure Unicode browser window title matches (REGEXPTITLE) work seamlessly.
- **Target Changes Only**: Avoid complete file rewrites. Target specific lines with surgical precision to preserve long-standing optimization comments.

## 📝 Markdown Guidelines
[[#^toc-markdown|TOC]]
- Use dashes (`-`) instead of asterisks (`*`) for Bullet list items.
- Maintain UPPERCASE.md filenames in documentation folders.

## ✒️ Formatting & Syntax Style
[[#^toc-syntax|TOC]]
- **Indentation**: Use 4 spaces for indentation. Never mix tabs and spaces.
- **Braces and Blocks**: AutoIt v3 utilizes explicit keyword blocks. Ensure matching `EndIf`, `WEnd`, `Next`, `EndSelect`, and `EndFunc` are always aligned with their parent statement.
- **Naming Conventions**: Use Hungarian Notation for variables to instantly represent type scope:
  - `$h` - Window or GDI handles (e.g. `$hGUI`, `$hTargetWin`).
  - `$id` - UI Control IDs (e.g. `$idListview`, `$idStatus`).
  - `$i` - Integers (e.g. `$iSelected`, `$iBrowserCount`).
  - `$s` - Strings (e.g. `$sName`, `$sSuffix`).
  - `$a` - Arrays (e.g. `$aBrowsers`, `$aWinList`).
  - `$b` - Booleans (e.g. `$bGUI_Visible`).
- **Global Function Ordering**: Functions are placed at the bottom of the script, organized logically into clear sections starting with core engine procedures, GDI functions, user interface helpers, and hotkey actions.

---

## 🛡️ Robustness & Error-Handling Frameworks
[[#^toc-errors|TOC]]
- **Primary Paradigm:** Defensive checking of handle validations and error returns. Always verify that arrays are structures using `IsArray()` before parsing coordinate values.
- **Defensive Coding Checks:** Always validate that external files exist using `FileExists()` before executing process runs. Use `BitAND(WinGetState($hWnd), 2)` to verify window visibility before applying border states or activating focus.
- **Logging Integration:** Execution errors, layout modifications, and process changes must write messages to the central UI `$idStatus` label bar.

---

## 📂 Regions Division Style
[[#^toc-regions|TOC]]
- **Structures**: Group the file structure logically into functional sections divided by visual banners.
- **Example Regions Map**:
  ```text
  ; ==============================================================================
  ; GLOBAL VARIABLE DECLARATIONS
  ; ==============================================================================
  Global $aBrowsers[6][5]
  ...
  
  ; ==============================================================================
  ; USER INTERFACE SETUP
  ; ==============================================================================
  $hGUI = GUICreate("Browser Manager", ...)
  ...
  
  ; ==============================================================================
  ; DUMMY EVENT REGISTER & SHORTCUT ACCELERATORS
  ; ==============================================================================
  GUISetAccelerators($aAccelKeys, $hGUI)
  ...
  ```

---
## 🚀 Go to...
[[#^toc-goto|TOC]]
- 🔹 [AGENTS.md](../AGENTS.md)
- 🔹 [ARCHIVE.md](ARCHIVE.md)
- 🔹 [BUILD.md](BUILD.md)
- 🔸 [CODE.md](CODE.md)
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
