# Hermes Integration and AICM Improvements implementation Plan

> **For Codex:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add Hermes AI support, implement tool cleanup logic, refactor sync to be branch-agnostic, and add a version command.

**Architecture:** Update the `TARGETS` and `EXCLUDES` arrays in `aicm.sh`, implement the `cleanup()` function to detect installation conflicts, refactor `sync_repo()` to use the current git branch, and add a `version` case to the main loop.

**Tech Stack:** Bash, Git, NPM.

---

### Task 1: Add Hermes and Security Excludes

**Files:**
- Modify: `aicm.sh`

**Step 1: Update TARGETS array**
Add `"Hermes:.hermes:hermes:hermes"` to `TARGETS`.

**Step 2: Update EXCLUDES array**
Add `".env"`, `"auth.json"`, `"*.yaml"`, `"*.yml"` to `EXCLUDES`.

**Step 3: Commit**
```bash
git add aicm.sh
git commit -m "feat: add Hermes support and expand sensitive file excludes"
```

---

### Task 2: Implement Cleanup Logic

**Files:**
- Modify: `aicm.sh`

**Step 1: Implement cleanup function**
Implement logic to detect if a tool is installed via both `brew` and `npm`.

**Step 2: Commit**
```bash
git add aicm.sh
git commit -m "feat: implement installation conflict detection in cleanup"
```

---

### Task 3: Refactor Sync and Add Version

**Files:**
- Modify: `aicm.sh`
- Modify: `package.json`

**Step 1: Refactor sync_repo**
Replace hardcoded `master` with dynamic branch detection.

**Step 2: Add version command**
Add `version` flag and case.

**Step 3: Update package.json version**
Bump version to `1.1.0`.

**Step 4: Commit**
```bash
git add aicm.sh package.json
git commit -m "refactor: branch-agnostic sync and add version command"
```

---

### Task 4: Testing and Documentation

**Files:**
- Create: `tests/test_aicm.sh`
- Modify: `README.md`

**Step 1: Create test script**
Write a basic test script to verify core commands.

**Step 2: Update README**
Add Hermes to features and update command table.

**Step 3: Run tests**
Run `./tests/test_aicm.sh`.

**Step 4: Commit**
```bash
git add tests/test_aicm.sh README.md
git commit -m "test: add basic test suite and update README"
```
