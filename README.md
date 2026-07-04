---
title: README
---

<!-- START OF FILE: README.md - PART 1 -->
<!-- markdownlint-disable MD013 -->

# README

A desktop helper tool built to arrange, tile, and control multiple browser windows on your screen using fast keyboard shortcuts.

![icon](icon.jpg)
[!["Buy Me A Coffee"](https://buymeacoffee.com)](https://buymeacoffee.com)

## 📑 Project Files
- 🔹 [AGENTS.md](AGENTS.md)
- 🔹 [ARCHIVE.md](AIMD/ARCHIVE.md)
- 🔹 [BUILD.md](AIMD/BUILD.md)
- 🔹 [CODE.md](AIMD/CODE.md)
- 🔹 [DESIGN.md](AIMD/DESIGN.md)
- 🔹 [FEATURES.md](AIMD/FEATURES.md)
- 🔹 [LOG.md](AIMD/LOG.md)
- 🔹 [MANUAL.md](AIMD/MANUAL.md)
- 🔸 [README.md](README.md)
- 🔹 [SPEC.md](AIMD/SPEC.md)
- 🔹 [TASKS.md](AIMD/TASKS.md)
- 🔹 [TERMS.md](AIMD/TERMS.md)
- 🔹 [TESTING.md](AIMD/TESTING.md)
- 🔹 [VERSIONS.md](AIMD/VERSIONS.md)

## 🔍 Table of Contents
- [[#🎯 What It Does & Core Value]] ^toc-abstract
- [[#🛠️ Technology Used]] ^toc-stack
- [[#📦 Feature Groups Overview]] ^toc-groups
- [[#⚡ Quick Start for Developers]] ^toc-quickstart
- [[#📐 Screen Math & Grid Formulas]] ^toc-math

## 🎯 What It Does & Core Value
[[#^toc-abstract|TOC]]
- This application splits your desktop screen into clean layout shapes for web development. It keeps track of running browser windows, moves them instantly, and draws a safety-orange highlight frame around your active window without getting in your way or taking over your keyboard typing focus.

---

## 🛠️ Technology Used
[[#^toc-stack|TOC]]
- **Operating System:** Microsoft Windows 10 / Windows 11
- **Language Frameworks:** AutoIt3 Automation Language, Node.js Engine (for terminal project tasks)
- **System Integrations:** Native Windows API (User32 / GDI32 layout layers)

---

## 📦 Feature Groups Overview
[[#^toc-groups|TOC]]

### 🖥️ 1. Automated Layout Management
Manages coordinates, sizes, and positioning structures of browser frames on your desktop.
- **Window Grid Tiling** - Snap browser windows instantly to a precise 3x3 desktop layout or a custom center frame using keys `0-9`.
- **Center Position Exchange** - Press `Ctrl + 1-9` to swap the window resting in the middle slot with any outer grid window.

### 🕹️ 2. Context Navigation & Shortcut Handlers
Provides keyboard-driven commands to launch, activate, control, and manipulate browser windows.
- **Multi-Browser Selector** - Activate or run Brave (`B`), Chrome (`C`), Edge (`E`), Vivaldi (`V`), Firefox (`F`), or Browser Picker (`P`) instantly.
- **Active Tab Scrolling** - Press `PageUp` or `PageDown` to cycle tabs backward and forward without manually activating the target browser.
- **Clipboard Tab Loader** - Press `Shift+Insert` to pull web links straight out of your clipboard and open them as new tabs.
- **Active URL Capture** - Press `Ctrl+C` to copy the current webpage address of your selected browser to your clipboard silently.
- **Orange Border Indicator** - Outlines your targeted browser window with a clear 2px orange visual frame using GDI system graphics.
- **Tray Minimization** - Press `Escape` to minimize the manager panel out of sight into the system tray. Toggle it back anywhere using `Win + AppsKey`.
<!-- END OF FILE: README.md - PART 1 -->

<!-- START OF FILE: README.md - PART 2 -->
## ⚡ Quick Start for Developers
[[#^toc-quickstart|TOC]]

### 1. Test Project Syntax
```cmd
npm run check
```

### 2. Run Application & Test
```cmd
npm test
```

### 3. Compile to Standalone .EXE
```cmd
npm run compile
```

---

## 📐 Screen Math & Grid Formulas
[[#^toc-math|TOC]]

### 🗔 Layer Stacking Hierarchy Matrix
The operating system places application window states into three distinct vertical planes:

- 🔝 [ TOP FLOOR ]     ---> Main Browser Manager Window (Kept always on top)
- 🖼️  [ MIDDLE FLOOR ]  ---> Transparent 2px Orange Highlight Box Overlay
- 🌐 [ GROUND FLOOR ]  ---> Active Browser App Window (Brave, Chrome, Edge, Vivaldi, etc.)

### 🧮 3x3 Grid Monitor Math
The script divides your monitor screen size variables dynamically so it works on any computer resolution:

- 📊 Width of 1 Grid Cell  = Total Screen Width / 3
- 📊 Height of 1 Grid Cell = Total Screen Height / 3

Keys `1` through `9` correspond directly to these grid boxes, moving the target browser frame to the matching column and row location on your desktop.

#### The Proportional Center Formula (Key 0)
When you hit the `0` shortcut key, the script automatically resizes the targeted browser window to a perfectly centered layout that is exactly **5/9ths** of your screen width and height:
$$\text{Target Width} = \frac{\text{Screen Width} \times 5}{9}, \quad \text{Target Height} = \frac{\text{Screen Height} \times 5}{9}$$
$$\text{Window Position X} = \frac{\text{Screen Width} - \text{Target Width}}{2}$$
$$\text{Window Position Y} = \frac{\text{Screen Height} - \text{Target Height}}{2}$$

---

## 🚀 Go to...
- 🔹 [AGENTS.md](AGENTS.md)
- 🔹 [ARCHIVE.md](AIMD/ARCHIVE.md)
- 🔹 [BUILD.md](AIMD/BUILD.md)
- 🔹 [CODE.md](AIMD/CODE.md)
- 🔹 [DESIGN.md](AIMD/DESIGN.md)
- 🔹 [FEATURES.md](AIMD/FEATURES.md)
- 🔹 [LOG.md](AIMD/LOG.md)
- 🔹 [MANUAL.md](AIMD/MANUAL.md)
- 🔸 [README.md](README.md)
- 🔹 [SPEC.md](AIMD/SPEC.md)
- 🔹 [TASKS.md](AIMD/TASKS.md)
- 🔹 [TERMS.md](AIMD/TERMS.md)
- 🔹 [TESTING.md](AIMD/TESTING.md)
- 🔹 [VERSIONS.md](AIMD/VERSIONS.md)
<!-- END OF FILE: README.md - PART 2 -->