# AI Config Manager (AICM)

![AICM Ultimate AI Command Center](assets/aicm.png)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![npm version](https://img.shields.io/npm/v/@halilertekin/ai-config-manager.svg)](https://www.npmjs.com/package/@halilertekin/ai-config-manager)

**AICM** is the ultimate command center for your AI development environment. It manages backups, restores, updates, and synchronization for tools like Gemini, Claude, Cursor, Trae, GitHub Copilot, and more.

## 🚀 Features

*   **🛡️ Secure Backup:** Backups configs locally, stripping out sensitive tokens (OAuth, API keys).
*   **☁️ Cloud Sync:** Optional sync to your own **private** Git repository.
*   **🧠 Smart Restore:** Automatically installs missing tools (`npm`, `brew`, etc.) on new machines.
*   **🔄 Universal Update:** Updates all tools with one command.
*   **🧹 Duplicate Cleanup:** Detects and resolves conflicting installations.

## 📦 Installation

```bash
npm install -g @halilertekin/ai-config-manager
```

## 📖 Migration Guide: How to move to a new computer

### Step 1: On Old Computer
1.  Run backup:
    ```bash
    aicm backup
    ```
2.  **Option A (Cloud Sync - Recommended):**
    *   Create a **PRIVATE** GitHub repository (e.g., `my-ai-backups`).
    *   Run `aicm sync` and enter your repo URL.
    
    **Option B (Manual):**
    *   Copy the `backups/` folder to a USB drive or cloud storage (Dropbox/Drive).

### Step 2: On New Computer
1.  Install AICM: `npm install -g @halilertekin/ai-config-manager`
2.  **Option A (Cloud Sync):**
    *   Create a `backups` folder and clone your private repo into it.
    
    **Option B (Manual):**
    *   Copy your `backups` folder from USB/Drive to the current directory.
3.  Restore:
    ```bash
    aicm restore
    ```
    *(AICM will install missing tools and restore your settings automatically.)*

## 🛠 Commands

| Command | Description |
| :--- | :--- |
| `aicm list` | Detect installed tools. |
| `aicm backup` | Backup configs to local `./backups` folder. |
| `aicm restore` | Restore configs & install missing tools. |
| `aicm sync` | **(NEW)** Sync `backups/` to a private Git repo. |
| `aicm update` | Update all AI tools (`brew`/`npm`). |
| `aicm cleanup` | Find and fix duplicate installations. |

## ⚠️ Security Disclaimer

> **Your Data, Your Responsibility.**
> AICM attempts to exclude sensitive files (`oauth_creds.json`, etc.) from backups. However, **YOU** are responsible for ensuring no secrets are committed if you use the `sync` feature. **ALWAYS use a PRIVATE repository.**

## 🤝 Contributing

Contributions are welcome!
1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.