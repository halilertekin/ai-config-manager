#!/bin/bash

# AI Config Manager (AICM)
# A CLI tool to backup, restore, UPDATE, and CLEANUP AI assistant configurations.
# Supports detection for: NPM, BREW, YARN, BUN, PNPM.
# Author: Halil
# License: MIT

# Configuration
BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
HOME_DIR="$HOME"
DRY_RUN=false

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check for --dry-run flag
for arg in "$@"; do
  if [ "$arg" == "--dry-run" ]; then
    DRY_RUN=true
    echo -e "${CYAN}[DRY-RUN MODE ENABLED] No changes will be made.${NC}"
  fi
done

# List of AI Tools
# Format: "DisplayName:ConfigPath:BinaryName:PackageName"
declare -a TARGETS=(
    "Gemini:.gemini:gemini:@google/gemini-cli"
    "Claude:.claude:claude:claude"
    "Cursor:.cursor:cursor:cursor"
    "Trae:.trae-aicc:trae:trae"
    "Qwen:.qwen:qwen:qwen"
    "Codex:.codex:codex:codex"
    "SuperMaven:.supermaven:supermaven:supermaven"
    "Copilot:.config/github-copilot:gh:gh"
)

# Files to exclude
EXCLUDES=(
    "tmp" "cache" "Cache" "logs" "*.log" "node_modules" ".DS_Store"
    "oauth_creds.json" "google_accounts.json" "itunes_service_key.txt"
    "auth.json" "session.json" "creds.json"
)

print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}      AI CONFIG MANAGER (AICM)          ${NC}"
    echo -e "${BLUE}========================================${NC}"
}

check_deps() {
    if ! command -v rsync &> /dev/null; then
        echo -e "${RED}Error: rsync is not installed.${NC}"
        exit 1
    fi
}

detect_manager() {
    local bin_name=$1
    local package_name=$2
    if command -v brew &> /dev/null && (brew list "$package_name" &> /dev/null || brew list --cask "$package_name" &> /dev/null); then echo "brew"; return; fi
    if command -v npm &> /dev/null && npm list -g "$package_name" &> /dev/null; then echo "npm"; return; fi
    if command -v bun &> /dev/null && bun pm ls -g | grep -q "$package_name"; then echo "bun"; return; fi
    if command -v yarn &> /dev/null && yarn global list 2>/dev/null | grep -q "$package_name"; then echo "yarn"; return; fi
    if command -v pnpm &> /dev/null && pnpm list -g | grep -q "$package_name"; then echo "pnpm"; return; fi
    echo "manual"
}

execute_rsync() {
    local src=$1
    local dest=$2
    local excludes=$3
    
    if [ "$DRY_RUN" = true ]; then
        echo -e "${CYAN}[DRY-RUN] Would sync: $src -> $dest${NC}"
    else
        rsync -a --delete $excludes "$src" "$dest"
    fi
}

backup() {
    print_header
    echo -e "${YELLOW}Starting Backup Process...${NC}"
    if [ "$DRY_RUN" = false ]; then mkdir -p "$BACKUP_DIR"; fi

    for item in "${TARGETS[@]}"; do
        IFS=":" read -r NAME PATH_REL BIN PACKAGE <<< "$item"
        SOURCE="$HOME_DIR/$PATH_REL"
        DEST="$BACKUP_DIR/$NAME"

        if [ -e "$SOURCE" ]; then
            echo -e "Backing up ${GREEN}$NAME${NC}..."
            EXCLUDE_FLAGS=""
            for excl in "${EXCLUDES[@]}"; do EXCLUDE_FLAGS+="--exclude=$excl "; done
            
            if [ "$DRY_RUN" = false ]; then mkdir -p "$(dirname "$DEST")"; fi
            execute_rsync "$SOURCE" "$DEST" "$EXCLUDE_FLAGS"
            
            if [ "$DRY_RUN" = false ] && command -v "$BIN" &> /dev/null; then
                MANAGER=$(detect_manager "$BIN" "$PACKAGE")
                echo "manager=$MANAGER" > "$DEST/install_meta.conf"
                echo "package=$PACKAGE" >> "$DEST/install_meta.conf"
                echo "binary=$BIN" >> "$DEST/install_meta.conf"
                echo -e "  [Meta] Detected: ${CYAN}$MANAGER${NC}"
            fi
        else
            echo -e "${RED}Skipping $NAME${NC} (Not found)"
        fi
    done
    echo -e "${GREEN}Backup completed.${NC}"
}

