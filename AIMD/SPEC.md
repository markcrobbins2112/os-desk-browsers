---
title: SPEC
---

# SPEC

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
- 🔸 [SPEC.md](SPEC.md)
- 🔹 [TASKS.md](TASKS.md)
- 🔹 [TERMS.md](TERMS.md)
- 🔹 [TESTING.md](TESTING.md)
- 🔹 [VERSIONS.md](VERSIONS.md)

## 🔍 Table of Contents
- [[#🔗 External Application Protocols & URI Schemes]] ^toc-uri
- [[#💻 Native OS Integration Details]] ^toc-os
- [[#📋 Originally Requested Specifications]] ^toc-requested
- [[#🎯 Implemented Technical Concerns & Optimization Features]] ^toc-optimization
- [[#🚦 Internal Function Signatures & System Exit Codes]] ^toc-codes
- [[#Go to...]] ^toc-goto

This document compiles the user requirements and instructions from `AGENTS.md` and related files and provides detailed documentation of how the extension was architected and built.

---

## 🔗 External Application Protocols & URI Schemes
[[#^toc-uri|TOC]]

### Web Browsing Shell Contract
- **Target Schema:** `http://` or `https://`
- **Query String Map:**

  | Parameter | Type | Required | Description / Constraints |
  | :--- | :--- | :--- | :--- |
  | `url` | `String` | Yes | Target URL to open. Must be fully qualified and parseable by standard browsers. |

---

## 💻 Native OS Integration Details
[[#^toc-os|TOC]]

### Global Shell Shortcuts
- **System Hook Target:** Keyboard interception using `HotKeySet()` for background listening.
- **Properties Mapping:**
  - `Win + AppsKey` (ContextMenu key) maps directly to `_ToggleGUI()` to show/hide the main utility dynamically.

---

## 📋 Originally Requested Specifications
[[#^toc-requested|TOC]]
- **Keyboard-Driven Browser Orchestration**: Quick launch and activation of multiple browser instances via single character keystrokes.
- **Advanced 3x3 Layout Snapping**: Precise screen quadrant division with window-to-window swaps and focal center positioning.
- **Active Focus Highlighting**: Real-time GDI border outline wrapping the selected window context.
- **Z-Order Preservation**: Interacting with background windows and switching selectors must prioritize the highest available Z-index matching active windows.

---

## 🎯 Implemented Technical Concerns & Optimization Features
[[#^toc-optimization|TOC]]
- **Non-Focus-Stealing GDI Border**:
  - **The Problem**: Drawing a custom highlight border on the desktop usually activates the border window itself, stealing input focus away from the active browser.
  - **The Solution / Code Implementation**: Implemented a transparent, click-through, layered border window. Calls `_WinAPI_SetWindowPos` with the `$SWP_NOACTIVATE` flag, ensuring the overlay window draws on top without stealing focus.
- **Z-Index Visible Window Filter**:
  - **The Problem**: A simple query for browser windows can return hidden processes, background tab managers, or suspended frames, causing invalid focus targets.
  - **The Solution / Code Implementation**: Loops through window lists (`WinList()`) and verifies standard visibility states using `BitAND(WinGetState($hWnd), 2)` to isolate only active, visible, user-facing instances.

---

## 🚦 Internal Function Signatures & System Exit Codes
[[#^toc-codes|TOC]]

### Engine Error / Exit Status Codes

| Code (Integer) | Semantic Definition | Trigger Condition |
| :--- | :--- | :--- |
| `0` | `Success` | Perfect lifecycle termination via standard Exit. |

### Data Models & State Layouts
```text
; Browsers parameters are stored in a structured 2D array
$aBrowsers[0][0] = "Brave" (Display Name)
$aBrowsers[0][1] = "Brave" (Window Title Match Suffix)
$aBrowsers[0][2] = "C:\...\brave.exe" (Physical Executable Path)
$aBrowsers[0][3] = "brave.exe" (Process Executable Suffix)
$aBrowsers[0][4] = "B" (Single Character Activation Key)
```

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
- 🔸 [SPEC.md](SPEC.md)
- 🔹 [TASKS.md](TASKS.md)
- 🔹 [TERMS.md](TERMS.md)
- 🔹 [TESTING.md](TESTING.md)
- 🔹 [VERSIONS.md](VERSIONS.md)
