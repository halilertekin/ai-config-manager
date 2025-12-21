# AI Config Manager (AICM)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![npm version](https://img.shields.io/npm/v/@halilertekin/ai-config-manager.svg)](https://www.npmjs.com/package/@halilertekin/ai-config-manager)

**AICM** is an intelligent CLI tool designed to manage the lifecycle of your AI coding assistants. It handles **backup**, **restoration**, **global updates**, and **duplicate cleanup** for tools like Gemini, Claude, Cursor, Trae, GitHub Copilot, and more.

## ⚠️ Disclaimer & Warning

> **READ BEFORE USING:**
> 
> The `restore` function **WILL OVERWRITE** existing configuration files in your home directory (e.g., `~/.gemini`, `~/.claude`).
> 
> *   **Data Loss:** Any local changes made to these configurations since your last backup will be permanently lost upon restoration.
> *   **Safety First:** AICM includes a feature to create `.bak` backups before overwriting, but **you are responsible** for ensuring your data is safe.
> *   **Use Dry Run:** Always test commands with the `--dry-run` flag first to see what will happen without making changes.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND. THE AUTHORS ARE NOT LIABLE FOR ANY DATA LOSS.

## 🌟 Features

*   **🧠 Smart Detection:** Automatically detects installation methods (`npm`, `brew`, `yarn`, `bun`, `pnpm`).
*   **💾 Secure Backup:** Backs up configs excluding sensitive tokens (OAuth, API keys).
*   **♻️ Auto-Restore & Install:** Automatically re-installs missing tools on new machines.
*   **🛡️ Safety Modes:** Includes `--dry-run` mode and pre-restore `.bak` backups.
*   **🔄 Universal Update:** Updates all AI tools with one command (`aicm update`).
*   **🧹 Duplicate Cleanup:** Detects and resolves conflicting installations.

## 📦 Installation

### Option 1: Via NPM (Recommended)
```bash
npm install -g @halilertekin/ai-config-manager
```

### Option 2: Manual / Git
1.  Clone the repository:
    ```bash
    git clone https://github.com/halilertekin/ai-config-manager.git
    cd ai-config-manager
    ```
2.  Make executable:
    ```bash
    chmod +x aicm.sh
    alias aicm="~/path/to/ai-config-manager/aicm.sh"
    ```

## 🚀 Usage

### 1. Dry Run (Test First!)
See what would happen without making changes. Works with all commands.
```bash
aicm restore --dry-run
aicm backup --dry-run
```

### 2. Backup
Backs up configurations to `./backups`. Excludes `oauth_creds.json`, etc.
```bash
aicm backup
```

### 3. Restore
Restores configurations.
*   **Prompts for confirmation.**
*   **Offers to create local `.bak` copies before overwriting.**
*   **Installs missing tools automatically.**
```bash
aicm restore
```

### 4. Update All
Updates all detected AI tools.
```bash
aicm update
```

### 5. Cleanup
Scans for duplicate installations.
```bash
aicm cleanup
```

## 🗺️ Roadmap

Future plans for AICM:

- [ ] **Cloud Sync:** Integration with GitHub Gist or S3 for remote backups.
- [ ] **Encryption Support:** Optional GPG/Age encryption to safely backup sensitive tokens instead of excluding them.
- [ ] **Docker Export:** Generate a `Dockerfile` based on your current AI setup to create a reproducible container.
- [ ] **Git Auto-Commit:** Automatically commit local backups to a private git repository.
- [ ] **TUI (Text User Interface):** Interactive selection menu for backup/restore operations.
- [ ] **Cross-Platform:** Better support for Windows (PowerShell) and Linux distributions.

## 🤝 Contributing

Contributions are welcome!
1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.