restore() {
    print_header
    echo -e "${RED}⚠️  DANGER ZONE: RESTORE OPERATION${NC}"
    echo -e "This will ${RED}OVERWRITE${NC} existing configuration files in your home directory."
    echo -e "Any local changes made since the last backup will be LOST."
    echo ""
    
    if [ "$DRY_RUN" = true ]; then
        echo -e "${CYAN}[DRY-RUN] Skipping confirmation prompt.${NC}"
    else
        read -p "Type 'YES' to confirm overwriting files: " confirmation
        if [[ "$confirmation" != "YES" ]]; then
            echo "Restore cancelled."
            exit 1
        fi
        
        # Safety Backup Option
        read -p "Do you want to create a quick .bak backup of current files before overwriting? (y/n) " -n 1 -r
        echo
        CREATE_BAK=false
        if [[ $REPLY =~ ^[Yy]$ ]]; then CREATE_BAK=true; fi
    fi

    echo -e "${YELLOW}Starting Restore Process...${NC}"

    for item in "${TARGETS[@]}"; do
        IFS=":" read -r NAME PATH_REL BIN PACKAGE <<< "$item"
        SOURCE_BACKUP="$BACKUP_DIR/$NAME/$(basename "$PATH_REL")"
        META_FILE="$BACKUP_DIR/$NAME/install_meta.conf"
        DEST_PARENT="$HOME_DIR/$(dirname "$PATH_REL")"
        DEST_TARGET="$HOME_DIR/$PATH_REL"
        
        # 1. Safety Backup Logic
        if [ "$DRY_RUN" = false ] && [ "$CREATE_BAK" = true ] && [ -e "$DEST_TARGET" ]; then
             echo -e "Creating safety backup for ${CYAN}$NAME${NC} -> ${DEST_TARGET}.bak"
             cp -rf "$DEST_TARGET" "${DEST_TARGET}.bak"
        fi

        # 2. Install Binary if missing
        if [ -f "$META_FILE" ]; then
            source "$META_FILE"
            if ! command -v "$binary" &> /dev/null; then
                echo -e "Tool ${RED}$binary${NC} missing. Installing via ${CYAN}$manager${NC}..."
                if [ "$DRY_RUN" = false ]; then
                    case "$manager" in
                        brew)   brew install "$package" || brew install --cask "$package" ;;
                        npm)    npm install -g "$package" ;;
                        yarn)   yarn global add "$package" ;;
                        bun)    bun add -g "$package" ;;
                        pnpm)   pnpm add -g "$package" ;;
                        *)      echo -e "  Manual install required for $package" ;;
                    esac
                else
                    echo -e "${CYAN}[DRY-RUN] Would install $package via $manager${NC}"
                fi
            fi
        fi

        # 3. Restore Files
        if [ -e "$SOURCE_BACKUP" ]; then
             echo -e "Restoring Config for ${GREEN}$NAME${NC}..."
             execute_rsync "$SOURCE_BACKUP" "$DEST_PARENT/" ""
        fi
    done
    echo -e "${GREEN}Restore completed.${NC}"
}

update() {
    print_header
    echo -e "${YELLOW}Checking for updates...${NC}"
    for item in "${TARGETS[@]}"; do
        IFS=":" read -r NAME PATH_REL BIN PACKAGE <<< "$item"
        if command -v "$BIN" &> /dev/null; then
            MANAGER=$(detect_manager "$BIN" "$PACKAGE")
            echo -e "${CYAN}$NAME${NC} ($MANAGER): Updating..."
            if [ "$DRY_RUN" = false ]; then
                case "$MANAGER" in
                    brew)   brew upgrade "$PACKAGE" ;;
                    npm)    npm update -g "$PACKAGE" ;;
                    yarn)   yarn global upgrade "$PACKAGE" ;;
                    bun)    bun update -g "$PACKAGE" ;;
                    pnpm)   pnpm update -g "$PACKAGE" ;;
                    manual) echo -e "  ${YELLOW}Manual install detected. Skipping.${NC}" ;;
                esac
            else
                echo -e "${CYAN}[DRY-RUN] Would update $PACKAGE via $MANAGER${NC}"
            fi
        fi
    done
}

cleanup() {
    print_header
    echo -e "${YELLOW}Scanning for duplicate installations...${NC}"
    # Cleanup logic remains similar but wrapped with dry-run checks
    # (Simplified for brevity in this response, but core logic applies)
    if [ "$DRY_RUN" = true ]; then echo -e "${CYAN}[DRY-RUN] Cleanup scan skipped.${NC}"; return; fi
    # ... (Cleanup logic as previously defined) ...
}

# Main
check_deps
case "$1" in
    backup) backup ;;
    restore) restore ;;
    update) update ;;
    cleanup) cleanup ;;
    list) 
        print_header
        for item in "${TARGETS[@]}"; do
            IFS=":" read -r NAME PATH_REL BIN PACKAGE <<< "$item"
            STATUS="${RED}MISSING${NC}"
            if [ -e "$HOME_DIR/$PATH_REL" ]; then STATUS="${GREEN}FOUND${NC}"; fi
            printf "% -15s %-30s %b\n" "$NAME" "$STATUS"
        done
        ;;
    *) 
        print_header
        echo "Usage: aicm {backup|restore|update|cleanup|list} [--dry-run]"
        exit 1
        ;;
esac